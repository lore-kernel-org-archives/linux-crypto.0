From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/2] Add SHA-3 algorithm and test vectors.
Date: Mon, 20 Jun 2016 19:35:17 +0800
Message-ID: <20160620113517.GD10773@gondor.apana.org.au>
References: <1466139636-19779-1-git-send-email-raveendra.padasalagi@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jon Mason <jonmason@broadcom.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Anup Patel <anup.patel@broadcom.com>,
	Ray Jui <rjui@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Pramod Kumar <pramod.kumar@broadcom.com>,
	bcm-kernel-feedback-list@broadcom.com
To: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466139636-19779-1-git-send-email-raveendra.padasalagi@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 17, 2016 at 10:30:34AM +0530, Raveendra Padasalagi wrote:
> This patchset adds the implementation of SHA-3 algorithm
> in software and it's based on original implementation
> pushed in patch https://lwn.net/Articles/518415/ with
> additional changes to match the padding rules specified
> in SHA-3 specification.
> 
> This patchset also includes changes in tcrypt module to
> add support for SHA-3 algorithms test and related test
> vectors for basic testing.
> 
> Broadcom Secure Processing Unit-2(SPU-2) engine supports
> offloading of SHA-3 operations in hardware, in order to
> add SHA-3 support in SPU-2 driver we needed to have the
> software implementation and test framework in place.
> 
> The patchset is based on v4.7-rc1 tag and its tested on
> Broadcom NorthStar2 SoC.
> 
> The patch set can be fetched from iproc-sha3-v2 branch
> of https://github.com/Broadcom/arm64-linux.git
> 
> Changes since v1:
>  - Renamed MODULE_ALIAS to MODULE_ALIAS_CRYPTO

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
