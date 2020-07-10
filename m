Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2B2C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 09:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FB712077D
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 09:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WfzeSuob"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgGJJRq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 05:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgGJJRq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 05:17:46 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDC9C08C5CE;
        Fri, 10 Jul 2020 02:17:46 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id l1so5324900ioh.5;
        Fri, 10 Jul 2020 02:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc;
        bh=QZcfofaAiRdiS4Y00mVc9t22b6QsLSvbdGPCar/Bgfw=;
        b=WfzeSuobAgMF21nikEU79yh92e2RUib/UE7KPjMb5/V9nzvLkC5e4r9OmvntkMlrQN
         hYo8NpXR7UIlxd9Dr5APmeprjrgi7a0GvIkME8y5kwssjJ2cFBCVtSqCKQIG8padtrBX
         S+wN7QRmnh8OYKBoix21JL+CwM4gyuoaQpJkqXDoa7ff5dZGXIACouzUPg3/B5532X3c
         COqnO3oceKAzU7kKfH6DcN6RLHtPMS0dfI1bIVn8xZo45bQtpME6pJd52AB2EvT6dMD1
         He2EHtKo5O5Xq2uLSTKUp5bHbJYVl98cEMzdoQWPnduNPHYQequTf9mUn2aXPjcOeJKi
         pasw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:cc;
        bh=QZcfofaAiRdiS4Y00mVc9t22b6QsLSvbdGPCar/Bgfw=;
        b=LSAgkArG/tuNQipf0lN/dAy62kk/WlPDH7NKwtgnpgZscwmQv5+Hn6J3tIk6njQtDL
         /j+N3uSSY3I4F38HFklvZB1Ak4DmhXccjTba+9Eqg37Qqs43VkmejmW8vcjS6IYywpLv
         2JgPGzdm/bbLvq+fgSCvs8TXu6VJ9yOT1lZrW8zXgNyZJ1xOOvLVKiQ4bcLqKAvafbwZ
         dIlilxfJWkJhPxNbw2h8Y4Qmdb+2yun4j8WPzZOurehepzelz5P9mCrLdMJsBn7Ka+pp
         48gd+JboV56u18poXzO8+fMD/HQObMkbo5ZE9+WtQtEjEKUKmTEWuRKXmuvLRFAJw2ZZ
         2nIg==
X-Gm-Message-State: AOAM530vpUWN8Ttn2rBkkjB0s5AMFWnSjXUwQUJjC30Sa01i9HidiRTf
        J7jlR/OSsNYm9BeF29B70jBcqh1A0lND3W7sFfw=
X-Google-Smtp-Source: ABdhPJx+u8EmD/C3WW0PsTfCEC7tbyaNL5EH+izjVXjxx1ptCquVMHe02OJ75D1f6Ctol+HMs+esVk6Cdp97potiQkY=
X-Received: by 2002:a5e:9309:: with SMTP id k9mr45686369iom.135.1594372665059;
 Fri, 10 Jul 2020 02:17:45 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 10 Jul 2020 11:17:33 +0200
Message-ID: <CA+icZUWQVrph_Rv9O=Q4Fh8Y0jXzkWGCHN5DFAaCZeE5eXoPbw@mail.gmail.com>
Subject: Re: x86: crypto: fix building crc32c with clang ias
To:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[ Please CC me I am not subscribed to this ML ]
[ Original patch from Arnd (see [0]) ]

Hi,

as reported in [1] this is the last patch we "ClangBuiltLinux folks"
need to be full compliant with LLVM_IAS=1 (for example with Linux
v5.8-rc4).

These two commits entered recently cryptodev-2.6.git:

commit 44069737ac9625a0f02f0f7f5ab96aae4cd819bc
"crypto: aesni - add compatibility with IAS"

commit 3347c8a079d67af21760a78cc5f2abbcf06d9571
"crypto: aesni - Fix build with LLVM_IAS=1"

With these three patches we are full compliant with LLVM_IAS=1 in
x86/crypto tree.

Feel free to add my:
   Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
   Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

Thanks.

Regards,
- Sedat -

[0] https://lore.kernel.org/patchwork/patch/1248401/
[1] https://marc.info/?l=linux-crypto-vger&m=159437162224847&w=2
[2] https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=44069737ac9625a0f02f0f7f5ab96aae4cd819bc
[3] https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=3347c8a079d67af21760a78cc5f2abbcf06d9571
