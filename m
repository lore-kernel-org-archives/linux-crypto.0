Return-Path: <SRS0=ApwQ=4M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7217FC38BE0
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 20:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B2DD21744
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 20:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582575912;
	bh=HYM0NFUe8/gsTbLv+UZz00goi0LnoF+tZL7s26DcjUo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=vCdngQzrC98B4IU3bQ/BIDH0P19AjweoVjSSjsAUxPcJVIVy7zJZQ0AzJqdvBzB64
	 vQbdWOdNoYAraGUnToNzcf6zb0E11JjJ1LlaXxdbsVzFJ660TQkvTF0De9BoKiUps7
	 leFP4bT9gAv/9wv80Pjde08+LgoVRPVxgKjYYm9o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbgBXUZL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Feb 2020 15:25:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbgBXUZL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Feb 2020 15:25:11 -0500
Subject: Re: [GIT PULL] Crypto Fixes for 5.6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582575910;
        bh=HYM0NFUe8/gsTbLv+UZz00goi0LnoF+tZL7s26DcjUo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=tnoL2NvidhSTGp9r3hHST2FjLRMVzmIFtmJ9FD/KQSTvQhc/BD9VGIXf5uteKC9aa
         apHQwZ/wGrCKMwm+/BcMRuz0CiHCgIKfVI2gLF0Yq+b58gm9c1YgdmuFG1SfrfCvUe
         2lhaHfuosOF4zO2lBLTomNHC1lbrIa1U/sn8i+Ug=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200224060042.GA26184@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
 <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au>
 <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
 <20200224060042.GA26184@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200224060042.GA26184@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: c9cc0517bba9f0213f1e55172feceb99e5512daf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7031ecffab86199c2c688f7a723d03dfa6910fa6
Message-Id: <158257591092.9578.17346989825929490230.pr-tracker-bot@kernel.org>
Date:   Mon, 24 Feb 2020 20:25:10 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Mon, 24 Feb 2020 17:00:42 +1100:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7031ecffab86199c2c688f7a723d03dfa6910fa6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
