From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 0/3] crypto: drbg - revamp locking
Date: Sun, 19 Apr 2015 17:35:23 +0200
Message-ID: <2916811.EN7EiDNNhd@myon.chronox.de>
References: <1702481.h2hMdNkdaF@myon.chronox.de> <20150419054931.GC11255@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34211 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbbDSPf3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Apr 2015 11:35:29 -0400
In-Reply-To: <20150419054931.GC11255@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 19. April 2015, 13:49:31 schrieb Herbert Xu:

Hi Herbert,

> On Sat, Apr 18, 2015 at 07:35:11PM +0200, Stephan Mueller wrote:
> > Hi,
> > 
> > the current implementation of the DRBG generates a shadow copy of its
> > DRBG state for each incoming request. The idea is that only a short
> > term lock is needed to spawn the shadow copy. The drawback is that
> > if multiple parallel requests come in, the generated DRBG shadow
> > states only differ by a high-resolution timer that was mixed in during
> > the shadow state generation.
> > 
> > This patch now removes this shadow state and introduces a mutex
> > to serialize all requests to one DRBG instance.
> > 
> > The patch was fully CAVS tested and demonstrates that the DRBG still
> > complies with the standard.
> 
> All applied.

Thanks -- can you please push your tree? There is one more mutex_init missing: 
in drbg_healthcheck.

This missing mutex_init will cause a segfault when booting the kernel with 
fips=1

-- 
Ciao
Stephan
