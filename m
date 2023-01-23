Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF7EC25B50
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Jan 2023 09:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbjAWJ6v (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Jan 2023 04:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbjAWJ6k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2023 04:58:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058614C0A
        for <linux-crypto@vger.kernel.org>; Mon, 23 Jan 2023 01:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674467872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fp28RUK0xFhE/7bBO5cA+KdBINu5fWDxIv0BbY/vqSI=;
        b=CQiGCBmaedoUBGYUulvPApXX+j69etQVNy5Q/V5wdGIyGEob+eR195HEaoanEMbrKZkNRo
        /feEE0/kHTS8XK8Cd18bWbyuzhNqlVKI8xpsi1PeXKiKl2AddJtYXO6YKQdo75gncyNGK+
        iuuPAPkdZba4x3DB7oA7kxxuGpx1XVQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-269-XrlSrx6tMBmdBr7fFkjwlQ-1; Mon, 23 Jan 2023 04:57:50 -0500
X-MC-Unique: XrlSrx6tMBmdBr7fFkjwlQ-1
Received: by mail-qt1-f200.google.com with SMTP id bp43-20020a05622a1bab00b003b63be6827dso4287767qtb.23
        for <linux-crypto@vger.kernel.org>; Mon, 23 Jan 2023 01:57:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fp28RUK0xFhE/7bBO5cA+KdBINu5fWDxIv0BbY/vqSI=;
        b=uiDLNX8tcvKWVBJ67AQBCkPg5Tu/6NxsSu4powzROkpBImR2VTbGQj4XS+t0k3atz3
         pfNU4PXWX8LGjuOCYh170Nsx3ztgx46FKhDOuVxLyBX/B395w+HN/mOE7qs85mER9fsI
         CrSpGYt5fbCYuqqRVyMYj3dNSLOOkuwy8LYPV8uhgH/cfngRBjetBAo2DZQW37BABYbI
         jy5iaMSTi0jsF2NNJIywxhpIjX+x0YE8zLabbTIRJ0UVcp3IPvCHBcj1Z9HO+9Bio5Tj
         QV2aR99X4RP6KomQ4hdDvx2JtxePio+JrTkIuUmZVytxxs08oGWpq0vzgBK3NmKjBIAp
         qZwA==
X-Gm-Message-State: AFqh2kqv/4WOPN0/7c3jYtxkWjp3VwNDHLwxN3WHaywPfyjmT+nUk8M7
        HOSMamGDeKYJ7Ft3Y5p5qdqv5TEjY0G495tG8pyAU/1Zk5CTpKX56L0fVu8C71sW2UkSGvgNyvD
        ba//Kx45PJ/WksMHUsTqvJaQ6
X-Received: by 2002:ac8:7312:0:b0:3ab:7bb3:4707 with SMTP id x18-20020ac87312000000b003ab7bb34707mr30347688qto.64.1674467869594;
        Mon, 23 Jan 2023 01:57:49 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsDz4IWmjCsAs0UGbUioIk0MXga0k2KGKS9Tagt1MmSL1NfufKTZiRd8nkPQ0lsXafcagQtmA==
X-Received: by 2002:ac8:7312:0:b0:3ab:7bb3:4707 with SMTP id x18-20020ac87312000000b003ab7bb34707mr30347657qto.64.1674467869404;
        Mon, 23 Jan 2023 01:57:49 -0800 (PST)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id bz25-20020a05622a1e9900b003a591194221sm9405436qtb.7.2023.01.23.01.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 01:57:48 -0800 (PST)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Yury Norov <yury.norov@gmail.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haniel Bristot de Oliveira <bristot@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Peter Lafreniere <peter@n8pjl.ca>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Luck <tony.luck@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH RESEND 0/9] sched: cpumask: improve on
 cpumask_local_spread() locality
In-Reply-To: <4dc2a367-d3b1-e73e-5f42-166e9cf84bac@gmail.com>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
 <4dc2a367-d3b1-e73e-5f42-166e9cf84bac@gmail.com>
Date:   Mon, 23 Jan 2023 09:57:43 +0000
Message-ID: <xhsmhv8kxh8tk.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22/01/23 14:57, Tariq Toukan wrote:
> On 21/01/2023 6:24, Yury Norov wrote:
>>
>> This series was supposed to be included in v6.2, but that didn't happen. It
>> spent enough in -next without any issues, so I hope we'll finally see it
>> in v6.3.
>>
>> I believe, the best way would be moving it with scheduler patches, but I'm
>> OK to try again with bitmap branch as well.
>
> Now that Yury dropped several controversial bitmap patches form the PR,
> the rest are mostly in sched, or new API that's used by sched.
>
> Valentin, what do you think? Can you take it to your sched branch?
>

I would if I had one :-)

Peter/Ingo, any objections to stashing this in tip/sched/core?

