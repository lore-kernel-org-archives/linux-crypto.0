Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73B0C5479D
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Jan 2023 12:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjAKMN5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Jan 2023 07:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238691AbjAKMN3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Jan 2023 07:13:29 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC6DFACE
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jan 2023 04:13:11 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id a25so6389743qto.10
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jan 2023 04:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kmJ3yYULDZh/n/Ts/CIw+F5G8M6+xd7o3i732aR8bfU=;
        b=Huh5mGKh/5kG5fJLMYNPH7N0pSWybZghPelk0NUdJxECQjfmL+QRCFnkVZYZ4p+6iD
         U+QihvuYLnC/fu4YtVobiKMfwnj89zGyUkxMQNLkIvXiiPlansCrF7ZPHS4XRej3DbV6
         fdWAbhsdr/nCOV/rntZFIEmSK949BWpA3v5Sw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kmJ3yYULDZh/n/Ts/CIw+F5G8M6+xd7o3i732aR8bfU=;
        b=kl4zJ/jj8FjI29f4FJopzsU5VaBCvFyZu5pvJpO73RzSPqdHHnaF2foB1z5HTGJMJF
         ZAuGzEv/tPt7/RSGPGykxdajsfav6stTl4N06Vu5n4VjvHydwMHm4sbth6BN6FiUWGc2
         WVHevPl3/aIbmv8orqcLgevhs1Kz243jzFV2Hotc+lFg//tVifyMDPPP7FlWyVnuDhm6
         pegCN0qMijYzAK0UMpWgyto2z8yAQ2w93UpWCE5BMrjgKvTqux/wUX7/StgfTsN9nMoc
         mUuLduDXLxDkxTQw7vCevS39yEADSARwnG1pog42cgBTKsZFd77hLDwmGn1N4UjwIb+V
         56hQ==
X-Gm-Message-State: AFqh2krQzsq5mO5PbW/Yt6gDB2T6S4KDtI/c4+EHCqwbJQejrqTPhdLo
        fNuXlPaLVKu4LirEVrVFqhhJ+zaRca3odf6fmiI=
X-Google-Smtp-Source: AMrXdXsk3VKfHpNeKtR8tprEiYZYHuhqPlpPzGr31beNKg0AjiAjE82ofikgVXTukHNdhROM/gJV6A==
X-Received: by 2002:ac8:7f43:0:b0:3a7:e360:e0be with SMTP id g3-20020ac87f43000000b003a7e360e0bemr134720652qtk.63.1673439190219;
        Wed, 11 Jan 2023 04:13:10 -0800 (PST)
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com. [209.85.222.171])
        by smtp.gmail.com with ESMTPSA id z2-20020ac86b82000000b003a5c6ad428asm7432328qts.92.2023.01.11.04.13.10
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 04:13:10 -0800 (PST)
Received: by mail-qk1-f171.google.com with SMTP id s8so4229892qkj.6
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jan 2023 04:13:10 -0800 (PST)
X-Received: by 2002:a05:622a:2598:b0:3ae:db1:185f with SMTP id
 cj24-20020a05622a259800b003ae0db1185fmr412604qtb.436.1673438886653; Wed, 11
 Jan 2023 04:08:06 -0800 (PST)
MIME-Version: 1.0
References: <20230101162910.710293-1-Jason@zx2c4.com> <20230101162910.710293-3-Jason@zx2c4.com>
 <Y7QIg/hAIk7eZE42@gmail.com> <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
 <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
 <Y7SDgtXayQCy6xT6@zx2c4.com> <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
 <874jt0kndq.fsf@oldenburg.str.redhat.com> <CAHk-=wg7vMC2VmSBdVw7EKV+7UDiftQEg3L+3Rc0rcjjfsvs5A@mail.gmail.com>
 <Y75k2KaDz2WdcXLk@sol.localdomain>
In-Reply-To: <Y75k2KaDz2WdcXLk@sol.localdomain>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 11 Jan 2023 06:07:50 -0600
X-Gmail-Original-Message-ID: <CAHk-=wga2A0T8a3L6KHPrxjShU5-m6t7t71RfHHLnFmA0__wtQ@mail.gmail.com>
Message-ID: <CAHk-=wga2A0T8a3L6KHPrxjShU5-m6t7t71RfHHLnFmA0__wtQ@mail.gmail.com>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Florian Weimer <fweimer@redhat.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, tglx@linutronix.de,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
        Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org,
        mlichvar@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 11, 2023 at 1:27 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> How would userspace decide when to reseed its CRNGs, then?

.. and that is relevant to all the VM discussions exactly why?

                Linus
