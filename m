Return-Path: <SRS0=7O7/=CT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE4CC433E2
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 02:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 746A121D80
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 02:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599706209;
	bh=dkp7auU2FKhEvcTExb27Xv8XLSV29+CJUCDMUeythnQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=x2K/IkJZqYWL3tVsaTsVWUZgRPe1CZgqU7OFJ8QhV57wgDWw5tZ/lMUon4FIF+wR9
	 2S51cn/X8z4rirPrkDaEWZ/+QOAB+knxiF3NoFQir7szTPbHjzp05JOdw1rxWilxl8
	 /W7FlMRDPsvBNJXhixT4RA3JCO3EXPA68yObHTGc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgIJCuH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Sep 2020 22:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730453AbgIJCsM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Sep 2020 22:48:12 -0400
Subject: Re: [GIT PULL] Crypto Fixes for 5.9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599706092;
        bh=dkp7auU2FKhEvcTExb27Xv8XLSV29+CJUCDMUeythnQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=lnLxbhhSELHI4cgrWuryB9t0Bbchdok0uTNGkHhl+lDpVuTi22XwXQJgUA+1ts+cE
         7J4xEYYoKZoGg2hCaBewuQxvYs2i9Qw8adUWBYuDJIClgk8y6zd1E1m+ITtzLYU+IU
         TYbQykTJt6vaLTUAUQUVcK0VuhSQfzJJ10TBGSpQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200910003423.GA28062@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20200830223304.GA16882@gondor.apana.org.au> <20200910003423.GA28062@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200910003423.GA28062@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 1b0df11fde0f14a269a181b3b7f5122415bc5ed7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7fe10096c1508c7f033d34d0741809f8eecc1ed4
Message-Id: <159970609204.30392.6189665258916818752.pr-tracker-bot@kernel.org>
Date:   Thu, 10 Sep 2020 02:48:12 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Thu, 10 Sep 2020 10:34:23 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7fe10096c1508c7f033d34d0741809f8eecc1ed4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
