Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F717C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC67E611C1
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhJ2NNo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 09:13:44 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56392 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhJ2NNn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 09:13:43 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mgRf7-0002mh-Td; Fri, 29 Oct 2021 21:11:13 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mgRey-0003CW-EB; Fri, 29 Oct 2021 21:11:04 +0800
Date:   Fri, 29 Oct 2021 21:11:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
Cc:     linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>
Subject: Re: [PATCH 0/5] Keem Bay OCS ECC crypto driver
Message-ID: <20211029131104.GA12278@gondor.apana.org.au>
References: <20211020103538.360614-1-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020103538.360614-1-daniele.alessandrelli@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 20, 2021 at 11:35:33AM +0100, Daniele Alessandrelli wrote:
> Hi,
> 
> This patch series adds the Intel Keem Bay OCS ECC crypto driver, which
> enables hardware-accelerated 'ecdh-nist-p256' and 'ecdh-nist-p384' on
> the Intel Keem Bay SoC.
> 
> The following changes to core crypto code are also done:
> - KPP support is added to the crypto engine (so that the new driver can
>   use it).
> - 'crypto/ecc.h' is moved to 'include/crypto/internal' (so that this and
>   other drivers can use the symbols exported by 'crypto/ecc.c').
> - A few additional functions from 'crypto/ecc.c' are exported (so that
>   this and other drivers can use them and avoid code duplication).
> 
> The driver passes crypto manager self-tests.
> 
> A previous version of this patch series was submitted as an RFC:
> https://lore.kernel.org/linux-crypto/20201217172101.381772-1-daniele.alessandrelli@linux.intel.com/
> 
> Changes from previous RFC submission (RFC-v1):
> - Switched to the new 'ecdh-nist-p256' and 'ecdh-nist-p384' algorithm
>   names
> - Dropped the CONFIG_CRYPTO_DEV_KEEMBAY_OCS_ECDH_GEN_PRIV_KEY_SUPPORT
>   Kconfig option
> 
> Daniele Alessandrelli (2):
>   crypto: ecc - Move ecc.h to include/crypto/internal
>   crypto: ecc - Export additional helper functions
> 
> Prabhjot Khurana (3):
>   crypto: engine - Add KPP Support to Crypto Engine
>   dt-bindings: crypto: Add Keem Bay ECC bindings
>   crypto: keembay-ocs-ecc - Add Keem Bay OCS ECC Driver
> 
>  Documentation/crypto/crypto_engine.rst        |    4 +
>  .../crypto/intel,keembay-ocs-ecc.yaml         |   47 +
>  MAINTAINERS                                   |   11 +
>  crypto/crypto_engine.c                        |   26 +
>  crypto/ecc.c                                  |   14 +-
>  crypto/ecdh.c                                 |    2 +-
>  crypto/ecdsa.c                                |    2 +-
>  crypto/ecrdsa.c                               |    2 +-
>  crypto/ecrdsa_defs.h                          |    2 +-
>  drivers/crypto/keembay/Kconfig                |   19 +
>  drivers/crypto/keembay/Makefile               |    2 +
>  drivers/crypto/keembay/keembay-ocs-ecc.c      | 1017 +++++++++++++++++
>  include/crypto/engine.h                       |    5 +
>  {crypto => include/crypto/internal}/ecc.h     |   36 +
>  14 files changed, 1180 insertions(+), 9 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-ecc.yaml
>  create mode 100644 drivers/crypto/keembay/keembay-ocs-ecc.c
>  rename {crypto => include/crypto/internal}/ecc.h (90%)
> 
> 
> base-commit: 06f6e365e2ecf799c249bb464aa9d5f055e88b56

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
