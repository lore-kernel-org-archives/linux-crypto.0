Return-Path: <SRS0=veUY=7O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A094C433DF
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 19:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 457BA20776
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 19:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591040147;
	bh=J+cEF6NlV6FTuCyw4GSWHJsgj40PG61Pe/1hieAYRtk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=sGBCaFmeYa1sCrQ3n+P6NDsUulMSak3C4b/ImIxIp8spzbv9bACq1a8Yfr5QGNaGh
	 j7mI6E6i+SPjJHj9gDsxQTCjn7eaRcwiRONsrCLCuPaYVnpg2PA40JQME4cycaREVr
	 g3WB3cLGqZz4pssplUMCFjzMivNhS9YPzCXyFOOM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbgFATfl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jun 2020 15:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729558AbgFATfH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jun 2020 15:35:07 -0400
Subject: Re: [GIT PULL] Crypto Update for 5.8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591040106;
        bh=J+cEF6NlV6FTuCyw4GSWHJsgj40PG61Pe/1hieAYRtk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=YKlgJNTSYsSxtqkyL+YTAfnOx9cPHu4nJApU4V8hGb2k73aVgVHgInrwuFRWE2svc
         er1c8QtpaS5UyiiGskbtdih3b0ml0+VtkrkwH/Kuntea0QG9XK4F4NxNeLJynb5rkB
         JJ9oSYvHaBxNWFfzIXTcam5cZUfVVW1l8sG93umM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200601024533.GA18937@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20191125034536.wlgw25gpgn7y7vni@gondor.apana.org.au>
 <20200128050326.x3cfjz3rj7ep6xr2@gondor.apana.org.au>
 <20200401042720.GA12178@gondor.apana.org.au>
 <20200601024533.GA18937@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200601024533.GA18937@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 58ca0060ec4e51208d2eee12198fc55fd9e4feb3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 81e8c10dac62c427b25f6bbb07936806e4dd9e8a
Message-Id: <159104010689.18844.9017176619965025932.pr-tracker-bot@kernel.org>
Date:   Mon, 01 Jun 2020 19:35:06 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Mon, 1 Jun 2020 12:45:33 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/81e8c10dac62c427b25f6bbb07936806e4dd9e8a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
