Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C58C4332B
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 23:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06E1C2073E
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 23:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585004709;
	bh=8Kbx+YuPM/kjl/gzSlFEWqeDnOrd7rW3lT6qNKD2TGE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=1CRgvCscOb8H/zTiuRImH2+bBxVep4xq0HKar7oc4ip8N2/zl52+KrniSNjsl0RBd
	 8kqXKAIC3tpEM8YYCGsazm864zUHqVq6FpO8wFGsFUIf64nRrkT+EXiaD0HwRs8jbr
	 YHhyPiCBKNjZ0fg5MVcaGxeMErOqiNRLNHN/jWs8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgCWXFI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 19:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgCWXFI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 19:05:08 -0400
Subject: Re: [GIT PULL] Crypto Fixes for 5.6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585004707;
        bh=8Kbx+YuPM/kjl/gzSlFEWqeDnOrd7rW3lT6qNKD2TGE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=gh9N4QYcxURA1vuQFp9X/9vN6jCysP/P03cueNfUJCEfemtKsTLS1covr9hYe6r7h
         NQfwsSX792qAPbQquM/9UWdEVfXyco3VcCYWdSsmmdBPiS4dZBE9ajciSYACkz9zE/
         NZNbOftpssAWUHRnxNxqsyOIMfrL9H1cw9BrvonA=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200323225403.GA10100@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
 <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au>
 <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
 <20200224060042.GA26184@gondor.apana.org.au>
 <20200312115714.GA21470@gondor.apana.org.au>
 <20200323225403.GA10100@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200323225403.GA10100@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: c8cfcb78c65877313cda7bcbace624d3dbd1f3b3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 979e52ca0469fb38646bc51d26a0263a740c9f03
Message-Id: <158500470751.3923.15723237667884136785.pr-tracker-bot@kernel.org>
Date:   Mon, 23 Mar 2020 23:05:07 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Tue, 24 Mar 2020 09:54:03 +1100:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/979e52ca0469fb38646bc51d26a0263a740c9f03

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
