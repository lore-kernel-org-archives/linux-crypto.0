From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto: md5 - Add export support
Date: Wed, 13 Jan 2010 20:52:39 +1100
Message-ID: <20100113095239.GA11568@gondor.apana.org.au>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net> <1262026755-23056-4-git-send-email-max@hinterhof.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>
To: Max Vozeler <max@hinterhof.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40518 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753779Ab0AMJwo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2010 04:52:44 -0500
Content-Disposition: inline
In-Reply-To: <1262026755-23056-4-git-send-email-max@hinterhof.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 28, 2009 at 06:59:14PM +0000, Max Vozeler wrote:
> This patch adds export support to md5.  The exported type is
> defined by struct md5_state.
> 
> This is modeled after the equivalent change to sha1_generic,
> except only export is added for now.
> 
> Signed-off-by: Max Vozeler <max@hinterhof.net>
> Cc: Jari Ruusu <jariruusu@users.sourceforge.net>

Please add an import function as the shash API requires import
to be present if export is present.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
