Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1F8C433DB
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 22:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC496207E8
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 22:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbhABWIn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jan 2021 17:08:43 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37340 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbhABWIm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jan 2021 17:08:42 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kvp3u-0000bT-DV; Sun, 03 Jan 2021 09:07:51 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 03 Jan 2021 09:07:50 +1100
Date:   Sun, 3 Jan 2021 09:07:50 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: Re: [PATCH v4 0/5] crypto: Add Keem Bay OCS HCU driver
Message-ID: <20210102220750.GL12767@gondor.apana.org.au>
References: <20201216114639.3451399-1-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216114639.3451399-1-daniele.alessandrelli@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 16, 2020 at 11:46:34AM +0000, Daniele Alessandrelli wrote:
> The Intel Keem Bay SoC has an Offload Crypto Subsystem (OCS) featuring a
> Hashing Control Unit (HCU) for accelerating hashing operations.
> 
> This driver adds support for such hardware thus enabling hardware-accelerated
> hashing on the Keem Bay SoC for the following algorithms:
> - sha224 and hmac(sha224)
> - sha256 and hmac(sha256)
> - sha384 and hmac(sha384)
> - sha512 and hmac(sha512)
> - sm3    and hmac(sm3)
> 
> The driver is passing crypto manager self-tests, including the extra tests
> (CRYPTO_MANAGER_EXTRA_TESTS=y).
> 
> v3 -> v4:
> - Addressed comments from Mark Gross.
> - Added Reviewed-by-tag from Rob Herring to DT binding patch.
> - Driver reworked to better separate the code interacting with the hardware
>   from the code implementing the crypto ahash API.
> - Main patch split into 3 different patches to simplify review (patch series is
>   now composed of 5 patches)
> 
> v2 -> v3:
> - Fixed more issues with dt-bindings (removed useless descriptions for reg,
>   interrupts, and clocks)
> 
> v1 -> v2:
> - Fixed issues with dt-bindings
> 
> Daniele Alessandrelli (3):
>   crypto: keembay-ocs-hcu - Add HMAC support
>   crypto: keembay-ocs-hcu - Add optional support for sha224
>   MAINTAINERS: Add maintainers for Keem Bay OCS HCU driver
> 
> Declan Murphy (2):
>   dt-bindings: crypto: Add Keem Bay OCS HCU bindings
>   crypto: keembay - Add Keem Bay OCS HCU driver
> 
>  .../crypto/intel,keembay-ocs-hcu.yaml         |   46 +
>  MAINTAINERS                                   |   11 +
>  drivers/crypto/keembay/Kconfig                |   29 +
>  drivers/crypto/keembay/Makefile               |    3 +
>  drivers/crypto/keembay/keembay-ocs-hcu-core.c | 1264 +++++++++++++++++
>  drivers/crypto/keembay/ocs-hcu.c              |  840 +++++++++++
>  drivers/crypto/keembay/ocs-hcu.h              |  106 ++
>  7 files changed, 2299 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
>  create mode 100644 drivers/crypto/keembay/keembay-ocs-hcu-core.c
>  create mode 100644 drivers/crypto/keembay/ocs-hcu.c
>  create mode 100644 drivers/crypto/keembay/ocs-hcu.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
