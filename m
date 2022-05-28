Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51979C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 28 May 2022 01:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355417AbiE1BVb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 May 2022 21:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241873AbiE1BV3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 May 2022 21:21:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF56612AB30;
        Fri, 27 May 2022 18:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A9F1B82637;
        Sat, 28 May 2022 01:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 234CCC385A9;
        Sat, 28 May 2022 01:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653700885;
        bh=81OIyW59KL8zJ4RBHbad9qMQj/FTbdeHmPCRRO0/qNA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=rOCAah0RXphFxUzkB591gIW70wLBpuvx8V54ATcTmaCdgoGN2Uu83JjzfYYoSFoz5
         hn4fwWGbPsnarqsoxVpqyaWTKckBX8njt0nW/QlfLiWE07XU0xVl4SSIKfilFLs1ry
         iE89GLC/VnDYRCWFqfYWtQda0EqpV/UvakobW5igs+sr4TFrBcajgJJxmiYaw0RbgY
         ZFkT7Diyb/MsDJR9MZzCa6dtKGBs+ogkgM2Hy+aF5rjtbdYIOBJxVi5g0Id0aIjeDK
         4aim6YbE8p/UaQGKbYpSLpRoUv5fZQCdMGupuNJm11rfF1uybJA1p7Gm1DIcG0ZbhO
         N4RCGuffAZpFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 10589EAC081;
        Sat, 28 May 2022 01:21:25 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 5.19
From:   pr-tracker-bot@kernel.org
In-Reply-To: <YpC1/rWeVgMoA5X1@gondor.apana.org.au>
References: <20210108035450.GA6191@gondor.apana.org.au>
 <20210708030913.GA32097@gondor.apana.org.au>
 <20210817013601.GA14148@gondor.apana.org.au>
 <20210929023843.GA28594@gondor.apana.org.au>
 <20211029041408.GA3192@gondor.apana.org.au>
 <20211112104815.GA14105@gondor.apana.org.au>
 <YcKz4wHYTe3qlW7L@gondor.apana.org.au>
 <YgMn+1qQPQId50hO@gondor.apana.org.au>
 <YjE5yThYIzih2kM6@gondor.apana.org.au>
 <YkUdKiJflWqxBmx5@gondor.apana.org.au> <YpC1/rWeVgMoA5X1@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <YpC1/rWeVgMoA5X1@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v5.19-p1
X-PR-Tracked-Commit-Id: e4e62bbc6aba49a5edb3156ec65f6698ff37d228
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d075c0c1be279c5f4c6688ac0442fff6494e56bc
Message-Id: <165370088505.10997.16739846821297828541.pr-tracker-bot@kernel.org>
Date:   Sat, 28 May 2022 01:21:25 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Fri, 27 May 2022 19:29:02 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v5.19-p1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d075c0c1be279c5f4c6688ac0442fff6494e56bc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
