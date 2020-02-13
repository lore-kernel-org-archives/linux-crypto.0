Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F17C352A3
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 22:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8B932168B
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 22:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581633622;
	bh=m3e4lM+CV/lHzecXSlRVzwKPpUS2FGSatK1iyKTRGow=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=nRj4CvNmL9pVJZbW+rQxVCCwhPtEoVbqEWSV8sRh0L6UkY8E9vRMTJkA47LRC5c99
	 9p1D7h4SSsVmS4eFbd+apCzgE/SuNG6wmdXZ2s+ftHrj0nziLXu18PiHWPxKpmev86
	 q0H7qZD/17BaCgo2mvzTEVeKIBJlvFO5YGKD9K1s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgBMWkW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 17:40:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:37550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbgBMWkW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 17:40:22 -0500
Subject: Re: [GIT PULL] Crypto Fixes for 5.6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581633621;
        bh=m3e4lM+CV/lHzecXSlRVzwKPpUS2FGSatK1iyKTRGow=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=zWXDuQwleMzsYKNIzQ6drz96vylviZal7T1maIADzAfHLngoZgCWD6eI9/fcWLCoK
         QvmTLoOfzQ64BI5eqiyUwQk3NW23+6/Tlp1E7UTKMthhEMYbNTEaaopiPbz+hBCbnF
         +kKXT5FiEQeNz/FJnwBjdhDXt5K+DJi7rRhU9oRk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
 <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au>
 <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 2343d1529aff8b552589f622c23932035ed7a05d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 64ae1342f8980d05c3df414a022b8123aa76c56b
Message-Id: <158163362160.23424.17873755953815720551.pr-tracker-bot@kernel.org>
Date:   Thu, 13 Feb 2020 22:40:21 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Thu, 13 Feb 2020 11:32:31 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/64ae1342f8980d05c3df414a022b8123aa76c56b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
