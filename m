Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECC0C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 17:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74A5E2147C
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552497016;
	bh=HUgHyqNdUhzMNw0TEXtYyCShY6Jzop0xT7ClpTG4yKg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=U40L69SvWoyYADJPh6s/SjSOGncNJGYa9bc6d7LllIen2h3ckX0cg7btV3dYCMpli
	 ixedtjrUJcS1Rg29xjjBEn0elE9O5GyXnC3121RVrb2W6eokRqiHn7t8FcW+ko5O8f
	 bt1zzHwB8ZtkbNKqCBdDgPmdFUeo48/wVZgzm6Cs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfCMRKP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 13:10:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfCMRKP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 13:10:15 -0400
Subject: Re: [GIT] Crypto Fixes for 5.1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552497015;
        bh=HUgHyqNdUhzMNw0TEXtYyCShY6Jzop0xT7ClpTG4yKg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=OmyX0xF6NbHGPmr9uKepdcpcCFROKUyKI5ZB8G1LdqCkiStLGugKpc9C8ZKy0NF8O
         YQqemOtIzwL3HrV+OD62aUj6y4trnHLRmkXc9MlGLokFuydzR5OLJl8MwhbMyP974k
         5KT8eqcEgIY2oQrFYxMk5oRIOjFehY5z062dvw3o=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190312045818.bgpiuxogmaxyscdv@gondor.apana.org.au>
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
 <20190312045818.bgpiuxogmaxyscdv@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190312045818.bgpiuxogmaxyscdv@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 00e87449430dc130b43d84bdee71ef94524d9c39
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dac0bde43b0b3685390b68c9058bee36d4d5c747
Message-Id: <155249701509.28396.9047584997134797302.pr-tracker-bot@kernel.org>
Date:   Wed, 13 Mar 2019 17:10:15 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Tue, 12 Mar 2019 12:58:18 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dac0bde43b0b3685390b68c9058bee36d4d5c747

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
