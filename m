Return-Path: <SRS0=/ZR5=OQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48990 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbeLGGS0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Dec 2018 01:18:26 -0500
Date: Fri, 7 Dec 2018 14:18:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Yael Chemla <yael.chemla@foss.arm.com>,
        Ofir Drang <Ofir.Drang@arm.com>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] new HW version and co-maintainer
Message-ID: <20181207061816.a27rmuk5uzki7bjd@gondor.apana.org.au>
References: <1542102039-22256-1-git-send-email-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542102039-22256-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 13, 2018 at 09:40:34AM +0000, Gilad Ben-Yossef wrote:
> Add support for CryptoCell 703 HW revision and a new co-maintainer.
> 
> Gilad Ben-Yossef (3):
>   crypto: ccree: add support for CryptoCell 703
>   dt-bindings: crypto: ccree: add dt bindings for ccree 703
>   MAINTAINERS: ccree: add co-maintainer
> 
>  .../devicetree/bindings/crypto/arm-cryptocell.txt  |  1 +
>  MAINTAINERS                                        |  1 +
>  drivers/crypto/Kconfig                             |  2 +-
>  drivers/crypto/ccree/cc_aead.c                     | 16 ++++++++-
>  drivers/crypto/ccree/cc_cipher.c                   | 38 +++++++++++++++++++++-
>  drivers/crypto/ccree/cc_driver.c                   | 19 ++++++++---
>  drivers/crypto/ccree/cc_driver.h                   |  8 +++++
>  drivers/crypto/ccree/cc_hash.c                     | 16 +++++++--
>  8 files changed, 92 insertions(+), 9 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
