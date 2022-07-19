Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECDBC43334
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jul 2022 15:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbiGSPPp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Jul 2022 11:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238985AbiGSPPe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Jul 2022 11:15:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1AD9C550B3
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2022 08:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658243714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DZfape1HvRcQDBJMjqCK8x7O2btj6Zg9uPaKpCKPLz4=;
        b=A73vFLu8lP9Ui8AT3JEQEjnipDQnV3FShXbctl23TfDsy5O0Bg22o791JsAWIg2e6ltIPO
        rVg4UmELRTG8Dcpnx+0NZYaEyO1DmIYKhpk1sZ1UbsIaFoPicDusXkS984Zt3edM9Usz9M
        60TGJVf8IWUruGp7MbGioEda3nk0M6Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-RucEUlWNMECtRVqthets1Q-1; Tue, 19 Jul 2022 11:15:06 -0400
X-MC-Unique: RucEUlWNMECtRVqthets1Q-1
Received: by mail-wm1-f72.google.com with SMTP id bg6-20020a05600c3c8600b003a03d5d19e4so5548172wmb.1
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2022 08:15:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DZfape1HvRcQDBJMjqCK8x7O2btj6Zg9uPaKpCKPLz4=;
        b=F2j6Zj2p6WDeuA9NdVXIAfZpRl0c8nzZXtWBPkAuGP6HzKERSPjdbFFc2C9v5VxfKR
         mF8Bgz/KxW/sC5sxPFoWmdLjsUJJ8vBvq9tavmrRznHBN4ihlaZyK4VaPcoVjnvngZCe
         VQb50/NMNfFaKrbDJxqFngzc9f9LWxfo8jhkDAA/9ravw4eLH1QFgxhAYb9iu6zSAQ1q
         G2fUaMfOkVCxX+Q1KKMQpziQAuXAvp0h+AWfjkk7eao0D5jIGZlsliP9/XcQMFHZ+GU/
         zYcQIPR1NLVAzndEhMF8ejcPzdG9N3b6fqqVF4knszSTZ0KK0MLkWwrdgFPBNCmM1QFD
         bhZg==
X-Gm-Message-State: AJIora8BgItRoTN8p2cAO4GioCXL7IwoA/jbxUm0LXQMlOX4+fRP5kPh
        sLZU6i+hf/x6CQXj4pdugBVT0VGCjLAJRxJY7K18//a58XKMsUaLVrO6lugk80Nav7dmDBaoKz+
        bZRr4zutdzVzyJhoqBX3BaeD4GxP/4ZuLP333oplgc4Z3q5DC3MAwSAgcgIlvHPashvgu5V692P
        UN
X-Received: by 2002:a1c:2b05:0:b0:3a0:2ae2:5277 with SMTP id r5-20020a1c2b05000000b003a02ae25277mr32016359wmr.30.1658243704654;
        Tue, 19 Jul 2022 08:15:04 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ufZw67mDO/HMSiR5dpo2mMh5Dr7OZ3O/vXfLgflU9RixvUu7uhgILPHQ/3jGFAFcB3ZuKGow==
X-Received: by 2002:a1c:2b05:0:b0:3a0:2ae2:5277 with SMTP id r5-20020a1c2b05000000b003a02ae25277mr32016321wmr.30.1658243704438;
        Tue, 19 Jul 2022 08:15:04 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id bg10-20020a05600c3c8a00b003a0323463absm23061621wmb.45.2022.07.19.08.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 08:15:03 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgense?= =?utf-8?Q?n?= 
        <toke@redhat.com>, Rui Salvaterra <rsalvaterra@gmail.com>,
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
In-Reply-To: <CAHmME9q8-1vpV9zFsKkawk+XFm96S6fmug7v-NPJNpQmRoe6-Q@mail.gmail.com>
References: <Yrw5f8GN2fh2orid@zx2c4.com>
 <20220629114240.946411-1-Jason@zx2c4.com> <87v8s8ubws.fsf@kernel.org>
 <xhsmho7xv512f.mognet@vschneid.remote.csb>
 <CAHmME9q8-1vpV9zFsKkawk+XFm96S6fmug7v-NPJNpQmRoe6-Q@mail.gmail.com>
Date:   Tue, 19 Jul 2022 16:15:02 +0100
Message-ID: <xhsmhcze16snd.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/07/22 13:53, Jason A. Donenfeld wrote:
> Hi Valentin,
>
> On 7/11/22, Valentin Schneider <vschneid@redhat.com> wrote:
>> Thanks for the Cc.
>>
>> I'm not hot on the export of wake_up_state(), IMO any wakeup with
>> !(state & TASK_NORMAL) should be reserved to kernel internals. Now, here
>> IIUC the problem is that the patch uses an inline invoking
>>
>>   wake_up_state(p, TASK_INTERRUPTIBLE)
>>
>> so this isn't playing with any 'exotic' task state, thus it shouldn't
>> actually need the export.
>>
>> I've been trying to figure out if this could work with just a
>> wake_up_process(), but the sleeping pattern here is not very conforming
>> (cf. 'wait loop' pattern in sched/core.c), AFAICT the signal is used to
>> circumvent that :/
>
> I don't intend to work on this patch more. If you'd like to ack the
> trivial scheduler change (adding EXPORT_SYMBOL), that'd help, and then
> this can move forward as planned. Otherwise, if you have particular
> opinions about this patch that you want to happen, feel free to pick
> up the patch and send your own revisions (though I don't intend to do
> further review). Alternatively, I'll just send a patch to remove the
> driver entirely. Hopefully you do find this ack-able, though.
>

I'm not for a blanket wake_up_state() export, however if we *really* need
it then I suppose we could have a wake_up_process_interruptible() exported
and used by __set_notify_signal().

