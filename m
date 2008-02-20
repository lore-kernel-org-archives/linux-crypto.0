From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Thu, 21 Feb 2008 01:29:58 +0800
Message-ID: <20080220172958.GF27726@gondor.apana.org.au>
References: <E1JRLsx-0003Yz-00@gondolin.me.apana.org.au> <47BB036D.7090701@trash.net> <20080220005329.GA21565@gondor.apana.org.au> <47BC1E12.9050201@trash.net> <20080220131903.GA1965@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56187 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752620AbYBTRaE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Feb 2008 12:30:04 -0500
Content-Disposition: inline
In-Reply-To: <20080220131903.GA1965@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 20, 2008 at 04:19:03PM +0300, Evgeniy Polyakov wrote:
>
> What iv generation scheme do you use? It looks like only gcm and ccm add
> 16 bytes to cryptlen and set nbytes to them. Although they both install
> two scatterlists for crypto operation: one for data and one for above
> addition block of 16 bytes.
> 
> Btw, Herbert, I've found a tiny typo in both ccm and gcm modules, which
> do not set correct cra_aead.geniv name.

Actually rfc4309/rfc4106 do need to use the seqiv generator.
Also ccm/gcm are not IV generators so they can't be used in
the geniv field.  The geniv field is meant to contain an IV
generator template that takes a block cipher which may lack a
givencrypt function and produce a new block cipher with a
givencrypt function.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
