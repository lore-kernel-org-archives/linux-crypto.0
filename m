Return-Path: <SRS0=jN6o=RF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9A1C43381
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Mar 2019 00:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF0B72084F
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Mar 2019 00:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551486004;
	bh=IFpnuf7Vqa/tKxz8L3pVoGxkGPdv7CO6jbnim1F3rgI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=KhLk3vBIAHn8T5AnNJc9gPXo4srrz8L2hpBr/GH05qiJFgX+4F3KTEvgHnxP3rP9u
	 QfeY8UjxgWmsgFN+5inhLW1WC4VPTOnBsYSyyt5BU+CjFC0dBOs9ihts7SaPIEBz4o
	 +8GSudrW9qtOyZqfy6X3T34RSTbbEmXs8YfOE0RA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbfCBAUE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Mar 2019 19:20:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfCBAUE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Mar 2019 19:20:04 -0500
Subject: Re: [GIT] Crypto Fixes for 5.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551486003;
        bh=IFpnuf7Vqa/tKxz8L3pVoGxkGPdv7CO6jbnim1F3rgI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=s5Iu/xqywtW+SM4P7u2tngfPWTeTlc/NjP9xdUU2FMBQ9bHfQsyyr06I4PlawK4H4
         7ICGKDnjhUclVBJPsw1dV8L+y2oa2c+xRYhYTILNerNaFOEkbTzfVIVzK4n2dglLaD
         PuFYhtQuHFTBJW7+hIAlTo3Luw1jFJKrhIN6eZGw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190228055618.ix3iqmcuwlok5zjo@gondor.apana.org.au>
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
 <20190228055618.ix3iqmcuwlok5zjo@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190228055618.ix3iqmcuwlok5zjo@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: c64316502008064c158fa40cc250665e461b0f2a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3f25a5990d9d32e8f77ce830b9ea6c0e4f4bea4b
Message-Id: <155148600343.30240.18256785578839270718.pr-tracker-bot@kernel.org>
Date:   Sat, 02 Mar 2019 00:20:03 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Thu, 28 Feb 2019 13:56:18 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3f25a5990d9d32e8f77ce830b9ea6c0e4f4bea4b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
