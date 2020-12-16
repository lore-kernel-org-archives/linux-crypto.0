Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28771C4361B
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 13:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7D7C23105
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 13:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgLPNko (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 08:40:44 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:40384 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgLPNko (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 08:40:44 -0500
Received: by mail-io1-f71.google.com with SMTP id l18so22024619iok.7
        for <linux-crypto@vger.kernel.org>; Wed, 16 Dec 2020 05:40:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=H23gK52sCILiq088lhUQFDzvFZHl87rDPzyeRO8RNd4=;
        b=euVUq/eNO82xsaa2QxLxk8LE/l8Q63FihQ7D5K3qnUVXJig5C7U8EkRIEveyZuPsLE
         sk0ztXZUXb1F+ulWUgfQL+SRdbpKpcIu2opPgVtpifIpXeLix6uqqS9srDGBw/f15Wsp
         9/H48aia3sXcUZvYIDAaM4eB76tF6qLMEKV3bblEgvF7pZDO6zRpOXbhtgT4c0IhOVNX
         daC08n4uBx7rP6Tqiixd7AQyZBIxgr1s+gjHbYenznR7Vu4nXiPsbRhXOI6X3vIfs1vh
         FEiBGyeH15xo8EIruYx3kprPQmloKpZgz01yxJJa+sHzCrPoDlUR/WN37PX+5KSzVGEu
         l4tQ==
X-Gm-Message-State: AOAM5312kC+eRgJcW6Ut8bf91RpoxMf3Bd77YkoHPk2ALlvKxtAvFSBU
        yNOce8j95GtXzn71ntLEoVoyj6EtK7KzOEiscOPN30Olr7kR
X-Google-Smtp-Source: ABdhPJycCbsLgF11aJGiLLu+8JEFqwjFZFOTcyTLJfHZRSLSOi8ZBEoTLEWIX6TXadn0g2BSEryafSecxWImCEYJifPSP/NC/og0
MIME-Version: 1.0
X-Received: by 2002:a92:bb84:: with SMTP id x4mr3410125ilk.298.1608126003067;
 Wed, 16 Dec 2020 05:40:03 -0800 (PST)
Date:   Wed, 16 Dec 2020 05:40:03 -0800
In-Reply-To: <000000000000f683660598300559@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002aca3d05b69503ac@google.com>
Subject: Re: INFO: rcu detected stall in sys_open (2)
From:   syzbot <syzbot+7ee926c5e237e614ccb1@syzkaller.appspotmail.com>
To:     bp@alien8.de, davem@davemloft.net, dhowells@redhat.com,
        fweisbec@gmail.com, herbert@gondor.apana.org.au, hpa@zytor.com,
        linux-afs@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 1d0e850a49a5b56f8f3cb51e74a11e2fedb96be6
Author: David Howells <dhowells@redhat.com>
Date:   Fri Oct 16 12:21:14 2020 +0000

    afs: Fix cell removal

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=128ceadf500000
start commit:   c85fb28b Merge tag 'arm64-fixes' of git://git.kernel.org/p..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=de7f697da23057c7
dashboard link: https://syzkaller.appspot.com/bug?extid=7ee926c5e237e614ccb1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1227c177900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13553f60500000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: afs: Fix cell removal

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
