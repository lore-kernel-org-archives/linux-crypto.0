Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8842DEB64D8
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jun 2023 23:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbjFNXEj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Jun 2023 19:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjFNXEi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jun 2023 19:04:38 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EAE2684
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 16:04:38 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-340b21b5927so7039985ab.3
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 16:04:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686783877; x=1689375877;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/FvgsNZbMshDfWtJb8Ii39l/0H93uFx36WrvlKiAiTY=;
        b=DiXRIG43KinA/4xS9M3w3PBbPTcxzMcFO6yyvZg7ECxcigVhhyQOLu+RmZt5TRRvT4
         34ExLcXUXcW9CRiWlUVF1CKWKSizBRhwlGpGORG20c+cb4oL5Z9byfYfyV/Jtqaw5fAx
         Ki25ziHYLdzTArny8Segl/hvjmlU/BT3IABSNSohkGNA69UV9CuXadMAJ8eWKNIwqN63
         xG1+Q8TYlNAgLlmfvwuw46EwmBivUbE72i23m2wX2vsA4L5CcGrc1Xwg6goWGa8LfCi5
         /CEC10ednVfFzGBk3qibWK6EmwemyThLBOo+T4FKH42AaYwlkkkXFckIK3NXdMyks1Y0
         2CQw==
X-Gm-Message-State: AC+VfDwZPsLcERZG06/4yPmoyvt/6NeyVwtwRWhPk8c231QEUJ45do0L
        GbVDLYnvVztY6LpQxxHK0tyKJPy3ccYnGYULl0fFfmNmrRJZ
X-Google-Smtp-Source: ACHHUZ5ythZ0Axbf1hC7Gjy6i3ZBawNjy0uyb3Fi9JiOPPifmsSE16NxhTszqGRP/oFDB8ZLyVWcQMYnLmTHD3TUcqhitl24el+B
MIME-Version: 1.0
X-Received: by 2002:a92:d4d1:0:b0:33b:f9b5:d6c2 with SMTP id
 o17-20020a92d4d1000000b0033bf9b5d6c2mr7195369ilm.5.1686783877405; Wed, 14 Jun
 2023 16:04:37 -0700 (PDT)
Date:   Wed, 14 Jun 2023 16:04:37 -0700
In-Reply-To: <1634372.1686755343@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d3650205fe1ef98f@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in shash_async_export
From:   syzbot <syzbot+472626bb5e7c59fb768f@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+472626bb5e7c59fb768f@syzkaller.appspotmail.com

Tested on:

commit:         fa0e21fa rtnetlink: extend RTEXT_FILTER_SKIP_STATS to ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=149b6617280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=472626bb5e7c59fb768f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=154a41fd280000

Note: testing is done by a robot and is best-effort only.
