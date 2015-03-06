From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/2] Add support for Broadcom RNG200
Date: Fri, 6 Mar 2015 22:53:48 +1100
Message-ID: <20150306115348.GA5363@gondor.apana.org.au>
References: <sbranden@broadcom.com>
 <1425501734-14025-1-git-send-email-sbranden@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bcm-kernel-feedback-list@broadcom.com,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Matt Mackall <mpm@selenic.com>,
	Grant Likely <grant.likely@linaro.org>,
	Ray Jui <rjui@broadcom.com>,
	Jonathan Richardson <jonathar@broadcom.com>,
	Dmitry Torokhov <dtor@google.com>,
	Anatol Pomazao <anatol@google.com>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Scott Branden <sbranden@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1425501734-14025-1-git-send-email-sbranden@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 04, 2015 at 12:42:12PM -0800, Scott Branden wrote:
> This series of patchsets contains the Broadcom Random Number Generator
> driver and device tree binding documentation.
> 
> Changes from v2:
>  added usleep_range instead of cpu_relax
>  add init and cleanup functions following new hwrng model

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
