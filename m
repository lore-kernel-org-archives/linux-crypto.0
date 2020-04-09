Return-Path: <SRS0=VxYc=5Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFF2C2D0EA
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Apr 2020 04:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9656F20757
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Apr 2020 04:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586408145;
	bh=nJh3It1f33AWj6QKhfbCSxlUGc9AwMrcvBA8sSIJW7k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=Q1AkX7mSQw2Q04LBiYYER/o1TZafMIbW4gn6Ce6zsLygRiZ+xYgJECCmEsjGGcdAW
	 CKGWQIiRm+d5RiV/QdC9F/BTAbRPA6rLHWWY+4Rl5XighhT0IC5CHWbqYvWHYDTgi3
	 73n9o+8USQkAsojaKmMgN/WPQktRl0kSKMv2VwoM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgDIEzc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Apr 2020 00:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgDIEzb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Apr 2020 00:55:31 -0400
Subject: Re: [GIT PULL] Crypto Fixes for 5.7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586408132;
        bh=nJh3It1f33AWj6QKhfbCSxlUGc9AwMrcvBA8sSIJW7k=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=10A1/aZNGFEu1NTORAeA5I2qLzII3QrZOYEbj7Ss6loEniLFEX87L6T9+UBXLP5Vl
         bAF741J9j/nk5k1pYhH7SaKwP954CPkW3OiKwq8I0I0fXdmuNQaD+zkYwEG5SByPh2
         C0hkvlBeu6Va6rc5TIlv83hJmcfwRHlV/+vB8r2Q=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200408061513.GA23636@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
 <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au>
 <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
 <20200408061513.GA23636@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200408061513.GA23636@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 755bddd1e4eaf9178758bd554c60aaab46fc42ba
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d8fc9cde85d829eed6ca050d86799cc4cfa6a048
Message-Id: <158640813200.3202.15552752765181066219.pr-tracker-bot@kernel.org>
Date:   Thu, 09 Apr 2020 04:55:32 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Wed, 8 Apr 2020 16:15:13 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d8fc9cde85d829eed6ca050d86799cc4cfa6a048

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
