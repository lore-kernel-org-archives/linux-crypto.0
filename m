Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B843C6FD1D
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Mar 2023 18:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjCUS40 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Mar 2023 14:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjCUS4Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Mar 2023 14:56:25 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC93D497D8
        for <linux-crypto@vger.kernel.org>; Tue, 21 Mar 2023 11:56:11 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id h8so63638876ede.8
        for <linux-crypto@vger.kernel.org>; Tue, 21 Mar 2023 11:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1679424970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o0ckUw7dWkverm2igg++8Ynt0yEw3mz/3PbETIyN2lM=;
        b=YjXxz2fldoEPn98x7H4DLLXJC69GOlH6LDoVYMF6q1wVKfiNxHx8O8ZsXAOw4m1fcP
         2tIEgQnL5cSvPsy7A7aXnxcTKfrlPMcfCG9R7ao4wEvcATARrJb5uwhCE0ti6wo2K+cz
         C7EHru6XQt/a2dZQ1BqsbIHWbWlbOthBJn4Xw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679424970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o0ckUw7dWkverm2igg++8Ynt0yEw3mz/3PbETIyN2lM=;
        b=BL11KkwKqyUqNPQWo0MAnc+dMFwKbYfWxjdsnNxoFUQL4UY7EJK4Ar+oBq2/SobsRW
         3jdYsu31T803dZPe7o8H1TiIs0/Exd2tY2RS9VDTQNUNcQbGl1X7FRsPLctLi+uh2O4l
         3o9tv8LD/gx+1DY4liX89TYAgJX017IQgsrshYHKRuV9ZpvNiGeu72eL57kXGxOq2qiR
         n6OgbqfKF2trdVWPsMs2iqa1QuF2wu1Bq4xJCkhwd6uOEq0sghSeODyJEpDOQR7iPfTl
         zzPRTUIlXQwqKo+1iXHyihUnURXjobYwjxFYvBycnKPbHQwSQvSMsBlS2FEK5N19Z2b/
         U1UA==
X-Gm-Message-State: AO0yUKUjRMDa9z0IN98pPBOMRTDkJkCoe7yIoT9OXPJImwRr475cXOXV
        6mzEvg2yHlYTZnIJ96Dzml9hL2KQ/HXPsjMrUx58o40v
X-Google-Smtp-Source: AK7set+Qq9D+XYAjqwAoGxhiZo4xo8gBF+9rIBOrp+VcNqII8Z8rQDfpL+lW95RILsTvL9FotorAmw==
X-Received: by 2002:a17:906:cc18:b0:8da:69ae:6ff0 with SMTP id ml24-20020a170906cc1800b008da69ae6ff0mr3710692ejb.22.1679424970075;
        Tue, 21 Mar 2023 11:56:10 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id u17-20020a170906409100b009338ad391b9sm3688210ejj.213.2023.03.21.11.56.09
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 11:56:09 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id w9so63695840edc.3
        for <linux-crypto@vger.kernel.org>; Tue, 21 Mar 2023 11:56:09 -0700 (PDT)
X-Received: by 2002:a17:907:9b03:b0:932:da0d:9375 with SMTP id
 kn3-20020a1709079b0300b00932da0d9375mr2409395ejc.4.1679424514115; Tue, 21 Mar
 2023 11:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <2851036.1679417029@warthog.procyon.org.uk>
In-Reply-To: <2851036.1679417029@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 21 Mar 2023 11:48:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh1b0r+5SnwWedx=J4aZhRif1HLN_moxEG9Jzy23S6QUA@mail.gmail.com>
Message-ID: <CAHk-=wh1b0r+5SnwWedx=J4aZhRif1HLN_moxEG9Jzy23S6QUA@mail.gmail.com>
Subject: Re: [GIT PULL] keys: Miscellaneous fixes/changes
To:     David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Bharath SM <bharathsm@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Robbie Harwood <rharwood@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        keyrings@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-crypto@vger.kernel.org, kexec@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 21, 2023 at 9:43=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
>  (1) Fix request_key() so that it doesn't cache a looked up key on the
>      current thread if that thread is a kernel thread.  The cache is
>      cleared during notify_resume - but that doesn't happen in kernel
>      threads.  This is causing cifs DNS keys to be un-invalidateable.

I've pulled this, but I'd like people to look a bit more at this.

The issue with TIF_NOTIFY_RESUME is that it is only done on return to
user space.

And these days, PF_KTHREAD isn't the only case that never returns to
user space. PF_IO_WORKER has the exact same behaviour.

Now, to counteract this, as of this merge window (and marked for
stable) IO threads do a fake "return to user mode" handling in
io_run_task_work(), and so I think we're all good, but I'd like people
to at least think about this.

              Linus
