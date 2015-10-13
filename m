From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: unaligned access in pkcs7_verify
Date: Tue, 13 Oct 2015 09:29:28 -0400
Message-ID: <20151013132928.GK20800@oracle.com>
References: <20151002140014.GI18263@oracle.com>
 <20151008131519.GA24362@gondor.apana.org.au>
 <20151008144343.GE19655@oracle.com>
 <20151012133209.GA27746@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26781 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbbJMN3i (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Oct 2015 09:29:38 -0400
Content-Disposition: inline
In-Reply-To: <20151012133209.GA27746@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (10/12/15 21:32), Herbert Xu wrote:
> 
> .. pkcs7_verify definitely
> shouldn't place the structure after the digest without aligning the
> pointer.  So something like your patch is needed (but please use
> alignof instead of sizeof).  Also don't put in digest_size but
> instead align the pointer like
> 
> 	desc = PTR_ALIGN(digest + digest_size, ...)

I tried the patch below for 24+ hours, and it ran without mishaps. 
But given that the panics I saw earlier (page faults typically
triggered  by openswan's pluto) occurred unpredictably, it would be 
useful to have an expert-review of this code.

Thanks,
--Sowmini

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index d20c0b4..958ac01 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -46,14 +46,15 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
 
 	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
-	sinfo->sig.digest_size = digest_size = crypto_shash_digestsize(tfm);
-
+	sinfo->sig.digest_size = crypto_shash_digestsize(tfm);
+	digest_size = crypto_shash_digestsize(tfm) +
+		ALIGN(crypto_shash_digestsize(tfm), __alignof__(*desc));
 	ret = -ENOMEM;
 	digest = kzalloc(digest_size + desc_size, GFP_KERNEL);
 	if (!digest)
 		goto error_no_desc;
 
-	desc = digest + digest_size;
+	desc = PTR_ALIGN(digest + digest_size, __alignof__(*desc));
 	desc->tfm   = tfm;
 	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
