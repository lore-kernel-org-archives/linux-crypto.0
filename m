Return-Path: <SRS0=6JMd=BC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6380C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 08:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E8692086A
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 08:18:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OsFuFLxd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGWISo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 04:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgGWISn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 04:18:43 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98043C0619DC;
        Thu, 23 Jul 2020 01:18:43 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id o3so3578994ilo.12;
        Thu, 23 Jul 2020 01:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=IH5nIhgYMr2jeQTF+7+IwFj00X321cLfGc0hLCqlb3E=;
        b=OsFuFLxdpyXxkfoSlN+LN7w7Q3xAOZ7BZBrFWgVWqB/sGg1X2ze4MQ1MXrHeBmg/QY
         4XkmKKX4IFcASGUK7NYcsE1tfwAY70+OvDS2B/nNsG69F69zdbeBhko6YBOS+UmnKLPH
         h5A1g+wBjAHdnfDsami4JGSbMxOIwsSSE+4kUKs8C5LqEXQL4lumo6+SzzehfC+FvjFm
         X6HYBGkNbaIsdgaKNGA+KocnzEmtVQpP7JjJTwUKCluTMCVN7WnR+RlD/eALzeWXoE+Z
         LMRaavnYiQ3UOzEpVOV8UWLgQHqVw4UrkngWaDLnEKnB6BFxCoyNfR6mofp4eCF+ZrSi
         m+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=IH5nIhgYMr2jeQTF+7+IwFj00X321cLfGc0hLCqlb3E=;
        b=UWVHHI3UPG/1HjS6WvBhThz+Crn/v+BoRVzGApyHZfHVh7pN1BH7aY2U4ipP+psrjX
         uv4qphNdvcPumlnj7b5WFosC5sIXIBVlCz5KniNXUNfhfNnCtEZ7W+nsxt+yXXgJeq9u
         Ad+ALdsz+JquucXYmvzTm+Lf/ZWytQVCfHJenwqabTb+7LUWMutfIwYqVd6AjTrpYrBo
         m0eQAG24U6HAH8UCE3nKB3aF/VLZ9eBA9z3Wl618fRw2JdtAzKNrKfdP+LHVLe16gLN9
         A1GVTzTxODy1Zuk/P6l/A1fiUWZ1oW1wLRKX0/N1F2VO9w133Ox+2TI2lzccXx1RpB9P
         257g==
X-Gm-Message-State: AOAM532ebVLCfZV3A1JLNnZtaG3JTpJpKQoo1q2j4aciUHK8GjgQiPnO
        cz7mjV4EyianNxFidogP57KLtS3q8otx1fcFV/o=
X-Google-Smtp-Source: ABdhPJyPk994azZvWyl9oZx3n8OK5HD7HeA1ROWgXndf9SLMTo4mQrIly9vdxSAaN2hhb2rUYGeLpiB7GSegZLcuZ34=
X-Received: by 2002:a92:dc09:: with SMTP id t9mr4002418iln.226.1595492322916;
 Thu, 23 Jul 2020 01:18:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200527141754.1850968-1-arnd@arndb.de> <20200723075612.GA14212@gondor.apana.org.au>
In-Reply-To: <20200723075612.GA14212@gondor.apana.org.au>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 23 Jul 2020 10:18:30 +0200
Message-ID: <CA+icZUWvQXUV_ibuWoAASqrCS42Q5PsQhtf1_qz_MALWcUQhiQ@mail.gmail.com>
Subject: Re: [PATCH] x86: crypto: fix building crc32c with clang ias
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Tim Chen <tim.c.chen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 23, 2020 at 9:57 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, May 27, 2020 at 04:17:40PM +0200, Arnd Bergmann wrote:
> > The clang integrated assembler complains about movzxw:
> >
> > arch/x86/crypto/crc32c-pcl-intel-asm_64.S:173:2: error: invalid instruction mnemonic 'movzxw'
> >
> > It seems that movzwq is the mnemonic that it expects instead,
> > and this is what objdump prints when disassembling the file.
> >
> > Fixes: 6a8ce1ef3940 ("crypto: crc32c - Optimize CRC32C calculation with PCLMULQDQ instruction")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Patch applied.  Thanks.
>

Thanks you very much.

Now we have all x86/crypto patches to be able to use Clang's
Integrated Assembler (IAS) and build with `make LLVM_IAS=1`.

- Sedat -

[1] https://github.com/ClangBuiltLinux/linux/issues/1049#issuecomment-662609378
