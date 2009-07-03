From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] crypto: Update stdrng test name so that the testmgr
	finds it properly
Date: Fri, 3 Jul 2009 22:59:09 +0200
Message-ID: <20090703205909.GA4227@Chamillionaire.breakpoint.cc>
References: <20090701155219.GA31414@hmsreliant.think-freely.org> <20090702060255.GA18642@Chamillionaire.breakpoint.cc> <20090702083259.GA12884@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
	davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44556 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757121AbZGCU7M (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Jul 2009 16:59:12 -0400
Content-Disposition: inline
In-Reply-To: <20090702083259.GA12884@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2009-07-02 16:32:59 [+0800]:

>--- a/crypto/testmgr.c
>+++ b/crypto/testmgr.c
>@@ -2365,14 +2366,22 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
> 	}
> 
> 	i = alg_find_test(alg);
>-	if (i < 0)
>+	j = alg_find_test(driver);
>+	if (i < 0 && j < 0)
> 		goto notest;
> 
>-	if (fips_enabled && !alg_test_descs[i].fips_allowed)
>+	if (fips_enabled && ((i >= 0 && !alg_test_descs[i].fips_allowed) ||
>+			     (j >= 0 && !alg_test_descs[j].fips_allowed)))
> 		goto non_fips_alg;
> 
>-	rc = alg_test_descs[i].test(alg_test_descs + i, driver,
>-				      type, mask);
>+	rc = 0;
>+	if (i >= 0)
>+		rc |= alg_test_descs[i].test(alg_test_descs + i, driver,
>+					     type, mask);
>+	if (j >= 0)
>+		rc |= alg_test_descs[j].test(alg_test_descs + j, driver,
>+					     type, mask);

Do you execute test2 if test1 failed on purpose?
If not what about:

	if (!rc && j >= 0)
		rc = alg_test_descs[j].test(alg_test_descs + j, driver,
					     type, mask);

so there is return code mixup.

Sebastian
