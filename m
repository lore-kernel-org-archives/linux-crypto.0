Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1EEC4338F
	for <linux-crypto@archiver.kernel.org>; Sat, 14 Aug 2021 13:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A43760F51
	for <linux-crypto@archiver.kernel.org>; Sat, 14 Aug 2021 13:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238401AbhHNNHf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 14 Aug 2021 09:07:35 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:44586 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbhHNNHd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 14 Aug 2021 09:07:33 -0400
Received: by mail-il1-f200.google.com with SMTP id y20-20020a056e020f5400b00224400d1c21so4895476ilj.11
        for <linux-crypto@vger.kernel.org>; Sat, 14 Aug 2021 06:07:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=t5YQUGSZE6EI9BhxfatfxY8kQRFsuaqSI5BxeVjzuZ0=;
        b=R7j+aPvXLMuOX34RPMtOer+GYK43x4Al25XAfXT7EoIrYIUv0atUD2lZxzhxOwJsOV
         nF/FBPhehhoU4F2NCWMRDIZwX+DRjm+ZwfZOixPJ3hun9j1XLdkwsoI2LxuWPhnYf/nb
         TpZmpobjeA6qzhwkDvLYl83k211gP1xn5sPuPoPQINCZqFXab/c3TN2zb9tdmPUgUB2E
         VcGdIk9dNTxL2TRFCpU/Tu09FSCKFhOPuudUoDjCi7UHcrcuh1UdIsG4Myvl0m2Io8Ao
         TEPPSXDaDGuQXarlN/dnvaXtaZle5VF5lOlJmMwwy2/nfByDrhE7m0O36OLQlPupOVeu
         EuwA==
X-Gm-Message-State: AOAM533QdYHfYnMXoMcdHIJ6G3Xbnt5xk3HMLABGzwtMQYp4BtXWmEH6
        PcllTnbGDCnqMk45cgGyi6iVshp5ybIYQvTBwTebg2PE5IXM
X-Google-Smtp-Source: ABdhPJy2AvLguRSMEmfyW87t0JS484ypKZ9GNlz2YX0HW0onFVHA9gtYaOLblHldyW0ZHNRgbBvtlICabAwh4/WuQloazRiOUvWa
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17cf:: with SMTP id z15mr2152427ilu.103.1628946425097;
 Sat, 14 Aug 2021 06:07:05 -0700 (PDT)
Date:   Sat, 14 Aug 2021 06:07:05 -0700
In-Reply-To: <00000000000006e7be05bda1c084@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000006b42305c984a5d3@google.com>
Subject: Re: [syzbot] general protection fault in scatterwalk_copychunks (4)
From:   syzbot <syzbot+66e3ea42c4b176748b9c@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, bp@alien8.de,
        daniel@iogearbox.net, davem@davemloft.net,
        herbert@gondor.apana.org.au, hpa@zytor.com,
        john.fastabend@gmail.com, kuba@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vfedorenko@novek.ru, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

syzbot has bisected this issue to:

commit 635d9398178659d8ddba79dd061f9451cec0b4d1
Author: Vadim Fedorenko <vfedorenko@novek.ru>
Date:   Wed May 20 08:41:44 2020 +0000

    net/tls: free record only on encryption error

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=144095e6300000
start commit:   f8fbb47c6e86 Merge branch 'for-v5.14' of git://git.kernel...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=164095e6300000
console output: https://syzkaller.appspot.com/x/log.txt?x=124095e6300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=171d57d5a48c8cad
dashboard link: https://syzkaller.appspot.com/bug?extid=66e3ea42c4b176748b9c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b8db9e300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c21581300000

Reported-by: syzbot+66e3ea42c4b176748b9c@syzkaller.appspotmail.com
Fixes: 635d93981786 ("net/tls: free record only on encryption error")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
