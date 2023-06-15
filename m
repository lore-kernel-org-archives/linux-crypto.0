Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41904EB64D9
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jun 2023 16:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjFOQ3e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jun 2023 12:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjFOQ3d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2023 12:29:33 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60DB2943
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jun 2023 09:29:32 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-77ad8444d82so884945239f.3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jun 2023 09:29:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686846572; x=1689438572;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rFlp6dTsaA6DhlunBCFuGZl4rO+rbbI1YI66BI+ayy0=;
        b=H8Yvu7JMPnTBV57F2gUS2Z9XTAMhGmQ7LJj76dTBGPzco/Cfws6rwGiAkcy/l3M6ek
         btiNdwgxtkYRjauIvhFbY12v8vK4rh0DT1rhJrXRbluY1kHGfkhrCmvqx9fEsRTeIPyG
         BRZ3Nimtl9VvbJDj8Qzvl/l27wCzJrEUWIrCZ0rf3596wllVfkWOuKB2mMMu25FKU8Sx
         sMA4Y6ABsx1x9XS3T3o95TUFc0bIiqXB6OBulMPdhjvWSHyqvMH4wz4OYkV4lnUufBCm
         ElZX5AHmGiC3OYdjOT5iCgvDpVVhixwsFTUZRBkxEXxeuAyeeNc5xK6u0RrzBUbpjfzH
         3V/g==
X-Gm-Message-State: AC+VfDwZbImkmlEFximN4cN+LWGIDnDWGBHB+l4874Q3OIHBQa3NCbpl
        uYXky0tqybUlfE+68xWI1nGb+SFTyED+LeU11cZz+eC5O7an
X-Google-Smtp-Source: ACHHUZ6BC1oLFaizK+dPrbWHixBXw11XLiRKPCBpLu1/NFHfMT6V5NocQP4Kg1nqUcfAa7Xz2d73qx3Bzsyo96gJOv+WQdcRn/nP
MIME-Version: 1.0
X-Received: by 2002:a02:7318:0:b0:423:19cd:69b8 with SMTP id
 y24-20020a027318000000b0042319cd69b8mr510226jab.0.1686846572347; Thu, 15 Jun
 2023 09:29:32 -0700 (PDT)
Date:   Thu, 15 Jun 2023 09:29:32 -0700
In-Reply-To: <256755.1686844894@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc6a1705fe2d92c1@google.com>
Subject: Re: [syzbot] [crypto?] KASAN: slab-out-of-bounds Read in extract_iter_to_sg
From:   syzbot <syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com

Tested on:

commit:         97c5209b leds: trigger: netdev: uninitialized variable..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=1258baf7280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=6efc50cc1f8d718d6cb7
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12c65e17280000

Note: testing is done by a robot and is best-effort only.
