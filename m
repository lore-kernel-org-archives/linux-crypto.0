From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/4] crypto: lmk2/lmk3 cipher block modes
Date: Tue, 19 Jan 2010 21:00:38 +1300
Message-ID: <20100119080038.GA20166@gondor.apana.org.au>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net> <1262026755-23056-5-git-send-email-max@hinterhof.net> <20100117110325.GA32635@gondor.apana.org.au> <20100118165234.GD3964@quark.vpn.nusquama.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org, linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50542 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753851Ab0ASIAm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jan 2010 03:00:42 -0500
Content-Disposition: inline
In-Reply-To: <20100118165234.GD3964@quark.vpn.nusquama.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 18, 2010 at 05:52:34PM +0100, Max Vozeler wrote:
>
> The difference is that the IV is derived from the cleartext and
> so is not known before decrypt.
> 
> So decrypt could be described using CBC as, I think:
> 
>  1) CBC decrypt with null IV
>  2) Derive IV based on cleartext of blocks 1..31
>  3) XOR block 0 with IV

Yep, this sounds like the way it should be implemented.
 
> But I'm not sure how to implement it given the difference
> described above. It might look something like this:
> 
>  - Add IV generators "lmk2", "lmk3"
> 
>  - Treat them as "cbc" with null IV internally, then after 
>    decrypt derive IV and xor block 0 with it.
> 
> The second part is why I built this as a mode originally. It
> seemed like it was not belonging in dm-crypt.

OK, I see what you mean.

Let's keep lmk2/lmk3 as separate modes, but implement it as a
wrapper around cbc.  That is, instead of allocating the cipher,
you'd allocate "cbc(cipher)" (as an ablkcipher) and use it to
perform the actual encryption/decryption.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
