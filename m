Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 741FAC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 07:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 566F460E8C
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 07:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240473AbhJ0Hd6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 03:33:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42906 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240459AbhJ0Hd4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 03:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635319890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pdBGyNQbCwNdMaZgeJvgtH6mfy3H0eefALA7ZhIsoCE=;
        b=bsO+zE5+WB5eknH4Fl/gE8dWtz+c87+KyYxJYXYsVrHAMf8L8Nejr6nceZ/JiPBS+yPlK7
        +xksSgZ+33lVH8VI2RUf3t3xmJx/qXAlU1nSsWD2FikXa4lsbwE4dOHYhw9qD0ECYi6lWF
        rv/6NrOXGNhVMJpUdDFT6CEtE4MaxNc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-Z3sZp9e9O9Gcb9RnhpLcRQ-1; Wed, 27 Oct 2021 03:31:28 -0400
X-MC-Unique: Z3sZp9e9O9Gcb9RnhpLcRQ-1
Received: by mail-wr1-f70.google.com with SMTP id j12-20020adf910c000000b0015e4260febdso320229wrj.20
        for <linux-crypto@vger.kernel.org>; Wed, 27 Oct 2021 00:31:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pdBGyNQbCwNdMaZgeJvgtH6mfy3H0eefALA7ZhIsoCE=;
        b=bDIhD9TcHPXED3Kf3AG33YOboii0v7QqGyn/YeialwS8ktISnW5+SGT8rQPdp7ymFj
         ouTZY1C0QGuURWt6x7qnRDl5vkJgM3fJImNr0ZYvwYO9mX/74pUNYyIYg0HvE37FlVTP
         4zfWGADxuSDlF4qawS1pfl/b7Qo3rzLxJZdU4yk/sChiq3KvRT0nVzqYi/j9edbxJub/
         p2JpLEiNFJlGphxvQRQSlEHKXJjQB+6Zn5EHJmomaY/9IoPo46/D3IzrQb3yHWkyEr2i
         SKf4P5R/S5LttKtD7xBdFxmZBbI3cXwQouNag+ZfUHy2JxifRDB2OYkVUF9qwO2lO0KO
         r0FQ==
X-Gm-Message-State: AOAM530f7Pi890+CKBOPrlpQvcmbOZpRenmh5/X6XDLxwXW27MXX7yg0
        M+/Dl8TQ2bPa9IKZCwYhvOxBlykwQpgCT7WH1/B/G0L2z/EhGtKhRqWCINiT/m04ASUBNynrQZS
        aZrseaDOwPDPKbg9e+PF5CUR3
X-Received: by 2002:adf:eece:: with SMTP id a14mr35038654wrp.79.1635319887715;
        Wed, 27 Oct 2021 00:31:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzS6rp75ohuHcjXYmJO4wHdGcRrVVHMk7HPNSlP20KM7B3pHs1PLcpTB3vinC7J54MB+lNmA==
X-Received: by 2002:adf:eece:: with SMTP id a14mr35038629wrp.79.1635319887509;
        Wed, 27 Oct 2021 00:31:27 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.14.190])
        by smtp.gmail.com with ESMTPSA id z135sm3051719wmc.45.2021.10.27.00.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 00:31:27 -0700 (PDT)
Message-ID: <57f9eace-c721-1c33-e080-135df4087606@redhat.com>
Date:   Wed, 27 Oct 2021 09:31:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in copy_data
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au, jiri@nvidia.com,
        kuba@kernel.org, leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000a4cd2105cf441e76@google.com>
 <b6d96f08-78df-cf34-5e58-572b3fd4b566@gmail.com>
 <6c7e48b9-5204-352f-18e7-26b13d70f966@redhat.com>
 <20211027031847-mutt-send-email-mst@kernel.org>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <20211027031847-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 27/10/2021 09:20, Michael S. Tsirkin wrote:
> On Wed, Oct 27, 2021 at 09:08:04AM +0200, Laurent Vivier wrote:
>> On 27/10/2021 00:34, Eric Dumazet wrote:
>>>
>>>
>>> On 10/26/21 9:39 AM, syzbot wrote:
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    9ae1fbdeabd3 Add linux-next specific files for 20211025
>>>> git tree:       linux-next
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=1331363cb00000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=aeb17e42bc109064
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=b86736b5935e0d25b446
>>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116ce954b00000
>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132fcf62b00000
>>>>
>>>> The issue was bisected to:
>>>>
>>>> commit 22849b5ea5952d853547cc5e0651f34a246b2a4f
>>>> Author: Leon Romanovsky <leonro@nvidia.com>
>>>> Date:   Thu Oct 21 14:16:14 2021 +0000
>>>>
>>>>       devlink: Remove not-executed trap policer notifications
>>>
>>> More likely this came with
>>>
>>> caaf2874ba27b92bca6f0298bf88bad94067ec37 hwrng: virtio - don't waste entropy
>>>
>>
>> I'm going to have a look.
>>
>> Thanks,
>> Laurent
> 
> How bad is it if we just drop this and waste some bytes of entropy?
> 

I don't think it's bad at all. In most of the cases we should use the full buffer.

So, you can drop, I will re-submit them later with a fix.

Thanks,
Laurent

