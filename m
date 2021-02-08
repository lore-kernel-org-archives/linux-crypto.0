Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E303C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E73A64E9D
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhBHJuT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:50:19 -0500
Received: from linux.microsoft.com ([13.77.154.182]:36394 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbhBHJrl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:47:41 -0500
Received: from [192.168.0.114] (unknown [49.207.205.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id D633E20B6C40;
        Mon,  8 Feb 2021 01:46:50 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D633E20B6C40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1612777619;
        bh=R2/ccuzxb5NZv2ZzRkculnBKFeUjJYNG5AB4+Yu0bPg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=i7FLf4yy+QFOBtd9kBrZwl6Reg9zTXFL221Zf9UmnfgsJ1QxJgb+YPXbwmnCK5jBU
         3f4umBqomg54xaCDL6BAnr+RNGBQQKWoPOsJWz6gIupXFeQeBlDDI+KOUSxP3+Dkwc
         yZFpPuu2DsXGMAK45zKF10uQyObDY1+wgEX801pk=
Subject: Re: [PATCH v5 00/19]crypto: convert tasklets to use new tasklet_setup
 API()
To:     Allen Pais <allen.lkml@gmail.com>, herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, gcherian@marvell.com,
        thomas.lendacky@amd.com, john.allen@amd.com, gilad@benyossef.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com,
        giovanni.cabiddu@intel.com, heiko@sntech.de, krzk@kernel.org,
        vz@mleia.com, k.konieczny@samsung.com,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        qat-linux@intel.com, linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
References: <20210208094238.571015-1-allen.lkml@gmail.com>
From:   Allen Pais <apais@linux.microsoft.com>
Message-ID: <9e26b2b1-2bd3-4398-5ed1-981eac87953d@linux.microsoft.com>
Date:   Mon, 8 Feb 2021 15:16:42 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210208094238.571015-1-allen.lkml@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> From: Allen Pais <apais@linux.microsoft.com>
> 
> Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")
> introduced a new tasklet initialization API. This series converts
> all the crypto modules to use the new tasklet_setup() API
> 
> The series is based on v5.11-rc4 (19c329f68089)

  I missed updating this bit. The series is based on
v5.11-rc7 (92bf22614b21).

Thanks.

> v5:
>    - Fix amcc build failure.
> 
> v4:
>    - added acks
>    - fixed checkpatch errors(Giovanni Cabiddu)
> 
> v3:
>    - fixed rockchip driver(Emil Renner Berthing)
> 
> v2:
>    - added acks
>    - addressed comments [Krzysztof and Gilad]
> 
> Allen Pais (19):
>    crypto: amcc: convert tasklets to use new tasklet_setup() API
>    crypto: atmel: convert tasklets to use new tasklet_setup() API
>    crypto: axis: convert tasklets to use new tasklet_setup() API
>    crypto: caam: convert tasklets to use new tasklet_setup() API
>    crypto: cavium: convert tasklets to use new tasklet_setup() API
>    crypto: ccp: convert tasklets to use new tasklet_setup() API
>    crypto: ccree: convert tasklets to use new tasklet_setup() API
>    crypto: hifn_795x: convert tasklets to use new tasklet_setup() API
>    crypto: img-hash: convert tasklets to use new tasklet_setup() API
>    crypto: ixp4xx: convert tasklets to use new tasklet_setup() API
>    crypto: mediatek: convert tasklets to use new tasklet_setup() API
>    crypto: omap: convert tasklets to use new tasklet_setup() API
>    crypto: picoxcell: convert tasklets to use new tasklet_setup() API
>    crypto: qat: convert tasklets to use new tasklet_setup() API
>    crypto: qce: convert tasklets to use new tasklet_setup() API
>    crypto: rockchip: convert tasklets to use new tasklet_setup() API
>    crypto: s5p: convert tasklets to use new tasklet_setup() API
>    crypto: talitos: convert tasklets to use new tasklet_setup() API
>    crypto: octeontx: convert tasklets to use new tasklet_setup() API
> 
>   drivers/crypto/amcc/crypto4xx_core.c          | 10 ++---
>   drivers/crypto/atmel-aes.c                    | 14 +++----
>   drivers/crypto/atmel-sha.c                    | 14 +++----
>   drivers/crypto/atmel-tdes.c                   | 14 +++----
>   drivers/crypto/axis/artpec6_crypto.c          |  7 ++--
>   drivers/crypto/caam/jr.c                      |  9 ++--
>   drivers/crypto/cavium/cpt/cptvf_main.c        |  9 ++--
>   drivers/crypto/cavium/nitrox/nitrox_common.h  |  2 +-
>   drivers/crypto/cavium/nitrox/nitrox_isr.c     | 13 +++---
>   drivers/crypto/cavium/nitrox/nitrox_reqmgr.c  |  4 +-
>   drivers/crypto/ccp/ccp-dev-v3.c               |  9 ++--
>   drivers/crypto/ccp/ccp-dev-v5.c               |  9 ++--
>   drivers/crypto/ccp/ccp-dmaengine.c            |  7 ++--
>   drivers/crypto/ccree/cc_fips.c                |  8 ++--
>   drivers/crypto/ccree/cc_request_mgr.c         | 12 +++---
>   drivers/crypto/hifn_795x.c                    |  6 +--
>   drivers/crypto/img-hash.c                     | 12 +++---
>   drivers/crypto/ixp4xx_crypto.c                |  4 +-
>   .../crypto/marvell/octeontx/otx_cptvf_main.c  | 12 +++---
>   drivers/crypto/mediatek/mtk-aes.c             | 14 +++----
>   drivers/crypto/mediatek/mtk-sha.c             | 14 +++----
>   drivers/crypto/omap-aes.c                     |  6 +--
>   drivers/crypto/omap-des.c                     |  6 +--
>   drivers/crypto/omap-sham.c                    |  6 +--
>   drivers/crypto/picoxcell_crypto.c             |  7 ++--
>   drivers/crypto/qat/qat_common/adf_isr.c       |  5 +--
>   drivers/crypto/qat/qat_common/adf_sriov.c     | 10 ++---
>   drivers/crypto/qat/qat_common/adf_transport.c |  4 +-
>   .../qat/qat_common/adf_transport_internal.h   |  2 +-
>   drivers/crypto/qat/qat_common/adf_vf_isr.c    | 11 +++--
>   drivers/crypto/qce/core.c                     |  7 ++--
>   drivers/crypto/rockchip/rk3288_crypto.c       | 14 +++----
>   drivers/crypto/s5p-sss.c                      | 13 +++---
>   drivers/crypto/talitos.c                      | 42 +++++++++----------
>   34 files changed, 154 insertions(+), 182 deletions(-)
> 
