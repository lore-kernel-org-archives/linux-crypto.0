From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/5] camellia: cleanup
Date: Tue, 6 Nov 2007 22:19:46 +0800
Message-ID: <20071106141946.GB24423@gondor.apana.org.au>
References: <200710251243.58701.vda.linux@googlemail.com> <200710251245.42880.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3259 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750981AbXKFOTt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Nov 2007 09:19:49 -0500
Content-Disposition: inline
In-Reply-To: <200710251245.42880.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 25, 2007 at 12:45:42PM +0100, Denys Vlasenko wrote:
> On Thursday 25 October 2007 12:43, Denys Vlasenko wrote:
> > Hi Hervert,
> > 
> > Please review and maybe propagate upstream following patches.
> > 
> > camellia2.diff
> >     Rename some macros to shorter names: CAMELLIA_RR8 -> ROR8,
> >     making it easier to understand that it is just a right rotation,
> >     nothing camellia-specific in it.
> >     CAMELLIA_SUBKEY_L() -> SUBKEY_L() - just shorter.
> > 
> >     Move be32 <-> cpu conversions out of en/decrypt128/256 and into
> >     camellia_en/decrypt - no reason to have that code duplicated twice.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Patch applied.  BTW, we have a function called ror32 that can
replace all of these ROR* macros.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
