Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91233EB64D9
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jun 2023 22:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjFSWJj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jun 2023 18:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjFSWJi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2023 18:09:38 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C1A134
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jun 2023 15:09:37 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7775dd6c7e1so389640539f.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jun 2023 15:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687212576; x=1689804576;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=18wIF3rKinLoRpSkehNKDsiNhig12DTTerhF0r5bB/A=;
        b=fbkU7lumJdzEtWcG3k1T6A+3ObbUrDPyWzM7k32J+X10yMydRMfYPC0JvdaxTO545k
         koeoPMqJ1HT3YDTue+JW23Yk8ys20ZZSg4EzaNmradbdMyZ3qO6zfX4WmZLWO4staHWK
         fcf4sBPeR9Y6OK8RKGxKTsojPz8vPYtrKB3ayVezFBaGFeGWcmrn+fgcE43gd0ggR7WF
         mVq4a8pTpgA3Mv1nLnO+guTdUirbi7scnJsLLtfmADYPh3zFo4rX1ApRCLG1pbnwAxMX
         oUN6H4HfB8b4pywrG0XShMyOcX/hFTO0rT37m8uq8HQTpUFEOvLRTi1EJom3+mkWgoP4
         O/UA==
X-Gm-Message-State: AC+VfDzFcTMf8UE2WUygfKbHwjkhN6Q8+UBHZjc7nF7cRKRnRSCrjD05
        cDa4Bm/iLoMd2lquEvWH3r9ShVTYGc5Uv7xmz1aHhBFeVLVU
X-Google-Smtp-Source: ACHHUZ47JiJ7D6zbVcTND2HYnJ/ijfBs9OfkopT5ILSUxZMfqmcxVgGVigX37KA31taxlGmZ9fCoz0oSgn1EnM5BowFoIAwwT2yh
MIME-Version: 1.0
X-Received: by 2002:a02:93a7:0:b0:426:29a2:9d24 with SMTP id
 z36-20020a0293a7000000b0042629a29d24mr3087319jah.2.1687212576774; Mon, 19 Jun
 2023 15:09:36 -0700 (PDT)
Date:   Mon, 19 Jun 2023 15:09:36 -0700
In-Reply-To: <1167416.1687211141@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004ca4ee05fe82cae7@google.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=178ba75b280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4a7d74e6a7c3211
dashboard link: https://syzkaller.appspot.com/bug?extid=88f4b1e6cf88da11f5cd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11352c83280000

Note: testing is done by a robot and is best-effort only.
