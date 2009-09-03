From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [pkg-cryptsetup-devel] Bug#541835: crypto configuration /
	dependencies broken
Date: Thu, 3 Sep 2009 13:22:06 +1000
Message-ID: <20090903032206.GA18883@gondor.apana.org.au>
References: <20090901005120.GB22049@resivo.wgnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sebastian@breakpoint.cc, celejar@gmail.com,
	randy.dunlap@oracle.com, 541835@bugs.debian.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	control@bugs.debian.org
To: Jonas Meurer <jonas@freesources.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42344 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754130AbZICDW1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Sep 2009 23:22:27 -0400
Content-Disposition: inline
In-Reply-To: <20090901005120.GB22049@resivo.wgnet.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jonas Meurer <jonas@freesources.org> wrote:
> 
> i guess the best solution would be to improve the module dependency
> system. cipher meta-modules like 'aes' should depend on all available
> implementations. same for ivciphers, hashs, rng implementations etc.

We already do that for algorithms at least, they should all have
aliases of the form "ALG" or "ALG-all".

Things like chainiv/eseqiv should just be included always.  There
are unlikely to be any new algorithms of that type.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
