From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] trigger a panic when operating in FIPS mode and a
	crypto self test fails.
Date: Sun, 12 Oct 2008 20:38:11 +0800
Message-ID: <20081012123811.GA14351@gondor.apana.org.au>
References: <20080922192727.GA4718@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-kernel@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50964 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752183AbYJLMi0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 12 Oct 2008 08:38:26 -0400
Content-Disposition: inline
In-Reply-To: <20080922192727.GA4718@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 22, 2008 at 03:27:27PM -0400, Neil Horman wrote:
> Hey all-
> 	The FIPS specification requires that should self test for any supported
> crypto algorithm fail during operation in fips mode, we need to prevent the use
> of any crypto functionality until such time as the system can be re-initialized.
> Seems like the best way to handle that would be to panic the system if we were
> in fips mode and failed a self test.  This patch implements that functionality.
> I've built and run it successfully with and 

Patch applied.  Thanks Neil!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
