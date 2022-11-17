Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC921C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Nov 2022 12:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239684AbiKQMYs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Nov 2022 07:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiKQMYr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Nov 2022 07:24:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43A92229E
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2022 04:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668687832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5jdvVC382FTzq1UHx+dqms0RlcCWrWtt69iT+pMSrhc=;
        b=Zcn30s6mzHo2TA2845EVihGK7vA5Dp9MKdZXfGilcuB6FGDDuYtLgWGz1WFZcjTGZKklnD
        2jkG9Ap4TgoS+EGcsBnkoQC/og7AmoHvNrEnGMOM9wPmqoqqJ7EDLOFGx/n5PK9xejdqoH
        5BiyJ+NDBxVVP4oQBxAnxSkqEhTMCaQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-132-0MEx8mbYOfK_S1VtoN_Zmw-1; Thu, 17 Nov 2022 07:23:51 -0500
X-MC-Unique: 0MEx8mbYOfK_S1VtoN_Zmw-1
Received: by mail-wm1-f69.google.com with SMTP id 84-20020a1c0257000000b003cfe9e8e3f9so589767wmc.0
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2022 04:23:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5jdvVC382FTzq1UHx+dqms0RlcCWrWtt69iT+pMSrhc=;
        b=Et5hd/OJ5zKL2IDoiYI2zfTQ5H382oyyXe4X4XSvE4bE6YcWu3WwtrQiLJnLpaJRK9
         AX+/m02Mr5XFQT7OWxF+YOFYtNPq04r/Zqe1ovCAJEkR4mqxkzD0XnMh9wvc4wKcn0rZ
         Ytg1M6gw10vr1uG3IaDRbqSL9vUg4ao8/znO+BCDF/PgKjWxygzYKnHzZ4T0c1fPMnju
         rjLqohQNW/47Qpr2IiE3lEpyklZnmpSmEUcvvb9f6ozLUBdqeJFmZ5tMd3fWQ+xfTY7W
         vPS+o1Egu9HDDUOO99aivY3/L/i3y1kNGiXRdT3TzzCzPQeunlmyMtO2dk1HONSmeLzU
         5maA==
X-Gm-Message-State: ANoB5pm63fHjNbOU6p3/UmKEAvR9GdhUhMOD2TcGguC63w+k3/64s9v9
        cu0IzPWQbcbg9o0M/xHg0qilfpaYnZ26A6TbwxFN4wnIZs4Lb+9Lobp0jG69wtUzHVBt8ghzy/c
        0ohKlVqikZUG3kY6B76PU0mJn
X-Received: by 2002:a5d:4ace:0:b0:236:7988:b282 with SMTP id y14-20020a5d4ace000000b002367988b282mr1368751wrs.341.1668687830287;
        Thu, 17 Nov 2022 04:23:50 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6CQ2UnPStDreGkKJNcXcxnxWYWv26PNS2guHgtGUV1HlDKjg+B2zZNBBQjpHdL/U5XI5rkiQ==
X-Received: by 2002:a5d:4ace:0:b0:236:7988:b282 with SMTP id y14-20020a5d4ace000000b002367988b282mr1368719wrs.341.1668687830120;
        Thu, 17 Nov 2022 04:23:50 -0800 (PST)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id r4-20020a05600c35c400b003c6b874a0dfsm1315337wmq.14.2022.11.17.04.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 04:23:49 -0800 (PST)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        haniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/4] cpumask: improve on cpumask_local_spread() locality
In-Reply-To: <Y3PXw8Hqn+RCMg2J@yury-laptop>
References: <20221112190946.728270-1-yury.norov@gmail.com>
 <xhsmh7czwyvtj.mognet@vschneid.remote.csb> <Y3PXw8Hqn+RCMg2J@yury-laptop>
Date:   Thu, 17 Nov 2022 12:23:45 +0000
Message-ID: <xhsmho7t5ydke.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 15/11/22 10:32, Yury Norov wrote:
> On Tue, Nov 15, 2022 at 05:24:56PM +0000, Valentin Schneider wrote:
>>
>> Is this meant as a replacement for [1]?
>
> No. Your series adds an iterator, and in my experience the code that
> uses iterators of that sort is almost always better and easier to
> understand than cpumask_nth() or cpumask_next()-like users.
>
> My series has the only advantage that it allows keep existing codebase
> untouched.
>

Right

>> I like that this is changing an existing interface so that all current
>> users directly benefit from the change. Now, about half of the users of
>> cpumask_local_spread() use it in a loop with incremental @i parameter,
>> which makes the repeated bsearch a bit of a shame, but then I'm tempted to
>> say the first point makes it worth it.
>>
>> [1]: https://lore.kernel.org/all/20221028164959.1367250-1-vschneid@redhat.com/
>
> In terms of very common case of sequential invocation of local_spread()
> for cpus from 0 to nr_cpu_ids, the complexity of my approach is n * log n,
> and your approach is amortized O(n), which is better. Not a big deal _now_,
> as you mentioned in the other email. But we never know how things will
> evolve, right?
>
> So, I would take both and maybe in comment to cpumask_local_spread()
> mention that there's a better alternative for those who call the
> function for all CPUs incrementally.
>

Ack, sounds good.

> Thanks,
> Yury

