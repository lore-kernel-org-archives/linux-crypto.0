Return-Path: <SRS0=E3Xp=R2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E531C43381
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Mar 2019 00:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DCA7218E2
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Mar 2019 00:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfCWA4C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 20:56:02 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:34255 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727718AbfCWA4B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 20:56:01 -0400
Received: by mail-io1-f72.google.com with SMTP id y13so3178274iol.1
        for <linux-crypto@vger.kernel.org>; Fri, 22 Mar 2019 17:56:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=QVKXEHZlQ4zxgOh6DaFM9re+jwNmJJ3qdBUhbm76O0o=;
        b=M7Xux1PfWnD/g4zuRnHaBNWIMAJV1BZJLjc0NU2RPH8bksziLzi6GzUozRd6OHthSA
         ljsAFA7twq1g7xelIM7a1b97lvWGeB2J+bFuScJCIVcSM0Ca/bEZ6UCX4UE/mszSSEHO
         McnEZ/tTm8w/X910QO70yO3S4y/FP78kBtNQoIQq8B2Q9oDAhN0qMxAXikCTQfm9KjFe
         PakczNE19B5MllzB5jSfgbxDZEOJl2ZWhsJOz6821SIdqWCrfYuslohy08BtME0g+oqx
         RgnkCqmdPjTsWJ+41EzCDnR9eARGRRuwrwX6Nsxd+9jjMlgT1s0sx/7U6NJxrXNVYYsJ
         NSDg==
X-Gm-Message-State: APjAAAUlwxz0Y3xGY6jY3WBdgRK2PlpEOiUmGaukpNA2fI2YWsRiTz2e
        8LJ4HYIEW24MEANBauxGiBI/IhSdNDa1NSAsEN1iD0A+5BDI
X-Google-Smtp-Source: APXvYqwu20vReMFN7O9wsnXc/l1OP/dLP8tzqz+VV9gs3L+Hxn6GJpkSEEa2TqHeNRoaUFlJRNvX5E37J7FRdVKYUD9DqnMrJAY2
MIME-Version: 1.0
X-Received: by 2002:a24:791:: with SMTP id f139mr9274itf.73.1553302560862;
 Fri, 22 Mar 2019 17:56:00 -0700 (PDT)
Date:   Fri, 22 Mar 2019 17:56:00 -0700
In-Reply-To: <000000000000cab053057c2e5202@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005e7c340584b86f64@google.com>
Subject: Re: INFO: task hung in tls_sw_free_resources_tx
From:   syzbot <syzbot+503339bf3c9053b8a7fc@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, ilyal@mellanox.com,
        john.fastabend@gmail.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

syzbot has bisected this bug to:

commit 3c4d7559159bfe1e3b94df3a657b2cda3a34e218
Author: Dave Watson <davejwatson@fb.com>
Date:   Wed Jun 14 18:37:39 2017 +0000

     tls: kernel TLS support

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10c2d407200000
start commit:   6915bf3b net: phy: don't allow __set_phy_supported to add ..
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12c2d407200000
console output: https://syzkaller.appspot.com/x/log.txt?x=14c2d407200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28ecefa8a6e10719
dashboard link: https://syzkaller.appspot.com/bug?extid=503339bf3c9053b8a7fc
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e6996d400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117e2125400000

Reported-by: syzbot+503339bf3c9053b8a7fc@syzkaller.appspotmail.com
Fixes: 3c4d7559159b ("tls: kernel TLS support")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
