Return-Path: <SRS0=SVjD=ZH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469C5C432C3
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 17:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29B742072B
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 17:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfKORv0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Nov 2019 12:51:26 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:40904 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbfKORvZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Nov 2019 12:51:25 -0500
Received: by mail-io1-f72.google.com with SMTP id 125so7635157iou.7
        for <linux-crypto@vger.kernel.org>; Fri, 15 Nov 2019 09:51:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=pGJy5bV/ClMY0bQDidFNUwMMkISrO4lRL5Ugf+Rz2YY=;
        b=S8yo4JZCgJR4fQqEnsT0ajJXDbRuB9ASMbCebWOu3+1RbMWeuVZHKus/BJ4ATyDr00
         DH9WItNktk9CHMfYj/kskvdaF/aiCGL/sBy1UfBHJyc6pa/Hye9Tpprlo9VsXsfkN+p0
         HdfJ/Gielt5d/7uBQkpoks+JXrVm+NQaPIF+L7O95dwks5ZrQLbVqbwS/g97EAb/NGvV
         y31+ZV4jZ1i08oIZ2+x4fhjIlvIBdiG/JuDjNqptohMNpAdR2DiTnDfuvWhkRgXdz2Gr
         t32sOS+daJLU3PV/J2Er03q1HM/HxIF/eAS/dI+2CgiISkx2btx5UROtNyZIdDGKhWnk
         K4YA==
X-Gm-Message-State: APjAAAWt+tKsQZhGrK7rA6qrg99jbUN81EvQx4fCjIUyn913CN1+vWxO
        PnqNSCrTVs344P3ObT5OKblBGqJLSzilHCejhtFY88ex9A6q
X-Google-Smtp-Source: APXvYqxIKKi0/wnIl2ukMipzPOcGhT1Mj43uGPGEnX0b3CFttSEg5G8lFDDVS8HLZr0z0KhEQPp+P5k74GJmu4km2VyfzOyuGwXP
MIME-Version: 1.0
X-Received: by 2002:a5d:8555:: with SMTP id b21mr1949271ios.22.1573840284098;
 Fri, 15 Nov 2019 09:51:24 -0800 (PST)
Date:   Fri, 15 Nov 2019 09:51:24 -0800
In-Reply-To: <5dcee59a.1c69fb81.188d.e4b9@mx.google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001129840597663fa0@google.com>
Subject: Re: Re: INFO: task hung in chaoskey_disconnect
From:   syzbot <syzbot+f41c4f7c6d8b0b778780@syzkaller.appspotmail.com>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     alexandre.belloni@bootlin.com, andreyknvl@google.com,
        arnd@arndb.de, b.zolnierkie@samsung.com,
        gregkh@linuxfoundation.org, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, lvivier@redhat.com, mchehab@kernel.org,
        mpm@selenic.com, swboyd@chromium.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> Quoting syzbot (2019-11-06 04:32:09)
>> Hello,

>> syzbot found the following crash on:

>> HEAD commit:    b1aa9d83 usb: raw: add raw-gadget interface
>> git tree:       https://github.com/google/kasan.git usb-fuzzer
>> console output: https://syzkaller.appspot.com/x/log.txt?x=16ae2adce00000
>> kernel config:   
>> https://syzkaller.appspot.com/x/.config?x=79de80330003b5f7
>> dashboard link:  
>> https://syzkaller.appspot.com/bug?extid=f41c4f7c6d8b0b778780
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:       
>> https://syzkaller.appspot.com/x/repro.syz?x=10248158e00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16afbf7ce00000

>> IMPORTANT: if you fix the bug, please add the following tag to the  
>> commit:
>> Reported-by: syzbot+f41c4f7c6d8b0b778780@syzkaller.appspotmail.com

> I suspect this is because of the kthread getting stuck problem reported
> by Maciej. Maybe try the commit that Herbert picked up.

> #syz test:  
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

Bugs found by USB fuzzer can only be tested on  
https://github.com/google/kasan.git tree,
usb-fuzzer branch because USB fuzzer is not upstreamed yet.
See https://goo.gl/tpsmEJ#usb-fuzzer for details.


