Return-Path: <SRS0=6oT7=ZS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F56C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 04:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A9B320836
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 04:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574742334;
	bh=0UAFpaqUXTb/xXEEmjS/LdyfXz7Ox4fiV24f5sFKrEc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=hzoFDN4YjreryLqE9UjUUBS1/KFy3Bquq2E0QctnWaBqi/D+29xYxeK96brkY+Z/f
	 qTN259H95bRQpp2ANMCiLVtwyLUPQplu2BnqJcf7Mt9lx7/nJQSsI3e3hhIKU6z6NX
	 Rgx9vExVXnepc5ejJrX8SuQvSLejWXVti3KMidV8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfKZEZJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Nov 2019 23:25:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:59788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbfKZEZH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Nov 2019 23:25:07 -0500
Subject: Re: [GIT PULL] Crypto Update for 5.5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574742307;
        bh=0UAFpaqUXTb/xXEEmjS/LdyfXz7Ox4fiV24f5sFKrEc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=XQ80ym9qoCTTd3cDeY1u1FEmSOcdQRkv/GjWD3TbIWOYjtfQXYmpSqg65aTJso2qK
         jZkZUd90fr8pd3lgZB/KvugSUY607YMAoz9w6fRZ9L09TAlznEJGwlR7QQJft1hFkq
         KR++p5nOsxAPSQMsO/q0Je3t+247t39Z22grjPmg=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191125034536.wlgw25gpgn7y7vni@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20191125034536.wlgw25gpgn7y7vni@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191125034536.wlgw25gpgn7y7vni@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 refs/heads/master
X-PR-Tracked-Commit-Id: 4ee812f6143d78d8ba1399671d78c8d78bf2817c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 642356cb5f4a8c82b5ca5ebac288c327d10df236
Message-Id: <157474230722.2264.10245207484531370133.pr-tracker-bot@kernel.org>
Date:   Tue, 26 Nov 2019 04:25:07 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Mon, 25 Nov 2019 11:45:36 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/642356cb5f4a8c82b5ca5ebac288c327d10df236

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
