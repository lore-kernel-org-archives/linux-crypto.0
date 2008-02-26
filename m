From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6.25 patch] drivers/crypto/hifn_795x.c: fix 64bit division
Date: Tue, 26 Feb 2008 17:34:21 +0200
Message-ID: <20080226153421.GB10717@cs181133002.pp.htv.fi>
References: <20080226122100.GB22699@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-kernel@vger.kernel.org,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ralf Baechle <ralf@linux-mips.org>,
	linux-crypto@vger.kernel.org
To: Martin Michlmayr <tbm@cyrius.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48406 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbYBZPfZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Feb 2008 10:35:25 -0500
Content-Disposition: inline
In-Reply-To: <20080226122100.GB22699@deprecation.cyrius.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 26, 2008 at 01:21:00PM +0100, Martin Michlmayr wrote:
> With 2.6.25-rc3 and a config file with
> 
> CONFIG_CRYPTO_DEV_HIFN_795X=m
> CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
> 
> I get the following build error on at least ARM and MIPS:
> 
>   Building modules, stage 2.
>   MODPOST 759 modules
> ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!

Fix below.

> Martin Michlmayr

cu
Adrian


<--  snip  -->


Using ndelay() with a 64bit variable as parameter can result in build 
errors like the following on some 32bit systems when it results in a 
64bit division:

<--  snip  -->

 ...
  MODPOST 759 modules
ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!

<--  snip  -->

Reported by Martin Michlmayr.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

40b45041ddc587c20b872a86a6a36952c28b02c7 diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 3110bf7..b1541c6 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -807,7 +807,7 @@ static int hifn_rng_data_present(struct hwrng *rng, int wait)
 		return 1;
 	if (!wait)
 		return 0;
-	ndelay(nsec);
+	ndelay((u32)nsec);
 	return 1;
 }
 
