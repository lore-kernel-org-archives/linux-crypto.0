Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C8BC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 13:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D6D060F39
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 13:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbhJ0NNc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 09:13:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25572 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236464AbhJ0NNc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 09:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635340266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IWYKdmA4eUJEUsGe3mptr98qqwVK7XBGAcGwuVBZe7o=;
        b=bIZwgie8pg38MTj8LwgIn4ELW/pmrEV+FYAETTnjlUuO2CETjTfgITgXZdvw6tymktxWpV
        f3zBJ5Dzzu+cqOsNQntvzZM97osv5S4puN52J90erpp1xvU8WbfvFHfWGegVxSib/k5PKc
        Hy/ZkVni01Ryq4/b9WC+06VH2EzqXcY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-utusR5ivOnGEWfiF26YH8g-1; Wed, 27 Oct 2021 09:11:05 -0400
X-MC-Unique: utusR5ivOnGEWfiF26YH8g-1
Received: by mail-wm1-f69.google.com with SMTP id f20-20020a05600c155400b0030db7b29174so1176836wmg.2
        for <linux-crypto@vger.kernel.org>; Wed, 27 Oct 2021 06:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IWYKdmA4eUJEUsGe3mptr98qqwVK7XBGAcGwuVBZe7o=;
        b=nHPfbPX52TIMGhIgghWpCh2iBQfXMbxZ1euU6ESPnS4ddHGwNON3381s8XRUIIvojC
         dklrKI/u8b5pjDtplKsAqUu+4kpSDGLOBvJnqDtX0tMJSDbDeONMRNcNiMZVJtQ4zerF
         LbH1CzMjOKymDw2sfocd8PS+MjF2dHNHBCcEJ8PB8mOxmw6YbwwqJ0TkhfNapm3tqVBP
         shS5qRQlOepkkgKCwrqe3POQezdReuym+FcYqwSoWeizJfv4tw3UcNzmfYQKsBdxsxLY
         qhLTu/6qf4dFspKgAkk1DW2kG9uVrWZGDsNq4Zhu0bTjKB1plWnGlaeomGno85OImJxl
         mwYw==
X-Gm-Message-State: AOAM5318xyta/L0Ox2EyvZjQI4B3Z740po0ZMpV44lHPUUKC+s7STYAn
        ovLHhKfuPEJNcUuyTPHqQVSIb8Sn1vtnYUYKB2pgEHxSyQL3V51oK6XIhf7bkoM+o+wPwwgWpf9
        b34Y4HkUSSS/2/y3zRhWIdSrC
X-Received: by 2002:a05:6000:18af:: with SMTP id b15mr38755696wri.359.1635340264015;
        Wed, 27 Oct 2021 06:11:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzjUjZddIUlCrumNutOY9tavd1hZf4C85p9ozzn0zyY1ymdGYMDfidxui06HqTzb2IhpmXTA==
X-Received: by 2002:a05:6000:18af:: with SMTP id b15mr38755662wri.359.1635340263764;
        Wed, 27 Oct 2021 06:11:03 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.14.190])
        by smtp.gmail.com with ESMTPSA id o26sm3436083wmc.17.2021.10.27.06.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 06:11:03 -0700 (PDT)
Message-ID: <eab57f0e-d3c6-7619-97cc-9bc3a7a07219@redhat.com>
Date:   Wed, 27 Oct 2021 15:11:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in copy_data
Content-Language: en-US
To:     syzbot <syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au, jiri@nvidia.com,
        kuba@kernel.org, leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mpm@selenic.com, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000a4cd2105cf441e76@google.com>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <000000000000a4cd2105cf441e76@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 26/10/2021 18:39, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9ae1fbdeabd3 Add linux-next specific files for 20211025
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1331363cb00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=aeb17e42bc109064
> dashboard link: https://syzkaller.appspot.com/bug?extid=b86736b5935e0d25b446
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116ce954b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132fcf62b00000
> 
> The issue was bisected to:
> 
> commit 22849b5ea5952d853547cc5e0651f34a246b2a4f
> Author: Leon Romanovsky <leonro@nvidia.com>
> Date:   Thu Oct 21 14:16:14 2021 +0000
> 
>      devlink: Remove not-executed trap policer notifications
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137d8bfcb00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10fd8bfcb00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=177d8bfcb00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com
> Fixes: 22849b5ea595 ("devlink: Remove not-executed trap policer notifications")
> 
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in memcpy include/linux/fortify-string.h:225 [inline]
> BUG: KASAN: slab-out-of-bounds in copy_data+0xf3/0x2e0 drivers/char/hw_random/virtio-rng.c:68
> Read of size 64 at addr ffff88801a7a1580 by task syz-executor989/6542
> 

I'm not able to reproduce the problem with next-20211026 and the C reproducer.

And reviewing the code in copy_data() I don't see any issue.

Is it possible to know what it the VM configuration used to test it?

Thanks,
Laurent

