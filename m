From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/4] crypto: lmk2/lmk3 cipher block modes
Date: Sun, 17 Jan 2010 22:03:25 +1100
Message-ID: <20100117110325.GA32635@gondor.apana.org.au>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net> <1262026755-23056-5-git-send-email-max@hinterhof.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>
To: Max Vozeler <max@hinterhof.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36897 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750953Ab0AQLD3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Jan 2010 06:03:29 -0500
Content-Disposition: inline
In-Reply-To: <1262026755-23056-5-git-send-email-max@hinterhof.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 28, 2009 at 06:59:15PM +0000, Max Vozeler wrote:
> This is a compatible implementation of the block chaining
> modes used by the Loop-AES block device encryption system
> (http://loop-aes.sf.net/).
> 
> It implements two modes: lmk2 and lmk3. They correspond to
> the modes used in Loop-AES v2.x and Loop-AES v3.x and are
> intended to be full compatible.
> 
> Both modes operate on full 512 byte sectors. They use CBC
> with an IV derived from the sector number, the data and (for
> lmk3 only) an extra 128-bit IV seed.
> 
> Signed-off-by: Max Vozeler <max@hinterhof.net>
> Cc: Jari Ruusu <jariruusu@users.sourceforge.net>

So this is just CBC with a modified IV? If so it should not be
implemented as another mode.  Doing it as a mode means that you
will not benefit from any hardware implementations of CBC.

You should instead implement it as an IV generator.  Currently
they're done in dm-crypt.  But we could move them into crypto
at some point if there are multiple users in the kernel.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
