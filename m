From: Milan Broz <mbroz@redhat.com>
Subject: Re: [BUGFIX] dm-crypt: Fix a bug of async cryption complete	function
Date: Fri, 27 Feb 2009 14:51:15 +0100
Message-ID: <49A7EFD3.9080107@redhat.com>
References: <1235724971.6204.106.camel@yhuang-dev.sh.intel.com> <20090227114103.GB24024@gondor.apana.org.au> <49A7D3E5.5040706@redhat.com> <20090227115638.GA24221@gondor.apana.org.au> <49A7DC7E.1040307@redhat.com> <20090227124602.GA24630@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Alasdair G Kergon <agk@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59482 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839AbZB0NvR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2009 08:51:17 -0500
In-Reply-To: <20090227124602.GA24630@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> On Fri, Feb 27, 2009 at 01:28:46PM +0100, Milan Broz wrote:
>> Like this?
>>
>> struct ablkcipher_request *req = (char *)dmreq - cc->dmreq_start;
>> mempool_free(req, cc->req_pool);
>
> Exactly.  You could also embed the ablkcipher_request at the
> end of dmreq, as in
>
> struct dm_crypt_request {
> 	struct scatterlist sg_in;
> 	struct scatterlist sg_out;
> 	struct ablkcipher_request req;
> };
>
> Then you can use container_of.

Hm, I better keep explicitly this pointer retyping as reminder that
the structures need some revision in future...

Is the attached and reworked patch ok?

Alasdair, please can we queue this for 2.6.29-rc as urgent bugfix?

Milan
-- 
mbroz@redhat.com

----
dm-crypt: Fix async completion to not use crypto_async_request directly

In async cryption complete function (kcryptd_async_done), the
crypto_async_request passed in may be different from the one passed to
crypto_ablkcipher_encrypt/decrypt. Only crypto_async_request->data is
guaranteed to be same as the passed in one. Current kcryptd_async_done
uses passed in crypto_async_request directly, which may cause AES-NI
based AES algorithm implementation panic.

This patch fix this bug by using crypto_async_request->data only,
which point to dm_crypt_request, the crypto_async_request passed in
and original data (convert_context) can be gotten from
dm_crypt_request.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Milan Broz <mbroz@redhat.com>

---
 drivers/md/dm-crypt.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 35bda49..ebab49f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -60,6 +60,7 @@ struct dm_crypt_io {
 };
 
 struct dm_crypt_request {
+	struct convert_context *ctx;
 	struct scatterlist sg_in;
 	struct scatterlist sg_out;
 };
@@ -335,6 +336,18 @@ static void crypt_convert_init(struct crypt_config *cc,
 	init_completion(&ctx->restart);
 }
 
+static struct dm_crypt_request *dmreq_of_req(struct crypt_config *cc,
+					     struct ablkcipher_request *req)
+{
+	return (struct dm_crypt_request *)((char *)req + cc->dmreq_start);
+}
+
+static struct ablkcipher_request *req_of_dmreq(struct crypt_config *cc,
+					       struct dm_crypt_request *dmreq)
+{
+	return (struct ablkcipher_request *)((char *)dmreq - cc->dmreq_start);
+}
+
 static int crypt_convert_block(struct crypt_config *cc,
 			       struct convert_context *ctx,
 			       struct ablkcipher_request *req)
@@ -345,10 +358,11 @@ static int crypt_convert_block(struct crypt_config *cc,
 	u8 *iv;
 	int r = 0;
 
-	dmreq = (struct dm_crypt_request *)((char *)req + cc->dmreq_start);
+	dmreq = dmreq_of_req(cc, req);
 	iv = (u8 *)ALIGN((unsigned long)(dmreq + 1),
 			 crypto_ablkcipher_alignmask(cc->tfm) + 1);
 
+	dmreq->ctx = ctx;
 	sg_init_table(&dmreq->sg_in, 1);
 	sg_set_page(&dmreq->sg_in, bv_in->bv_page, 1 << SECTOR_SHIFT,
 		    bv_in->bv_offset + ctx->offset_in);
@@ -395,8 +409,9 @@ static void crypt_alloc_req(struct crypt_config *cc,
 		cc->req = mempool_alloc(cc->req_pool, GFP_NOIO);
 	ablkcipher_request_set_tfm(cc->req, cc->tfm);
 	ablkcipher_request_set_callback(cc->req, CRYPTO_TFM_REQ_MAY_BACKLOG |
-					     CRYPTO_TFM_REQ_MAY_SLEEP,
-					     kcryptd_async_done, ctx);
+					CRYPTO_TFM_REQ_MAY_SLEEP,
+					kcryptd_async_done,
+					dmreq_of_req(cc, cc->req));
 }
 
 /*
@@ -821,7 +836,8 @@ static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 static void kcryptd_async_done(struct crypto_async_request *async_req,
 			       int error)
 {
-	struct convert_context *ctx = async_req->data;
+	struct dm_crypt_request *dmreq = async_req->data;
+	struct convert_context *ctx = dmreq->ctx;
 	struct dm_crypt_io *io = container_of(ctx, struct dm_crypt_io, ctx);
 	struct crypt_config *cc = io->target->private;
 
@@ -830,7 +846,7 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 		return;
 	}
 
-	mempool_free(ablkcipher_request_cast(async_req), cc->req_pool);
+	mempool_free(req_of_dmreq(cc, dmreq), cc->req_pool);
 
 	if (!atomic_dec_and_test(&ctx->pending))
 		return;


