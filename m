Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E665C282CE
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F8D720883
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554704709;
	bh=lD02SgsOs5l+ctoqEZhNOgCSmVR0Kt7MVFctEy79BKI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=G/H6g/U8aX9UDCuD7wyhAKXACVL1H2mjWXWi89z/j2EwHOEAYuGSfYh7NTa8UAk1f
	 Ogq63acpHFNC2KJeu/U9FdR1qXWqBFdVNE/nGaN/b0jPAFVtLJ+LN32iEr5i2iqPUB
	 cE1n4tT+5+SzMdz9ovHQzatcPnHwomoiUHEoLC9g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbfDHGZI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbfDHGZI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 02:25:08 -0400
Subject: Re: [GIT] Crypto Fixes for 5.1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554704707;
        bh=lD02SgsOs5l+ctoqEZhNOgCSmVR0Kt7MVFctEy79BKI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=fOGylSIbExW1+7II8FIHpIKTHSnvdPQLjW3JhcLWqFvG7QyNbXicB0kuGflti18Yw
         n4m63cckb8aeU5i816AfkCGyiT5mGLMUqBKIF50ZYleFSZYw2Gc/J5GNFyciR2CjyG
         8ROrRMG2Di6t4l0DgT7f2QNeL6JXjqkZ5ayK8Co8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190408054823.4jedcfql7woverqb@gondor.apana.org.au>
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
 <20190408054823.4jedcfql7woverqb@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190408054823.4jedcfql7woverqb@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: b4e9e931e9bb2f5b302ce66640832f5a3e57e8c4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fd008d1a7a204695f0e5e003af16448bb9c34b7b
Message-Id: <155470470783.8914.7967179820833322736.pr-tracker-bot@kernel.org>
Date:   Mon, 08 Apr 2019 06:25:07 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Mon, 8 Apr 2019 13:48:23 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fd008d1a7a204695f0e5e003af16448bb9c34b7b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
