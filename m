Return-Path: <SRS0=MZ7V=QG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4E3C282D7
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 20:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C62B218D3
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 20:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548881758;
	bh=jMmbRqJlDUQ3q6EoRsqs7LQtkHDtGl0xwnkBERVr0m0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=X36nC8eqnwmc+lx+sU0YH4OiUn2122sclmGBOAVqXlnStkrmbFy066WnmIZ21vI4p
	 jZyq/1i5hC31DxwYltlTfuXcrAZOoSvT7SHOi+U6a7Veu8o7LTCcv9STnbjuv4O7aS
	 Y2WV1S5qlWnfUi4pqbDYLp6jtjzlcsAH25NpesQ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfA3Uz5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Jan 2019 15:55:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:34982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbfA3Uz5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Jan 2019 15:55:57 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68DB22184D;
        Wed, 30 Jan 2019 20:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548881756;
        bh=jMmbRqJlDUQ3q6EoRsqs7LQtkHDtGl0xwnkBERVr0m0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c5JDhTdFMu0jhMRAlCC2G/4g35deNG/AL5Ninp40jwOzwBCj1JbE8VyOrk+Cp4RcM
         KZdx2bo21CLS4gETJBBdM589i4xLdo2nhpS96nISK9fmtEU9FJhSl3DTYWqtWrYMp1
         wRS1TzF357FwskO7WQno5BcoStQK4yraQWVc6nzA=
Date:   Wed, 30 Jan 2019 12:55:55 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/3] crypto: arm/crct10dif-ce - cleanup and
 optimizations
Message-ID: <20190130205553.GA231835@gmail.com>
References: <20190130031444.28935-1-ebiggers@kernel.org>
 <20190130031444.28935-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190130031444.28935-3-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 29, 2019 at 07:14:43PM -0800, Eric Biggers wrote:
> +	.macro		__adrl, out, sym
> +	movw		\out, #:lower16:\sym
> +	movt		\out, #:upper16:\sym
> +	.endm

Hi Ard, it seems we need the __LINUX_ARM_ARCH__ < 7 case after all?
The kbuild test robot reported a build error, which can be reproduced with:

( cat arch/arm/configs/multi_v7_defconfig;
  echo CONFIG_ARCH_MULTI_V6=y;
  echo CONFIG_CRC_T10DIF=y;
  echo CONFIG_CRYPTO_CRCT10DIF_ARM_CE=y ) > .config
make olddefconfig
make arch/arm/crypto/crct10dif-ce-core.o


  AS      arch/arm/crypto/crct10dif-ce-core.o
arch/arm/crypto/crct10dif-ce-core.S: Assembler messages:
arch/arm/crypto/crct10dif-ce-core.S:165: Error: .err encountered
arch/arm/crypto/crct10dif-ce-core.S:165: Error: selected processor does not support `movw fold_consts_ptr,#:lower16:.Lfold_across_128_bytes_consts' in ARM mode
arch/arm/crypto/crct10dif-ce-core.S:165: Error: selected processor does not support `movt fold_consts_ptr,#:upper16:.Lfold_across_128_bytes_consts' in ARM mode
arch/arm/crypto/crct10dif-ce-core.S:267: Error: .err encountered
arch/arm/crypto/crct10dif-ce-core.S:267: Error: selected processor does not support `movw r3,#:lower16:.Lbyteshift_table+16' in ARM mode
arch/arm/crypto/crct10dif-ce-core.S:267: Error: selected processor does not support `movt r3,#:upper16:.Lbyteshift_table+16' in ARM mode
arch/arm/crypto/crct10dif-ce-core.S:329: Error: .err encountered
arch/arm/crypto/crct10dif-ce-core.S:329: Error: selected processor does not support `movw fold_consts_ptr,#:lower16:.Lfold_across_16_bytes_consts' in ARM mode
arch/arm/crypto/crct10dif-ce-core.S:329: Error: selected processor does not support `movt fold_consts_ptr,#:upper16:.Lfold_across_16_bytes_consts' in ARM mode
scripts/Makefile.build:367: recipe for target 'arch/arm/crypto/crct10dif-ce-core.o' failed
make[1]: *** [arch/arm/crypto/crct10dif-ce-core.o] Error 1
Makefile:1709: recipe for target 'arch/arm/crypto/crct10dif-ce-core.o' failed
make: *** [arch/arm/crypto/crct10dif-ce-core.o] Error 2

- Eric
