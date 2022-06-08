Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A482BC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jun 2022 05:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbiFHFVn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jun 2022 01:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiFHFVC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jun 2022 01:21:02 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8DF277F84
        for <linux-crypto@vger.kernel.org>; Tue,  7 Jun 2022 19:51:08 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id z19-20020a05660200d300b0066583f8cf2eso9086952ioe.2
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jun 2022 19:51:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=9RKAoJeiSZe3EQhiQtHMGEfkjZC8rMlcX/wtjfSGmZo=;
        b=GjLZivMCbhOB0p0mmxuGzxcTTujSG2deTA+Ept6vGKb8I2B3rrJSFCS7RHHmsXKlsD
         KDeR4GbDc6zAmFczUBeNwtEmhVBShvqR55Ac9mxfxTA0g/C4pt7wJrTGmo+jY3cfPZ4t
         +tPY9cVT5BnSoDlOelidvIsSuvd5orRpeQ/6YuBA2D9RJlH6lKZi5KmbP7xD9SgAbeiD
         9O/2NjPG+lL7Mfrfp7pRd54S0rvUuuRy71CUOEpN6WOF2rv7BpiwWccgtMT1eiez6HBI
         /+vsibYAerXUKvRtIRvnC8Gj9Z4hEdBuPZ1U1ncl5IGPxJtArL5qfD2yM7S5s+6tm5OB
         YVdw==
X-Gm-Message-State: AOAM532HW0s5ioyPdCHMbT417/K7smu/0vVDAYpO3/7TUQA052z/L3KX
        bdjXQbZ1Le7MmCk14Y//NUNFDUi97VSRvcVvR/zIsTE5h5z3
X-Google-Smtp-Source: ABdhPJwHWDSpCC0WchloMDJtjp2ekL7TNVVprJjUbPcnJTsuVKCcOficGv4YWiReILvGYDzovpuwpzGZF4W6lsmLboE1EZkSP2bI
MIME-Version: 1.0
X-Received: by 2002:a02:bb85:0:b0:331:7a13:201b with SMTP id
 g5-20020a02bb85000000b003317a13201bmr13410664jan.41.1654656667728; Tue, 07
 Jun 2022 19:51:07 -0700 (PDT)
Date:   Tue, 07 Jun 2022 19:51:07 -0700
In-Reply-To: <CACGkMEvtV+hVdpgpkYvAmkRteYDN+2dDacrfXsYDv0ZzjJU+ag@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e7c46e05e0e6c6a1@google.com>
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

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file drivers/char/hw_random/virtio-rng.c
patch: **** unexpected end of file in patch



Tested on:

commit:         bd8bb9ae vdpa: ifcvf: set pci driver data in probe
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
dashboard link: https://syzkaller.appspot.com/bug?extid=5b59d6d459306a556f54
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=165a0febf00000

