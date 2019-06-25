Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2426C48BD4
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 17:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98A9E208E3
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 17:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561482760;
	bh=O2rccZsy2PvIAmAVzuj1EWVEjc4YLywh1wXT6zundPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=tEcF/RMf+44/FX85OSS2d1IEVtbpvmocc0JBrd0mT7HN8kS68WVrHJTCCRWE408e2
	 vE20OwgWqxLQR8smNMXk76svZmBYJVqUEhtIuuR0YFH9K4dZ51tep7tbYwTbzpHus3
	 8XdfI0XDvm4JIhbPd266aPYGr4OQQiLZPGP3eDEc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbfFYRMj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 13:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727687AbfFYRMj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 13:12:39 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96510208CA;
        Tue, 25 Jun 2019 17:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561482757;
        bh=O2rccZsy2PvIAmAVzuj1EWVEjc4YLywh1wXT6zundPU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vkLPwk9xZyQn5iWFrFsNBReSmNRVUUsOB2MqjQ6UTNpmVFS/uSO7Yp0UJMSfCDX2m
         +X4kHzrThALNHl+gqXdD+9ygNQ5fb60LXdoNqhRHlcMH+AOkglm/8uMSrLUUGNpGKH
         vixVSqW+9zfgN8cFP+nlyRzOfgLIAbWDGwiBsOr4=
Date:   Tue, 25 Jun 2019 10:12:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        omosnace@redhat.com, geert@linux-m68k.org,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] crypto: morus - remove generic and x86 implementations
Message-ID: <20190625171234.GB81914@gmail.com>
References: <20190625145254.28510-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625145254.28510-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[+Cc Milan]

On Tue, Jun 25, 2019 at 04:52:54PM +0200, Ard Biesheuvel wrote:
> MORUS was not selected as a winner in the CAESAR competition, which
> is not surprising since it is considered to be cryptographically
> broken. (Note that this is not an implementation defect, but a flaw
> in the underlying algorithm). Since it is unlikely to be in use
> currently, let's remove it before we're stuck with it.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/m68k/configs/amiga_defconfig     |    2 -
>  arch/m68k/configs/apollo_defconfig    |    2 -
>  arch/m68k/configs/atari_defconfig     |    2 -
>  arch/m68k/configs/bvme6000_defconfig  |    2 -
>  arch/m68k/configs/hp300_defconfig     |    2 -
>  arch/m68k/configs/mac_defconfig       |    2 -
>  arch/m68k/configs/multi_defconfig     |    2 -
>  arch/m68k/configs/mvme147_defconfig   |    2 -
>  arch/m68k/configs/mvme16x_defconfig   |    2 -
>  arch/m68k/configs/q40_defconfig       |    2 -
>  arch/m68k/configs/sun3_defconfig      |    2 -
>  arch/m68k/configs/sun3x_defconfig     |    2 -
>  arch/x86/crypto/Makefile              |   13 -
>  arch/x86/crypto/morus1280-avx2-asm.S  |  622 ---------
>  arch/x86/crypto/morus1280-avx2-glue.c |   66 -
>  arch/x86/crypto/morus1280-sse2-asm.S  |  896 -------------
>  arch/x86/crypto/morus1280-sse2-glue.c |   65 -
>  arch/x86/crypto/morus1280_glue.c      |  209 ---
>  arch/x86/crypto/morus640-sse2-asm.S   |  615 ---------
>  arch/x86/crypto/morus640-sse2-glue.c  |   65 -
>  arch/x86/crypto/morus640_glue.c       |  204 ---
>  crypto/Kconfig                        |   56 -
>  crypto/Makefile                       |    2 -
>  crypto/morus1280.c                    |  542 --------
>  crypto/morus640.c                     |  533 --------
>  crypto/testmgr.c                      |   12 -
>  crypto/testmgr.h                      | 1707 -------------------------
>  include/crypto/morus1280_glue.h       |   97 --
>  include/crypto/morus640_glue.h        |   97 --
>  include/crypto/morus_common.h         |   18 -
>  30 files changed, 5843 deletions(-)
>  delete mode 100644 arch/x86/crypto/morus1280-avx2-asm.S
>  delete mode 100644 arch/x86/crypto/morus1280-avx2-glue.c
>  delete mode 100644 arch/x86/crypto/morus1280-sse2-asm.S
>  delete mode 100644 arch/x86/crypto/morus1280-sse2-glue.c
>  delete mode 100644 arch/x86/crypto/morus1280_glue.c
>  delete mode 100644 arch/x86/crypto/morus640-sse2-asm.S
>  delete mode 100644 arch/x86/crypto/morus640-sse2-glue.c
>  delete mode 100644 arch/x86/crypto/morus640_glue.c
>  delete mode 100644 crypto/morus1280.c
>  delete mode 100644 crypto/morus640.c
>  delete mode 100644 include/crypto/morus1280_glue.h
>  delete mode 100644 include/crypto/morus640_glue.h
>  delete mode 100644 include/crypto/morus_common.h

Maybe include a link to the cryptanalysis paper
https://eprint.iacr.org/2019/172.pdf in the commit message, so people seeing
this commit can better understand the reasoning?

Otherwise this patch itself looks fine to me, though I'm a little concerned
we'll break someone actually using MORUS.  An alternate approach would be to
leave just the C implementation, and make it print a deprecation warning for a
year or two before actually removing it.  But I'm not sure that's needed, and it
might be counterproductive as it would allow more people to start using it.

From a Google search I don't see any documentation floating around specifically
telling people to use MORUS with cryptsetup, other than an email on the dm-crypt
mailing list (https://www.spinics.net/lists/dm-crypt/msg07763.html) which
mentioned it alongside other options.  So hopefully there are at most a couple
odd adventurous users, who won't mind migrating their data to a new LUKS volume.

- Eric
