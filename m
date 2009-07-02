From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] crypto: Update stdrng test name so that the testmgr
	finds it properly
Date: Thu, 2 Jul 2009 08:02:55 +0200
Message-ID: <20090702060255.GA18642@Chamillionaire.breakpoint.cc>
References: <20090701155219.GA31414@hmsreliant.think-freely.org>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58375 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbZGBGCz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2009 02:02:55 -0400
Content-Disposition: inline
In-Reply-To: <20090701155219.GA31414@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Neil Horman | 2009-07-01 11:52:19 [-0400]:

>Fix crypto testmgr reference to rng self tests.
>
>It seems the ansi_cprng self tests get skipped currently.  It appears this is
>because the test name is "ansi_cprng", but the test is looked up by the cra_name
>value of the algorithm in question, and ansi_cprng registers its cra_name as
>stdrng.  This patch brings the two into line.
>
>Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
>
>
> testmgr.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>index f9bea9d..3315a38 100644
>--- a/crypto/testmgr.c
>+++ b/crypto/testmgr.c
>@@ -1480,7 +1480,7 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
> /* Please keep this list sorted by algorithm name. */
> static const struct alg_test_desc alg_test_descs[] = {
> 	{
>-		.alg = "ansi_cprng",
>+		.alg = "stdrng",
> 		.test = alg_test_cprng,
> 		.fips_allowed = 1,
> 		.suite = {

Don't you use this vector for _all_ stdrngs now? krng for instance will
fail.

Sebastian
