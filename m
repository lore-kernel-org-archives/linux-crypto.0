Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2F9CCA482
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jun 2022 04:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiFHEq0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jun 2022 00:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiFHEpN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jun 2022 00:45:13 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF9041BCD6
        for <linux-crypto@vger.kernel.org>; Tue,  7 Jun 2022 19:37:14 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id x3-20020a056e021bc300b002d1b0ccfca6so14893190ilv.11
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jun 2022 19:37:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=tu6aa+xwVDffbv/lJ0S+vousZDYtDSyBdQaifN5ohVA=;
        b=7NZF0AXRUg4j9oh34A75Pm2171QU34uBBidSjGPt5sWwepyatIS2tpdVixP9jGfkpl
         rW8ZRLTAcZLJo2eABpwv/laR7nMc7x3q66xdQVd6nvEBFrVDMIxFhnSjvoYG0YdWRdo5
         16Li7BbOH4AXwKREuAY/lHy4hX8V/RFq6WB8SwfFnVkF1Tuv4ku8eLUpAEMPL1t/FOtg
         ubTjBfOk4RUhxG7f2hqOoCR8cZLO94zaXssmozwQu5T7PvVisGwQfiaEGrcT8dnaVVRw
         f2YNY4r4szPRMnQxJrqkvDPT7DZc0SAktzPRsnzU3yhJVs+AzwpVVBARaj/6awvQPdo2
         w3jQ==
X-Gm-Message-State: AOAM531UbqtADG4BssQCJx9knJ6fgrGDp7YGIdggWowhuhLbll25IhdL
        8WhaZXWvs6ciyUsei+OB57ycFW0I2S7FgqdjEGD1LluN5Aep
X-Google-Smtp-Source: ABdhPJwE6wCMlR17Kr99xZePUjVywNYrOFDkYbtuMs+ujjOcBdMnZ59NcK8fKjjsuQWikkqtEx1wq/n+YETlrRFEx6PJqAf+NEDy
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2513:b0:32e:5298:8264 with SMTP id
 v19-20020a056638251300b0032e52988264mr18072303jat.178.1654655833392; Tue, 07
 Jun 2022 19:37:13 -0700 (PDT)
Date:   Tue, 07 Jun 2022 19:37:13 -0700
In-Reply-To: <CACGkMEt_e59wRotUo9D1UqubAhe+txy0GF=r1BYBVdND8-uKbA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002cccbd05e0e69570@google.com>
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
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15f814cff00000

