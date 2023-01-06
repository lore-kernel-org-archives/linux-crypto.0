Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A54C63797
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Jan 2023 21:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbjAFVLJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Jan 2023 16:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbjAFVLI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Jan 2023 16:11:08 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E44A81C24
        for <linux-crypto@vger.kernel.org>; Fri,  6 Jan 2023 13:11:04 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id k4so2781024vsc.4
        for <linux-crypto@vger.kernel.org>; Fri, 06 Jan 2023 13:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6TxHKlwJQCLSbYZxgdJdZSJ5mNfa7xbEinv+9m+b8dU=;
        b=JkoJF2oW8oodyFdhhEZiE+zCQjJRSe8qbnBn4Ts4FFiwa0sekyPhwMSBKHbEAYUHQ3
         r06xF755O1aHQhg/uNyi+N/5KDBJ+uaAZmpigEg23rzOQ2HcFrMDLG9jJMUNcJHfKiAj
         dE34EO7JXggOKr+Oq4bXZx2m6WRZXthUX8U5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6TxHKlwJQCLSbYZxgdJdZSJ5mNfa7xbEinv+9m+b8dU=;
        b=227rpQ6CTuXW6NCAafVQuY+vSovyTYoDCTffidX8evkc855JWcXM/YCTbYPZIE9uku
         bJn8RvgxDRQVOWm5WTRPt8b+jNOVKDeWvDrV7zI0rj3HIZEBwjny1KoSq6JkTmQmda2j
         mCpbudiSmHy8vvSlsMwTTvQf23eghCxUSaIr08Q1AK8w9gMLo/BMDMTrGsJJzPOW+boX
         duL0DxSux03a4yRhlRXu4WJyITtSNBt/PKqFJzmFKLa6KrTzvB5dymU0if1luyIsQy/h
         wI16ltFLv4gg2zkR9IeEb98Tmj5YtOeKtK4gyQXHlRQVpRQqCETzi4zSUn/FvEYUbC/m
         auDw==
X-Gm-Message-State: AFqh2krUogRiDR+ZSf0e0NYIxKU6PwNatbf0Pc+Xy1pCBlFI2Dnnhu4d
        7mKrvIpvZdBBn6kLl/cu+PdNrG9WcCwC1Opl
X-Google-Smtp-Source: AMrXdXvP8+jbC1/qiJRvCsXerwrexkiNBtwsGmm8WqcC3nX14r7oeNwKmSntXhnWgG9/iw/tQufmjw==
X-Received: by 2002:a67:ff03:0:b0:3ce:bb3f:f7d0 with SMTP id v3-20020a67ff03000000b003cebb3ff7d0mr6164519vsp.16.1673039463542;
        Fri, 06 Jan 2023 13:11:03 -0800 (PST)
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com. [209.85.222.173])
        by smtp.gmail.com with ESMTPSA id v7-20020a05620a440700b006fb112f512csm1102556qkp.74.2023.01.06.13.11.01
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 13:11:01 -0800 (PST)
Received: by mail-qk1-f173.google.com with SMTP id pa22so1338905qkn.9
        for <linux-crypto@vger.kernel.org>; Fri, 06 Jan 2023 13:11:01 -0800 (PST)
X-Received: by 2002:a05:620a:4720:b0:6ff:cbda:a128 with SMTP id
 bs32-20020a05620a472000b006ffcbdaa128mr2770302qkb.697.1673039460720; Fri, 06
 Jan 2023 13:11:00 -0800 (PST)
MIME-Version: 1.0
References: <20230101162910.710293-3-Jason@zx2c4.com> <Y7QIg/hAIk7eZE42@gmail.com>
 <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
 <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
 <Y7SDgtXayQCy6xT6@zx2c4.com> <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
 <Y7SJ+/axonTK0Fir@zx2c4.com> <CAHk-=wi4gshfKjbhEO_xZdVb9ztXf0iuv5kKhxtvAHf2HzTmng@mail.gmail.com>
 <Y7STv9+p248zr+0a@zx2c4.com> <10302240-51ec-0854-2c86-16752d67a9be@opteya.com>
 <Y7dV1lVUYjqs8fh0@zx2c4.com> <CAHk-=wijEC_oDzfUajhmp=ZVnzMTXgjxHEcxAfaHiNQm4iAcqA@mail.gmail.com>
 <CAHk-=wiO4rp8oVmj6i6vvC97gNePLN-SxhSK=UozA88G6nxBGQ@mail.gmail.com> <f36f19ee-5bff-4cd0-b9a9-0fe987cf6d38@app.fastmail.com>
In-Reply-To: <f36f19ee-5bff-4cd0-b9a9-0fe987cf6d38@app.fastmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 6 Jan 2023 13:10:44 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgLWcKq2AdrTmTOxJKn6w4oEpEGdipWAah5Xad5-Yii6Q@mail.gmail.com>
Message-ID: <CAHk-=wgLWcKq2AdrTmTOxJKn6w4oEpEGdipWAah5Xad5-Yii6Q@mail.gmail.com>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To:     Andy Lutomirski <luto@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Florian Weimer <fweimer@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
        Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 6, 2023 at 12:54 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> I'm going to suggest a very very different approach: fix secret
> storage in memory for real. That is, don't lock "super secret
> sensitive stuff" into memory, and don't wipe it either. *Encrypt* it.

I don't think you're wrong, but people will complain about key
management, and worry about that part instead.

Honestly, this is what SGX and CPU enclaves is _supposed_ to all do
for you, but then nobody uses it for various reasons.

               Linus
