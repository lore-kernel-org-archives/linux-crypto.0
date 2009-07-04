From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Update stdrng test name so that the testmgr
	finds it properly
Date: Sat, 4 Jul 2009 09:08:55 +0800
Message-ID: <20090704010855.GA31752@gondor.apana.org.au>
References: <20090701155219.GA31414@hmsreliant.think-freely.org> <20090702060255.GA18642@Chamillionaire.breakpoint.cc> <20090702083259.GA12884@gondor.apana.org.au> <20090703205909.GA4227@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
	davem@davemloft.net
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48554 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751535AbZGDBJA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Jul 2009 21:09:00 -0400
Content-Disposition: inline
In-Reply-To: <20090703205909.GA4227@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 03, 2009 at 10:59:09PM +0200, Sebastian Andrzej Siewior wrote:
>
> >-	rc = alg_test_descs[i].test(alg_test_descs + i, driver,
> >-				      type, mask);
> >+	rc = 0;
> >+	if (i >= 0)
> >+		rc |= alg_test_descs[i].test(alg_test_descs + i, driver,
> >+					     type, mask);
> >+	if (j >= 0)
> >+		rc |= alg_test_descs[j].test(alg_test_descs + j, driver,
> >+					     type, mask);
> 
> Do you execute test2 if test1 failed on purpose?

Yes that was intentional.  Not that it makes much of a differnce.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
