Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1ECC433E6
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Jan 2021 21:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D84D22D6D
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Jan 2021 21:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437957AbhARVS0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Jan 2021 16:18:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388892AbhARVQy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Jan 2021 16:16:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 60E8A22D6E;
        Mon, 18 Jan 2021 21:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611004574;
        bh=NZxorr+VRqjnJETBl0roL3gtNdSTxbSBFhjf3bgXLAU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=HKaH1DBXoj4v9hC281E/qYG4YvePaLsGW/VFQnnYlZ37IFGQh/C5Uqn0Ptiyh2L4Q
         1cTb/Zv1KumnxmoE+GN/3NLsdOOeQnyc0haaWLgHqxXoq5wL9cH1JUP05MJwCrZMnH
         /8FgUa5N8fuORhAOAfRrAy2sHAE1qWFR4+JqWueJrc10HPh6sEqFkSJk/5RJYvoypj
         4qXsix/xKsQFO4QIhpOIoX1SvZW5NDasQxQvXkzPo3g987HJTJkcroXpXkX90399+E
         DYC+9wI4ZKiQLsrfQZHcSkdJk0k9xh0KG17ASYeQVUyZQx0rOIzXFmWDxILrRJAYOk
         R+6ba1YXY+Ehw==
Subject: Re: [GIT PULL] Crypto Fixes for 5.11
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210118051312.GA26120@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20200830223304.GA16882@gondor.apana.org.au>
 <20201026011159.GA2428@gondor.apana.org.au>
 <20201227113221.GA28744@gondor.apana.org.au>
 <20210108035450.GA6191@gondor.apana.org.au> <20210118051312.GA26120@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210118051312.GA26120@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 382811940303f7cd01d0f3dcdf432dfd89c5a98e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fd3958eac387593d02e4d4287658ba04bcdb235a
Message-Id: <161100457426.30333.4569988131854784361.pr-tracker-bot@kernel.org>
Date:   Mon, 18 Jan 2021 21:16:14 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Mon, 18 Jan 2021 16:13:13 +1100:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fd3958eac387593d02e4d4287658ba04bcdb235a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
