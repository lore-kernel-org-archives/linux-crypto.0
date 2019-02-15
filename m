Return-Path: <SRS0=bFfa=QW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62946C10F02
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Feb 2019 17:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30D2221925
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Feb 2019 17:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550250606;
	bh=HzMAk/Pjax0h0ML0vYeJe3mQA0oDzDwnpo72hWUlzM4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=H9qgi/eRcL3Ae5FydhXfzAq4L8bn/FBZHreF82C0sewUR7CztU1zvzeW1DQjRCyTI
	 YGgujF+rs8NZrwY9IJgEn9waai6i06bnPOt43/sDNtgRHsnjGWpMoO5IZScy4OfEo3
	 Qc4mplyugVr0LgrV5FNwaAzzeeHFUxHFu0zKMKVQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbfBORKE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Feb 2019 12:10:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbfBORKE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Feb 2019 12:10:04 -0500
Subject: Re: [GIT] Crypto Fixes for 5.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550250603;
        bh=HzMAk/Pjax0h0ML0vYeJe3mQA0oDzDwnpo72hWUlzM4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=POF0xKYP9wqC9N1Eofc0jZfDMIpXf54MXf/IklytLf5mI76NjLxqlXr99/9KxIwa4
         NobxITUGW2fbXuH/2rn0pjwgS8aRUvAukf8WRI+mfitX76XS0I4byCdur6oIhuK1ow
         mGWO7RszyYCVCXfdDgnnKttHNsV8Q2jnOEomV1tg=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
References: <20171222064931.GA27068@gondor.apana.org.au>
 <20180105073808.GA14405@gondor.apana.org.au>
 <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 1358c13a48c43f5e4de0c1835291837a27b9720c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2aba322074de0d6781f4ae6b44d3e792b9bd2243
Message-Id: <155025060394.11780.11662160614573441558.pr-tracker-bot@kernel.org>
Date:   Fri, 15 Feb 2019 17:10:03 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Fri, 15 Feb 2019 10:47:39 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2aba322074de0d6781f4ae6b44d3e792b9bd2243

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
