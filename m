Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D75E0C433C1
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 09:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F3D361A3F
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 09:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhCZJcY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Mar 2021 05:32:24 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35446 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229671AbhCZJcR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Mar 2021 05:32:17 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lPiob-0003VV-8k; Fri, 26 Mar 2021 20:31:38 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Mar 2021 20:31:36 +1100
Date:   Fri, 26 Mar 2021 20:31:36 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andreas Westin <andreas.westin@stericsson.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Berne Hebark <berne.herbark@stericsson.com>,
        Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Declan Murphy <declan.murphy@intel.com>,
        Harsh Jain <harsh@chelsio.com>,
        Henrique Cerri <mhcerri@br.ibm.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Jitendra Lulla <jlulla@chelsio.com>,
        Joakim Bech <joakim.xx.bech@stericsson.com>,
        Jonas Linde <jonas.linde@stericsson.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Kent Yoder <yoder1@us.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Manoj Malviya <manojmalviya@chelsio.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        M R Gowda <yeshaswi@chelsio.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Niklas Hernaeus <niklas.hernaeus@stericsson.com>,
        Paul Mackerras <paulus@samba.org>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Rob Rice <rob.rice@broadcom.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Shujuan Chen <shujuan.chen@stericsson.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Zaibo Xu <xuzaibo@huawei.com>
Subject: Re: [PATCH v3 00/10] Rid W=1 warnings in Crypto
Message-ID: <20210326093136.GH12658@gondor.apana.org.au>
References: <20210318124422.3200180-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210318124422.3200180-1-lee.jones@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 18, 2021 at 12:44:12PM +0000, Lee Jones wrote:
> This is set 1 of 2 sets required to fully clean Crypto.
> 
> v2: No functional changes since v1.
> v3: Description change and additional struct header fix
> 
> Lee Jones (10):
>   crypto: hisilicon: sec_drv: Supply missing description for
>     'sec_queue_empty()'s 'queue' param
>   crypto: bcm: Fix a whole host of kernel-doc misdemeanours
>   crypto: chelsio: chcr_core: Fix some kernel-doc issues
>   crypto: ux500: hash: hash_core: Fix worthy kernel-doc headers and
>     remove others
>   crypto: keembay: ocs-hcu: Fix incorrectly named functions/structs
>   crypto: atmel-ecc: Struct headers need to start with keyword 'struct'
>   crypto: caam: caampkc: Provide the name of the function and provide
>     missing descriptions
>   crypto: vmx: Source headers are not good kernel-doc candidates
>   crypto: nx: nx-aes-cbc: Repair some kernel-doc problems
>   crypto: cavium: nitrox_isr: Demote non-compliant kernel-doc headers
> 
>  drivers/crypto/atmel-ecc.c                |  2 +-
>  drivers/crypto/bcm/cipher.c               |  7 ++--
>  drivers/crypto/bcm/spu.c                  | 16 ++++-----
>  drivers/crypto/bcm/spu2.c                 | 43 +++++++++++++----------
>  drivers/crypto/bcm/util.c                 |  4 +--
>  drivers/crypto/caam/caamalg_qi2.c         |  3 ++
>  drivers/crypto/caam/caampkc.c             |  3 +-
>  drivers/crypto/cavium/nitrox/nitrox_isr.c |  4 +--
>  drivers/crypto/chelsio/chcr_algo.c        |  8 ++---
>  drivers/crypto/chelsio/chcr_core.c        |  2 +-
>  drivers/crypto/hisilicon/sec/sec_drv.c    |  1 +
>  drivers/crypto/keembay/ocs-hcu.c          |  8 ++---
>  drivers/crypto/nx/nx-aes-cbc.c            |  2 +-
>  drivers/crypto/nx/nx.c                    |  5 +--
>  drivers/crypto/nx/nx_debugfs.c            |  2 +-
>  drivers/crypto/ux500/cryp/cryp.c          |  5 +--
>  drivers/crypto/ux500/cryp/cryp_core.c     |  5 +--
>  drivers/crypto/ux500/cryp/cryp_irq.c      |  2 +-
>  drivers/crypto/ux500/hash/hash_core.c     | 15 +++-----
>  drivers/crypto/vmx/vmx.c                  |  2 +-
>  20 files changed, 73 insertions(+), 66 deletions(-)
> 
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: Atul Gupta <atul.gupta@chelsio.com>
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
> Cc: Ayush Sawal <ayush.sawal@chelsio.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Berne Hebark <berne.herbark@stericsson.com>
> Cc: "Breno Leitão" <leitao@debian.org>
> Cc: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Declan Murphy <declan.murphy@intel.com>
> Cc: Harsh Jain <harsh@chelsio.com>
> Cc: Henrique Cerri <mhcerri@br.ibm.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "Horia Geantă" <horia.geanta@nxp.com>
> Cc: Jitendra Lulla <jlulla@chelsio.com>
> Cc: Joakim Bech <joakim.xx.bech@stericsson.com>
> Cc: Jonas Linde <jonas.linde@stericsson.com>
> Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
> Cc: Kent Yoder <yoder1@us.ibm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
> Cc: Manoj Malviya <manojmalviya@chelsio.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: M R Gowda <yeshaswi@chelsio.com>
> Cc: Nayna Jain <nayna@linux.ibm.com>
> Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
> Cc: Niklas Hernaeus <niklas.hernaeus@stericsson.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
> Cc: Rob Rice <rob.rice@broadcom.com>
> Cc: Rohit Maheshwari <rohitm@chelsio.com>
> Cc: Shujuan Chen <shujuan.chen@stericsson.com>
> Cc: Tudor Ambarus <tudor.ambarus@microchip.com>
> Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
> Cc: Zaibo Xu <xuzaibo@huawei.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
