From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: [PATCH v2] sunrpc: Fix skcipher/shash conversion
Date: Sun, 3 Apr 2016 12:37:15 +0800
Message-ID: <20160403043715.GA26722@gondor.apana.org.au>
References: <20160403001319.GB12588@fieldses.org>
 <20160403010952.GA25687@gondor.apana.org.au>
 <20160403035900.GB14318@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160403035900.GB14318-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Apr 02, 2016 at 11:59:00PM -0400, J. Bruce Fields wrote:
> 
> Thanks.  It's getting further now, but appears to be freezing later.
> Possibly unrelated.  I'm travelling, and it'll be Monday or Wednesday
> till I can take another look.

Thanks for the update.  I've found another bug in the hash conversion
that causes memory corruption which may lead to your hang.

Here's a patch with the previous fix plus the new hash fixes.

---8<---
The skcpiher/shash conversion introduced a number of bugs in the
sunrpc code:

1) Missing calls to skcipher_request_set_tfm lead to crashes.
2) The allocation size of shash_desc is too small which leads to
memory corruption.

Fixes: 3b5cf20cf439 ("sunrpc: Use skcipher and ahash/shash")
Reported-by: J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Signed-off-by: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>

diff --git a/net/sunrpc/auth_gss/gss_krb5_crypto.c b/net/sunrpc/auth_gss/gss_krb5_crypto.c
index d94a8e1..da26455 100644
--- a/net/sunrpc/auth_gss/gss_krb5_crypto.c
+++ b/net/sunrpc/auth_gss/gss_krb5_crypto.c
@@ -78,6 +78,7 @@ krb5_encrypt(
 	memcpy(out, in, length);
 	sg_init_one(sg, out, length);
 
+	skcipher_request_set_tfm(req, tfm);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, sg, sg, length, local_iv);
 
@@ -115,6 +116,7 @@ krb5_decrypt(
 	memcpy(out, in, length);
 	sg_init_one(sg, out, length);
 
+	skcipher_request_set_tfm(req, tfm);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, sg, sg, length, local_iv);
 
@@ -946,7 +948,8 @@ krb5_rc4_setup_seq_key(struct krb5_ctx *kctx, struct crypto_skcipher *cipher,
 		return PTR_ERR(hmac);
 	}
 
-	desc = kmalloc(sizeof(*desc), GFP_KERNEL);
+	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(hmac),
+		       GFP_KERNEL);
 	if (!desc) {
 		dprintk("%s: failed to allocate shash descriptor for '%s'\n",
 			__func__, kctx->gk5e->cksum_name);
@@ -1012,7 +1015,8 @@ krb5_rc4_setup_enc_key(struct krb5_ctx *kctx, struct crypto_skcipher *cipher,
 		return PTR_ERR(hmac);
 	}
 
-	desc = kmalloc(sizeof(*desc), GFP_KERNEL);
+	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(hmac),
+		       GFP_KERNEL);
 	if (!desc) {
 		dprintk("%s: failed to allocate shash descriptor for '%s'\n",
 			__func__, kctx->gk5e->cksum_name);
diff --git a/net/sunrpc/auth_gss/gss_krb5_mech.c b/net/sunrpc/auth_gss/gss_krb5_mech.c
index 71341cc..6542749 100644
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -451,7 +451,8 @@ context_derive_keys_rc4(struct krb5_ctx *ctx)
 		goto out_err_free_hmac;
 
 
-	desc = kmalloc(sizeof(*desc), GFP_KERNEL);
+	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(hmac),
+		       GFP_KERNEL);
 	if (!desc) {
 		dprintk("%s: failed to allocate hash descriptor for '%s'\n",
 			__func__, ctx->gk5e->cksum_name);
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
