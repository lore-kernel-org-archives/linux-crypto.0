Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E534CD4844
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Sep 2023 16:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbjIVQnQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Sep 2023 12:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbjIVQnN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Sep 2023 12:43:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E819194;
        Fri, 22 Sep 2023 09:43:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD19CC433CB;
        Fri, 22 Sep 2023 16:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695400987;
        bh=agnFLu86wxOsCv6hqcPTqig9ZdZP7owzznCNcWLQPpk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=YvfPIOhn5d7+xL9D6jlZY+lIy9RE1ZjomH+mVemwJVbpKsobzdRSRQmVz0ZzYRt7r
         2Olc7YVhiG1E4D/5lT0Wj8ThV1QixpQNN5x2/x9h2rj5tJqEFZGscW0hORyWsI9QxD
         ogfpHlzZrxBiMierhCcy0uaPZlgFOumAPIEQyxvhr+CNCqAUIGl65Sc0HJefJ28fbx
         UedN+9thACJGTAwE8Xm6THuSnPgyOIXTmiPHcdKAZeAct4MrbH+SSlUfiPBB4G6f3p
         WLBmogwMYHERbUOhDUKLA9BjLNlVOl3NyQ2VTW1RoVZ+v6mRiMRpHBqH+3ZKHA/6hd
         9MJU1BJR88VWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B2B1C04DD9;
        Fri, 22 Sep 2023 16:43:07 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ZQz3qxwwAjDaqi5V@gondor.apana.org.au>
References: <Yr1XPJsAH2l1cx3A@gondor.apana.org.au>
 <Y0zcWCmNmdXnX8RP@gondor.apana.org.au>
 <Y1thZ/+Gh/ONyf7x@gondor.apana.org.au>
 <Y7fmtJHWT1Zx+A1j@gondor.apana.org.au>
 <ZARrt99wJb7IhoY4@gondor.apana.org.au>
 <ZFeldCJcieIlXKJ8@gondor.apana.org.au>
 <ZHQe9A8CC93iCFMG@gondor.apana.org.au>
 <ZKtH5zrS4pR22PGT@gondor.apana.org.au>
 <ZOLcCC523FoBAyv0@gondor.apana.org.au>
 <ZPAiMYaqUslSyZ6+@gondor.apana.org.au> <ZQz3qxwwAjDaqi5V@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZQz3qxwwAjDaqi5V@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.6-p3
X-PR-Tracked-Commit-Id: 21155620fbf2edbb071144894ff9d67ba9a1faa0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2f8d62daf2b5d9835ccd1ae0407de130156c17c1
Message-Id: <169540098762.17578.3605776358546603234.pr-tracker-bot@kernel.org>
Date:   Fri, 22 Sep 2023 16:43:07 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Fri, 22 Sep 2023 10:10:51 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.6-p3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2f8d62daf2b5d9835ccd1ae0407de130156c17c1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
