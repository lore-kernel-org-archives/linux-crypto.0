Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AC7C636CC
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Feb 2023 10:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjBGKad (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Feb 2023 05:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjBGKa3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Feb 2023 05:30:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8A323108
        for <linux-crypto@vger.kernel.org>; Tue,  7 Feb 2023 02:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675765759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XeNNXdPHcFQFjrDCbOR/TvrpskWkdGBwv23ZwvAwhAQ=;
        b=UO1XhJhXp+IJnTNYshZK7vZUjvRg8lX5ss+Vj6mhVrFdSndq7ai4ZcnnsiI8HuZ4pCpSHy
        +tXdM3RwIqatATEs7sx2Knd78dY/Q58q6UGr+xrs1L0LHAaOC6rbXGHZmpUGwvNwXavP3a
        OdVE18GWpHVPbI/k5L9une1bM4jIUMM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-656-zn3UNTYePiiTmY3rwErMqA-1; Tue, 07 Feb 2023 05:29:18 -0500
X-MC-Unique: zn3UNTYePiiTmY3rwErMqA-1
Received: by mail-qt1-f197.google.com with SMTP id v8-20020a05622a144800b003ba0dc5d798so6149147qtx.22
        for <linux-crypto@vger.kernel.org>; Tue, 07 Feb 2023 02:29:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XeNNXdPHcFQFjrDCbOR/TvrpskWkdGBwv23ZwvAwhAQ=;
        b=yEIN2G8qxsXvzxA6UgisFDg4ldszon5E4GCtluQnccKDBpy4hxgo+g9R8LxtJDHGIt
         wvc9XlVwBi7iaXCDKyMp/S3SZKZV3kuXkZed2b4XRfOlYzkoWkALrLhFljkapZMlvOBV
         gjMTW2QY+t4OIjKJJV470J49Tgz50QNQWqSNJ8KX+6v9mLtjBzYy6cTYt8B0s+YFmnkK
         0cRin8JLZVPoypJHGZpd+AY39S6iSKgBlpv7eGafREzgULafVH+8eA53fJ7cZEiV390M
         skhcAlMWGgDp8QZh4Pp3SkCYP1A1s30Y5N0qeR1WxHsUIPWbNvEQA1kz1broLVIkmmx7
         er9w==
X-Gm-Message-State: AO0yUKVY/GOILwuFOBWAnr81qmxE/t2753Lg6qiyUokrjjXIMNDPYXlg
        WESiohhI5U20+zYC/InOSwt+MVxcQ/EPCJCICcF1X7cLPyd4oe1LelHXFyJUUC/scqFLYXWmPxy
        qiKOB2cOLTCF6GTqAOkj7bBo/
X-Received: by 2002:a05:6214:628:b0:568:d153:823a with SMTP id a8-20020a056214062800b00568d153823amr3751787qvx.15.1675765757654;
        Tue, 07 Feb 2023 02:29:17 -0800 (PST)
X-Google-Smtp-Source: AK7set9BUnmZ40Hqit30IPBlDyN9DB7QZjcW+HxvsM96EkuqWD4++1pq7itmtw1eDdcYnxruJSbEJA==
X-Received: by 2002:a05:6214:628:b0:568:d153:823a with SMTP id a8-20020a056214062800b00568d153823amr3751745qvx.15.1675765757393;
        Tue, 07 Feb 2023 02:29:17 -0800 (PST)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id r6-20020a05620a03c600b00702d1c6e7bbsm8958153qkm.130.2023.02.07.02.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 02:29:16 -0800 (PST)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
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
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH 3/9] sched: add sched_numa_find_nth_cpu()
In-Reply-To: <20230206210943.79e01af9@kernel.org>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
 <20230121042436.2661843-4-yury.norov@gmail.com>
 <20230206210943.79e01af9@kernel.org>
Date:   Tue, 07 Feb 2023 10:29:12 +0000
Message-ID: <xhsmh4jrxsr9j.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 06/02/23 21:09, Jakub Kicinski wrote:
> On Fri, 20 Jan 2023 20:24:30 -0800 Yury Norov wrote:
>> The function finds Nth set CPU in a given cpumask starting from a given
>> node.
>>
>> Leveraging the fact that each hop in sched_domains_numa_masks includes the
>> same or greater number of CPUs than the previous one, we can use binary
>> search on hops instead of linear walk, which makes the overall complexity
>> of O(log n) in terms of number of cpumask_weight() calls.
>
> Valentin, would you be willing to give us a SoB or Review tag for
> this one?  We'd like to take the whole series via networking, if
> that's okay.

Sure, feel free to add

  Reviewed-by: Valentin Schneider <vschneid@redhat.com>

to patches that don't already have it.

