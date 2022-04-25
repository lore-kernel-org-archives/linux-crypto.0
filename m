Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB29EC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 15:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242784AbiDYPXO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 11:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240093AbiDYPXN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 11:23:13 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C7EF70
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 08:20:05 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id z30so7158266pfw.6
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 08:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=jI17jX2VOaLJfc9AfJqU1GSCFAD6t7z5sS76HYwewd0=;
        b=BwNx1EG/blk0vUyqI0sgYlBJdVl5y5hRSnFaNVOD2lDrREI1aB2qDGWAzyJiRMHr8o
         1ddUvfcq8O7lESQkU7F8tEvqTXawfoKGIBDItZtInrNe3lPN4DJZtAqPRx1bqZviLex8
         vts3wvUo7Lp8rjispWnXrSNrdOrnGahgLkkRaF75t7BcohdJLB+9Y7JbPqTT+d2ZP7FQ
         0oBzn8so8Rrs9Z+/s8lgEqpIn2Gkg8IhoUHMqYgL7i3cqmEc73xGLF6IP4LsWb+7dh6C
         RqXmVVdzf2g8Q04odAjopltJUjLCMS3bIdsYYOdptzNknoJlRufb1Cvh4bS/UJjTB3Rr
         YTQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=jI17jX2VOaLJfc9AfJqU1GSCFAD6t7z5sS76HYwewd0=;
        b=RyUgJR9n+N0A2lsk2JZwXV1/oH7pp+0/jZq09Ad1y+0GiQXur0O5fj9VoXFEkBIY2s
         mYQ+v1aUKi2EjonjCPPsYeYQVgyuOwIy8lyJnczUXyEjey1N7qGpl9Tn+zmKQZoetCmp
         4dAU2lH0EIYigtewvOQoRnxvgHUUOV2gRJrtfnQe2pQrNGy7TdBPHe6uQ4HdZzek6nPa
         xNpqaXQB1SGMne4BWRGGIvKufY10bNNL08rk7yHpTL5QG3jCeZoFklmdy7qRVYTGAtz9
         CxJgvW/U4Lon5NkY3+NoLuaMXfRW40mkRjhM5/aSYAhJZKKyWKwuCc7htXLZbSWcWNeI
         INRg==
X-Gm-Message-State: AOAM5336PqUirNCzpJoXeH+72EjaKuRRiqEp49AVWADoWAP33Ap8b/7E
        fAXFR4j9cJbGxTT3k93DHi39yHUvGMgQ7g==
X-Google-Smtp-Source: ABdhPJyjVW6BtRR4eGDuZRuKEcZeHboxtGb4eE+0Lm3lXGt4/atAK7VkeIhtvLfPilhch/tupfRRgA==
X-Received: by 2002:a63:4e59:0:b0:39d:69fe:eaa with SMTP id o25-20020a634e59000000b0039d69fe0eaamr15736865pgl.340.1650900004529;
        Mon, 25 Apr 2022 08:20:04 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id d8-20020a056a00198800b004fab740dbe6sm12668514pfl.15.2022.04.25.08.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 08:20:03 -0700 (PDT)
Date:   Mon, 25 Apr 2022 08:20:03 -0700 (PDT)
X-Google-Original-Date: Mon, 25 Apr 2022 08:14:07 PDT (-0700)
Subject:     Re: [PATCH v6 08/17] riscv: use fallback for random_get_entropy() instead of zero
In-Reply-To: <CAHmME9qosSq+3RYtBCMiS6yCaiZcJtaBW=8StMTACEkr3hVSow@mail.gmail.com>
CC:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        tglx@linutronix.de, Arnd Bergmann <arnd@arndb.de>,
        Paul Walmsley <paul.walmsley@sifive.com>
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Jason@zx2c4.com
Message-ID: <mhng-fb5b48c2-4e08-4e41-9f28-88e216df40ab@palmer-mbp2014>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 25 Apr 2022 08:02:49 PDT (-0700), Jason@zx2c4.com wrote:
> Hi Palmer,
>
> On Mon, Apr 25, 2022 at 4:55 PM Palmer Dabbelt <palmer@dabbelt.com> wrote:
>> Fine for me if this goes in via some other tree, but also happy to take
>> it via the RISC-V tree if you'd like.
>
> I'm going to take this series through the random.git tree, as I've got
> things that build on top of it for random.c slated for 5.19.
>
>> IMO we could just call this a
>> fix, maybe
>>
>> Fixes: aa9887608e77 ("RISC-V: Check clint_time_val before use")
>>
>> (but that just brought this back, so there's likely older kernels broken
>> too).  Shouldn't be breaking any real hardware, though, so no rush on my
>> end.
>
> That'd be fine with me, but it'd involve also backporting the
> timekeeping patch, which adds a new API, so maybe we better err on the
> side of caution with that new code.

wFM.  Like I said this isn't going to break any existing hardware, and 
anyone trying to ship something without the timers is likely going to be 
in for way more trouble than this so will probably be stuck with newer 
kernels anyway.

>> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
>> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
>
> Thanks for the review.
>
>> Makes sense: we had an architecturally-mandated timer at the time, but
>> we don't any more.
>
> That's too bad. Out of curiosity, what happened? Was that deemed too
> expensive for certain types of chips that western digital wanted to
> produce for their hard drives, or some really constrained use case
> like that?

No idea, but it was at the beginning of the "everything is 
optional"-ification of the ISA so I'm guessing it's just part of that.
