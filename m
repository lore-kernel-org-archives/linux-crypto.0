Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012B3EB64D8
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jun 2023 16:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjFNQN0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Jun 2023 12:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjFNQNZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jun 2023 12:13:25 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B321FE2
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 09:13:24 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-77a1d6d2f7fso834965539f.2
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 09:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686759204; x=1689351204;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zeyhKQmQJgmGwX9czunjxyhPF6/Uyh0HJoA+1LIdqE8=;
        b=TRV+5gd5AK0dIAaaJ9JI/M4cAdKsjveO7hFMskYQvBsoozfs/zPUSw33m/KF9IHx3W
         EyobSpW+rpdLRppdBZiaCiDgBP9USpTgV0lH99jC972q5wU4OzLlPisVHwI+MlgF1fHc
         AUbTwczZeFFbcaLzoq4t3TO//7sQBcB80S3ZBJwZD6Hw6iuXhPOaaGTUv2Aew9ixdaRi
         EhNqyLg0aFuxRJVlv8EeOKTKqixqBjkDVc9Lwljyc6oMTt6hOA50Hryrga2BAki7TNX3
         ZdqS/JUIIzue91+TtOwfHEquSoA9LJvewviez0HddGLVFk+Rl/1+MHkPKxJj7a28kxx5
         IBkQ==
X-Gm-Message-State: AC+VfDywiJcDCS49M7mJ0mE3KKMTuPikjE1RW0+jJC1AS7EcEunwYmMB
        D3fgaQZGurSoz4r5KLflbIxQ2uNYxw9dXTkKrWA0f4sysRp1
X-Google-Smtp-Source: ACHHUZ4r58bUvl9LoPAOXo+B6/ljIZcwyo9JK7UM90Yqibs/UTgX1tiUUXTcfd0jBjqB48XmrgyKXZl5c+T2EAc/pq3qX0C1IjMx
MIME-Version: 1.0
X-Received: by 2002:a5e:da05:0:b0:775:4f90:a4ce with SMTP id
 x5-20020a5eda05000000b007754f90a4cemr6194252ioj.0.1686759203788; Wed, 14 Jun
 2023 09:13:23 -0700 (PDT)
Date:   Wed, 14 Jun 2023 09:13:23 -0700
In-Reply-To: <1604533.1686754299@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029dd9c05fe193bf3@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in crypto_shash_final
From:   syzbot <syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com

Tested on:

commit:         fa0e21fa rtnetlink: extend RTEXT_FILTER_SKIP_STATS to ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=13b86427280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=14234ccf6d0ef629ec1a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15bf213b280000

Note: testing is done by a robot and is best-effort only.
