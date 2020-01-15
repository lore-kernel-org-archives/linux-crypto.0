Return-Path: <SRS0=cdcO=3E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00235C32771
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jan 2020 19:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE9AF24679
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jan 2020 19:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579116910;
	bh=MZHhE3uyS8e42CyWUCBrOI6Xv2zVdwGVR/Ja3KZefrM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=l1dLtgq7TSkhtM/M92GcM6mE/5FbbuomiHXP9zyAkUDFVzhpWnMRbF/tXfnJ+7YWq
	 kzrQWJH8TMBqyUnD92YtsCA6USYuwgvTPalAiLnCaIvNPIet0TvRO53eQ8KNlFwR3D
	 +afaxliJwNWlNxFnL9DpE67FJZsV4QY0rT/9sXac=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgAOTfG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Jan 2020 14:35:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729336AbgAOTfF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Jan 2020 14:35:05 -0500
Subject: Re: [GIT PULL] Crypto Fixes for 5.5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579116905;
        bh=MZHhE3uyS8e42CyWUCBrOI6Xv2zVdwGVR/Ja3KZefrM=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=frztle5fCVQQw8tDRdtjVqWR3Ej3Nw/a5PHVj6JOkGu1leIJPyK22ARQFPYHnH4gR
         bprC42dYTrXyXvb56YVd98CSlX0vIsCnZsj37+EL50MSoTSYJPETDBmr8WMNXIwBda
         fWdTiVLN2HIRTTIb8xPX4QVs9bkVgCSDjg3G/8Tw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
 <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: cb1eeb75cf3dd84ced81333967200583993dfd73
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0174cb6ce9449ce9b59cb9c6f4f64dc4df3de458
Message-Id: <157911690513.18389.12567093045839498553.pr-tracker-bot@kernel.org>
Date:   Wed, 15 Jan 2020 19:35:05 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Wed, 15 Jan 2020 23:08:12 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0174cb6ce9449ce9b59cb9c6f4f64dc4df3de458

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
