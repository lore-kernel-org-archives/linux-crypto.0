From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Support VIA Nano hardware RNG
Date: Fri, 15 May 2009 16:00:46 +1000
Message-ID: <20090515060045.GC17124@gondor.apana.org.au>
References: <20090511040341.GF4005@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Harald Welte <HaraldWelte@viatech.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53570 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756747AbZEOGAp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 May 2009 02:00:45 -0400
Content-Disposition: inline
In-Reply-To: <20090511040341.GF4005@prithivi.gnumonks.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 11, 2009 at 12:03:41PM +0800, Harald Welte wrote:
> Support VIA Nano hardware RNG
> 
> The VIA Nano CPU supports the same XSTORE instruction based RNG,
> but it lacks the MSR present in earlier CPUs.
> 
> Signed-off-by: Harald Welte <HaraldWelte@viatech.com>

Patch applied.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
