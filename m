Return-Path: <SRS0=mwGE=VG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B11BEC606B0
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 04:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 840A3216C4
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 04:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562647507;
	bh=+vI4k3MjSW67vSZ3SKKwrRDU1kDzVEY30ZV/nuL5SaE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=oLrfPr8pJCnrmq735IwKQsDeLZ1lsE85RfQqkjtqcZmmmw3ebXEJwD0MDoXMswORP
	 8FxhHMkOKZF++WV6ROLm8TMtXOhBX6cE+awDqHDdeZRdr3QzylwcH6nxYzL1fchQVD
	 fyo1Ifay2nWQSODAIajFvPioHJwK0saulK3AOsYY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfGIEpG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jul 2019 00:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfGIEpG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jul 2019 00:45:06 -0400
Subject: Re: [GIT] Crypto Update for 5.3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562647505;
        bh=+vI4k3MjSW67vSZ3SKKwrRDU1kDzVEY30ZV/nuL5SaE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=SbctPPUVBwNyZPtqKe/y6sySFsFDVH8/ydONiJTaDQTkdzeEe00OOjnY/gcwNUayi
         XVOzq5ytBSF7Q2RF7gSPL1scdPtTK4uV15mO5eZkRZHsrjvv9LGf2givn6uyElv25L
         1czYW68az7ThtmejoqlvHbGr3AaO4pP9cSveykXo=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190708150800.6xjc4idh2ppbxyn6@gondor.apana.org.au>
References: <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
 <20190305081155.7rpkydnc4ipm43o6@gondor.apana.org.au>
 <20190506032938.fgyw2qupyktvsx7w@gondor.apana.org.au>
 <20190708150800.6xjc4idh2ppbxyn6@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190708150800.6xjc4idh2ppbxyn6@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: f3880a23564e3172437285ebcb5b8a124539fdae
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4d2fa8b44b891f0da5ceda3e5a1402ccf0ab6f26
Message-Id: <156264750537.18377.8256540964991209965.pr-tracker-bot@kernel.org>
Date:   Tue, 09 Jul 2019 04:45:05 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Mon, 8 Jul 2019 23:08:00 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4d2fa8b44b891f0da5ceda3e5a1402ccf0ab6f26

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
