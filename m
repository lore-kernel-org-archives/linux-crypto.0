Return-Path: <SRS0=6fPk=5K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46918C54FD0
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 13:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E4A62078E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 13:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585142823;
	bh=cRMnzJlM4MdOZf8WiPCh3JhbOveFjpzO8YOajpEZfpg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=xNni5NTyUIAMuDSYBmrC7SZr8UjEfiA55yOWcyfGdZOTeSqqda9r+ZYJg+eaoqNIR
	 Z1vxTC//Tvr/oTNpvzYxgOgqkPvpZTdxuqt8M+aqLiTV6VyED/zRlpZYX4lpHaO+vY
	 jDUOt5w5DhaWlP4YghnWBmYZ8qwHSckbFTN46ZRU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgCYN1C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Mar 2020 09:27:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgCYN1C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Mar 2020 09:27:02 -0400
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A28F120870
        for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2020 13:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585142821;
        bh=cRMnzJlM4MdOZf8WiPCh3JhbOveFjpzO8YOajpEZfpg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OgIPvmzTk4N1npPOWL5bcGi2a7i+MyFgimQ6JHIYVPGweGlDz/dOIEUriP3NZ9OBq
         RnOJ40lEreYinOKH/3Klk2gtPy489OK+Cs2Ryyt5eRbMmmoA8lNdMyzGsGgCYgfwj6
         v9hdgsgHd27Urwhl5k26J89ks6DXa5gErTZXLOE8=
Received: by mail-io1-f45.google.com with SMTP id a24so1579819iol.12
        for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2020 06:27:01 -0700 (PDT)
X-Gm-Message-State: ANhLgQ3PHE28LNJTQ6ISN9+43KBiLQGsiCUIBtFQKRKR7cKB6+rJfQ4H
        RF8Ejz71dAUwBiW8iUVPwt8XZqZYzUDrCfKXojI=
X-Google-Smtp-Source: ADFU+vvbZyOfNa3XDJibw7rhJIu4kwtdKxFTqoEjWnue8LN0T3U3l29HitkV76a3j2CJp0OgtS4/8EuZII8BRZFIrig=
X-Received: by 2002:a02:5489:: with SMTP id t131mr2869139jaa.134.1585142821043;
 Wed, 25 Mar 2020 06:27:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200325114110.23491-1-broonie@kernel.org> <20200325123157.GA12236@lakrids.cambridge.arm.com>
In-Reply-To: <20200325123157.GA12236@lakrids.cambridge.arm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 25 Mar 2020 14:26:49 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH1OC0hqnP5hWUVMK8Z5CrWp+XFfxAyufXY4bKwN2U2xw@mail.gmail.com>
Message-ID: <CAMj1kXH1OC0hqnP5hWUVMK8Z5CrWp+XFfxAyufXY4bKwN2U2xw@mail.gmail.com>
Subject: Re: [PATCH 0/3] arm64: Open code .arch_extension
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

,

On Wed, 25 Mar 2020 at 13:32, Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Wed, Mar 25, 2020 at 11:41:07AM +0000, Mark Brown wrote:
> > Since inserting BTI landing pads into assembler functions will require
> > us to change the default architecture we need a way to enable
> > extensions without hard coding the architecture.
>
> Assuming we'll poke the toolchain folk, let's consider alternative ways
> around this in the mean time.
>
> Is there anything akin to push/pop versions of .arch directitves that we
> can use around the BTI instructions specifically?
>
> ... or could we encode the BTI instructions with a .inst, and wrap those
> in macros so that GAS won't complain (like we do for mrs_s and friends)?
>
> ... does asking GCC to use BTI for C code make the default arch v8.5 for
> inline asm, or does it do something special to allow BTI instructions in
> specific locations?
>

I think using macros wrapping .inst directives is the most hassle free
way to achieve this, assuming there is no need to encode registers or
immediates (which makes it slightly messy - refer to
arch/arm64/crypto/sm3-ce-core.S for an example)
