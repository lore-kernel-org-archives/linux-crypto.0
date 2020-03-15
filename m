Return-Path: <SRS0=NifF=5A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CFEC2BB1D
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Mar 2020 14:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E235206B1
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Mar 2020 14:52:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j0+Hv971"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgCOOwT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Mar 2020 10:52:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43362 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728310AbgCOOwT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Mar 2020 10:52:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id b2so11784400wrj.10;
        Sun, 15 Mar 2020 07:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=7Gi+bCJZz4lHK563HcUlk7nIdd2eNAvPQL3ugWFcKi0=;
        b=j0+Hv971Q3EFKqojafHzYkdFMh5pOunYi5hyJIEjse0f1ZGtX7fTXKcN3Lrcxbw4CS
         Jb0eJ5EmPI+qs1QCv962jd2cqr4G7ko5zDBvFxElmvBcMpsHzBnGcqy5LC3PXr7rncnq
         akFlAglqRW1W2LiAANi+GT6TSFsFq5KLQWv93gUxCurDm23MkoC77qj6icuaWNI0FFYs
         pL1HPDgyllegAokH9S9QPs1nEv4jzJO4Mk0KybSpib712NqIynYJ3to/iCSacMuEWax7
         6G2d8D8C5OOpcDoAnhN5Rbre9V/jmuPCwwUoAtSZ/Rh6resTWDqT7a0h/zrjqZN1jVOv
         dgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=7Gi+bCJZz4lHK563HcUlk7nIdd2eNAvPQL3ugWFcKi0=;
        b=Edfanh3oB2LBtzSKn6Q/p/2t78Mhz8YATkkMLukA883kTikoDm8PcAQCbqyrUc6D6o
         3q3FmxUwxrFjNuShZl8Ek9O31mKTP19XigVy7hn9SvwdOuyVfCubuWcTyjoQLrlK/uk7
         AchqOVPtQWpNS4twmREa+6Aiqz3zgCzdcMkozjypavKAvSJP2Q1ZPi9Ovn747JqkJspZ
         Nd4nzxiB2Jy8LmfutDvH77t6vsujxq7CgtEy1wh3MSZPnMnhvoi/uuBdia+N4gpgQKyT
         F5ZCQclA8gHLJ9iH9cSgn9p0ZD1NQDZ1fs11s1FlnLzK5Fwu9Zn8FIIUz0anukHY2I9B
         Og1Q==
X-Gm-Message-State: ANhLgQ3v6udfYhCttVeRpD0LGyornr7AzoBo72kK1H3OvgTUn+c+N41I
        9Oz2GiiqL8P1h/CHednXfSU=
X-Google-Smtp-Source: ADFU+vv+fswinTfECRcUsv5566rVnszb3rK5dZ9IdZZAIGCwH0wYljS9xHDRwAdKtdX02tI2Av4nUQ==
X-Received: by 2002:a5d:640a:: with SMTP id z10mr27030399wru.301.1584283937438;
        Sun, 15 Mar 2020 07:52:17 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id t81sm26050317wmb.15.2020.03.15.07.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2020 07:52:16 -0700 (PDT)
Date:   Sun, 15 Mar 2020 15:52:14 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     peterz@infradead.org, herbert@gondor.apana.org.au,
        viro@zeniv.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        dvhart@infradead.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: BUG: cryptsetup benchmark stuck
Message-ID: <20200315145214.GA9576@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

hello

On next-20200313, running cryptsetup benchmark is stuck.
I have bisected this problem twice and the result is the same:

git bisect start
# bad: [2e602db729948ce577bf07e2b113f2aa806b62c7] Add linux-next specific files for 20200313
git bisect bad 2e602db729948ce577bf07e2b113f2aa806b62c7
# good: [98d54f81e36ba3bf92172791eba5ca5bd813989b] Linux 5.6-rc4
git bisect good 98d54f81e36ba3bf92172791eba5ca5bd813989b
# good: [f1ffc9616ef098ac180ac8ae3554e9beda4014f8] Merge remote-tracking branch 'bluetooth/master'
git bisect good f1ffc9616ef098ac180ac8ae3554e9beda4014f8
# good: [517488f00386297a3ed8a626c4fd23c1c05fab77] Merge remote-tracking branch 'iommu/next'
git bisect good 517488f00386297a3ed8a626c4fd23c1c05fab77
# bad: [308033e51d5c167ded64799982ab042ee1cdd7e5] Merge remote-tracking branch 'thunderbolt/next'
git bisect bad 308033e51d5c167ded64799982ab042ee1cdd7e5
# bad: [436b37da2c4b71ce22d915355291a2fe9bf71abd] Merge remote-tracking branch 'irqchip/irq/irqchip-next'
git bisect bad 436b37da2c4b71ce22d915355291a2fe9bf71abd
# bad: [b8aaa6b4a71eaa1161ae3a8e67e7c48dbdd131d5] Merge branch 'efi/urgent'
git bisect bad b8aaa6b4a71eaa1161ae3a8e67e7c48dbdd131d5
# good: [c99bbc21e58b91ac670c95a51639cc35f364ce7a] Merge branch 'sched/core'
git bisect good c99bbc21e58b91ac670c95a51639cc35f364ce7a
# bad: [1949ed1e393b5740b295f548ce66e2eeae3e76f7] Merge branch 'locking/urgent'
git bisect bad 1949ed1e393b5740b295f548ce66e2eeae3e76f7
# good: [836196beb377e59e54ec9e04f7402076ef7a8bd8] perf/core: Add per perf_cpu_context min_heap storage
git bisect good 836196beb377e59e54ec9e04f7402076ef7a8bd8
# good: [798048f85093901f475d25b2ac8d9ea1bc6d471a] Merge tag 'perf-urgent-for-mingo-5.6-20200306' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent
git bisect good 798048f85093901f475d25b2ac8d9ea1bc6d471a
# good: [edd5d987f561b657c46383b0a778b99d51a76e4b] Merge branch 'ras/core'
git bisect good edd5d987f561b657c46383b0a778b99d51a76e4b
# good: [95ed6c707f26a727a29972b60469630ae10d579c] perf/cgroup: Order events in RB tree by cgroup id
git bisect good 95ed6c707f26a727a29972b60469630ae10d579c
# good: [b00f7244f01b8a9d205944929f58b99732541f44] Merge branch 'perf/core'
git bisect good b00f7244f01b8a9d205944929f58b99732541f44
# bad: [8019ad13ef7f64be44d4f892af9c840179009254] futex: Fix inode life-time issue
git bisect bad 8019ad13ef7f64be44d4f892af9c840179009254
# first bad commit: [8019ad13ef7f64be44d4f892af9c840179009254] futex: Fix inode life-time issue


git bisect start
# good: [2c523b344dfa65a3738e7039832044aa133c75fb] Linux 5.6-rc5
git bisect good 2c523b344dfa65a3738e7039832044aa133c75fb
# bad: [2e602db729948ce577bf07e2b113f2aa806b62c7] Add linux-next specific files for 20200313
git bisect bad 2e602db729948ce577bf07e2b113f2aa806b62c7
# good: [acfda12b3a9b7b8d8cb4ff5f6ff0e48f688e254c] Merge remote-tracking branch 'spi-nor/spi-nor/next'
git bisect good acfda12b3a9b7b8d8cb4ff5f6ff0e48f688e254c
# good: [b38d0a2fd9c0bdd99492655295d0972ea549dca6] Merge remote-tracking branch 'devicetree/for-next'
git bisect good b38d0a2fd9c0bdd99492655295d0972ea549dca6
# bad: [308033e51d5c167ded64799982ab042ee1cdd7e5] Merge remote-tracking branch 'thunderbolt/next'
git bisect bad 308033e51d5c167ded64799982ab042ee1cdd7e5
# bad: [436b37da2c4b71ce22d915355291a2fe9bf71abd] Merge remote-tracking branch 'irqchip/irq/irqchip-next'
git bisect bad 436b37da2c4b71ce22d915355291a2fe9bf71abd
# bad: [b8aaa6b4a71eaa1161ae3a8e67e7c48dbdd131d5] Merge branch 'efi/urgent'
git bisect bad b8aaa6b4a71eaa1161ae3a8e67e7c48dbdd131d5
# good: [c99bbc21e58b91ac670c95a51639cc35f364ce7a] Merge branch 'sched/core'
git bisect good c99bbc21e58b91ac670c95a51639cc35f364ce7a
# bad: [1949ed1e393b5740b295f548ce66e2eeae3e76f7] Merge branch 'locking/urgent'
git bisect bad 1949ed1e393b5740b295f548ce66e2eeae3e76f7
# good: [836196beb377e59e54ec9e04f7402076ef7a8bd8] perf/core: Add per perf_cpu_context min_heap storage
git bisect good 836196beb377e59e54ec9e04f7402076ef7a8bd8
# good: [798048f85093901f475d25b2ac8d9ea1bc6d471a] Merge tag 'perf-urgent-for-mingo-5.6-20200306' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent
git bisect good 798048f85093901f475d25b2ac8d9ea1bc6d471a
# good: [edd5d987f561b657c46383b0a778b99d51a76e4b] Merge branch 'ras/core'
git bisect good edd5d987f561b657c46383b0a778b99d51a76e4b
# good: [95ed6c707f26a727a29972b60469630ae10d579c] perf/cgroup: Order events in RB tree by cgroup id
git bisect good 95ed6c707f26a727a29972b60469630ae10d579c
# good: [b00f7244f01b8a9d205944929f58b99732541f44] Merge branch 'perf/core'
git bisect good b00f7244f01b8a9d205944929f58b99732541f44
# bad: [8019ad13ef7f64be44d4f892af9c840179009254] futex: Fix inode life-time issue
git bisect bad 8019ad13ef7f64be44d4f892af9c840179009254
# first bad commit: [8019ad13ef7f64be44d4f892af9c840179009254] futex: Fix inode life-time issue

Since the two bisect lead to the same commit, I think it should be right one even if I dont find anything related to my problem.
But reverting this patch is impossible, so I cannot test to try without it.

Regards
