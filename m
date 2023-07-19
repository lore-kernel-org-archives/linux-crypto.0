Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DCAFC001B0
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jul 2023 17:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjGSRmd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jul 2023 13:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjGSRmc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jul 2023 13:42:32 -0400
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6805D1735
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jul 2023 10:42:28 -0700 (PDT)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3a034580aafso11684180b6e.0
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jul 2023 10:42:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689788547; x=1692380547;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5GdSlJQiKv484CM7UIkrDgwXqQQM0s/UqcfPqk1L/74=;
        b=EVi8j84Z4xWFKGBfzTAdHSHwNd3i1uLs4fBRyPWaHpI86gf9886lD85ONUgJKmXWA+
         X7pcXloHdsDiyYqbMp5hFpCJ7ksl20eFHF9ZSTgI4IHoBu57nLGCmJqXCwoU57dYyDhK
         asmvFkYNturBnSL/uc649Mu8HBOJ3K3SBWVUBKwQzo08OKDRxhyCKI9EFMLyuvxqlBXi
         9JL+W0n0AMs+c3uzquadMi8YawNcNUyg537sUUP6O6viuRXvpNb4l6OQ28cTKxzg2bAK
         wNIlbJGCnAfxxzC5ZxaZwo5fVOzjbedAlme122dsggpE2gsCWAASmOCgc+yupamNkTgU
         GJmg==
X-Gm-Message-State: ABy/qLYlzcuZlW2/hAEHsdZd+EhKIL85kjDkbUIO8NMW3lSnWttTXooZ
        syMdb3R8PcrK6Cr7jtr0HlvZZ0pL8dpV/D8X7bMSuAT6sa2e
X-Google-Smtp-Source: APBJJlGc+FLMHZg6mdALKsMlGrkkyQ9/UibmMwawm8SN0wVBXG3jpPAmimRjmmikWRK5g6vvUtlS7JtRmzwo7B46VeTGBSh53ppP
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3013:b0:38d:ca0a:8e18 with SMTP id
 ay19-20020a056808301300b0038dca0a8e18mr28834819oib.2.1689788547816; Wed, 19
 Jul 2023 10:42:27 -0700 (PDT)
Date:   Wed, 19 Jul 2023 10:42:27 -0700
In-Reply-To: <000000000000ada87505fe7cf809@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002361ee0600da8ec5@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in shash_ahash_update
From:   syzbot <syzbot+88f4b1e6cf88da11f5cd@syzkaller.appspotmail.com>
To:     Jiadong.Zhu@amd.com, alexander.deucher@amd.com,
        davem@davemloft.net, dhowells@redhat.com,
        herbert@gondor.apana.org.au, jiadong.zhu@amd.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 1dbcf770cc2d15baf8a1e8174d6fd014a68b45ca
Author: Jiadong Zhu <Jiadong.Zhu@amd.com>
Date:   Wed May 24 03:42:19 2023 +0000

    drm/amdgpu: Reset CP_VMID_PREEMPT after trailing fence signaled

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1622cafaa80000
start commit:   9a94d764e9bc Merge tag 'mlx5-updates-2023-06-16' of git://..
git tree:       net-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4a7d74e6a7c3211
dashboard link: https://syzkaller.appspot.com/bug?extid=88f4b1e6cf88da11f5cd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1152c4ff280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1307cbcf280000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: drm/amdgpu: Reset CP_VMID_PREEMPT after trailing fence signaled

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
