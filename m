Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E04DDCDB474
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Oct 2023 21:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442824AbjJLVZk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Oct 2023 17:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442914AbjJLVZi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2023 17:25:38 -0400
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BB8BB
        for <linux-crypto@vger.kernel.org>; Thu, 12 Oct 2023 14:25:30 -0700 (PDT)
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3ae5ee6624dso2217402b6e.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Oct 2023 14:25:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697145930; x=1697750730;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y3QvOYTxISpyAN6lBZKnAumWUoCDT9rshpzEVP85mU0=;
        b=J0ITqawRmMnDe3nEFv4o9bmrV8qTJUlR20H7rJnHyLguhFJHUw+NGIVHqcwe7n7vI7
         ABJwaO/hEOf6L4CzRSCbPFQBIs3Nh1cMdbyzWDL+9XxivVBCQDMbHMz0FswEC4WPqjwH
         L74o34xMjdgYcSP06EJSjRNcbU4JuI3bDj6aMQEwlZ2/vHClKDWlZukrMrHEaD+2YFQO
         MRh0DalGGo047juqTuTABi+j6ztYS+O2GxApFfBX9hRsYFvPJ0vvsGQqIhY06YcbHTOr
         52oLplniZhhbC9V+XAM0ZfXleYVsp19rPpUoxEq1TG7t/DYvhzfLRVgAtCzHhm8pCHLo
         i27Q==
X-Gm-Message-State: AOJu0Yx3TmIpM7cOBNQUOyZNg6tf+25zxbC7P1tK5W5lDZih9dfbhPQW
        Z2R6O8TcWJcC/F7efFQdrHx2PRJx/BWvBels5hBEpjiUSztF
X-Google-Smtp-Source: AGHT+IHr9VDIw51thCNfY4Z/TaWoINBr61iwfFvvmuyI7d/MHpnu5HUkhyeevkB5Mp+bdpbYs9dP9oQ7BgdXZ0/HorlKMMmV8cNc
MIME-Version: 1.0
X-Received: by 2002:a05:6808:308e:b0:3ad:fc2e:fbc6 with SMTP id
 bl14-20020a056808308e00b003adfc2efbc6mr13661508oib.10.1697145930065; Thu, 12
 Oct 2023 14:25:30 -0700 (PDT)
Date:   Thu, 12 Oct 2023 14:25:30 -0700
In-Reply-To: <00000000000006e7be05bda1c084@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004b2b3d06078b94b0@google.com>
Subject: Re: [syzbot] [net] [crypto] general protection fault in
 scatterwalk_copychunks (4)
From:   syzbot <syzbot+66e3ea42c4b176748b9c@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, bp@alien8.de,
        daniel@iogearbox.net, davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, hpa@zytor.com,
        john.fastabend@gmail.com, kuba@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        liujian56@huawei.com, mingo@redhat.com, netdev@vger.kernel.org,
        pabeni@redhat.com, sd@queasysnail.net,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vfedorenko@novek.ru, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit cfaa80c91f6f99b9342b6557f0f0e1143e434066
Author: Liu Jian <liujian56@huawei.com>
Date:   Sat Sep 9 08:14:34 2023 +0000

    net/tls: do not free tls_rec on async operation in bpf_exec_tx_verdict()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17338965680000
start commit:   bd6c11bc43c4 Merge tag 'net-next-6.6' of git://git.kernel...
git tree:       net-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=634e05b4025da9da
dashboard link: https://syzkaller.appspot.com/bug?extid=66e3ea42c4b176748b9c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10160198680000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15feabc0680000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: net/tls: do not free tls_rec on async operation in bpf_exec_tx_verdict()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
