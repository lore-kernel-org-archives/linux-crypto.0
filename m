From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [PATCH] [crypto] LRW: use proper alignment.
Date: Wed, 5 Mar 2008 19:17:21 +0800
Message-ID: <20080305111721.GC27552@gondor.apana.org.au>
References: <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc> <1b5471b654eea02f82ccf0aad032fbbb951cbbc5.1204465942.git.sebastian@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44747 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752173AbYCELRX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Mar 2008 06:17:23 -0500
Content-Disposition: inline
In-Reply-To: <1b5471b654eea02f82ccf0aad032fbbb951cbbc5.1204465942.git.sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Mar 02, 2008 at 01:35:17PM +0000, Sebastian Siewior wrote:
> The LRW blockmode uses a copy of the IV which is saved on the stack
> and may or may not be properly aligned. If it is not, it will break
> hardware cipher like the geode or padlock.
> This patch moves the copy of IV to the private structre which has the
> same aligment as the underlying cipher.
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

The same comment applies to this patch.  Please change it to use
cit_* instead of cia_*.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
