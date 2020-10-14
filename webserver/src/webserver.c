#include <kore/kore.h>
#include <kore/http.h>
#include <bloom.h>

#define BF_EN    "en"
#define BF_ETT   "ett"
#define BF_ENETT "both"
#define BF_NONE  "not found"
#define BF_ERR   "error"

bloomfilter en;
bloomfilter ett;

int	page(struct http_request *);
static void readfile(bloomfilter* bf, char* path);
static int get(struct http_request *);
static int post(struct http_request *);


void kore_parent_configure(int argc, char *argv[]) {
    bf_init(&en, 2000000);
    bf_init(&ett, 2000000);
    readfile(&en, "en.txt");
    readfile(&ett, "ett.txt");
}

void kore_parent_teardown()
{
    bf_cleanup(&en);
    bf_cleanup(&ett);
}

static void readfile(bloomfilter* bf, char* path)
{
    FILE* f;
    char buf[32];
    int read = 0;

    f = fopen(path, "r");

    if ( NULL == f )
    {
        kore_log(LOG_NOTICE, "failed to read %s", path);
        return;
    }
    while( fgets(buf, sizeof(buf), f) )
    {
        buf[strcspn(buf, "\n")] = 0;
        bf_insert(bf, buf);
        read++;
    }

    fclose(f);
    kore_log(LOG_INFO, "read %d words from %s", read, path);
}

int page(struct http_request *req)
{
    http_response_header(req, "content-type", "text/plain");
    if (req->method == HTTP_METHOD_GET)
    {
        return get(req);
    }
    else if (req->method == HTTP_METHOD_POST)
    {
        return post(req);
    }
    kore_log(LOG_NOTICE, "unexpected http method");
	return (KORE_RESULT_ERROR);

}

static int get(struct http_request *req)
{
    http_response(req, 404, NULL, 0);
	return (KORE_RESULT_OK);
}

static int post(struct http_request *req)
{
    char *noun;

    http_populate_post(req);

    if ( ! http_argument_get_string(req, "noun", &noun) )
    {
        kore_log(LOG_NOTICE, "failed to get noun from POST body");
	    http_response(req, 400, BF_ERR, strlen(BF_ERR));
    	return (KORE_RESULT_OK);
    }

    noun = kore_text_trim(noun, strlen(noun));

    if ( bf_contains(&en, noun) )
    {
        if ( bf_contains(&ett, noun) )
        {
	        http_response(req, 200, BF_ENETT, strlen(BF_ENETT));
        }
        else
        {
	        http_response(req, 200, BF_EN, strlen(BF_EN));
        }
    }
    else if ( bf_contains(&ett, noun) )
    {
	    http_response(req, 200, BF_ETT, strlen(BF_ETT));
    }
    else
    {
	    http_response(req, 200, BF_NONE, strlen(BF_NONE));
    }
	return (KORE_RESULT_OK);
}



