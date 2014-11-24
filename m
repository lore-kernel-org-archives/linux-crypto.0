From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: Add Imagination Technologies hw hash
 accelerator
Date: Mon, 24 Nov 2014 22:39:17 +0800
Message-ID: <20141124143916.GA31808@gondor.apana.org.au>
References: <1415621455-10468-1-git-send-email-james.hartley@imgtec.com>
 <1415621455-10468-2-git-send-email-james.hartley@imgtec.com>
 <CAL1qeaGN9q_WHP2YJ3fY3r11v0pitcmwbjam5dRzeZhHCp7c8g@mail.gmail.com>
 <5467070E.5040104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Bresticker <abrestic@chromium.org>,
	James Hartley <james.hartley@imgtec.com>, davem@davemloft.net,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	joe@perches.com, mchehab@osg.samsung.com,
	Antti Palosaari <crope@iki.fi>, jg1.han@samsung.com,
	linux-crypto@vger.kernel.org,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Ezequiel Garcia <ezequiel.garcia@imgtec.com>
To: Corentin LABBE <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60948 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbaKXOj4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2014 09:39:56 -0500
Content-Disposition: inline
In-Reply-To: <5467070E.5040104@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Nov 15, 2014 at 08:55:58AM +0100, Corentin LABBE wrote:
>
> and then get it via
> struct crypto_priv *cp = req->base.tfm->__crt_alg->data;
> (a function will be better than that)
> 
> So what is the recommended way to get driver structure inside the cryptoAPI function (init/udpate/final)?

Have a look at talitos which deals with this by embedding crypto_alg
within its own data structure.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
