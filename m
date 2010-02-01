From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/4] crypto: lmk2/lmk3 cipher block modes
Date: Mon, 1 Feb 2010 21:44:52 +1100
Message-ID: <20100201104452.GA1096@gondor.apana.org.au>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net> <1262026755-23056-5-git-send-email-max@hinterhof.net> <20100117110325.GA32635@gondor.apana.org.au> <20100118165234.GD3964@quark.vpn.nusquama.org> <20100119080038.GA20166@gondor.apana.org.au> <20100201103227.GA30127@quark.vpn.nusquama.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org, linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44225 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754018Ab0BAKo5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2010 05:44:57 -0500
Content-Disposition: inline
In-Reply-To: <20100201103227.GA30127@quark.vpn.nusquama.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 01, 2010 at 11:32:27AM +0100, Max Vozeler wrote:
> 
> I'm wondering if I'm heading in the right direction since
> this is stretching my understanding of the API:
> 
> Would it look something like ccm, in that

Not quite.

>  alloc does
>   - crypto_grab_skcipher(spawn, "cbc(aes)"
>   - crypto_skcipher_spawn_alg()
> 
>  then my alg.cra_init does
>   - crypto_spawn_skcipher ? 

The skcipher interface is synchronous only.  It's OK for CCM and
GCM as we don't currently have an async CTR implementation.

For CBC however you really need the ablkcipher interface so that
all hardware implementations are available, notably the Intel AES
implementation is only available through the async interface.

The authenc/chainiv/seqiv drivers should serve as an example as
to how the ablkcipher interface can be used.

The other place where it differs from ccm is that ccm is an
AEAD algorithm, thus presenting itself through the crypto_aead
interface.  You will on the other hand present an ablkcipher
interface.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
