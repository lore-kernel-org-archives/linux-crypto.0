Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0994C74A5B
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Mar 2023 19:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjCUTWU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Mar 2023 15:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbjCUTWR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Mar 2023 15:22:17 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C84831BD8
        for <linux-crypto@vger.kernel.org>; Tue, 21 Mar 2023 12:22:14 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id o12so63904843edb.9
        for <linux-crypto@vger.kernel.org>; Tue, 21 Mar 2023 12:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1679426533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AHtgR0XvPydSJ2xRHzSM20hkxNSVo2TSBRlBp9YTFyU=;
        b=AD6aPA9u70fXHrmlk16ASDhb6ySx+aypTn68plHV/Ab7KbrZsb7apePctdz/CJYGxU
         8gluqq5WjF4FL6f9Mm9aA1Jith5btLXPWg4zGhzWcIO4f0UtuEPTdIrfciEQc/MapFAj
         bfWs8fVAQNw1soGzo2v+ZqPQEW1YSvfyiejdc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679426533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AHtgR0XvPydSJ2xRHzSM20hkxNSVo2TSBRlBp9YTFyU=;
        b=0P4i80yqys6vw//1kRtty5xEdq9WfiwF6T51wEe1lTeyE164jMHU4jdSVA89Pzuncf
         K7tQkXUSzxsvU/rpVCHq8WYqmno2TMgXJoeg8sQDIGyIb/va4n6z9o6/UCBF9P+XPkf+
         V0THUDQ7Zw61wy6P6hMPuPCGu5QF5Gc6LbChDxXv9qgEZ6UV+2EkQ8joqli9FsvpQss1
         td3bhlIYPIATsznuIovW66VBBIaOIcQOUNvZjCCp8qbZQfCT8h1V6WxDkLsUesGQZdl/
         DQOPHIuhSRUgA6k0fwIcBmDX+ZxHcCXmlNXXT8HuI6mCzrzw3g2HN+vl2FyZFIXybr4W
         VYfw==
X-Gm-Message-State: AO0yUKWO6RWjJj+zBV7WcrP2vybCcF5WZf6gmqbaCVAh1WIYKZhVjv1d
        R6vKixW5gGvhQNMqEc92H0oUdjRLh0mNgeMUrI+Y+O91
X-Google-Smtp-Source: AK7set8mPP0VYfMjFJKaX+pFAApsc7SIb7axUZgVhtyj+GE7CkbZPOywkjMiVsB7E8kc1KVPV3jhbA==
X-Received: by 2002:a17:906:1705:b0:92c:a80e:2260 with SMTP id c5-20020a170906170500b0092ca80e2260mr4904455eje.54.1679426532834;
        Tue, 21 Mar 2023 12:22:12 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id l22-20020a170906079600b009333288d0ffsm4754544ejc.194.2023.03.21.12.22.11
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 12:22:11 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id ew6so950161edb.7
        for <linux-crypto@vger.kernel.org>; Tue, 21 Mar 2023 12:22:11 -0700 (PDT)
X-Received: by 2002:a50:9e6f:0:b0:4fb:482b:f93d with SMTP id
 z102-20020a509e6f000000b004fb482bf93dmr2321260ede.2.1679426530851; Tue, 21
 Mar 2023 12:22:10 -0700 (PDT)
MIME-Version: 1.0
References: <2851036.1679417029@warthog.procyon.org.uk> <CAHk-=wh1b0r+5SnwWedx=J4aZhRif1HLN_moxEG9Jzy23S6QUA@mail.gmail.com>
 <8d532de2-bf3a-dee4-1cad-e11714e914d0@kernel.dk>
In-Reply-To: <8d532de2-bf3a-dee4-1cad-e11714e914d0@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 21 Mar 2023 12:21:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi2yeuwCxvB18=AWG+YKnMgd28WGkHFMqTyMA=59cw3rg@mail.gmail.com>
Message-ID: <CAHk-=wi2yeuwCxvB18=AWG+YKnMgd28WGkHFMqTyMA=59cw3rg@mail.gmail.com>
Subject: Re: [GIT PULL] keys: Miscellaneous fixes/changes
To:     Jens Axboe <axboe@kernel.dk>
Cc:     David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
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

On Tue, Mar 21, 2023 at 12:16=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> I haven't seen the patch yet as it hasn't been pushed,

Well, it went out a couple of minutes before your email, so it's out now.

> It may make sense to add some debug check for
> PF_KTHREAD having TIF_NOTIFY_RESUME set, or task_work pending for that
> matter, as that is generally not workable without doing something to
> handle it explicitly.

Yeah, I guess we could have some generic check for that. I'm not sure
where it would be. Scheduler?

               Linus
