From: "Dey, Megha" <megha.dey@intel.com>
Subject: RE: sha1_mb broken
Date: Wed, 28 Sep 2016 22:52:46 +0000
Message-ID: <C440BA31B54DCD4AAC682D2365C8FEE703CEF203@ORSMSX111.amr.corp.intel.com>
References: <1939675.7gNnqUbNs6@positron.chronox.de>
 <1475085499.2490.1.camel@megha-Z97X-UD7-TH>
 <1475087147.2490.6.camel@megha-Z97X-UD7-TH>
 <2200246.hBmZe7vJh4@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12966 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932369AbcI1Wwt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 18:52:49 -0400
In-Reply-To: <2200246.hBmZe7vJh4@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



-----Original Message-----
From: Stephan Mueller [mailto:smueller@chronox.de] 
Sent: Wednesday, September 28, 2016 11:46 AM
To: Dey, Megha <megha.dey@intel.com>
Cc: linux-crypto@vger.kernel.org; tim.c.chen@linux.intel.com
Subject: Re: sha1_mb broken

Am Mittwoch, 28. September 2016, 11:25:47 CEST schrieb Megha Dey:

Hi Megha,

> Hi Stephan,
> 
> There was a bug fix: Commit ID : 0851561d (introduced in 4.6-rc5).

I use the current cryptodev-2.6 tree.
> 
> Assuming that you are using an older kernel than this one, maybe we 
> are issuing the complete with the wrong pointer, so the original 
> issuer of the request never gets the complete back.
> 
> If you are using an older kernel, can you please use the lastest and 
> let me know if you still see this issue?
> 
> Also can you give more info on the test case? Does it issue single 
> request or multiple requests?

It is a single test with the message "8c899bba" where I expect "ac6d8c4851beacf61c175aed0699053d8f632df8"

>> For the message 8c899bba, the expected hash is  not ac6d8c4851beacf61c175aed0699053d8f632df8 but 
2e2816f6241fef89d78dd7afc926adc03ca94ace. I used this hash value in the existing tcrypt test and the test passes.

I would like to duplicate the test case you are using so that I can have a better look.
Can you provide the complete code for the test case? The code you sent earlier are missing some structure definitions. I will try to incorporate this test in the tcrypt test suite and try to reproduce this issue.

The code is the following which works with any other hash:

struct kccavs_ahash_def {
	struct crypto_ahash *tfm;
	struct ahash_request *req;
	struct kccavs_tcrypt_res result;
};

/* Callback function */
static void kccavs_ahash_cb(struct crypto_async_request *req, int error) {
	struct kccavs_tcrypt_res *result = req->data;

	if (error == -EINPROGRESS)
		return;
	result->err = error;
	complete(&result->completion);
	dbg("Encryption finished successfully\n"); }

/* Perform hash */
static unsigned int kccavs_ahash_op(struct kccavs_ahash_def *ahash) {
	int rc = 0;

	rc = crypto_ahash_digest(ahash->req);

	switch (rc) {
	case 0:
		break;
	case -EINPROGRESS:
	case -EBUSY:
		rc = wait_for_completion_interruptible(&ahash->result.completion);
		if (!rc && !ahash->result.err) {
#ifdef OLDASYNC
			INIT_COMPLETION(aead->result.completion);
#else
			reinit_completion(&ahash->result.completion);
#endif
			break;
		}
	default:
		dbg("ahash cipher operation returned with %d result"
		    " %d\n",rc, ahash->result.err);
		break;
	}
	init_completion(&ahash->result.completion);

	return rc;
}

static int kccavs_test_ahash(size_t nbytes) {
	int ret;
	struct crypto_ahash *tfm;
	struct ahash_request *req = NULL;
	struct kccavs_ahash_def ahash;
	struct kccavs_data *data = &kccavs_test->data;
	struct kccavs_data *key = &kccavs_test->key;
	unsigned char *digest = NULL;
	struct scatterlist sg;

	/*
	 * We explicitly do not check the input buffer as we allow
	 * an empty string.
	 */

	/* allocate synchronous hash */
	tfm = crypto_alloc_ahash(kccavs_test->name, 0, 0);
	if (IS_ERR(tfm)) {
		pr_info("could not allocate digest TFM handle for %s\n", kccavs_test-
>name);
		return PTR_ERR(tfm);
	}

	digest = kzalloc(crypto_ahash_digestsize(tfm), GFP_KERNEL);
	if (!digest) {
		ret = -ENOMEM;
		goto out;
	}

	req = ahash_request_alloc(tfm, GFP_KERNEL);
	if (!req) {
		pr_info("could not allocate request queue\n");
		ret = -ENOMEM;
		goto out;
	}
	ahash.tfm = tfm;
	ahash.req = req;

	if (key->len) {
		dbg("set key for HMAC\n");
		ret = crypto_ahash_setkey(tfm, key->data, key->len);
		if (ret < 0)
			goto out;
	}

	sg_init_one(&sg, data->data, data->len);
	ahash_request_set_crypt(req, &sg, digest, data->len);
	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
				   kccavs_ahash_cb, &ahash.result);

	ret = kccavs_ahash_op(&ahash);
	if (!ret) {
		data->len = crypto_ahash_digestsize(tfm);
		memcpy(data->data, digest, data->len);
	}

out:
	kzfree(digest);
	if (req)
		ahash_request_free(req);
	crypto_free_ahash(tfm);
	return ret;
}


Ciao
Stephan
