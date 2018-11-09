Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37340 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbeKITai (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 14:30:38 -0500
Date: Fri, 9 Nov 2018 17:50:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ofir Drang <Ofir.Drang@arm.com>,
        Yael Chemla <Yael.Chemla@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] crypto: ccree: add CryptoCell 713 baseline support
Message-ID: <20181109095040.6wkjifw7hwlvoqq3@gondor.apana.org.au>
References: <1540806616-5483-1-git-send-email-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540806616-5483-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 29, 2018 at 09:50:11AM +0000, Gilad Ben-Yossef wrote:
> Add first batch of patches for support of Arm TrustZone CryptoCell 713.
> 
> Changes from v1:
> - Format dt bindings document one version per line and correct the heading
>   as indicated by Rob Herring.
> 
> Gilad Ben-Yossef (3):
>   crypto: ccree: add support for CryptoCell 713
>   dt-bindings: crypto: ccree: add ccree 713
>   crypto: ccree: add SM4 support
> 
>  .../devicetree/bindings/crypto/arm-cryptocell.txt  |  7 ++-
>  drivers/crypto/Kconfig                             |  3 +-
>  drivers/crypto/ccree/cc_cipher.c                   | 66 ++++++++++++++++++++++
>  drivers/crypto/ccree/cc_driver.c                   | 23 +++++---
>  drivers/crypto/ccree/cc_driver.h                   |  5 +-
>  drivers/crypto/ccree/cc_hw_queue_defs.h            |  3 +
>  6 files changed, 94 insertions(+), 13 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
