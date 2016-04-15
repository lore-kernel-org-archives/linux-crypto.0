From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto,ccp: Fix RT breaking #include
 <linux/rwlock_types.h>
Date: Fri, 15 Apr 2016 22:28:36 +0800
Message-ID: <20160415142836.GA733@gondor.apana.org.au>
References: <1459861401.7776.4.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Gary R Hook <gary.hook@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58618 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbcDOO2p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2016 10:28:45 -0400
Content-Disposition: inline
In-Reply-To: <1459861401.7776.4.camel@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 05, 2016 at 03:03:21PM +0200, Mike Galbraith wrote:
> 
> Direct include of rwlock_types.h breaks RT, use spinlock_types.h instead.
> 
> Fixes: 553d2374db0b crypto: ccp - Support for multiple CCPs
> Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
