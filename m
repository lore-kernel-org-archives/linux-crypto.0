Return-Path: <SRS0=Q7wt=RI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CA9C43381
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 17:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5609920675
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 17:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551807611;
	bh=e+z91fk2LWZBWFR5shJS26qkF3zRWV8rEgGmO5dvoBY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=G2qFrTvSoWg5EPncdgptwe+dAKUWsUjjh5bT+qaLD3UM22BBG/yNwwKFpmW9JIzQA
	 2lozo8c10G/YQRoU4Tb7B3s+A44w6GwOzDHIPrb5+3Tzce+6yh+EWWUaU8+hFXURkm
	 faO7PzQ1pbx9JtLm/8t+kAHgH5VKxRZELCZWMwME=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfCERkE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Mar 2019 12:40:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbfCERkE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Mar 2019 12:40:04 -0500
Subject: Re: [GIT] Crypto Update for 5.1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551807603;
        bh=e+z91fk2LWZBWFR5shJS26qkF3zRWV8rEgGmO5dvoBY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=S1KdCMWxEEDvszBeJza3a9ReWF3tyCG/qNwHGce2m9xoyl60GZt5DyHejOveVjtTQ
         G1jiWffvOSGK0zVeTVywqMwusQvRJhGup3yBZ4SsDXxD4cMjHb43sR7BFvG16fdKbg
         Nm5epT8By1awXUwSUGURZ25SvlNTuHNbECCDgFQQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190305081155.7rpkydnc4ipm43o6@gondor.apana.org.au>
References: <20180105073808.GA14405@gondor.apana.org.au>
 <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
 <20190305081155.7rpkydnc4ipm43o6@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190305081155.7rpkydnc4ipm43o6@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 0918f18c7179e8cdf718d01531a81b28130b4217
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 63bdf4284c38a48af21745ceb148a087b190cd21
Message-Id: <155180760360.1948.15848062740945412667.pr-tracker-bot@kernel.org>
Date:   Tue, 05 Mar 2019 17:40:03 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Tue, 5 Mar 2019 16:11:55 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/63bdf4284c38a48af21745ceb148a087b190cd21

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
