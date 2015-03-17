From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: linux-next: build failure after merge of the crypto tree
Date: Tue, 17 Mar 2015 22:11:31 +1100
Message-ID: <20150317111131.GA11471@gondor.apana.org.au>
References: <20150317130104.548124c2@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	James Hartley <james.hartley@imgtec.com>,
	Andrew Bresticker <abrestic@chromium.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150317130104.548124c2@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 17, 2015 at 01:01:04PM +1100, Stephen Rothwell wrote:
> 
> After merging the crypto tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/crypto/img-hash.c: At top level:
> drivers/crypto/img-hash.c:878:1: error: expected ',' or ';' before 'static'
>  static int img_hash_probe(struct platform_device *pdev)
>  ^
> 
> Caused by commit d358f1abbf71 ("crypto: img-hash - Add Imagination
> Technologies hw hash accelerator").

Thanks for the report Stephen, I'll merge this patch to fix it.

---8<---
imghash: Add missing semicolon to fix build error
    
There is a missing semicolon after MODULE_DEVICE_TABLE.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 0274172..fec61fc 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -873,7 +873,7 @@ static const struct of_device_id img_hash_match[] = {
 	{ .compatible = "img,hash-accelerator" },
 	{}
 };
-MODULE_DEVICE_TABLE(of, img_hash_match)
+MODULE_DEVICE_TABLE(of, img_hash_match);
 
 static int img_hash_probe(struct platform_device *pdev)
 {

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
