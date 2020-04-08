Return-Path: <SRS0=EmbF=5Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFDFC2D0EA
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 15:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F4B720730
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 15:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgDHPhH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Apr 2020 11:37:07 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:50535 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgDHPhG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Apr 2020 11:37:06 -0400
Received: by mail-io1-f70.google.com with SMTP id a12so280575ioe.17
        for <linux-crypto@vger.kernel.org>; Wed, 08 Apr 2020 08:37:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Sk/yJxNuEWZ2R900yOk1engj26s2zBpDSaCTxgbd3iw=;
        b=S3zVy02FfMFWkBT7fY1DyjBnHIpwPb6g9x+S0VzcyWIxTYdUbGxDIiUO1CCx6jM+Kp
         6ajVX2IMixntaXxwoU24bPz1f7UXH0nkxOoSin8HBvxP1JH/pdRB94yKb7yh285KW+jG
         qfMQTdKqFKtYZWSAn2E4ojMXq8cNKsPvUNHuWUXNQgZc9qbySQIVvx2bbMOfNvCuEvyO
         Na1n56sXoO8TfZu/aUUjrEHrFn+C+rF5R2qnPWRnsHlLnFsmyIm1S93Fptt594SjFc/Q
         XS7vV/X7EvDk1SHYBjKwdhdGBj0V0aAH6yFEEM8G++BbFdomFfo15rxO2UQQapw4IOpT
         rm0w==
X-Gm-Message-State: AGi0PuZDzX/Uzwmmn+hH9V2btIbqfnyBPR3YwGoOHW47//V/N6VIQz0a
        qEl9dhzo0FS12DfvFWtfDiI2wuOv2Gz5OLHcgyrA1rIlxvBy
X-Google-Smtp-Source: APiQypJdvcrg+aR58S2FEowGROs10MppJcSNDVTGB35UmZY5ZA1bV17WnWZlHjZMwBB+AaHxZWu05S2h25UB/7vDqvwQJi6PzhCP
MIME-Version: 1.0
X-Received: by 2002:a92:dcd1:: with SMTP id b17mr8371614ilr.80.1586360224353;
 Wed, 08 Apr 2020 08:37:04 -0700 (PDT)
Date:   Wed, 08 Apr 2020 08:37:04 -0700
In-Reply-To: <20200408151815.GG66033@xz-x1>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a89b5805a2c9450d@google.com>
Subject: Re: WARNING in af_alg_make_sg
From:   syzbot <syzbot+3be1a33f04dc782e9fd5@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, bgeffon@google.com, davem@davemloft.net,
        hdanton@sina.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+3be1a33f04dc782e9fd5@syzkaller.appspotmail.com

Tested on:

commit:         f5e94d10 Merge tag 'drm-next-2020-04-08' of git://anongit...
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
kernel config:  https://syzkaller.appspot.com/x/.config?x=ca75979eeebf06c2
dashboard link: https://syzkaller.appspot.com/bug?extid=3be1a33f04dc782e9fd5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1672dcede00000

Note: testing is done by a robot and is best-effort only.
