Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B61FC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 07:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78E9E610A5
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 07:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238290AbhJ0HKf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 03:10:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236891AbhJ0HKe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 03:10:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635318489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LpE+Ob5AjjJOTxjUmx4/xC9nQg/xV3VH4DZnf1t0as8=;
        b=L096aJS0/C+Mde8pbpomGB5reJHkTcWu1BI+Tv0FNK82RkQiTxsrexsOljdynhpls6w65X
        A8nQyv6/jxpYdjP8S78KGlOZ8tWjcEGL8r/ls8po81+akZs8MrKyyh9qvZAEagXlrnq+tZ
        xkO4OHlyakBLtLD0KUQ2JYaOsBna4TQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-nNq2qWk_Nm-Z1RYvbPgBIA-1; Wed, 27 Oct 2021 03:08:07 -0400
X-MC-Unique: nNq2qWk_Nm-Z1RYvbPgBIA-1
Received: by mail-wm1-f72.google.com with SMTP id m1-20020a1ca301000000b003231d5b3c4cso1770094wme.5
        for <linux-crypto@vger.kernel.org>; Wed, 27 Oct 2021 00:08:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LpE+Ob5AjjJOTxjUmx4/xC9nQg/xV3VH4DZnf1t0as8=;
        b=XJh/SsJSF1hDm8BJvkkz62+XFZ1JoEXKzEj7x453memC2hhRlhEq3FxtHyRzW4uCd+
         mHCl9RbpDOKc7KLEp/cZhfaCmVIs+i1ucQk96Aa+rH9mpWF7SydHvSJtlzgEyCP1NUec
         QbN8FM96zbwUpG97aJEBIEhSfWYyuWoNTDaigHcqq2G3NWU07lQCAbwduZCscVbr3fg2
         3E+NADQ/HFf6wUrN62f1/L2aqKiNbqYARjfKTIn9rlgVKlwqvhVT9uWJMo/8lWhlhkZe
         ibn26YDaVoBi0dRmgho394d0wC+u32+8iJitPPTzvW107tEtLvnd5+XQucgMUD5n5wi9
         XchQ==
X-Gm-Message-State: AOAM533sGfn5/EV4SgBPKlGCgV7+olaLTlFJAEverwrT971DXQOxa4ax
        Cip3NoZzdMgzZYT9bJ1U7U5UVvZ8IpDzvEUJPSErIy/Parnuyj3lBxUvOBg7sjU0uzCEiUc7jtq
        zxdDh7fjGXVp0PxALT7pY4XBC
X-Received: by 2002:a5d:494d:: with SMTP id r13mr38285146wrs.222.1635318486497;
        Wed, 27 Oct 2021 00:08:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzf37l5gdvKcKdjqCrZo/kpOfCDswUMNaEnj2mAOufEC32VQVVHsjAg4MKPQSIlTnjZWd1EGQ==
X-Received: by 2002:a5d:494d:: with SMTP id r13mr38285112wrs.222.1635318486297;
        Wed, 27 Oct 2021 00:08:06 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.14.190])
        by smtp.gmail.com with ESMTPSA id e17sm7721173wrx.18.2021.10.27.00.08.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 00:08:05 -0700 (PDT)
Message-ID: <6c7e48b9-5204-352f-18e7-26b13d70f966@redhat.com>
Date:   Wed, 27 Oct 2021 09:08:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in copy_data
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au, jiri@nvidia.com,
        kuba@kernel.org, leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mpm@selenic.com, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000a4cd2105cf441e76@google.com>
 <b6d96f08-78df-cf34-5e58-572b3fd4b566@gmail.com>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <b6d96f08-78df-cf34-5e58-572b3fd4b566@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 27/10/2021 00:34, Eric Dumazet wrote:
> 
> 
> On 10/26/21 9:39 AM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    9ae1fbdeabd3 Add linux-next specific files for 20211025
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1331363cb00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=aeb17e42bc109064
>> dashboard link: https://syzkaller.appspot.com/bug?extid=b86736b5935e0d25b446
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116ce954b00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132fcf62b00000
>>
>> The issue was bisected to:
>>
>> commit 22849b5ea5952d853547cc5e0651f34a246b2a4f
>> Author: Leon Romanovsky <leonro@nvidia.com>
>> Date:   Thu Oct 21 14:16:14 2021 +0000
>>
>>      devlink: Remove not-executed trap policer notifications
> 
> More likely this came with
> 
> caaf2874ba27b92bca6f0298bf88bad94067ec37 hwrng: virtio - don't waste entropy
> 

I'm going to have a look.

Thanks,
Laurent


