From: Max Vozeler <max@hinterhof.net>
Subject: Re: [PATCH 4/4] crypto: lmk2/lmk3 cipher block modes
Date: Mon, 1 Feb 2010 11:32:27 +0100
Message-ID: <20100201103227.GA30127@quark.vpn.nusquama.org>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net>
 <1262026755-23056-5-git-send-email-max@hinterhof.net>
 <20100117110325.GA32635@gondor.apana.org.au>
 <20100118165234.GD3964@quark.vpn.nusquama.org>
 <20100119080038.GA20166@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.nusquama.org ([85.131.211.20]:52372 "EHLO
	mail.nusquama.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab0BAKeD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2010 05:34:03 -0500
Content-Disposition: inline
In-Reply-To: <20100119080038.GA20166@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Tue, Jan 19, 2010 at 09:00:38PM +1300, Herbert Xu wrote:
> Let's keep lmk2/lmk3 as separate modes, but implement it as a
> wrapper around cbc.  That is, instead of allocating the cipher,
> you'd allocate "cbc(cipher)" (as an ablkcipher) and use it to
> perform the actual encryption/decryption.

I started looking at this today.

I'm wondering if I'm heading in the right direction since
this is stretching my understanding of the API:

Would it look something like ccm, in that

 alloc does
  - crypto_grab_skcipher(spawn, "cbc(aes)"
  - crypto_skcipher_spawn_alg()

 then my alg.cra_init does
  - crypto_spawn_skcipher ? 

Any advice appreciated. In the meantime I'll read the code
to get a better understanding of how this fits together.

	Max
