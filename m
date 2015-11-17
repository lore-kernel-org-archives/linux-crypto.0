From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto-ixp4xx: Reduce assignment for a variable in
 init_ixp_crypto()
Date: Tue, 17 Nov 2015 21:48:48 +0800
Message-ID: <20151117134848.GA9452@gondor.apana.org.au>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <5648D2C1.8050603@users.sourceforge.net>
 <5648D466.10307@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40997 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbbKQNsz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Nov 2015 08:48:55 -0500
Content-Disposition: inline
In-Reply-To: <5648D466.10307@users.sourceforge.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 15, 2015 at 07:52:22PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 15 Nov 2015 19:06:44 +0100
> 
> The variable "ret" was set more often than necessary by the
> init_ixp_crypto() function.
> 
> * Omit its initialisation at the beginning.
> 
> * Use an error return code in two cases directly.
> 
> * Improve compliance with the Linux coding style convention.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Again I don't see how this is making the code better so nack.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
