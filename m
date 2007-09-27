From: Joy Latten <latten@austin.ibm.com>
Subject: Re: [PATCH 8/8] [CRYPTO] aead: Add authenc
Date: Thu, 27 Sep 2007 17:29:04 -0500
Message-ID: <200709272229.l8RMT4n3003226@faith.austin.ibm.com>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36612 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652AbXI0Wcy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2007 18:32:54 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8RMWrbH019136
	for <linux-crypto@vger.kernel.org>; Thu, 27 Sep 2007 18:32:53 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8RMWrB7548822
	for <linux-crypto@vger.kernel.org>; Thu, 27 Sep 2007 18:32:53 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8RMWqEB001860
	for <linux-crypto@vger.kernel.org>; Thu, 27 Sep 2007 18:32:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Again, sorry for the late notice, but this just came
to my attention.

+static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
+{
+	struct crypto_instance *inst;
+	struct crypto_alg *auth;
+	struct crypto_alg *enc;
+	struct authenc_instance_ctx *ctx;
+	unsigned int authsize;
+	unsigned int enckeylen;
+	int err;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD);
+	if (err)
+		return ERR_PTR(err);
+
+	auth = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_HASH,
+			       CRYPTO_ALG_TYPE_HASH_MASK);
+	if (IS_ERR(auth))
+		return ERR_PTR(PTR_ERR(auth));
+
+	err = crypto_attr_u32(tb[2], &authsize);
+	inst = ERR_PTR(err);
+	if (err)
+		goto out_put_auth;
+
+	enc = crypto_attr_alg(tb[3], CRYPTO_ALG_TYPE_BLKCIPHER,
+			      CRYPTO_ALG_TYPE_MASK);
+	inst = ERR_PTR(PTR_ERR(enc));
+	if (IS_ERR(enc))
+		goto out_put_auth;
+
+	err = crypto_attr_u32(tb[4], &enckeylen);
+	if (err)
+		goto out_put_enc;
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
+	err = -ENOMEM;
+	if (!inst)
+		goto out_put_enc;
+
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "authenc(%s, %u, %s, %u)", auth->cra_name, authsize,

The parsing routine in cryptomg_schedule_probe() does
not appear to accomodate whitespaces in the template.

Thus if user enters template without whitespaces,
then the above would cause a problem because the 
name in the template would not match up with the name
in the instance above. 

I have not tested this with authenc, but did with 
ctr(aes,4,8) as opposed to ctr(aes, 4, 8).
With whitespaces, it failed.  Without whitespaces 
in either template or instance, it worked.

+		     enc->cra_name, enckeylen) >= CRYPTO_MAX_ALG_NAME)
+		goto err_free_inst;
+
+	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "authenc(%s, %u, %s, %u)", auth->cra_driver_name,

Same thing...

+		     authsize, enc->cra_driver_name, enckeylen) >=
+	    CRYPTO_MAX_ALG_NAME)
+		goto err_free_inst;
+

Regards,
Joy
