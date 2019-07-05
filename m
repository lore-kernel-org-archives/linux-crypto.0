Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E01C5B57D
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 04:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7F382189E
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 04:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562301607;
	bh=anXgiQzlwWAoucjffgnQSite8ZEZr2YplIVIl/UKK8E=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=ppfCjx9iUsesaPSf1luyUEKmJkCYlS462Q2TKMlJk8plm69w/tdKCmlXAHOlc66S+
	 OPM8yxzk6yRWU2DHzO+x8sQZfBjyAsoUxYbkufApVHoCKETIkltdQjyyAu1jAulO1A
	 KVzTgkNEf5OCeCubya7bkc9zmZHsqjPmRZmG4H90=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbfGEEkG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 00:40:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfGEEkG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 00:40:06 -0400
Subject: Re: [GIT] Crypto Fixes for 5.2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562301605;
        bh=anXgiQzlwWAoucjffgnQSite8ZEZr2YplIVIl/UKK8E=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=zNoj/DpE4fpJ9RnSQaxyeU5kMN4ozxWxZ/KqvTzFBpllfKiFd6D9SywEt986PDOyv
         aDuFgPWjeu/zp5h6X0CrCqgNMiP/BK9l0jxNFB3g3xWKyqlZSjIvVzGyMPRNZBIAqA
         LRSMbhCMxnRFXARBpyxatXKEtAL0uK8HIS2nFORA=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190705042449.rmzg2rk4janrgeoe@gondor.apana.org.au>
References: <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
 <20190312045818.bgpiuxogmaxyscdv@gondor.apana.org.au>
 <20190515060552.ecfwhazt2fnthepg@gondor.apana.org.au>
 <20190606060324.du5zbk3ju5djkhfe@gondor.apana.org.au>
 <20190705042449.rmzg2rk4janrgeoe@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190705042449.rmzg2rk4janrgeoe@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 21d4120ec6f5b5992b01b96ac484701163917b63
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ee39d46dcaf8f25894f13236d3d984d9a4d2fd3e
Message-Id: <156230160517.9557.7664525002945873265.pr-tracker-bot@kernel.org>
Date:   Fri, 05 Jul 2019 04:40:05 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Fri, 5 Jul 2019 12:24:49 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ee39d46dcaf8f25894f13236d3d984d9a4d2fd3e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
