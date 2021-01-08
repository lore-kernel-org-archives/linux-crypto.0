Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C1BC43381
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 20:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CD6123A9C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 20:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbhAHUgw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jan 2021 15:36:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729342AbhAHUgr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jan 2021 15:36:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1B25D23AC0;
        Fri,  8 Jan 2021 20:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610138167;
        bh=suKmYRChMg59UeP8h5ovz4ks+SbFS4gN8LXaH+t3mpc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=s2Zz0Ql0WP00aQbR4ydcsZh6+iX0pRZriHcgB7+n9tCdCH/Amx9NyotwORYa0YrLX
         jGGEHPS17/lkLXvBTrWu/TcCnGpu0/7NQ53qj4sEHvs7g0EZBSGB9sarKBsWdMzdb+
         8apfZadqYfmwqNeNaCWEaCBdJZo5sOQzKxnDKmMOLW6lHM3HjY+iKpWnUXnQArgbHF
         1jBS7Zki7obNGlkaUiN64uKr/R12kZEpxerEvfaSDCDDIuPxilOTU7fdkyiVfqRjGW
         NJZgjToZ3J/fS26PbLgfM0HnK8TFZ0D07cncRQ7/tRwflZUVOBbS1UR0Q6iGj0wfow
         6GmeA7GKk5FtA==
Subject: Re: [GIT PULL] Crypto Fixes for 5.11
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210108035450.GA6191@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20200830223304.GA16882@gondor.apana.org.au>
 <20201026011159.GA2428@gondor.apana.org.au>
 <20201227113221.GA28744@gondor.apana.org.au> <20210108035450.GA6191@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210108035450.GA6191@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 0aa171e9b267ce7c52d3a3df7bc9c1fc0203dec5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ea1c87c156d94dd78b4f5267ec40c403b2da7e14
Message-Id: <161013816709.21693.17874596360461078655.pr-tracker-bot@kernel.org>
Date:   Fri, 08 Jan 2021 20:36:07 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Fri, 8 Jan 2021 14:54:50 +1100:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ea1c87c156d94dd78b4f5267ec40c403b2da7e14

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
