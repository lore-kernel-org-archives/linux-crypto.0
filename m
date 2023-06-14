Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2798FEB64D8
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jun 2023 22:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbjFNWvf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Jun 2023 18:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbjFNWve (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jun 2023 18:51:34 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377831FCC
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 15:51:33 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-76998d984b0so872692939f.2
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 15:51:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686783092; x=1689375092;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EvWGvGEYVDY0zHX9FKywaaz8rQNIa9z0Aga8elPLqso=;
        b=Vt/Mw86dPBl+KO7MmoZXtGamSK0U+9ojN+TzlsIClxfRklt3lnagb0gFql7aNaFECV
         eb6BW2xUn1Yea/MDNSHZEQmsSNb3VbulLLzNQioz3nFKHW39aWFDsOvaPQ5/ayuNszB1
         LI4pklJA5zl/4V7FhmmoZCG35I1g8hs4oc8uqz+InpnwEC9u5uwJUtj0zC20+jpazEP5
         usW/H+v6g2o93sqe/rqce4yFVOKcDZRf3pw4Qg06YUmzjqrfjPSN8TUHLt3Z+PfJXzdg
         UoAQrRXfbeUEFRxsZ9LB1bL6juZ/K2c6wFxb4po4+Eiqqiu7Kjv2BLrTntCcyTvFwNCN
         rtzg==
X-Gm-Message-State: AC+VfDwyGpWdS8zhcKJ2WclHGy4S3/LxFSmUxM0X5VxngggLAf8UbAwF
        PPoJsYM2FKYoc+xJwGiDKW38ImZNgFb6n89EmvWFSp/olixC
X-Google-Smtp-Source: ACHHUZ5CrMxjJAzysjfmyxYmSDBMC3q+sumWtPMCJn5LhHxYTj4gZWD8HH/6ppLUpOaHirncbQikaPSGA+Jf2kxBMEr1Tlxy+AnU
MIME-Version: 1.0
X-Received: by 2002:a92:dc0e:0:b0:329:4c5e:15d8 with SMTP id
 t14-20020a92dc0e000000b003294c5e15d8mr7285347iln.2.1686783092577; Wed, 14 Jun
 2023 15:51:32 -0700 (PDT)
Date:   Wed, 14 Jun 2023 15:51:32 -0700
In-Reply-To: <1604551.1686754324@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000bdc3a05fe1ecb0a@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in crypto_shash_finup
From:   syzbot <syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com

Tested on:

commit:         fa0e21fa rtnetlink: extend RTEXT_FILTER_SKIP_STATS to ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=129a0837280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=4e2e47f32607d0f72d43
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14cfedfd280000

Note: testing is done by a robot and is best-effort only.
