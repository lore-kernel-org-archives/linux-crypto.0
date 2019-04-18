Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88D9C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 15:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DB822083D
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 15:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555600816;
	bh=uw1EPQGXOUv+9daVdEBorMMcvRB8V5nG5bjqGFF9GKQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=Mv+l2BG8zkabSIB/J6IdJr3mpAsTl1QVQUPq7n1VknwvSUjoH2yt4Mtd76rpyhteF
	 vF7mSVrmBxaX7QZNhCPR75qPY0nBw5fYG9vytukdPMdsVsB2gtvrRAK7yAEwa8FWhG
	 QpvmuFOBz3+vInsGtANXvAxr1z1LFUptFe0j97aU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389540AbfDRPUG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 11:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388842AbfDRPUF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 11:20:05 -0400
Subject: Re: [GIT] Crypto Fixes for 5.1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555600804;
        bh=uw1EPQGXOUv+9daVdEBorMMcvRB8V5nG5bjqGFF9GKQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=T91EB+CHTqltw82POP1Ov2h+amkA7Y8KAx30108+GMSOwNRRvKfuP83fUKGvfB41s
         CBE1jkSrYgV7pe35296D8C+MqfboHFFVJ1xJyEPCWQhqIfjxCF5JwON8RVxXli+xmL
         BppTBAYK1DE2gfM1xH0eLQ0tAU4yG+k6H+zXA+XE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190418051741.rveqa67qhh5trj7w@gondor.apana.org.au>
References: <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
 <20190312045818.bgpiuxogmaxyscdv@gondor.apana.org.au>
 <20190408054823.4jedcfql7woverqb@gondor.apana.org.au>
 <20190418051741.rveqa67qhh5trj7w@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190418051741.rveqa67qhh5trj7w@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 678cce4019d746da6c680c48ba9e6d417803e127
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d3ce3b1879ffb991d3894b57cda8610827fbdef3
Message-Id: <155560080468.14770.10265401303042368404.pr-tracker-bot@kernel.org>
Date:   Thu, 18 Apr 2019 15:20:04 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Thu, 18 Apr 2019 13:17:41 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d3ce3b1879ffb991d3894b57cda8610827fbdef3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
