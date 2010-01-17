From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto: md5 - Add export support
Date: Sun, 17 Jan 2010 21:55:52 +1100
Message-ID: <20100117105552.GA32505@gondor.apana.org.au>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net> <1262026755-23056-4-git-send-email-max@hinterhof.net> <20100113095239.GA11568@gondor.apana.org.au> <20100113173706.GB29443@quark.vpn.nusquama.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org, linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33268 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750783Ab0AQKz4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Jan 2010 05:55:56 -0500
Content-Disposition: inline
In-Reply-To: <20100113173706.GB29443@quark.vpn.nusquama.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 13, 2010 at 06:37:06PM +0100, Max Vozeler wrote:
>
> This patch adds export/import support to md5. The exported type is
> defined by struct md5_state.
> 
> This is modeled after the equivalent change to sha1_generic.

Applied to cryptodev.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
