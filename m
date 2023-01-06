Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D70C54EBD
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Jan 2023 21:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbjAFVTS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Jan 2023 16:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236426AbjAFVTH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Jan 2023 16:19:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559F081D4E;
        Fri,  6 Jan 2023 13:19:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08162B81ECB;
        Fri,  6 Jan 2023 21:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4EE7C433F0;
        Fri,  6 Jan 2023 21:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673039940;
        bh=DQVWB0K5khEPAM6N0U6SCCfFquRHQV2sZN5Ca/Nyuvc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=gKLzh0OaJzRx4d5cQ8+Zl9InDG0giXEFHGWj0IdXeC9wf10ZdK76wBdlVEMFeSFHi
         u6ZWTa6bdMyu0zmW/1GEvrSuACej1ioy4wZxDQnpMPTeHH9n++so2qEGW07IBPGVxJ
         8Zm3QVMkIJD7hF3Bj+QAPauhFyF8nPOUWYF+uANEEHC3hj6IK9yfHQ8x271lSWXW3O
         vnsm+xbVe6cbBJE331Mfe8grLceb1/8PGtJF91d0z/qHiVMsoT8sHCif1u8dwIt7aC
         LPo1epsDawNQLwS1ETKRXcNTVQ3E6RpJl/aBJqHDA2IoknoMu4zE8aTGIMgn/K2Jog
         vZGAgOnTvLQWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 90E60E5724D;
        Fri,  6 Jan 2023 21:19:00 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <Y7fmtJHWT1Zx+A1j@gondor.apana.org.au>
References: <20211112104815.GA14105@gondor.apana.org.au>
 <YcKz4wHYTe3qlW7L@gondor.apana.org.au>
 <YgMn+1qQPQId50hO@gondor.apana.org.au>
 <YjE5yThYIzih2kM6@gondor.apana.org.au>
 <YkUdKiJflWqxBmx5@gondor.apana.org.au>
 <YpC1/rWeVgMoA5X1@gondor.apana.org.au>
 <Yqw7bf7ln6vtU/VH@gondor.apana.org.au>
 <Yr1XPJsAH2l1cx3A@gondor.apana.org.au>
 <Y0zcWCmNmdXnX8RP@gondor.apana.org.au>
 <Y1thZ/+Gh/ONyf7x@gondor.apana.org.au> <Y7fmtJHWT1Zx+A1j@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <Y7fmtJHWT1Zx+A1j@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.2-p2
X-PR-Tracked-Commit-Id: 736f88689c6912f05d0116917910603a7ba97de7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 90bc52c525fdac4ed8cbf13c08c813ec2a4fc856
Message-Id: <167303994058.10294.10697135724767945601.pr-tracker-bot@kernel.org>
Date:   Fri, 06 Jan 2023 21:19:00 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Fri, 6 Jan 2023 17:15:32 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.2-p2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/90bc52c525fdac4ed8cbf13c08c813ec2a4fc856

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
