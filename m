Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54540C43218
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 16:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB76A2088F
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 16:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556209507;
	bh=Fvu9Scboft/BCvNUwlEB95bSImiEN9ADyc5SyNZAnfE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=0Jx64ljPL1q7FHOYIb915bazNEQeu4J/OWeg6ag42ttuDjRRu33EYlEuGAgx4Vsop
	 8kMmdIqXsMwK01IYaqa5PWC7zT2TkIZTAtJXXoK/7uVi7HVrOCs/DZQQrPrOfr9N6J
	 MSrqeFSSKdcgaDH7SMnGAixgt+iuaG85vrbQS3d0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfDYQZF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbfDYQZF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 12:25:05 -0400
Subject: Re: [GIT] Crypto Fixes for 5.1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556209505;
        bh=Fvu9Scboft/BCvNUwlEB95bSImiEN9ADyc5SyNZAnfE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=tgVBoQsQTnjbsmGB2Nv8SZonB7HFEEBnPWbnPiDMPth4SRcxTItqR5keQW5kuvQjb
         esuexMU7pSHnYB+OGG/CRTdXvnxXBfBaDEOZJI1qRSE1hqq7up+VmUPfeB00JAown0
         oXHDz1iveoQtNQBTvzHrf9aF+q0uJEckWSmGPfEI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190425072648.zqt5ft5d33q4njzj@gondor.apana.org.au>
References: <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
 <20190312045818.bgpiuxogmaxyscdv@gondor.apana.org.au>
 <20190408054823.4jedcfql7woverqb@gondor.apana.org.au>
 <20190418051741.rveqa67qhh5trj7w@gondor.apana.org.au>
 <20190425072648.zqt5ft5d33q4njzj@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190425072648.zqt5ft5d33q4njzj@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: b257b48cd5830c5b1d0c347eb281f9c28056f881
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f6f3e747454fc539bbd7904cf70672368289d820
Message-Id: <155620950502.1828.15719098092437886671.pr-tracker-bot@kernel.org>
Date:   Thu, 25 Apr 2019 16:25:05 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Thu, 25 Apr 2019 15:26:48 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f6f3e747454fc539bbd7904cf70672368289d820

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
