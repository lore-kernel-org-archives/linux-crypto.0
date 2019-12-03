Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DF7C432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 01:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFEBA206DC
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 01:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575336629;
	bh=8Lf2PjWtMV/4wS+ZyOysIoJcGTAU4jWkrQ13cfIsqT4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=jj7lXZcmBr7Imu/3vof/tybmilFDVPiCx6nzib1Mi2i8Fc140hvWzoc5W8V4UhIKr
	 YrR+Ol77+aUvrSfqj6zMSDZHvQagMMQqfNWrEWyrDe6e36bHuvsW5wHxFP7oxiax6r
	 21FdKvXRBdmQ41TrF7UsF0SjjI+YHYsJvsS7T51s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfLCBaV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Dec 2019 20:30:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:32774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfLCBaU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Dec 2019 20:30:20 -0500
Subject: Re: [GIT PULL] Crypto Fixes for 5.5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575336619;
        bh=8Lf2PjWtMV/4wS+ZyOysIoJcGTAU4jWkrQ13cfIsqT4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=IiVXdbMe/lh99V+2TQ2j9d6Eqj/m45Dk+qoHF6bMj9e+kkYI96UFms8aj+rVq6ENP
         axy0Eq0oVNpQpcMGglX+kredwGoOIvVpeK8EgfNv8hNvYbRpNf9Lt7jgHcBMQuQZT0
         sn+Uce8D507+G8Howu2UPj5Dbtm96x7UGi5fABaY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 8a6b8f4d7a891ac66db4f97900a86b55c84a5802
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 483847a70262f7361f8a6f78513c985c2c8b1719
Message-Id: <157533661960.4888.4046452170429637946.pr-tracker-bot@kernel.org>
Date:   Tue, 03 Dec 2019 01:30:19 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Mon, 2 Dec 2019 14:20:17 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/483847a70262f7361f8a6f78513c985c2c8b1719

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
