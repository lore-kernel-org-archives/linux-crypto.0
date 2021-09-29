Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C06FC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Sep 2021 14:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 031A06140F
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Sep 2021 14:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344681AbhI2OxF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Sep 2021 10:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344650AbhI2OxE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Sep 2021 10:53:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A0FBB6140F;
        Wed, 29 Sep 2021 14:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632927083;
        bh=4MTYS0Wrxq32jGccn2+z0xjkc8jblxaTyP1QSt/tfmE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=LNAo6Pdakidd25x+Tbv9IhkDmCmyfT57EahT4+Qk80Qdn65Q6dNQ6+ZaGX8+/xSiO
         6vSpkaEs+C1AXqFw1NObsEKz05iE43DOljANTLI2Jhvl0fTLFvFOoJ3m6UXKt4JYnN
         VGF8RYLWwQgbKGBDc740HZ8ZD6IT6f7lmebibsPSEK4GIiZpEaArSGt1eIjdhb+omK
         X4pFMPqvt7uXVyRn6PqJsHzusTSG4qFCdcui8x/CZpuKzgaXJ1zkR2kEd15q4DKQOf
         RJjUexNB3y7iJ8HiyN7G+D8GerddMpczFLwMe2LiGw96biTzQ5oP7PEw2h462rdu//
         bmIry8iZB3wzA==
Subject: Re: [GIT PULL] Crypto Fixes for 5.15
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210929023843.GA28594@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20200830223304.GA16882@gondor.apana.org.au>
 <20201026011159.GA2428@gondor.apana.org.au>
 <20201227113221.GA28744@gondor.apana.org.au>
 <20210108035450.GA6191@gondor.apana.org.au>
 <20210708030913.GA32097@gondor.apana.org.au>
 <20210817013601.GA14148@gondor.apana.org.au> <20210929023843.GA28594@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210929023843.GA28594@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 0e14ef38669ce4faa80589247fe8ed8a3780f414
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6e439bbd436e39f15abc9587cdd23d56257780cb
Message-Id: <163292708352.10457.5947662652430933621.pr-tracker-bot@kernel.org>
Date:   Wed, 29 Sep 2021 14:51:23 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Wed, 29 Sep 2021 10:38:43 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6e439bbd436e39f15abc9587cdd23d56257780cb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
