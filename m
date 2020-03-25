Return-Path: <SRS0=6fPk=5K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EDBC43331
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 11:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3A142078E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 11:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585136723;
	bh=feUfzVqMn/cgtqqVh3lV2rv2NlCW5TbLBBgFLBvyE1A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=OKOMmmN7opiYPbHKSDu9N33U8SCljT/IkaM/bArPiQ6KerPxIy4zV31bIdkf7kTAu
	 AWpQanal83a2zWMKaWac0/+fltSwOrDceP/OAUhWUTS7MxYuuXUby7ho5lfKF2+NsS
	 5a3TSceT+t4uGJP394prd2bv/t4uHy127pzBkyNM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgCYLpX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Mar 2020 07:45:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbgCYLpX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Mar 2020 07:45:23 -0400
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DA5220775
        for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2020 11:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585136722;
        bh=feUfzVqMn/cgtqqVh3lV2rv2NlCW5TbLBBgFLBvyE1A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PLp3qnAwb8amqv0P0bKEFsufSmvqhwWehGPGhIDseAV6mVlS6vxqn2EqiCh1Go5sa
         YAIAjk93N8l/y98GZ0XUNIyaIHRjZIh7dOgT7kGSlAVAfcoSQTRSLIxOgVK1n5Z0P3
         xr2+ciJJZz+FsxwFv9QCiurfNGUsWd/1BxdTLxRs=
Received: by mail-io1-f45.google.com with SMTP id a20so1825734ioo.13
        for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2020 04:45:22 -0700 (PDT)
X-Gm-Message-State: ANhLgQ0xhpXhK8pCDAT6OBPZy3l5HHq5Db9kc3MY1hhE4w0whE1EzJaf
        XUZStRrlrrpzesWRutfezsOEF+ecm5RFPnXf0h0=
X-Google-Smtp-Source: ADFU+vsgn5bSaiqX53PNf/K2+W1ldzxeeGFCyDOP7aQcyvzAirF/46cbqggUvktMRaBAUXCbyx3LmgaoJyyYiNzjQls=
X-Received: by 2002:a05:6602:2546:: with SMTP id j6mr2450622ioe.171.1585136721872;
 Wed, 25 Mar 2020 04:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200325114110.23491-1-broonie@kernel.org>
In-Reply-To: <20200325114110.23491-1-broonie@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 25 Mar 2020 12:45:11 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH=g5N4ZtnZeX5N8hf9cnWVam4Htnov6qAmQwD58Wp73Q@mail.gmail.com>
Message-ID: <CAMj1kXH=g5N4ZtnZeX5N8hf9cnWVam4Htnov6qAmQwD58Wp73Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] arm64: Open code .arch_extension
To:     Mark Brown <broonie@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 25 Mar 2020 at 12:41, Mark Brown <broonie@kernel.org> wrote:
>
> Currently several assembler files override the default architecture to
> enable extensions in order to allow them to implement optimised routines
> for systems with those extensions. Since inserting BTI landing pads into
> assembler functions will require us to change the default architecture we
> need a way to enable extensions without hard coding the architecture.
> The assembler has the .arch_extension feature but this was introduced
> for arm64 in gas 2.26 which is too modern for us to rely on it.
>
> We could just update the base architecture used by these assembler files
> but this would mean the assembler would no longer catch attempts to use
> newer instructions so instead introduce a macro which sets the default
> architecture centrally.  Doing this will also make our use of .arch and
> .cpu to select the base architecture more consistent.
>
> Mark Brown (3):
>   arm64: asm: Provide macro to control enabling architecture extensions
>   arm64: lib: Use ARM64_EXTENSIONS()
>   arm64: crypto: Use ARM64_EXTENSIONS()
>

Hi Mark,

I don't think this is the right fix. What is wrong with keeping these
.cpu and .arch directives in the .S files, and simply make
SYM_FUNC_START() expand to something that includes .arch_extension pac
or .arch_extension bti when needed? That way, we only use
.arch_extension when we know the assembler supports it (given that
.arch_extension support itself should predate BTI or PAC support in
GAS or Clang)



>  arch/arm64/crypto/aes-ce-ccm-core.S   | 3 ++-
>  arch/arm64/crypto/aes-ce-core.S       | 2 +-
>  arch/arm64/crypto/aes-ce.S            | 2 +-
>  arch/arm64/crypto/crct10dif-ce-core.S | 3 ++-
>  arch/arm64/crypto/ghash-ce-core.S     | 3 ++-
>  arch/arm64/crypto/sha1-ce-core.S      | 3 ++-
>  arch/arm64/crypto/sha2-ce-core.S      | 3 ++-
>  arch/arm64/include/asm/linkage.h      | 6 ++++++
>  arch/arm64/lib/crc32.S                | 2 +-
>  9 files changed, 19 insertions(+), 8 deletions(-)
>
> --
> 2.20.1
>
