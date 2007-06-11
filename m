From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
Date: 11 Jun 2007 14:04:05 +0200
Message-ID: <p73hcpevgsq.fsf@bingen.suse.de>
References: <20070608214242.23949.30350.stgit@dev>
	<20070608214253.23949.40465.stgit@dev>
	<20070609201159.GC11166@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Benjamin Gilbert <bgilbert@cs.cmu.edu>, akpm@linux-foundation.org,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbXFKLHz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jun 2007 07:07:55 -0400
In-Reply-To: <20070609201159.GC11166@waste.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Matt Mackall <mpm@selenic.com> writes:
> 
> Have you benchmarked this against lib/sha1.c? Please post the results.
> Until then, I'm frankly skeptical that your unrolled version is faster
> because when I introduced lib/sha1.c the rolled version therein won by
> a significant margin and had 1/10th the cache footprint.

I would always suggest to benchmark such functions with forced cold i/d caches

(memset(x, 0, 5*1024*1024) and running some very large generated
function every few iterations of the benchmark) 

-Andi
