Return-Path: <SRS0=9//E=BY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A994DC433E1
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Aug 2020 20:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 790C7206C0
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Aug 2020 20:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597437292;
	bh=ZYAKTMixhsAxwqGc64zD7+lYHJZVqcZX6SlY3GmH6SU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=V2+DqagYY1kFlaOXoMqSIc0YBHlPRQWUwbqd44J6GoAXSUrSlTormpYPX4CJcTNq2
	 wCg3GaimR6ZCscrJseH/InSsINTpDhj3weJJ2WwaLs9ia3jIesgH6gRUuTpiN3I4sf
	 Li5j1pnhLGE5aAAh/Qckv9M0U+99v87Ckx7KVVyE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgHNUev (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Aug 2020 16:34:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgHNUev (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Aug 2020 16:34:51 -0400
Subject: Re: [GIT PULL] Crypto Fixes for 5.9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597437289;
        bh=ZYAKTMixhsAxwqGc64zD7+lYHJZVqcZX6SlY3GmH6SU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=v9gOd6jYiCr94sicRl62Y0obLHEPilfvzSectuXdLQYS73XBSFtGZrFWPsSyLWT1C
         FWn/+Lgewa0bS3viNNzw2aeP2oCNO99Qlz0D9ZTn6wW90fg+e1p8lAnRfVsMHNOuHY
         LNBy/p0OzeV7PzdVAto/8nFFsLPH2WmUWS9UpqGU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200814131817.GA8147@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
 <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au>
 <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
 <20200408061513.GA23636@gondor.apana.org.au>
 <20200611040544.GA27603@gondor.apana.org.au> <20200814131817.GA8147@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200814131817.GA8147@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 21dfbcd1f5cbff9cf2f9e7e43475aed8d072b0dd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d9361cb285281563adada9b16708b12053bd6531
Message-Id: <159743728959.11329.10172436795875749032.pr-tracker-bot@kernel.org>
Date:   Fri, 14 Aug 2020 20:34:49 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Fri, 14 Aug 2020 23:18:18 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d9361cb285281563adada9b16708b12053bd6531

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
