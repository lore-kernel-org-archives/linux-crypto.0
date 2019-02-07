Return-Path: <SRS0=Jc5W=QO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43AD8C282C4
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Feb 2019 17:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1492A21872
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Feb 2019 17:02:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KGxSnork"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfBGRCM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Feb 2019 12:02:12 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:37623 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfBGRCM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Feb 2019 12:02:12 -0500
Received: by mail-it1-f195.google.com with SMTP id b5so1458892iti.2
        for <linux-crypto@vger.kernel.org>; Thu, 07 Feb 2019 09:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yekiINZOvow/56QtEZFZV4uAzjjuHYvfcb4vk7nERI8=;
        b=KGxSnork5ZdIVpsZ2ZAk3VXpWfz0y58EMcD2qqCIhB2/hauyLjRlpG9lFDVj5OWz4e
         v0LTYvuOAL4BokiAvQqvdUfbaai+UBeaOaZctkVedMO/atnyyEZcTd2MaZM6PVFv8GDP
         UGGurdCGV4Tkm+ceVE7af0QKAF7Tga7wSIgCk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yekiINZOvow/56QtEZFZV4uAzjjuHYvfcb4vk7nERI8=;
        b=YLzX8r+29Rbn0qQTRlb+kqgPkhzjDQeQh/JEPyLcGtb1X4D1FxsCRIqKvQLdl8iBHt
         cyFjYkuGgCI8JvNz9IRWaVq6bHwOe37CBRq/6lWegY6p08N+BJVyTcp63jsS5YskWqgW
         NL1Agb6RKllMZvnjnKvaUs9CT0HrTZcTn6nn0IgnVQGCE92/ZfJ68bm9nKyccLV2xghc
         OhwtH6tt4YSO+WGycrWOyWhSoS/HViRElMHQgolaCkz4dznmP/DAVti3aRekSR39KtKN
         QHqPliwP7XqakNIm6JENiSShn4A3UuDRVEbvs9d8Z9zBT+brsR4ij0E1GNAhNAJBMBeB
         avyA==
X-Gm-Message-State: AHQUAuZUMj+GygN4fpUM8OmzqSFukj8gdtajaQT2KXeOD6cxfexKpc3/
        xLeViUTKCaO/o2o833zoaTjj/kx4pww=
X-Google-Smtp-Source: AHgI3IYQ47g9aWbPRuyTBmvIl5CjgzWf49xmB0yULu8KwU8GEwCGJjz7i7duRTMut96aA9uGFjkpGA==
X-Received: by 2002:a5e:8a05:: with SMTP id d5mr6644733iok.67.1549558931005;
        Thu, 07 Feb 2019 09:02:11 -0800 (PST)
Received: from mail-it1-f173.google.com (mail-it1-f173.google.com. [209.85.166.173])
        by smtp.gmail.com with ESMTPSA id m196sm9534920itc.33.2019.02.07.09.02.09
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Feb 2019 09:02:09 -0800 (PST)
Received: by mail-it1-f173.google.com with SMTP id g85so1446345ita.3
        for <linux-crypto@vger.kernel.org>; Thu, 07 Feb 2019 09:02:09 -0800 (PST)
X-Received: by 2002:a24:55ca:: with SMTP id e193mr5929100itb.119.1549558929044;
 Thu, 07 Feb 2019 09:02:09 -0800 (PST)
MIME-Version: 1.0
References: <20190131192533.34130-1-thgarnie@chromium.org> <20190131192533.34130-2-thgarnie@chromium.org>
 <20190207114850.GD2414@zn.tnic>
In-Reply-To: <20190207114850.GD2414@zn.tnic>
From:   Thomas Garnier <thgarnie@chromium.org>
Date:   Thu, 7 Feb 2019 09:01:57 -0800
X-Gmail-Original-Message-ID: <CAJcbSZGzTZmkpCWC3VbLJ7ygkxiRSAfq+GNOkHUungUEjiURTw@mail.gmail.com>
Message-ID: <CAJcbSZGzTZmkpCWC3VbLJ7ygkxiRSAfq+GNOkHUungUEjiURTw@mail.gmail.com>
Subject: Re: [PATCH v6 01/27] x86/crypto: Adapt assembly for PIE support
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 7, 2019 at 3:49 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Jan 31, 2019 at 11:24:08AM -0800, Thomas Garnier wrote:
> > Change the assembly code to use only relative references of symbols for the
> > kernel to be PIE compatible.
> >
> > Position Independent Executable (PIE) support will allow to extend the
> > KASLR randomization range below 0xffffffff80000000.
>
> This sentence is auto-sprinkled in a bunch of commit messages. Sounds to
> me it should be rather somewhere in the 0/n message as a justification
> for the feature but not in every other commit message...?

I go into more details in the compose message but I wanted a small
sentence explaining why PIE changes are being made.

>
> --
> Regards/Gruss,
>     Boris.
>
> Good mailing practices for 400: avoid top-posting and trim the reply.
