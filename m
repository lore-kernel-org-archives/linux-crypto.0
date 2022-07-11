Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCAF9CCA47F
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jul 2022 11:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiGKLpM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jul 2022 07:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbiGKLox (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jul 2022 07:44:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D27FF1117D
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jul 2022 04:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657539675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gHZTeBa+zo6V5aGVigu7pGUwqHAZBzzfDHWLTO9INzI=;
        b=VnME6Q7nQgsS30ursDvkPyRslJgOQr0nbpJ0wrgV7GYn0ryV7GTKcRewRXhwLpiQdxoUmV
        7zKQfHzB/yj9wy1rDgsNWLiF4sARvsZJpK4e6QJ9Krzk6V0+j3IPQq3VlnrUxueHmO2Yha
        NUImyKaBKh8gmd1o+YoVn2DtHKTcurE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-eREXW90SPZO1YrnBl6FWVA-1; Mon, 11 Jul 2022 07:41:15 -0400
X-MC-Unique: eREXW90SPZO1YrnBl6FWVA-1
Received: by mail-wm1-f71.google.com with SMTP id 2-20020a1c0202000000b003a2cfab44eeso5103892wmc.6
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jul 2022 04:41:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=gHZTeBa+zo6V5aGVigu7pGUwqHAZBzzfDHWLTO9INzI=;
        b=1/An6UGmX8EV0/NPBldr9A7seG0brD1tXB5hc/aIhTN8RwoO3uHpnkqLTFuKpyt1tg
         NfxfmdkYe/CfLFrFoJUxqeAw37Yta5bJKy/jZuKKb2cmmEl4JFYm3u39PB1VV8fO+cZE
         ymA+E5hbg83UgecWclp74bEv9xat5j9G8Vdyx2uKIAuF08pwmwFVFqMHX4KeWm0ja4bS
         GVI6L35PHSwKWtEO23nut3lO6tsYYadW95s5biLh9BdGsd7apxbwK8woIXwh/Xomp92C
         QixwDE5zihe7WQCgmOvuc9moG9V0cM5AUaxVKIOY1x1o8s+6u4uQOrH24xn6zH54naT0
         2UWA==
X-Gm-Message-State: AJIora/osncDpDdGq4eosYFMHL/+8VBbhV1zBqkA+8+iqTGZvaw9XioG
        H3gQToOVCfkoGh1ncySQrADj5UxUibDHjqdugg500+AOuLKjdwxnVB6gjY9/Zvo3nAToHiJsoAZ
        WQKgtlCXJMpPbh3wsirjSGeWmTRKciRO643QjpRxLlqVlstlMNyiIF+/Sf+JS7+m68jof0tlamH
        QW
X-Received: by 2002:adf:fbc6:0:b0:21d:3fc3:99e with SMTP id d6-20020adffbc6000000b0021d3fc3099emr16603251wrs.550.1657539673444;
        Mon, 11 Jul 2022 04:41:13 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tqCQTI5mdoLJYyLC9KKsKSmRT9hOYxAFOVKHCeTy+01po4lrgNtzb/0y31cJeV8TLUEzjpoQ==
X-Received: by 2002:adf:fbc6:0:b0:21d:3fc3:99e with SMTP id d6-20020adffbc6000000b0021d3fc3099emr16603219wrs.550.1657539673173;
        Mon, 11 Jul 2022 04:41:13 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id u20-20020adfa194000000b0021da61caa10sm2434566wru.56.2022.07.11.04.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 04:41:12 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v8] ath9k: let sleep be interrupted when unregistering
 hwrng
In-Reply-To: <87v8s8ubws.fsf@kernel.org>
References: <Yrw5f8GN2fh2orid@zx2c4.com>
 <20220629114240.946411-1-Jason@zx2c4.com> <87v8s8ubws.fsf@kernel.org>
Date:   Mon, 11 Jul 2022 12:41:12 +0100
Message-ID: <xhsmho7xv512f.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 07/07/22 19:26, Kalle Valo wrote:
> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
>
>> There are two deadlock scenarios that need addressing, which cause
>> problems when the computer goes to sleep, the interface is set down, and
>> hwrng_unregister() is called. When the deadlock is hit, sleep is delayed
>> for tens of seconds, causing it to fail. These scenarios are:
>>
>> 1) The hwrng kthread can't be stopped while it's sleeping, because it
>>    uses msleep_interruptible() instead of schedule_timeout_interruptible=
().
>>    The fix is a simple moving to the correct function. At the same time,
>>    we should cleanup a common and useless dmesg splat in the same area.
>>
>> 2) A normal user thread can't be interrupted by hwrng_unregister() while
>>    it's sleeping, because hwrng_unregister() is called from elsewhere.
>>    The solution here is to keep track of which thread is currently
>>    reading, and asleep, and signal that thread when it's time to
>>    unregister. There's a bit of book keeping required to prevent
>>    lifetime issues on current.
>>
>> Reported-by: Gregory Erwin <gregerwin256@gmail.com>
>> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> Cc: Kalle Valo <kvalo@kernel.org>
>> Cc: Rui Salvaterra <rsalvaterra@gmail.com>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: stable@vger.kernel.org
>> Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly dumpi=
ng into random.c")
>> Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytGgDs=
FGTEjs0c00giw@mail.gmail.com/
>> Link: https://lore.kernel.org/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY8=
Hys_DVXtent3HA@mail.gmail.com/
>> Link: https://bugs.archlinux.org/task/75138
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> ---
>> Changes v7->v8:
>> - Add a missing export_symbol.
>>
>>  drivers/char/hw_random/core.c        | 30 ++++++++++++++++++++++++----
>>  drivers/net/wireless/ath/ath9k/rng.c | 19 +++++++-----------
>>  kernel/sched/core.c                  |  1 +
>>  3 files changed, 34 insertions(+), 16 deletions(-)
>
> I don't see any acks for the hw_random and the scheduler change, adding m=
ore
> people to CC. Full patch here:
>
> https://patchwork.kernel.org/project/linux-wireless/patch/20220629114240.=
946411-1-Jason@zx2c4.com/
>
> Are everyone ok if I take this patch via wireless-next?
>

Thanks for the Cc.

I'm not hot on the export of wake_up_state(), IMO any wakeup with
!(state & TASK_NORMAL) should be reserved to kernel internals. Now, here
IIUC the problem is that the patch uses an inline invoking

  wake_up_state(p, TASK_INTERRUPTIBLE)

so this isn't playing with any 'exotic' task state, thus it shouldn't
actually need the export.

I've been trying to figure out if this could work with just a
wake_up_process(), but the sleeping pattern here is not very conforming
(cf. 'wait loop' pattern in sched/core.c), AFAICT the signal is used to
circumvent that :/

