Return-Path: <SRS0=52Dc=ZX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1FCC432C0
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 07:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3673020833
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 07:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfLAH6B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Dec 2019 02:58:01 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:39957 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfLAH6B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Dec 2019 02:58:01 -0500
Received: by mail-io1-f69.google.com with SMTP id d1so8140850ioe.7
        for <linux-crypto@vger.kernel.org>; Sat, 30 Nov 2019 23:58:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=VnR9yosaS+lY39eJX0ls3om/qYEVU2oks9FYgzUS5Rc=;
        b=DAYjbfgguu8fp3Jwwr2eKEEisJbDoP8+F1OC8xxd9CaT0UEhX+ODE9H+SouMbqbWMI
         IhGvBckOo5VmsuZyb1Myk/opKZD8+fHoKXfQJU7Eg+ntI7YHmfvzQ/J+RTQBO8K9o39v
         ipafYv3e/q5MXCUOY0WegFuXB/PIWmXdH6vRn26sGRc8ZrThCqZHfv/EaLhu1Vwzq+Wb
         J9Zj2kIEKdYbKwr5B2DcKOQh+/Re1i6SS2lwnyPiNSyF2MUmABGaPZwO7GhMb07dsJVp
         XdNi0W3ahMo5FM++s+T7NfEidYOYQVPFUpmEX/tTrA1SX7NAvXMg2VBHEQEYt7cyJBeQ
         k9nw==
X-Gm-Message-State: APjAAAULBXY+eXqykAHQ4SMhzVXN/5zJRQ1E2gtZrudWUqATjcKJpXxk
        XOAvqIZi688FIK++TMM1KNxc2+yXVCaK5xmBK6p26fDfw0Jq
X-Google-Smtp-Source: APXvYqywuenkguXBw8KNCZzGDJV9kQVYNSCYJOwcG7e6qPfDdYpHrz7xWKQHu6QoaKIitUWg/b7Z/dHbzYjBRqdKiNJ/tpnHCeBh
MIME-Version: 1.0
X-Received: by 2002:a92:d901:: with SMTP id s1mr23813418iln.86.1575187080666;
 Sat, 30 Nov 2019 23:58:00 -0800 (PST)
Date:   Sat, 30 Nov 2019 23:58:00 -0800
In-Reply-To: <001a1140b8307b0439055ffc7872@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000065e61505989fd2c3@google.com>
Subject: Re: INFO: task hung in aead_recvmsg
From:   syzbot 
        <syzbot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dvyukov@google.com, ebiggers3@gmail.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        peterz@infradead.org, smueller@chronox.de,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

syzbot has bisected this bug to:

commit 0c1e16cd1ec41987cc6671a2bff46ac958c41eb5
Author: Stephan Mueller <smueller@chronox.de>
Date:   Mon Dec 5 14:26:19 2016 +0000

     crypto: algif_aead - fix AEAD tag memory handling

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12d6d0a6e00000
start commit:   618d919c Merge tag 'libnvdimm-fixes-5.1-rc6' of git://git...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11d6d0a6e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16d6d0a6e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=856fc6d0fbbeede9
dashboard link:  
https://syzkaller.appspot.com/bug?extid=56c7151cad94eec37c521f0e47d2eee53f9361c4
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ef592d200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16b865fd200000

Reported-by:  
syzbot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com
Fixes: 0c1e16cd1ec4 ("crypto: algif_aead - fix AEAD tag memory handling")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
