Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C825C77B7E
	for <linux-crypto@archiver.kernel.org>; Mon, 29 May 2023 11:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjE2LkJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 May 2023 07:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbjE2LkE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2023 07:40:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6C0E8;
        Mon, 29 May 2023 04:39:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78852623B4;
        Mon, 29 May 2023 11:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E08E3C433EF;
        Mon, 29 May 2023 11:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685360355;
        bh=ddaIsiQIP7JIrjb7rhE+HLQmE+gMo0PSVV8o9Wii1rM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=MVioXZLyySCMnH0MBmzVmePXE5sWv7j/scrQ0I75+Cw13IOn29CPmEL1TmLllKYyH
         /kWglI9OtGnubZ/zf2h6JIklrYkEeldck951hAXHCi5p6oAs9zHlKsteq9eGg8tjUZ
         8sYJ43WCqC2Vne0I+XJy8WAHqJtDVwp8psrTvhRS620F6JoZPDZAPGxkprq5Q3a4HY
         xr5gsB6mBa4fcPvQ0jNMHB9a3vbYjYpgUOOTQYDgPmgl1frl0A5xETkgz68gVynOpW
         KOro3SOHDjJmk/FKa9vMgDOYHnVHeP7Vw7Vc/Y6DzLogFToognRvI90Ki61Rb4MgYU
         6JopPADtMEKug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE673E52BF3;
        Mon, 29 May 2023 11:39:15 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ZHQe9A8CC93iCFMG@gondor.apana.org.au>
References: <YjE5yThYIzih2kM6@gondor.apana.org.au>
 <YkUdKiJflWqxBmx5@gondor.apana.org.au>
 <YpC1/rWeVgMoA5X1@gondor.apana.org.au>
 <Yqw7bf7ln6vtU/VH@gondor.apana.org.au>
 <Yr1XPJsAH2l1cx3A@gondor.apana.org.au>
 <Y0zcWCmNmdXnX8RP@gondor.apana.org.au>
 <Y1thZ/+Gh/ONyf7x@gondor.apana.org.au>
 <Y7fmtJHWT1Zx+A1j@gondor.apana.org.au>
 <ZARrt99wJb7IhoY4@gondor.apana.org.au>
 <ZFeldCJcieIlXKJ8@gondor.apana.org.au> <ZHQe9A8CC93iCFMG@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZHQe9A8CC93iCFMG@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 v6.4-p3
X-PR-Tracked-Commit-Id: 6ab39f99927eed605728b02d512438d828183c97
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7a6c8e512fa072cfe8ad7a3b26666b6f26435870
Message-Id: <168536035583.26850.7658776743639166971.pr-tracker-bot@kernel.org>
Date:   Mon, 29 May 2023 11:39:15 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Mon, 29 May 2023 11:41:40 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 v6.4-p3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7a6c8e512fa072cfe8ad7a3b26666b6f26435870

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
