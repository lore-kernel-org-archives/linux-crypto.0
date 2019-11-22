Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B00C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 02:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35FEA206D7
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 02:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574389268;
	bh=Bmw3dilrhOSB2KEzqqUzCdnYmuPbOsPuYjwQA42dvLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DPUmUGi9oDuAP6ddE1TyxmtroQX6gYqXl/N/myl8fJCVOHmlXmBG/id4DgN5tEYJI
	 kYX4cg6nr5IGOsFcWPpKwq2711KZ4Bpv4DsiJclfUEZ/HK/MG7bzQp97EQqqNAtmgc
	 1A5DZ5FQ7yyQhKh++UqmgZRw12ixUY9jzgA/Twzc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfKVCVH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 21:21:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbfKVCVH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 21:21:07 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40ABE20409;
        Fri, 22 Nov 2019 02:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574389266;
        bh=Bmw3dilrhOSB2KEzqqUzCdnYmuPbOsPuYjwQA42dvLs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GaABxv3D3oik8n+/v9lZqt6E0icOZlfY85tHCu1TWZXx+4L5ip4bIu2QQ+QSHcYfg
         zazTIZgOJ85ifILklKnReN1XMXFOsXuuy+ISetvz5c+eV5i1225W/tDfBbWZBfBEsh
         mImvl7ntrBZvFtvTN6E9TRvzCgtr8MXAGTUj+bAY=
Date:   Thu, 21 Nov 2019 18:21:04 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        =?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 0/8] crypto: x86: Fix indirect function call casts
Message-ID: <20191122022104.GC32523@sol.localdomain>
References: <20191122010334.12081-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122010334.12081-1-keescook@chromium.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 21, 2019 at 05:03:26PM -0800, Kees Cook wrote:
> v6:
> - minimize need for various internal casts (ebiggers)
> - clarify comments (ebiggers)
> - switch all context pointers to const (ebiggers)
> v5: https://lore.kernel.org/lkml/20191113182516.13545-1-keescook@chromium.org
> v4: https://lore.kernel.org/lkml/20191111214552.36717-1-keescook@chromium.org
> v3: https://lore.kernel.org/lkml/20190507161321.34611-1-keescook@chromium.org
> 
> Hi,
> 
> Now that Clang's CFI has been fixed to do the right thing with extern
> asm functions, this patch series is much simplified. Repeating patch
> 1's commit log here:
> 
>     The crypto glue performed function prototype casting to make indirect
>     calls to assembly routines. Instead of performing casts at the call
>     sites (which trips Control Flow Integrity prototype checking), switch
>     each prototype to a common standard set of arguments which allows the
>     incremental removal of the existing macros. In order to keep pointer
>     math unchanged, internal casting between u128 pointers and u8 pointers
>     is added.
> 
> With this series (and the Clang LTO+CFI series) I am able to boot x86
> with all crytpo selftests enabled without tripping any CFI checks.
> 
> Thanks!
> 
> -Kees
> 
> Kees Cook (8):
>   crypto: x86/glue_helper: Regularize function prototypes
>   crypto: x86/serpent: Remove glue function macros usage
>   crypto: x86/camellia: Remove glue function macro usage
>   crypto: x86/twofish: Remove glue function macro usage
>   crypto: x86/cast6: Remove glue function macro usage
>   crypto: x86/aesni: Remove glue function macro usage
>   crypto: x86/glue_helper: Remove function prototype cast helpers
>   crypto, x86/sha: Eliminate casts on asm implementations

This patchset doesn't actually compile until patch 6/8, due to
-Werror=incompatible-pointer-types in the kernel's top-level Makefile.  It's
generally expected that every kernel commit compiles, and I'm not sure it's a
good idea to allow any exceptions.

The easiest solution would be to just squash the first 6 patches together into
one big patch.

Alternatively, 'ccflags-y := -Wno-error=incompatible-pointer-types' could be
added to arch/x86/crypto/Makefile in patch 1 and removed in patch 7.

- Eric
