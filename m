From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr - fix RNG return code enforcement
Date: Fri, 13 Mar 2015 21:38:20 +1100
Message-ID: <20150313103820.GA1757@gondor.apana.org.au>
References: <20150311121107.GY786@surtsey.monkey.lab>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
To: Alexander Bergmann <abergmann@suse.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:44501 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbbCMKi1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Mar 2015 06:38:27 -0400
Content-Disposition: inline
In-Reply-To: <20150311121107.GY786@surtsey.monkey.lab>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 11, 2015 at 01:11:07PM +0100, Alexander Bergmann wrote:
> From 0c7233769665f03e9f91342770dba7279f928c23 Mon Sep 17 00:00:00 2001
> From: Stephan Mueller <smueller@chronox.de>
> Date: Tue, 10 Mar 2015 17:00:36 +0100
> Subject: [PATCH] crypto: testmgr - fix RNG return code enforcement
> 
> Due to the change to RNGs to always return zero in success case, the
> invocation of the RNGs in the test manager must be updated as otherwise
> the RNG self tests are not properly executed any more.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> Signed-off-by: Alexander Bergmann <abergmann@suse.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
