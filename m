Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFABC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 20:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3ED0610F8
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 20:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235554AbhKLUo6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 15:44:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231968AbhKLUo5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 15:44:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 52360610D0;
        Fri, 12 Nov 2021 20:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636749726;
        bh=dQUk4X2qOhzpCjHCPly9op5V1uDns0LwUl4joXekB5Q=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=d7TwD2E4xb4SRStHK/UCbdKBV26lrwuq5WYsOye6InZouqIfOwEQMg/xgul+mE45E
         /jus2l4MtO9lqF195+6sLV4etZTq3kF1LLz6Kpx6s+aF1oR+qobLJuAHJ1aChjf9wF
         fDkgzW1GwifR2mFGLepHbWbVevHniHxUlnsIs4AEeABzE+qNkzdwM3mPlal+7s0xXf
         dDag0zXfH7h9FiICJHvkMG78OoyNKeFDQTR/uEfElACtLZmIyn25nUJGF2Ab0BI07j
         Ipf5yFV2Ea/0wuZZueaAPoPaJV6XIPVBdWQA1wSQINxngZAp4SkAp4TetfYbMlz7JA
         +hQKZFELyOF4A==
Subject: Re: [GIT PULL] Crypto Fixes for 5.16
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211112104815.GA14105@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20200830223304.GA16882@gondor.apana.org.au>
 <20201026011159.GA2428@gondor.apana.org.au>
 <20201227113221.GA28744@gondor.apana.org.au>
 <20210108035450.GA6191@gondor.apana.org.au>
 <20210708030913.GA32097@gondor.apana.org.au>
 <20210817013601.GA14148@gondor.apana.org.au>
 <20210929023843.GA28594@gondor.apana.org.au>
 <20211029041408.GA3192@gondor.apana.org.au> <20211112104815.GA14105@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211112104815.GA14105@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: beaaaa37c664e9afdf2913aee19185d8e3793b50
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 66f4beaa6c1d28161f534471484b2daa2de1dce0
Message-Id: <163674972619.4802.15642938512992640681.pr-tracker-bot@kernel.org>
Date:   Fri, 12 Nov 2021 20:42:06 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Fri, 12 Nov 2021 18:48:15 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/66f4beaa6c1d28161f534471484b2daa2de1dce0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
