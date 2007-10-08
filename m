From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] load the SHA1[1|256] module by an alias (v2)
Date: Mon, 8 Oct 2007 12:12:07 +0800
Message-ID: <20071008041207.GA32533@gondor.apana.org.au>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au> <20071004083512.GA11305@Chamillionaire.breakpoint.cc> <E1IdMSX-0004KV-LS@Chamillionaire.breakpoint.cc> <20071005085744.GC10959@gondor.apana.org.au> <E1IdnjO-0006eu-JQ@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1807 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750749AbXJHEMK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Oct 2007 00:12:10 -0400
Content-Disposition: inline
In-Reply-To: <E1IdnjO-0006eu-JQ@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 05, 2007 at 03:12:10PM +0200, Sebastian Siewior wrote:
> Loading the crypto algorithm by the alias instead of by module directly
> has the advantage that all possible implementations of this algorithm
> are loaded automatically and the crypto API can choose the best one
> depending on its priority.
> Additionally it ensures that the generic implementation as well as the
> HW driver (if available) is loaded in case the HW driver needs the
> generic version as fallback in corner cases.
> Also remove the probe for sha1 in padlock's init code.
> Quote from Herbert:
>   The probe is actually pointless since we can always probe when
>   the algorithm is actually used which does not lead to dead-locks
>   like this.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Patch applied with one small change where I left the *-padlock
aliases around since people might already be using them and
they're correct as the specific name of those algorithms.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
