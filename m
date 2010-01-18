From: Max Vozeler <max@hinterhof.net>
Subject: Re: [PATCH 4/4] crypto: lmk2/lmk3 cipher block modes
Date: Mon, 18 Jan 2010 17:52:34 +0100
Message-ID: <20100118165234.GD3964@quark.vpn.nusquama.org>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net>
 <1262026755-23056-5-git-send-email-max@hinterhof.net>
 <20100117110325.GA32635@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.nusquama.org ([85.131.211.20]:45875 "EHLO
	mail.nusquama.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0ARQw7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2010 11:52:59 -0500
Content-Disposition: inline
In-Reply-To: <20100117110325.GA32635@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert,

On Sun, Jan 17, 2010 at 10:03:25PM +1100, Herbert Xu wrote:
> On Mon, Dec 28, 2009 at 06:59:15PM +0000, Max Vozeler wrote:
> > Both modes operate on full 512 byte sectors. They use CBC
> > with an IV derived from the sector number, the data and (for
> > lmk3 only) an extra 128-bit IV seed.
> 
> So this is just CBC with a modified IV? 

Is is almost CBC, but not exactly.

The difference is that the IV is derived from the cleartext and
so is not known before decrypt.

So decrypt could be described using CBC as, I think:

 1) CBC decrypt with null IV
 2) Derive IV based on cleartext of blocks 1..31
 3) XOR block 0 with IV

> If so it should not be implemented as another mode. Doing it as
> a mode means that you will not benefit from any hardware
> implementations of CBC.

If there is some way to implement it cleanly without making it
another mode I would prefer doing that.

> You should instead implement it as an IV generator.  Currently
> they're done in dm-crypt. 

I'd agree that dm-crypt would be the more suitable place.

But I'm not sure how to implement it given the difference
described above. It might look something like this:

 - Add IV generators "lmk2", "lmk3"

 - Treat them as "cbc" with null IV internally, then after 
   decrypt derive IV and xor block 0 with it.

The second part is why I built this as a mode originally. It
seemed like it was not belonging in dm-crypt.

	Max
