Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37648 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbeKPQaf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Nov 2018 11:30:35 -0500
Date: Fri, 16 Nov 2018 14:19:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Cristian Stoica <cristian.stoica@microchip.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/5] crypto: caam - add support for Era 10
Message-ID: <20181116061926.txgs4tznsfzuqad5@gondor.apana.org.au>
References: <20181108133631.15779-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181108133631.15779-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 08, 2018 at 03:36:26PM +0200, Horia Geantă wrote:
> This patch set adds support for CAAM Era 10, currently used in LX2160A SoC:
> -new register mapping: some registers/fields are deprecated and moved
> to different locations, mainly version registers
> -algorithms
> chacha20 (over DPSECI - Data Path SEC Interface on fsl-mc bus)
> rfc7539(chacha20,poly1305) (over both DPSECI and Job Ring Interface)
> rfc7539esp(chacha20,poly1305) (over both DPSECI and Job Ring Interface)
> 
> Note: the patch set is generated on top of cryptodev-2.6, however testing
> was performed based on linux-next (tag: next-20181108) - which includes
> LX2160A platform support + manually updating LX2160A dts with:
> -fsl-mc bus DT node
> -missing dma-ranges property in soc DT node
> 
> Cristian Stoica (1):
>   crypto: export CHACHAPOLY_IV_SIZE
> 
> Horia Geantă (4):
>   crypto: caam - add register map changes cf. Era 10
>   crypto: caam/qi2 - add support for ChaCha20
>   crypto: caam/jr - add support for Chacha20 + Poly1305
>   crypto: caam/qi2 - add support for Chacha20 + Poly1305
> 
>  crypto/chacha20poly1305.c          |   2 -
>  drivers/crypto/caam/caamalg.c      | 266 ++++++++++++++++++++++++++++++++++---
>  drivers/crypto/caam/caamalg_desc.c | 139 ++++++++++++++++++-
>  drivers/crypto/caam/caamalg_desc.h |   5 +
>  drivers/crypto/caam/caamalg_qi.c   |  37 ++++--
>  drivers/crypto/caam/caamalg_qi2.c  | 156 +++++++++++++++++++++-
>  drivers/crypto/caam/caamhash.c     |  20 ++-
>  drivers/crypto/caam/caampkc.c      |  10 +-
>  drivers/crypto/caam/caamrng.c      |  10 +-
>  drivers/crypto/caam/compat.h       |   2 +
>  drivers/crypto/caam/ctrl.c         |  28 +++-
>  drivers/crypto/caam/desc.h         |  28 ++++
>  drivers/crypto/caam/desc_constr.h  |   7 +-
>  drivers/crypto/caam/regs.h         |  74 +++++++++--
>  include/crypto/chacha20.h          |   1 +
>  15 files changed, 724 insertions(+), 61 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
