Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A5CC04E53
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 16:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36B8A20881
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 16:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557936616;
	bh=S3xsJ9D2FBrUrUut4SDDJZr9fkFftSXWha+RF701Ghk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=L0qp3GirSI/D9eFLgTFdb7BrhyI1E2D+WLX9KHtbDfMh+UvTY34LdqycGtR+fbC4Y
	 JADC+tA4EzEtUUGOxXVP6SwUiDMc2C8HWAAbxr/X/wnYngEZnXB8ZrPTgqTKR3yH+m
	 /1bw2IJFZhHvMy+FwC4VLIyc0YyjZAhPgojXK6Pw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfEOQKP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 12:10:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbfEOQKP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 12:10:15 -0400
Subject: Re: [GIT] Crypto Fixes for 5.2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557936614;
        bh=S3xsJ9D2FBrUrUut4SDDJZr9fkFftSXWha+RF701Ghk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=GWkWaVgsXPQ+oFpx0EdKaSI3uHOcIPf85Cr4ZnFBEP0vQHqjXu6pbXFkMGPaSSOlp
         sXRJGofYq6r8luO49u2QPUPCaJK5vbd5wMb10gZ3zuANMKyuzMfH5wJvByPvbukz6/
         cPy3+LJk3Rk+M7xnaYQAlB/18XsnV4HMjO4dI98I=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190515060552.ecfwhazt2fnthepg@gondor.apana.org.au>
References: <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
 <20190312045818.bgpiuxogmaxyscdv@gondor.apana.org.au>
 <20190515060552.ecfwhazt2fnthepg@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190515060552.ecfwhazt2fnthepg@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: cbc22b062106993980df43a7ffa93351d3218844
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 88f76bc31b93cc228f5a43d5b565dc53615970ae
Message-Id: <155793661488.5377.14250847400138191195.pr-tracker-bot@kernel.org>
Date:   Wed, 15 May 2019 16:10:14 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Wed, 15 May 2019 14:05:52 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/88f76bc31b93cc228f5a43d5b565dc53615970ae

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
