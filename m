Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA22C4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 10:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 877F823ED0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 10:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388659AbgLKKOz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Dec 2020 05:14:55 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33380 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731373AbgLKKOW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Dec 2020 05:14:22 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1knfQa-0004wK-39; Fri, 11 Dec 2020 21:13:33 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Dec 2020 21:13:32 +1100
Date:   Fri, 11 Dec 2020 21:13:32 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
Cc:     linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>
Subject: Re: [PATCH 0/2] crypto: Add Keem Bay OCS AES/SM4 driver
Message-ID: <20201211101332.GA3266@gondor.apana.org.au>
References: <20201126115148.68039-1-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126115148.68039-1-daniele.alessandrelli@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 26, 2020 at 11:51:46AM +0000, Daniele Alessandrelli wrote:
> The Intel Keem Bay SoC has an Offload Crypto Subsystem (OCS) featuring a
> crypto engine for accelerating AES/SM4 operations.
> 
> This driver adds support for such hardware thus enabling hardware
> acceleration for the following transformations on the Intel Keem Bay SoC:
> 
> - ecb(aes), cbc(aes), ctr(aes), cts(cbc(aes)), gcm(aes) and cbc(aes);
>   supported for 128-bit and 256-bit keys.
> 
> - ecb(sm4), cbc(sm4), ctr(sm4), cts(cbc(sm4)), gcm(sm4) and cbc(sm4);
>   supported for 128-bit keys.
> 
> The driver passes crypto manager self-tests, including the extra tests
> (CRYPTO_MANAGER_EXTRA_TESTS=y).
> 
> Note: this driver is different from the Keem Bay OCS HCU driver previously
> submitted. Keem Bay OCS HCU provides hardware-accelerated ahash, while
> Keem Bay AES/SM4 (i.e., this driver) provides hardware-accelerated
> skcipher and aead.
> 
> 
> Daniele Alessandrelli (1):
>   dt-bindings: Add Keem Bay OCS AES bindings
> 
> Mike Healy (1):
>   crypto: keembay-ocs-aes: Add support for Keem Bay OCS AES/SM4
> 
>  .../crypto/intel,keembay-ocs-aes.yaml         |   45 +
>  MAINTAINERS                                   |   10 +
>  drivers/crypto/Kconfig                        |    2 +
>  drivers/crypto/Makefile                       |    1 +
>  drivers/crypto/keembay/Kconfig                |   39 +
>  drivers/crypto/keembay/Makefile               |    5 +
>  drivers/crypto/keembay/keembay-ocs-aes-core.c | 1713 +++++++++++++++++
>  drivers/crypto/keembay/ocs-aes.c              | 1489 ++++++++++++++
>  drivers/crypto/keembay/ocs-aes.h              |  129 ++
>  9 files changed, 3433 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-aes.yaml
>  create mode 100644 drivers/crypto/keembay/Kconfig
>  create mode 100644 drivers/crypto/keembay/Makefile
>  create mode 100644 drivers/crypto/keembay/keembay-ocs-aes-core.c
>  create mode 100644 drivers/crypto/keembay/ocs-aes.c
>  create mode 100644 drivers/crypto/keembay/ocs-aes.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
