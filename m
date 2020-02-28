Return-Path: <SRS0=oD/a=4Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAADAC3F2CE
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 00:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD2E9246A8
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 00:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbgB1Auq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Feb 2020 19:50:46 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:55664 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729984AbgB1Auq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Feb 2020 19:50:46 -0500
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1j7TrO-0000Lx-78; Fri, 28 Feb 2020 11:50:35 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Feb 2020 11:50:34 +1100
Date:   Fri, 28 Feb 2020 11:50:34 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kalyani Akula <kalyani.akula@xilinx.com>
Cc:     davem@davemloft.net, monstr@seznam.cz,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalyani Akula <kalyania@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        git-dev@xilinx.com,
        Mohan Marutirao Dhanawade <mohan.dhanawade@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Harsh Jain <harshj@xilinx.com>,
        Michal Simek <michals@xilinx.com>
Subject: Re: [PATCH V7 0/4] Add Xilinx's ZynqMP AES-GCM driver support
Message-ID: <20200228005033.GA9506@gondor.apana.org.au>
References: <1581935204-25673-1-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581935204-25673-1-git-send-email-kalyani.akula@xilinx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 17, 2020 at 03:56:40PM +0530, Kalyani Akula wrote:
> This patch set adds support for
> - dt-binding docs for Xilinx ZynqMP AES driver
> - Adds device tree node for ZynqMP AES driver
> - Adds communication layer support for aes in zynqmp.c
> - Adds Xilinx ZynqMP driver for AES Algorithm
> 
> NOTE: This patchset is based on Michal's branch
> https://git.kernel.org/pub/scm/linux/kernel/git/soc/soc.git/log/?h=arm/drivers
> because of possible merge conflict for 1/4 patch with below commit
> commit 461011b1e1ab ("drivers: firmware: xilinx: Add support for feature check")
> 
> V7 Changes:
> - Rebased this patchset on Cryptodev-2.6 tree and fixed compilation
>  issue seen. The issue is seen due to the below
>  commit af5034e8e4a5("crypto: remove propagation of CRYPTO_TFM_RES_* flags")
> 
> V6 Changes:
> - Updated SPDX-License-Identifier in xlnx,zynqmp-aes.yaml.
> 
> V5 Changes :
> - Moved arm64: zynqmp: Add Xilinx AES node from 2/4 to 4/4.
> - Moved crypto: Add Xilinx AES driver patch from 4/4 to 3/4.
> - Moved dt-bindings patch from 1/4 to 2/4
> - Moved firmware: xilinx: Add ZynqMP aes API for AES patch from 3/4 to 1/4
> - Converted dt-bindings from .txt to .yaml format.
> - Corrected typo in the subject.
> - Updated zynqmp-aes node to correct location.
> - Replaced ARCH_ZYNQMP with ZYNQMP_FIRMWARE in Kconfig
> - Removed extra new lines and added wherever necessary. 
> - Updated Signed-off-by sequence.
> - Ran checkpatch for all patches in the series.
> 
> V4 Changes :
> - Addressed review comments.
> 
> V3 Changes :
> - Added software fallback in cases where Hardware doesn't have
>   the capability to handle the request.
> - Removed use of global variable for storing the driver data.
> - Enabled CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y and executed all
>   the kernel selftests. Also covered tests with tcrypt module.
> 
> V2 Changes :
> - Converted RFC PATCH to PATCH
> - Removed ALG_SET_KEY_TYPE that was added to support keytype
>   attribute. Taken using setkey interface.
> - Removed deprecated BLKCIPHER in Kconfig
> - Erased Key/IV from the buffer.
> - Renamed zynqmp-aes driver to zynqmp-aes-gcm.
> - Addressed few other review comments
> 
> 
> Kalyani Akula (4):
>   firmware: xilinx: Add ZynqMP aes API for AES functionality
>   dt-bindings: crypto: Add bindings for ZynqMP AES-GCM driver
>   crypto: Add Xilinx AES driver
>   arm64: zynqmp: Add Xilinx AES node.
> 
>  .../bindings/crypto/xlnx,zynqmp-aes.yaml           |  37 ++
>  arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   4 +
>  drivers/crypto/Kconfig                             |  12 +
>  drivers/crypto/Makefile                            |   1 +
>  drivers/crypto/xilinx/Makefile                     |   2 +
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c             | 457 +++++++++++++++++++++
>  drivers/firmware/xilinx/zynqmp.c                   |  25 ++
>  include/linux/firmware/xlnx-zynqmp.h               |   2 +
>  8 files changed, 540 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml
>  create mode 100644 drivers/crypto/xilinx/Makefile
>  create mode 100644 drivers/crypto/xilinx/zynqmp-aes-gcm.c

Patches 1-3 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
