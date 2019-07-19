Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BB8C7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 19:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 871C72085A
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 19:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563565562;
	bh=Hcek8sgRWswciR4di4qADB2G9wfeT6ma69hYEzp0EcE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=y1Xpwo96zUCq0ztEnsVpHlHLVoChXzFGambHX1oklvXGhAxkKXXnY0tErO0MKkVM9
	 8UsAQ27pYI+3/5Qe1VoDDKmdvt9UhozL5+jlFcP/VzI6bj1NG5j+8g0Ryd8/seP0zC
	 5/+d4q82Mp+YEoADnL1zhXZ6SS8qNzABQhbM/K/g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387485AbfGSTpV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 15:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387481AbfGSTpU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 15:45:20 -0400
Subject: Re: [GIT] Crypto Fixes for 5.3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563565520;
        bh=Hcek8sgRWswciR4di4qADB2G9wfeT6ma69hYEzp0EcE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=HZJiRAASSXNQVBNiFTBylvYOdO5BCpq5k+75cupaB4A+0MRlBgAdZ+gUBLGkYsdDC
         mfAQOcq/P73N60PPJLWftnhIe30cwkvsKTfEI7emMxl9t1FN+WG063amMC8I31fYGY
         4eH1qnOiaFvp+40rUr271xpjf283co1iRBsaDW3w=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190719031206.nxyxk4vj6dg7hwxg@gondor.apana.org.au>
References: <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
 <20190312045818.bgpiuxogmaxyscdv@gondor.apana.org.au>
 <20190515060552.ecfwhazt2fnthepg@gondor.apana.org.au>
 <20190719031206.nxyxk4vj6dg7hwxg@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190719031206.nxyxk4vj6dg7hwxg@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: cf144f81a99d1a3928f90b0936accfd3f45c9a0a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dd4542d2823ac55cb86450960423f55e818aa182
Message-Id: <156356552025.25668.5097947581352741526.pr-tracker-bot@kernel.org>
Date:   Fri, 19 Jul 2019 19:45:20 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Fri, 19 Jul 2019 11:12:06 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dd4542d2823ac55cb86450960423f55e818aa182

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
