Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D41C4363A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 17:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DC9F20790
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603734749;
	bh=V5d3zpQhymxIHeGJoy+l8Yh+NdrCgDZXPbmGWJXNayU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=Od18ZDVFbl1bR/fc0+4OdysfS+a8gDxuFCinPhvs0uSWDlgXBnwZenmK8c2FA+d+3
	 ROFqogY2SiqpA5MOpKoAS6+hFv16tfvGC95EH9o++/TQ7aUZM2oviikfH3G3/PNWQN
	 gC0Lg89WpNtj8guJu837NiA4/K9df/hE+7C2LeLk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1788548AbgJZRw2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 13:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1788547AbgJZRw2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 13:52:28 -0400
Subject: Re: [GIT PULL] Crypto Fixes for 5.10
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603734748;
        bh=V5d3zpQhymxIHeGJoy+l8Yh+NdrCgDZXPbmGWJXNayU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=l7X8CtPfywJn0ZA+rB6FHwEcrsOEiOuWUZHVHbOdo/UGx5uxzMZZRngQfa8iuHc7E
         8y65weUfA8M7IZ89AOXZOsndKC7K3r9G3kLTqVw/VvGfrMwm1SlUj60dBAhlV8K01M
         DiAlJ1sbLR7YfLzgN6+TLNJXLm6YqGQ+pPcNNp44=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201026011159.GA2428@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20200830223304.GA16882@gondor.apana.org.au> <20201026011159.GA2428@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201026011159.GA2428@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: c3a98c3ad5c0dc60a1ac66bf91147a3f39cac96b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 41ba50b0572e90ed3d24fe4def54567e9050bc47
Message-Id: <160373474836.18562.14943712215644627613.pr-tracker-bot@kernel.org>
Date:   Mon, 26 Oct 2020 17:52:28 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Mon, 26 Oct 2020 12:11:59 +1100:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/41ba50b0572e90ed3d24fe4def54567e9050bc47

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
