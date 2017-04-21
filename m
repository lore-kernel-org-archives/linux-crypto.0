From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 0/2] crypto: hw_random - Add new Exynos RNG driver
Date: Fri, 21 Apr 2017 21:15:02 +0800
Message-ID: <20170421131502.GC14803@gondor.apana.org.au>
References: <20170411180835.8928-1-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Hogan <james.hogan@imgtec.com>,
        Matt Mackall <mpm@selenic.com>, Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Bernie Thompson <bernie@plugable.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        linux-kernel@vger.kernel.org, linux-metag@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:42962 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1039698AbdDUNRi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 09:17:38 -0400
Content-Disposition: inline
In-Reply-To: <20170411180835.8928-1-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 11, 2017 at 08:08:33PM +0200, Krzysztof Kozlowski wrote:
> Hi,
> 
> This is a follow up of my questions around exynos-rng [1].
> 
> Changes since v4:
> =================
> 1. Patch 2/2: Use "stdrng" name, as suggested by Herbert.
> 2. Patch 2/2: Add Bartlomiej's reviewed-by.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
