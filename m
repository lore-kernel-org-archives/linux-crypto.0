Return-Path: <SRS0=/HXT=5R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D17C43331
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 22:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2F0B2082F
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 22:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585780517;
	bh=LRgdnLuJcS7/CWipB+tmFu5gtxtwhF87azfE0yMxQdA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=EI5vbXlIpEoBsVkfYRYQhpTB8AIg8zPILe6HnYyqXSFkFbpDGg6G+kviR6nGOyaPt
	 tjkJF+FZ9PivVRn8EjEOk6DCDiWB/aB8bw1HOuzbJuzZYyPDz4knWo57XCJtuwm3kT
	 5+CIovJjA/3IPwjJhx5TEakZ5rrM3ox7OJOhBWCo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733178AbgDAWfR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Apr 2020 18:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733164AbgDAWfR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Apr 2020 18:35:17 -0400
Subject: Re: [GIT PULL] Crypto Update for 5.7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585780516;
        bh=LRgdnLuJcS7/CWipB+tmFu5gtxtwhF87azfE0yMxQdA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=WXsbK81hcirKmkkpYGuh0ly2DBD4lRq/LDheRSqa53asa25Gz1hrqFNVySkIUF12U
         YI/+QAReEmOn3Dyy0kAvjBjgJ4fO+Td6Dd1JOaQtODBz3BkwYsiooeT7Ntzw/5CED9
         eF4hLivqgjcy8rpcYUlvW5S04ME1Bo4Flrx1jrwY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200401042720.GA12178@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20191125034536.wlgw25gpgn7y7vni@gondor.apana.org.au>
 <20200128050326.x3cfjz3rj7ep6xr2@gondor.apana.org.au>
 <20200401042720.GA12178@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200401042720.GA12178@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: fcb90d51c375d09a034993cda262b68499e233a4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 72f35423e8a6a2451c202f52cb8adb92b08592ec
Message-Id: <158578051648.24680.17707593369397670566.pr-tracker-bot@kernel.org>
Date:   Wed, 01 Apr 2020 22:35:16 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Wed, 1 Apr 2020 15:27:21 +1100:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/72f35423e8a6a2451c202f52cb8adb92b08592ec

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
