Return-Path: <SRS0=MZ7V=QG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF71C282D7
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 21:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3B3720881
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 21:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548882539;
	bh=GJh6n9GmMPfbc0fnlKIm7XjEdr7VIklIawdWGsUcozI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=dd3i0HUNNtfbM//QqHLVdlgiaLIp35TlEso06S7ydNtHW6+asbwJByU4/gPqNMhiM
	 sAxPMvehndwpLOwtkPZMNHbuTCKBrBm0yjy3fzcCAWWKi/SOGmfY61AsSCrBgzIqLH
	 tNTHNbkizrGwX8qfZI7po23c0KkTBKLZjOwq8/7M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732622AbfA3VI7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Jan 2019 16:08:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbfA3VI7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Jan 2019 16:08:59 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D14D2184D;
        Wed, 30 Jan 2019 21:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548882537;
        bh=GJh6n9GmMPfbc0fnlKIm7XjEdr7VIklIawdWGsUcozI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rhJC3+pjbphXiZXO9SmDjiFBnJ1OMV59HKL21WW2hMx5a/owfqh8uJ45QDhKFprge
         TK1O0j7z4x+zb+Jk7T8NCiThpH9JEBXu25VvH4DGUXHlibbC/oJ64iyyWplShDtIBm
         +9m16Elvy2BQUtUtUHL1JE/4V1sRuLUHguapijfQ=
Date:   Wed, 30 Jan 2019 13:08:55 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/3] crypto: arm/crct10dif-ce - cleanup and
 optimizations
Message-ID: <20190130210855.GB231835@gmail.com>
References: <20190130031444.28935-1-ebiggers@kernel.org>
 <20190130031444.28935-3-ebiggers@kernel.org>
 <20190130205553.GA231835@gmail.com>
 <CAKv+Gu95XurUKRqV7VR5X1ECfDqDEw78qS_ggn9pcG30S-6zFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu95XurUKRqV7VR5X1ECfDqDEw78qS_ggn9pcG30S-6zFg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 30, 2019 at 10:00:53PM +0100, Ard Biesheuvel wrote:
> On Wed, 30 Jan 2019 at 21:55, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Tue, Jan 29, 2019 at 07:14:43PM -0800, Eric Biggers wrote:
> > > +     .macro          __adrl, out, sym
> > > +     movw            \out, #:lower16:\sym
> > > +     movt            \out, #:upper16:\sym
> > > +     .endm
> >
> > Hi Ard, it seems we need the __LINUX_ARM_ARCH__ < 7 case after all?
> > The kbuild test robot reported a build error, which can be reproduced with:
> >
> > ( cat arch/arm/configs/multi_v7_defconfig;
> >   echo CONFIG_ARCH_MULTI_V6=y;
> >   echo CONFIG_CRC_T10DIF=y;
> >   echo CONFIG_CRYPTO_CRCT10DIF_ARM_CE=y ) > .config
> > make olddefconfig
> > make arch/arm/crypto/crct10dif-ce-core.o
> >
> >
> >   AS      arch/arm/crypto/crct10dif-ce-core.o
> > arch/arm/crypto/crct10dif-ce-core.S: Assembler messages:
> > arch/arm/crypto/crct10dif-ce-core.S:165: Error: .err encountered
> > arch/arm/crypto/crct10dif-ce-core.S:165: Error: selected processor does not support `movw fold_consts_ptr,#:lower16:.Lfold_across_128_bytes_consts' in ARM mode
> > arch/arm/crypto/crct10dif-ce-core.S:165: Error: selected processor does not support `movt fold_consts_ptr,#:upper16:.Lfold_across_128_bytes_consts' in ARM mode
> > arch/arm/crypto/crct10dif-ce-core.S:267: Error: .err encountered
> > arch/arm/crypto/crct10dif-ce-core.S:267: Error: selected processor does not support `movw r3,#:lower16:.Lbyteshift_table+16' in ARM mode
> > arch/arm/crypto/crct10dif-ce-core.S:267: Error: selected processor does not support `movt r3,#:upper16:.Lbyteshift_table+16' in ARM mode
> > arch/arm/crypto/crct10dif-ce-core.S:329: Error: .err encountered
> > arch/arm/crypto/crct10dif-ce-core.S:329: Error: selected processor does not support `movw fold_consts_ptr,#:lower16:.Lfold_across_16_bytes_consts' in ARM mode
> > arch/arm/crypto/crct10dif-ce-core.S:329: Error: selected processor does not support `movt fold_consts_ptr,#:upper16:.Lfold_across_16_bytes_consts' in ARM mode
> > scripts/Makefile.build:367: recipe for target 'arch/arm/crypto/crct10dif-ce-core.o' failed
> > make[1]: *** [arch/arm/crypto/crct10dif-ce-core.o] Error 1
> > Makefile:1709: recipe for target 'arch/arm/crypto/crct10dif-ce-core.o' failed
> > make: *** [arch/arm/crypto/crct10dif-ce-core.o] Error 2
> >
> 
> That does not make sense. That code can only execute on a NEON capable
> CPU, which is guaranteed to support movw/movt as well. So I'd prefer
> solving this by adding '.arch armv7-a' to this .S file.

Yes that works.  I'll send out a new version with that.

- Eric
