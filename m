Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE09C4332D
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Dec 2020 17:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFF0922512
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Dec 2020 17:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgL0R15 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Dec 2020 12:27:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgL0R1r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Dec 2020 12:27:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9FFA922581;
        Sun, 27 Dec 2020 17:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609090026;
        bh=yUOzKR1+ETI28Fwqi8cicFWSw3QA4T1yLWmEGV06c+A=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=WnGUPDcugOgcobVrEmZATTDWPMKoEHnwmKoVwS2vzzXNblwt70MpfM7Dgg/0zjjj4
         /IWATNysWShq+/jPfMLGFgz7LDJUe4qy1TyvNwSrfUuhRLDcDhcCo34gGt/LSrHJmJ
         A1iNcqh3FbFYRmvphSToB9nlK+h7KMFeCEdZA731MT/yOOiRsoL4gAP/zqdoNLBAxu
         IZcpA1V9KjmYrCuxIQGVSWwYSRnuE70eKM3sdLg/nFM7EDzc2eqKEG9G5S18Y7z0ZM
         iLLm720f+9P5o7dlt/qhc9BuRZcNs5LE7yt+bwOejHdOVUf7ZfNXlUba9+/SrbrwZs
         tn6NZs6fEfPTw==
Subject: Re: [GIT PULL] Crypto Fixes for 5.11
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201227113221.GA28744@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20200830223304.GA16882@gondor.apana.org.au>
 <20201026011159.GA2428@gondor.apana.org.au> <20201227113221.GA28744@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201227113221.GA28744@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: c0e583ab2016de8dedfb73934d4c4e8ff5bd896c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 33c148a4ae7dc3cd440f6c0d746ac7f0ff320682
Message-Id: <160909002662.19416.10600482594063014941.pr-tracker-bot@kernel.org>
Date:   Sun, 27 Dec 2020 17:27:06 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Sun, 27 Dec 2020 22:32:21 +1100:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/33c148a4ae7dc3cd440f6c0d746ac7f0ff320682

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
