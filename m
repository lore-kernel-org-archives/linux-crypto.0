Return-Path: <SRS0=wcu2=DU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3144FC433E7
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Oct 2020 16:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFCCC25298
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Oct 2020 16:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602606251;
	bh=P+b1xRiVd/Glip2OOGNcKabJe6x7rDVX6Y/HLYin6D4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=vDFs0m5lcYCZgY14XgPiGsa09xHcfvarbeR5dldL8/vgBf06VFbV+hyRrpdZBoaBM
	 c/09hnZ4ZgQ0P+S19WUuzL1csdCcX3M2TuH2VF8qnVaDwm13SRaJp1DHPi6IIzgauX
	 beR2PfUZ99ROehs/vT+PMcHJXrLtRRILrUt5vrpU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389769AbgJMQYK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Oct 2020 12:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389679AbgJMQYF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Oct 2020 12:24:05 -0400
Subject: Re: [GIT PULL] Crypto Update for 5.10
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602606245;
        bh=P+b1xRiVd/Glip2OOGNcKabJe6x7rDVX6Y/HLYin6D4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Sd6qgZLpvDR/6YZCHv4KsMUOSwi0AESFDSNFHbJeHpLZIU/Kly9luLhOAC/8W0dVx
         XuiyFuIZjdeiHck3MzsfV9d3rmDivvtlM+8XnYZaHBq5AddvAPzbWZ4RFdOvSq+kmW
         xKtnP8iZPGfhec/LFT0DBUqv9T8abDKhDM9Zsq4c=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201012033249.GA25179@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au> <20201012033249.GA25179@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201012033249.GA25179@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 3093e7c16e12d729c325adb3c53dde7308cefbd8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 39a5101f989e8d2be557136704d53990f9b402c8
Message-Id: <160260624522.24492.2693209013854643177.pr-tracker-bot@kernel.org>
Date:   Tue, 13 Oct 2020 16:24:05 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Mon, 12 Oct 2020 14:32:49 +1100:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/39a5101f989e8d2be557136704d53990f9b402c8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
