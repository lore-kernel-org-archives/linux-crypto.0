Return-Path: <SRS0=adZw=7Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D164C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 18:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D74D220838
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 18:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591899924;
	bh=kTLLMVnlRM+509pU2bE1L1inuem8tZe8/XTl+lj4/74=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=pyiHr9pFfLNCcTOES9+muDb1qKBfKRiBjUpvTpkQUCO5toK5n+IL0pdMhpXIAYtXx
	 68h5LJZ8ZKKy544L7eV0loXhYVco8WRzxQLpGnyWrawzcTWqRHtNLpxElShkmxp5Vr
	 g4h8NTcs+19L1CmBP5zxtOhx8AIeqdi3VO7gRnik=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgFKSZY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jun 2020 14:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728237AbgFKSZX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jun 2020 14:25:23 -0400
Subject: Re: [GIT PULL] Crypto Fixes for 5.8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591899923;
        bh=kTLLMVnlRM+509pU2bE1L1inuem8tZe8/XTl+lj4/74=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ds9vecPOrJDxEDNFyRbIvtNeemHGIV7hPPOYL5uWXKMOKANHuHJd55NOPu+cQMiHh
         bBu4X17dkBOoEQE4gfGaqu+pKO9D31MMYsAPsC8lRUBTHxPHtFkBozSptHXsxLaB6R
         2826jeXXxMoihJDUZAq0HxNoYbgubiCjgulXcBIQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200611040544.GA27603@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
 <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au>
 <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
 <20200408061513.GA23636@gondor.apana.org.au>
 <20200611040544.GA27603@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200611040544.GA27603@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 320bdbd816156f9ca07e5fed7bfb449f2908dda7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e8de4575cf7601917c2eae9f8ee1a8ee3d9be2a7
Message-Id: <159189992371.7248.9813414443421093811.pr-tracker-bot@kernel.org>
Date:   Thu, 11 Jun 2020 18:25:23 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Thu, 11 Jun 2020 14:05:44 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e8de4575cf7601917c2eae9f8ee1a8ee3d9be2a7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
