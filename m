Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D53EB64D8
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jun 2023 15:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241048AbjFNPgk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Jun 2023 11:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235423AbjFNPgj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jun 2023 11:36:39 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A40B6
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 08:36:38 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-77ad94642d4so786501939f.1
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 08:36:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686756998; x=1689348998;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=phQ7TSdnMlVGNbVCPYRQr4PU6UmUaw+34QpLb3+bJI4=;
        b=Csj53k8iiQGG8pO8HjA0ILvyVcytWnLZlC1c2vofzSlBY9zC3j7b8tmdcMcCvqpqTR
         ah8Yu7QfZA6wE8cbUDpvdoN4Du96TUPi7IGq1YAWK3p/6JBGo9Rtu8rAt/cBNF6ivvP/
         Qw2HU4qict/3P+zuTAgh4x36EPwa1rR9w7KSA7HPePx+0kvjL/pla7BZecEc2MH6wB02
         Fje4RnQOZlSrNfCA7g531ZrtWmrIj/1zlyv/9CUt/IareSTsFKyDFVzIN3TX+DiBrLNS
         FcUVXZGhN5niFrH6MlDmiW4O1tBFW+qKqY/vtsVwZ7fRpCkoSz/1KhwMRT4MyLTlGRYy
         1Vhg==
X-Gm-Message-State: AC+VfDyQ+9u9xwhRcUJyW2KegujqqRaJuccUw4MRGKSkZrSp8TmgVg9i
        hEiF0gbi3dPdkcnc/ws4omQxakPyNL/OoZm/SZCuXi3jHj77
X-Google-Smtp-Source: ACHHUZ7Mkn9ZMRRLMYl80aZSQLcCbxjmQJ6yFASgFB/JtRpTXHcQNP4UiwWC3PuH4cNNqXMPQQRnYk8btGq1P2PL9D8qzqx2spm+
MIME-Version: 1.0
X-Received: by 2002:a92:d442:0:b0:340:9f52:a982 with SMTP id
 r2-20020a92d442000000b003409f52a982mr646147ilm.6.1686756997948; Wed, 14 Jun
 2023 08:36:37 -0700 (PDT)
Date:   Wed, 14 Jun 2023 08:36:37 -0700
In-Reply-To: <1602673.1686753912@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af6e4905fe18b762@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in shash_async_final
From:   syzbot <syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com

Tested on:

commit:         fa0e21fa rtnetlink: extend RTEXT_FILTER_SKIP_STATS to ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=17790627280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=13a08c0bf4d212766c3c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14c0019d280000

Note: testing is done by a robot and is best-effort only.
