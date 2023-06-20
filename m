Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD51DEB64D8
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jun 2023 08:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbjFTIJX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jun 2023 04:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbjFTIJW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2023 04:09:22 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B051B1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 01:09:19 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-77b25d256aaso417681039f.0
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 01:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687248558; x=1689840558;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kPOmXK+JJS4XSvlfMU0a0e+c0GK1JCtS0fKF/mMBn1s=;
        b=SRnowDs1hz8tykck+m+98Y9RrqfgJ+d+438pBJE54blavUekYzVCY2CjM3279q5vT5
         qikq6kW9MAHr8GmlcD65jdo1qrViOloZmMjavoEON7IZR2F9ed8mOTVZVTwEflMietKJ
         ZXomyAoBNPW55LEit/Uc00EtB0ARFUR82wfO8p+yFbTGtfxqx+DF1gixrdbrp1ZArUt8
         KHZGCsGgIjV7VeFuQjXq+zRot0AKjxkbxo4MrL+HPWFhdyOoZmpwKztUlb0LRYmWPr6p
         RI3fq2K0sA3ik+c19l94GmXzAu7eG8WFtpn1mhLA9IghR6lI/Vh8pqQ9733uQ57Lf8cN
         GTSw==
X-Gm-Message-State: AC+VfDyGrt81g44yyqaETcAULcOWEo9TDnTc/47/OKvLmft7AEOJmldm
        MA+Hkg8QM0Hsc5DEzjHPxBjdYpfiAXAfnrEPpA21/9WfhJma
X-Google-Smtp-Source: ACHHUZ47imoHu3Jlv7gSHJneCOAcUD5Sx26XyRsq93AybmIdKnUTNEssmEu5sY2CCI52QcBpBYoNLifZf2DdT28IgIIcEVk/2WfB
MIME-Version: 1.0
X-Received: by 2002:a5d:9e58:0:b0:766:6741:8856 with SMTP id
 i24-20020a5d9e58000000b0076667418856mr3886774ioi.4.1687248558828; Tue, 20 Jun
 2023 01:09:18 -0700 (PDT)
Date:   Tue, 20 Jun 2023 01:09:18 -0700
In-Reply-To: <1221049.1687246988@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ff364905fe8b2a25@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in shash_ahash_update
From:   syzbot <syzbot+88f4b1e6cf88da11f5cd@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+88f4b1e6cf88da11f5cd@syzkaller.appspotmail.com

Tested on:

commit:         49310624 Merge branch 'ipv6-random-cleanup-for-extensi..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=141473e3280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4a7d74e6a7c3211
dashboard link: https://syzkaller.appspot.com/bug?extid=88f4b1e6cf88da11f5cd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13365e5b280000

Note: testing is done by a robot and is best-effort only.
