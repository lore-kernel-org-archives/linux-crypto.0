Return-Path: <SRS0=h1Lr=7J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B02C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 19:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C851207D3
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 19:35:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XYa87opw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgE0TfB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 May 2020 15:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgE0TfA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 May 2020 15:35:00 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FF8C05BD1E;
        Wed, 27 May 2020 12:35:00 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t11so12297369pgg.2;
        Wed, 27 May 2020 12:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mqBj2b2oX4jL4f2LODtFXIhldQE/VACP+TTPinfd5B4=;
        b=XYa87opwkcJuXpolq9dJgh0OhVmKRWsmyeR9kLCl1ocAkJOMKWRWnx17pNzvvkD4ce
         GW2jPGDeJD1nNlrzQWtn7KLiHy6myBUhqx0WmP/wZ1Y5mnwLzlaXS4oO51EOR/BFkJiX
         eeFo2dRxS/vvQZWzWwPUB6TC0lIPknYkXUdmqXETLwbS65PWL+o9x9JHngsvnyv4MVE9
         plL9vMHrL7btfgZhyv0Fgg74fAa+Fj6dt1Uhu2tQsK5Ph5qlG0EPFLznM2cIhwzFd3p7
         BlTBuquGLM2J4iv7wgPyWEA8VH6XmHq8qCgxh8k+HonKdA6WVWSyAKL/OTgzTilxGtiT
         iFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mqBj2b2oX4jL4f2LODtFXIhldQE/VACP+TTPinfd5B4=;
        b=O2af+WCwqUo+q0AGAj4mQ3ZJsRPsI++7TknKxGpRdlk78SjIM6nT9c0uRwd6YReAn6
         L/8w6ZVSZgKOVl8WM4NYcWJXXuWjkF5ByM3hC1bans8g43rrQAocnLZzn8EgY31OLwsj
         qG9nj22UUsgy1qjVoK+BRiK7S3XA/I2T/thXU8UDP11gxbBubSGxrn3u4Tj/IVjxWeWS
         OP2Zv3SMQ1vZss7lF+OHAVJfUWCZVi1RQMamPM7pLAbdH9ne2E80qy4S5N+77smPz9Vm
         4kF7YkG/oz3S99qFjhrI3iy7gbMOpCAe0QwgLhxcGfWlTBF9Ejb0vVpzPAFNWFpXr1No
         aGPw==
X-Gm-Message-State: AOAM533VFgseKAI0Fiq4+PmDe2yj4rhmiA1l1pV2H5SBGuoY6Hl1bPFa
        2I7IEXcNqoxzaJP8saWh7xI=
X-Google-Smtp-Source: ABdhPJxMFrP8wWxZJuJfrB1FkAK8UOxIW5bnXQDdN4A40PVkpjsvNVplJtvJAquZrTOsRf/UXK9C7g==
X-Received: by 2002:a63:7d3:: with SMTP id 202mr5357406pgh.279.1590608099639;
        Wed, 27 May 2020 12:34:59 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id o15sm3181356pjq.28.2020.05.27.12.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 12:34:58 -0700 (PDT)
Date:   Wed, 27 May 2020 12:34:56 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Diab Neiroukh <officiallazerl0rd@gmail.com>
Subject: Re: [PATCH] x86: crypto: fix building crc32c with clang ias
Message-ID: <20200527193456.GA2141183@ubuntu-s3-xlarge-x86>
References: <20200527141754.1850968-1-arnd@arndb.de>
 <20200527164219.GB1073507@ubuntu-s3-xlarge-x86>
 <CAK8P3a1NS3OCNzD3uCjLmJvdcfLRguaoHtuTKXEuvizmbsQYhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1NS3OCNzD3uCjLmJvdcfLRguaoHtuTKXEuvizmbsQYhA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 27, 2020 at 08:24:35PM +0200, Arnd Bergmann wrote:
> On Wed, May 27, 2020 at 6:42 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > On Wed, May 27, 2020 at 04:17:40PM +0200, Arnd Bergmann wrote:
> > > The clang integrated assembler complains about movzxw:
> > >
> > > arch/x86/crypto/crc32c-pcl-intel-asm_64.S:173:2: error: invalid instruction mnemonic 'movzxw'
> > >
> > > It seems that movzwq is the mnemonic that it expects instead,
> > > and this is what objdump prints when disassembling the file.
> > >
> > > Fixes: 6a8ce1ef3940 ("crypto: crc32c - Optimize CRC32C calculation with PCLMULQDQ instruction")
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >
> > We had an identical patch pending from another contributor, see the
> > discussion and result in the issue below.
> >
> > https://github.com/ClangBuiltLinux/linux/issues/1010
> >
> > Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> >
> 
> Was the other one submitted upstream? If yes, let's use that one.
> 
>      Arnd

No, at least not that I saw. I've added Diab to CC now though to
confirm.

Cheers,
Nathan
