From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: nfs/krb5 crash on 4.6-rc1
Date: Sun, 3 Apr 2016 09:09:52 +0800
Message-ID: <20160403010952.GA25687@gondor.apana.org.au>
References: <20160403001319.GB12588@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160403001319.GB12588-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Apr 02, 2016 at 08:13:19PM -0400, J. Bruce Fields wrote:
> As of 3b5cf20c "sunrpc: Use skcipher and ahash/shash", I get a NULL
> dereference in krb5_encrypt on an NFS server when a client attempts to
> mount using krb5.  I haven't tried to figure out what's going on beyond
> that....

Oops, looks like I missed a couple of set_tfm calls.

---8<--
Subject: sunrpc: Add missing skcipher_request_set_tfm calls

A couple of skcipher_request users were missing set_tfm calls which
leads to a crash when they are called.

Fixes: 3b5cf20cf439 ("sunrpc: Use skcipher and ahash/shash")
Reported-by: J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Signed-off-by: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>

diff --git a/net/sunrpc/auth_gss/gss_krb5_crypto.c b/net/sunrpc/auth_gss/gss_krb5_crypto.c
index d94a8e1..ccc59aa 100644
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
 
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
