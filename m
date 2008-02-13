From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Wed, 13 Feb 2008 17:44:42 +0300
Message-ID: <20080213144442.GA10683@2ka.mipt.ru>
References: <47B2EDF9.6020900@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:51758 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYBNCN3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Feb 2008 21:13:29 -0500
Content-Disposition: inline
In-Reply-To: <47B2EDF9.6020900@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Patric.

On Wed, Feb 13, 2008 at 02:17:45PM +0100, Patrick McHardy (kaber@trash.net) wrote:
> I'm getting crashes when using HIFN and IPsec (ESP with
> AES + MD5) in the current -git tree. I didn't capture the
> Oops, but there seem to be a number of problems:
> 
> - hifn_setup_session walks over the scatterlist, subtracting
>   the scatterlist element size from nbytes until nbytes
>   reaches zero. In my case nbytes is 12 byte smaller than
>   the scatterlist, so nbytes underflows and it oopses when
>   walking over the of the scatterlist.

How is it possible? If I understood correctly ablkcipher_request->nbytes
has to have value equal to number of bytes placed into underlying
scatterlists, so if they do not match, hifn driver will not work at all.

> I couldn't figure out where in the crypto code the
> nbytes decrement by 12 bytes compared to the length
> seen when setting up the crypto operation happens
> or I might have tried to properly fix it myself.
> I'll happily test patches in case someone more
> familiar with the code does a proper fix.

Any chance you can apply following patch and check output for correct
and broken cases (it will produce 2 or 3 debug strings for each crypto
operation)?

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index dfbf24c..b8b088d 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1558,6 +1558,23 @@ err_out_unmap:
 	return err;
 }
 
+static void hifn_dump_req(struct ablkcipher_request *req, const char *prefix)
+{
+	int nbytes = (signed)req->nbytes;
+	struct scatterlist *src, *dst;
+	int idx = 0;
+
+	printk("%s: nbytes: %u, ", prefix, nbytes);
+	while (nbytes > 0) {
+		src = &req->src[idx];
+		dst = &req->dst[idx];
+
+		printk("%u/%u ", src->length, dst->length);
+		nbytes -= src->length;
+	}
+	printk("\n");
+}
+
 static int hifn_setup_session(struct ablkcipher_request *req)
 {
 	struct hifn_context *ctx = crypto_tfm_ctx(req->base.tfm);
@@ -1572,6 +1589,8 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 	unsigned alignmask =
 		crypto_ablkcipher_alignmask(crypto_ablkcipher_reqtfm(req));
 
+	hifn_dump_req(req, __func__);
+
 	if (ctx->iv && !ctx->ivsize && ctx->mode != ACRYPTO_MODE_ECB)
 		goto err_out_exit;
 
@@ -2182,6 +2201,8 @@ static int hifn_process_queue(struct hifn_device *dev)
 		ctx = crypto_tfm_ctx(async_req->tfm);
 		req = container_of(async_req, struct ablkcipher_request, base);
 
+		hifn_dump_req(req, __func__);
+
 		err = hifn_handle_req(req);
 		if (err)
 			break;
@@ -2196,6 +2217,8 @@ static int hifn_setup_crypto(struct ablkcipher_request *req, u8 op,
 	int err;
 	struct hifn_context *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct hifn_device *dev = ctx->dev;
+	
+	hifn_dump_req(req, __func__);
 
 	err = hifn_setup_crypto_req(req, op, type, mode);
 	if (err)


-- 
	Evgeniy Polyakov
