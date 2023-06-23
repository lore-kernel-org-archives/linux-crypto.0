Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5BCEB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jun 2023 15:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbjFWP3Z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Jun 2023 11:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbjFWP3Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2023 11:29:24 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947871BD0
        for <linux-crypto@vger.kernel.org>; Fri, 23 Jun 2023 08:29:22 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-340bdf36dcdso5478835ab.0
        for <linux-crypto@vger.kernel.org>; Fri, 23 Jun 2023 08:29:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687534162; x=1690126162;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zBrsp/L8LBbY13kpCjVb8ARrn73n9NBhpEUWG/fTsCo=;
        b=V1HGN6NJT2ENt2IjV2elHMn/Bq1+faNw1UJeLPRPpdADcKmxv08B/T+H/YJ9Jl+9jj
         F/PKD2dSIOQzCJ20v8Ndhiq8olb+kjqzlQ+OYCITahqUhUkdZvFEUR8iaev3zeTHaUmb
         iiXJX/vE5dR3p9PM7LKhwt+2TtlwZiYsxb4FmQpJHoid9NQWs4pE660aaP7qzVeurymT
         MtxFJJW+dm24WSSNSw6jRO3g70Yp2CSxNA+Z0oLAEZDISWDcFRpwXg65pzyU0WtaX+xq
         WX49GQVOszsYxrqtGQEVhkc0WoPUBapWWOrY4b8ZqJUix/zZf3eK6CJssQozfzulU+a7
         nLiw==
X-Gm-Message-State: AC+VfDwqQ4xqhaBsnz0L0VMGJY2LEvw50LzXqB0Ch4z5IKhd/Ngorl2X
        GF4ddqG4TroSA1vNzY47MX92FpcitsAx2y7mhUyOIRcjUxAT
X-Google-Smtp-Source: ACHHUZ5s4AxZGy5IkdfIF5CHenFw6Jv1FrcGeoKc+TSkvorT6RmNJB+KZsAlt7cYmNfsYhwRWXrGY0pg01T/p+aODwSow+udbhCe
MIME-Version: 1.0
X-Received: by 2002:a92:cd41:0:b0:341:d428:7bcd with SMTP id
 v1-20020a92cd41000000b00341d4287bcdmr8114863ilq.1.1687534161912; Fri, 23 Jun
 2023 08:29:21 -0700 (PDT)
Date:   Fri, 23 Jun 2023 08:29:21 -0700
In-Reply-To: <2370718.1687532181@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000446b0805fecdaaf4@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in shash_async_update
From:   syzbot <syzbot+0bc501b7bf9e1bc09958@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+0bc501b7bf9e1bc09958@syzkaller.appspotmail.com

Tested on:

commit:         faaa5fd3 dt-bindings: net: altr,tse: Fix error in "com..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=14f7e723280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a78c5a35ccd7ceb0
dashboard link: https://syzkaller.appspot.com/bug?extid=0bc501b7bf9e1bc09958
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
