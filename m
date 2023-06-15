Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61ABEB64D9
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jun 2023 21:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjFOVCb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jun 2023 17:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjFOVCa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2023 17:02:30 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213C12945
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jun 2023 14:02:26 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7773997237cso865630039f.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jun 2023 14:02:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686862945; x=1689454945;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n4hXMNSzNgX9qcNCtjmUZbMdzYOaYR79wSe3L4m7Iq0=;
        b=U1Wpfdqz4C6oCgJKufzc6W7+lFJ1CFNyfzqS2x8npOjy23ihTkoI83J2oKAw90F31E
         UptG2U3/AtcbA+eJlIy/FNdk8GVW3W0lbpG5VPLNyWoVsgBQ2LG+3Yam+xBNjdVvjo5F
         ig3VVsUmRM9XHXGxb+t+D42ci4SDaERl7fZVPcguHFWt1n0oU+ipKcPyxNdOHzBTX0VZ
         t7AgFVCgR6BDPGaQOjs76+shffbBJHIJa9CFRlEgbIOpJm2I0B6xzYTXsWCBhVZX7hb2
         2MFHnrUWneVCzKdETmx3JJl8qua2yvzwVCpnPL5Wb29sBmaEiqDitsVO/zptLHqCvpaP
         fTbA==
X-Gm-Message-State: AC+VfDx5HoDwmYmAA9Eut9vBYt4OqcXmNQM77el8S/nl6S35FTUpu6kg
        qhER4UE//GVGPCHjioY20LC9hDhFpSQqSCgxvzXThufnhbpO
X-Google-Smtp-Source: ACHHUZ6USDC6PDWcEo+gfpDJs9g2SM4qwmGn+hEQt8nQOfRMl2i2RpbGbn/LJN2jsjD6+hkn/9TTEE0EoYZWM6rU7UkLMOgtbQUB
MIME-Version: 1.0
X-Received: by 2002:a02:a18f:0:b0:420:d53f:2821 with SMTP id
 n15-20020a02a18f000000b00420d53f2821mr90094jah.5.1686862945444; Thu, 15 Jun
 2023 14:02:25 -0700 (PDT)
Date:   Thu, 15 Jun 2023 14:02:25 -0700
In-Reply-To: <262282.1686860686@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a5e86b05fe316253@google.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=13705753280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=6efc50cc1f8d718d6cb7
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10d19cbb280000

Note: testing is done by a robot and is best-effort only.
