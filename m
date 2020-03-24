Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA53C4332B
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FB742070A
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:29:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Me4q8UB5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgCXA3x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 20:29:53 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:41623 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726955AbgCXA3x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 20:29:53 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 67f2f08d;
        Tue, 24 Mar 2020 00:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=U3g+Qd4kxYtXwogFayZzRbGY6bY=; b=Me4q8U
        B5878gSo1i//NnY9TZKfxlVsiz4h7gGHs+Vyphm5oOsVm2Jsrd4OFre4I+dJXm+P
        4pIczEroj/c1eaqtqIid2P4upMoi5yrhq+PFlQ9gLZkhAZbHenimxgmu8Wd2r6sE
        avpePBIofAUfQDQiG6VsZDIhVW4Qd5z+0DSIjtxPK75FGDXKNzR4+CX6K1tijvdO
        axpAPD6WniGnW816r1GAz4scQ0bU1L5SZttbM2mmttuXnESNLsY4L5THoaCHcK6Y
        E9L33eRRJEMyGw/RqG0hYJSNqi6v45CsVpEhOhdC6JOSK2xk/vl6EK4OBejYJzu3
        MywHS/OYEplBUdww==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 79ea222a (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 24 Mar 2020 00:22:46 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id h8so16404623iob.2;
        Mon, 23 Mar 2020 17:29:49 -0700 (PDT)
X-Gm-Message-State: ANhLgQ21ruVrMQuF+xir2Y2w8zrTMXA2B/PZzN0XMkpct8F9YMjyuGuf
        nAxKP2Kb0mppkkpba9DmrSWMcCxQA07BfTz2Bq8=
X-Google-Smtp-Source: ADFU+vuIgqp3qi0NeoXrARe9XukRA7tgPq6DDZ/UWyvNDJcS924QH/wQYr2KPbvV0MaMeG8Mb5QDbAfOYGItqG57vlc=
X-Received: by 2002:a02:6241:: with SMTP id d62mr4216457jac.86.1585009788671;
 Mon, 23 Mar 2020 17:29:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200324001358.4520-1-masahiroy@kernel.org>
In-Reply-To: <20200324001358.4520-1-masahiroy@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 23 Mar 2020 18:29:37 -0600
X-Gmail-Original-Message-ID: <CAHmME9rdoo2Q3n4YA59GrVEh8uaCY_0-q+QVghjgG3WwcHkmug@mail.gmail.com>
Message-ID: <CAHmME9rdoo2Q3n4YA59GrVEh8uaCY_0-q+QVghjgG3WwcHkmug@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] x86: remove always-defined CONFIG_AS_* options
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     X86 ML <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        NeilBrown <neilb@suse.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 23, 2020 at 6:15 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
>
> arch/x86/Makefile tests instruction code by $(call as-instr, ...)
>
> Some of them are very old.
> For example, the check for CONFIG_AS_CFI dates back to 2006.
>
> We raise GCC versions from time to time, and we clean old code away.
> The same policy applied to binutils.
>
> The current minimal supported version of binutils is 2.21
>
> This is new enough to recognize the instruction in most of
> as-instr calls.
>
> If this series looks good, how to merge it?
> Via x86 tree or maybe crypto ?

This series looks fine, but why is it still incomplete? That is, it's
missing your drm commit plus the 4 I layered on top for moving to a
Kconfig-based approach and accounting for the bump to binutils 2.23.
Everything is now rebased here:
https://git.zx2c4.com/linux-dev/log/?h=jd/kconfig-assembler-support

Would you be up for resubmitting those all together so we can handle
this in one go?

Jason
