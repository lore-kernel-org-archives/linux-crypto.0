From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: meson: Remove unneeded platform MODULE_ALIAS
Date: Tue, 25 Oct 2016 11:43:41 +0800
Message-ID: <20161025034341.GI18685@gondor.apana.org.au>
References: <1476906618-14455-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Carlo Caione <carlo@caione.org>,
        linux-amlogic@lists.infradead.org, Matt Mackall <mpm@selenic.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Javier Martinez Canillas <javier@osg.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44204 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752330AbcJYDoS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Oct 2016 23:44:18 -0400
Content-Disposition: inline
In-Reply-To: <1476906618-14455-1-git-send-email-javier@osg.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 19, 2016 at 04:50:18PM -0300, Javier Martinez Canillas wrote:
> The Amlogic Meson is a DT-only platform, which means the devices are
> registered via OF and not using the legacy platform devices support.
> 
> So there's no need to have a MODULE_ALIAS("platform:meson-rng") since
> the reported uevent MODALIAS to user-space will always be the OF one.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
