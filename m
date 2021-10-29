Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920D4C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 18:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81E0760FF2
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 18:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhJ2SwD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 14:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230325AbhJ2SwD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 14:52:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2AC9760F4B;
        Fri, 29 Oct 2021 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635533374;
        bh=dUa5okgW+5K5TjZQub9JUubnjey4B5GhNsqS+9vAB2I=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=lJDRmnl2azRz/dvcy+xz2ltuItHgUn1/OZW20hQXRv5Xd5Qt3DPQYvqKN8lv/OI7n
         gq0WnB/uoh9rZZBJpEveEl4IMph1chCBS0+zH27PkYLUcVFWL3Vsu0zD4KWsX4GI43
         AL8WeRpoRdkdhE7sweKQysfP2JQH7kwVJ7XokBC0UyX3ZRJ8cO+vFqjg1hN4DGfSQH
         PGAYYJSEUkFWKfdkgXYqyLSuZOfc72SoVasFcdI3vocf7NHfWhKAVtL3DqNr5mCpI4
         gnz2vhOKEE1OIgVYSiA1vDZib0DdV7yiauwvO3sI8+kA2qJY630JbWiitmH3zR1nw4
         xIZ81DXgxOsag==
Subject: Re: [GIT PULL] Crypto Fixes for 5.15
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211029041408.GA3192@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20200830223304.GA16882@gondor.apana.org.au>
 <20201026011159.GA2428@gondor.apana.org.au>
 <20201227113221.GA28744@gondor.apana.org.au>
 <20210108035450.GA6191@gondor.apana.org.au>
 <20210708030913.GA32097@gondor.apana.org.au>
 <20210817013601.GA14148@gondor.apana.org.au>
 <20210929023843.GA28594@gondor.apana.org.au> <20211029041408.GA3192@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211029041408.GA3192@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: f8690a4b5a1b64f74ae5c4f7c4ea880d8a8e1a0d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 75c7a6c1ca63131875fe869cbfd404c94d0e1944
Message-Id: <163553337413.6387.6763795889603013861.pr-tracker-bot@kernel.org>
Date:   Fri, 29 Oct 2021 18:49:34 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Fri, 29 Oct 2021 12:14:09 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/75c7a6c1ca63131875fe869cbfd404c94d0e1944

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
