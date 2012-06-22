From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: gpf on boot with linux-next
Date: Fri, 22 Jun 2012 20:07:55 +0800
Message-ID: <20120622120755.GA24338@gondor.apana.org.au>
References: <1340363755.27031.37.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Sasha Levin <levinsasha928@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1340363755.27031.37.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 22, 2012 at 01:15:55PM +0200, Sasha Levin wrote:
> Hi all,
> 
> I'm seeing the following panic when booting the latest linux-next kernel:

Oops, stupid thinko on my part.  Can you see if the following patch
on top of linux-next fixes the issue?

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 368a832..f97027e 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -48,7 +48,7 @@ struct cryptomgr_param {
 	char larval[CRYPTO_MAX_ALG_NAME];
 	char template[CRYPTO_MAX_ALG_NAME];
 
-	struct completion completion;
+	struct completion *completion;
 
 	u32 otype;
 	u32 omask;
@@ -87,7 +87,7 @@ static int cryptomgr_probe(void *data)
 	crypto_tmpl_put(tmpl);
 
 out:
-	complete(&param->completion);
+	complete(param->completion);
 	kfree(param);
 	module_put_and_exit(0);
 }
@@ -189,14 +189,13 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 
 	memcpy(param->larval, larval->alg.cra_name, CRYPTO_MAX_ALG_NAME);
 
-	init_completion(&param->completion);
+	param->completion = &larval->completion;
 
 	thread = kthread_run(cryptomgr_probe, param, "cryptomgr_probe");
 	if (IS_ERR(thread))
 		goto err_free_param;
 
-	wait_for_completion_interruptible_timeout(&param->completion, 60 * HZ);
-	complete_all(&larval->completion);
+	wait_for_completion_interruptible(&larval->completion);
 
 	return NOTIFY_STOP;
 

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
