From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Force panic on continuous CPRNG test failure
	when in FIPS mode
Date: Thu, 5 Feb 2009 16:01:50 +1100
Message-ID: <20090205050150.GA22749@gondor.apana.org.au>
References: <20090123155817.GA29548@hmsreliant.think-freely.org> <20090128041828.GB13157@gondor.apana.org.au> <20090128121511.GA6361@hmsreliant.think-freely.org> <20090128121741.GA17496@gondor.apana.org.au> <20090128125848.GC6361@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44090 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750707AbZBEFBy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Feb 2009 00:01:54 -0500
Content-Disposition: inline
In-Reply-To: <20090128125848.GC6361@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 28, 2009 at 07:58:48AM -0500, Neil Horman wrote:
> 
> FIPS 140-2 specifies that all access to various cryptographic modules be
> prevented in the event that any of the provided self tests fail on the various
> implemented algorithms.  We already panic when any of the test in testmgr.c
> fail when we are operating in fips mode.  The continuous test in the cprng here
> was missed when that was implmented.  This code simply checks for the
> fips_enabled flag if the test fails, and warns us via syslog or panics the box
> accordingly.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Patch applied.  Thanks Neil.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
