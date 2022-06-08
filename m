Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D8CC43334
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jun 2022 05:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbiFHFnE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jun 2022 01:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbiFHFm5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jun 2022 01:42:57 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8831A3B5
        for <linux-crypto@vger.kernel.org>; Tue,  7 Jun 2022 20:15:09 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id j12-20020a5d93cc000000b006692aee869fso5498748ioo.5
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jun 2022 20:15:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=my0rk8z/GOJ43WqWCVtp9xPE8Ztlbnwblm3qHdmpM54=;
        b=nqZ6qzR17uvLSybpStIiXUP6fjEjYRFgqNgvCk1JOzJ++ODmvChtUTxh9GYq+zIcAF
         wJDZNxlCpYBD2g4CoAC6vJp10rjIa4ehAfQNm5flEWZ4ihuzEFly+NpmunwkB1t/4ql3
         ZOKrVyYFjKfd35WAQlPG+a4P3czLzx7Rs4gLkk7yizgq+6uQWS+/Itzg3KrtQVACcMqm
         Tatzg/lWCZ3p9sWks6j5sj+PrAMZ2YCP3vfAx/5YsJ3AxeomT1gKCK+nO2uKVDyTxtds
         TcWFobM/W6+iX6XZ/QrTjjvup0E20f3467Cp4L0B2OrEklOilf2zUKZwkyDtzsgydpwy
         VX8g==
X-Gm-Message-State: AOAM531Hj64VT9arFFMDbwLCEOShgDKjIzC7+HTNRBehBwV3nFQKY6Cp
        qomLU33ZKO6FGhgf0EjfLedaGoC3wQrCr/VC1pO8oYkzMAVK
X-Google-Smtp-Source: ABdhPJyDAHTZEqVZpAdPEsRA1tWIDLDO1YkbVcpsVw8DKrB6ladOIZSYZjLdMQ+C1zhzwGLq/5AjZkFGwdHA1V+LelZ+/7mstGCC
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1ca8:b0:2d4:455:88aa with SMTP id
 x8-20020a056e021ca800b002d4045588aamr14561882ill.303.1654658109343; Tue, 07
 Jun 2022 20:15:09 -0700 (PDT)
Date:   Tue, 07 Jun 2022 20:15:09 -0700
In-Reply-To: <CACGkMEus=RMMcDk+sM8X14=AtFjK+-3p_Lo=O6tfv9H=0wXENw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d5113205e0e71c8f@google.com>
Subject: Re: [syzbot] INFO: task hung in add_early_randomness (2)
From:   syzbot <syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com>
To:     herbert@gondor.apana.org.au, jasowang@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@dominikbrodowski.net, mpm@selenic.com, mst@redhat.com,
        syzkaller-bugs@googlegroups.com, xuanzhuo@linux.alibaba.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com

Tested on:

commit:         bd8bb9ae vdpa: ifcvf: set pci driver data in probe
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=8d4cbb773055caee
dashboard link: https://syzkaller.appspot.com/bug?extid=5b59d6d459306a556f54
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1731eaf7f00000

Note: testing is done by a robot and is best-effort only.
