Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5ECC001DE
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jul 2023 12:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbjGYM51 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jul 2023 08:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbjGYM5Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2023 08:57:25 -0400
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4534DA
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jul 2023 05:57:22 -0700 (PDT)
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3a5b92b4b63so4123436b6e.1
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jul 2023 05:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690289842; x=1690894642;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cOw8M5MEfuKWRaEOU1htxwvLHkFjQE/8NWsGwEPUhhQ=;
        b=lgA2pukqMCWaLoY/OVOGbxJ/0Zm0Y2OxH2twQU+RlVyDDGMisIEdJAccascyg9x482
         kUO+mYPdgi/HHNI1brUEqaILR/0GtUee8pXw1LdcsuMfqA0hQxnODCchHfqT28HY3osW
         DhXSpAwWAlo4S+C7p4SptyHx647VtTiKV3cqTZOpSwAZ8pesh4fxocT3QYszJjwLhl/F
         RQSavvjLnfjncgABjR9J/H/UnZqBpHxp9yIryEa7k+4vA3G/WXVm9d75sGO+Fxt6/dp3
         X4aVdbp0QZ1Fw35e5w+IXkx8fyesCkd15861hkhnsPSC8tM0loWFu+B/NsuX0ePAjnl4
         6yAg==
X-Gm-Message-State: ABy/qLaA2lkNaC0txWZSNZsZXMHAvyL+eSRKtVSpCTlyoSt6PQ5ScICk
        NtZIm3hNxyHzWr2l4vZOLWrJfcub6GKwYo7Em+BZ9FqcE/1W
X-Google-Smtp-Source: APBJJlGT5ZLlw0oGMTwCLMxeRVwuZL4LAuQ2BEQbUtmWWbEDKq21tCrSij87dhru4aCbHfthAYp+54z2UOiiNwEt9tNqBfQ6biJk
MIME-Version: 1.0
X-Received: by 2002:a05:6808:13cf:b0:3a5:a925:80a0 with SMTP id
 d15-20020a05680813cf00b003a5a92580a0mr18099491oiw.2.1690289842333; Tue, 25
 Jul 2023 05:57:22 -0700 (PDT)
Date:   Tue, 25 Jul 2023 05:57:22 -0700
In-Reply-To: <0000000000000cb2c305fdeb8e30@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009eae2406014f451d@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in cryptd_hash_export
From:   syzbot <syzbot+e79818f5c12416aba9de@syzkaller.appspotmail.com>
To:     alexander.deucher@amd.com, davem@davemloft.net,
        dhowells@redhat.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mario.limonciello@amd.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 30c3d3b70aba2464ee8c91025e91428f92464077
Author: Mario Limonciello <mario.limonciello@amd.com>
Date:   Tue May 30 16:57:59 2023 +0000

    drm/amd: Disallow s0ix without BIOS support again

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13ad506ea80000
start commit:   ded5c1a16ec6 Merge branch 'tools-ynl-gen-code-gen-improvem..
git tree:       net-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=e79818f5c12416aba9de
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c6193b280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c7a795280000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: drm/amd: Disallow s0ix without BIOS support again

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
