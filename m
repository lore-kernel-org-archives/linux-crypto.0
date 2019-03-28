Return-Path: <SRS0=b5bf=R7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30CA2C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 17:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C82E206B6
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 17:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfC1RIB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Mar 2019 13:08:01 -0400
Received: from mail-it1-f199.google.com ([209.85.166.199]:55101 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfC1RIB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Mar 2019 13:08:01 -0400
Received: by mail-it1-f199.google.com with SMTP id l140so3804428ita.4
        for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2019 10:08:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=nsKviR5t4bkwiMD3XR/+AXw8AQHK1X1Lwd9zYfIP0KQ=;
        b=UOjmNryMLSsxELVQjsaxOeeOXYW+6qXywWcceIuU0U7j6xQoJ6lVrjj7xrfcO1aZdp
         tZPcYRpxO+TAVHUtWK2EeB7eSU8jiLo8ioJnlf4byV+4mdr9FPzJzOofgEFh5lnSR4Qz
         bwMpIqYIWtL4h6o5AYH4aDl4t8so8Ur+d73aq3P3lC7gTy4f+BmUEoeYEllH5wzg9pYU
         bUdahS56EP/geFyJBZDW0DqbccxZcQU6a1325UA5/0WqsWS4oMwG5mxGBHUBTKrtKBxV
         4mh1CcH0jDplGuiJqAFMWNADVd/D08RP+PKGoq5JQl/EVc7wN/hchSFVEYGY6mzVpJip
         e+CQ==
X-Gm-Message-State: APjAAAWuypkOL+kLboSE91QnhEvD9nV5VP0Md5IkQMV+gA1CsOsBUlbo
        hkvbMvL5IUHFntKDKPJZrsxgEmfqXoARCq0iDKMDbtzRHbBG
X-Google-Smtp-Source: APXvYqxOe/Gq/iAWJ0JCUQX3iMclT7FD1f2YYet2gyiwVQP7XJzIEgsYSFNQuAsV2heohdLGUxGAO2Xy3XyFv9VcRbEBG4WFwEKh
MIME-Version: 1.0
X-Received: by 2002:a24:28d:: with SMTP id 135mr332348itu.16.1553792880757;
 Thu, 28 Mar 2019 10:08:00 -0700 (PDT)
Date:   Thu, 28 Mar 2019 10:08:00 -0700
In-Reply-To: <000000000000d014010576cc00f4@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b6565e05852a9811@google.com>
Subject: Re: KASAN: use-after-free Read in generic_gcmaes_encrypt
From:   syzbot <syzbot+6d3612ba5e254e387153@syzkaller.appspotmail.com>
To:     ard.biesheuvel@linaro.org, aviadye@mellanox.com,
        borisp@mellanox.com, bp@alien8.de, davejwatson@fb.com,
        davem@davemloft.net, herbert@gondor.apana.org.au, hpa@zytor.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vakul.garg@nxp.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

syzbot has bisected this bug to:

commit a42055e8d2c30d4decfc13ce943d09c7b9dad221
Author: Vakul Garg <vakul.garg@nxp.com>
Date:   Fri Sep 21 04:16:13 2018 +0000

     net/tls: Add support for async encryption of records for performance

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e6797d200000
start commit:   5694cecd Merge tag 'arm64-upstream' of git://git.kernel.or..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17e6797d200000
console output: https://syzkaller.appspot.com/x/log.txt?x=13e6797d200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=91a256823ef17263
dashboard link: https://syzkaller.appspot.com/bug?extid=6d3612ba5e254e387153
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110db3c7400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=113fa5ed400000

Reported-by: syzbot+6d3612ba5e254e387153@syzkaller.appspotmail.com
Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records  
for performance")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
