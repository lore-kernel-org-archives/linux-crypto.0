From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/5] camellia: cleanup
Date: Tue, 6 Nov 2007 22:17:40 +0800
Message-ID: <20071106141740.GA24423@gondor.apana.org.au>
References: <200710251243.58701.vda.linux@googlemail.com> <200710251245.04132.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3236 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751112AbXKFORp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Nov 2007 09:17:45 -0500
Content-Disposition: inline
In-Reply-To: <200710251245.04132.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 25, 2007 at 12:45:04PM +0100, Denys Vlasenko wrote:
> On Thursday 25 October 2007 12:43, Denys Vlasenko wrote:
> > Hi Hervert,
> > 
> > Please review and maybe propagate upstream following patches.
> > 
> > camellia1.diff:
> >     Move code blocks around so that related pieces are closer together:
> >     e.g. CAMELLIA_ROUNDSM macro does not need to be separated
> >     from the rest of the code by huge array of constants.
> > 
> >     Remove unused macros (COPY4WORD, SWAP4WORD, XOR4WORD[2])
> > 
> >     Drop SUBL(), SUBR() macros which only obscure things.
> >     Same for CAMELLIA_SP1110() macro and KEY_TABLE_TYPE typedef.
> > 
> >     Remove useless comments:
> >     /* encryption */ -- well it's obvious enough already!
> >     void camellia_encrypt128(...)
> > 
> >     Combine swap with copying at the beginning/end of encrypt/decrypt.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Patch applied.  Thanks Denis!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
