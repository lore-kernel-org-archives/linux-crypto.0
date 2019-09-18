Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC52C4CEC4
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 19:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DE4022430
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 19:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568836528;
	bh=Ppcqo0njTaWbTEH0HpXAidzscUG6hpIgS9kt5O0WjcU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=rks61Ytf8il9dTqHBHFqD0Qe5sBjqbjgUIsW98FAOhtwbbHNji341lpKggHb2r5+9
	 7Tz1kGEe77Otlb5gokynsp4uGK6ej6RG/Tfaxp8o19cbKGxg7YUOkmqrx6xjN52Wu1
	 spKsVqv1G+Mmp7t+Z9loO85d35SE90Atiskg3Bfk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388077AbfIRTz0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Sep 2019 15:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388042AbfIRTz0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Sep 2019 15:55:26 -0400
Subject: Re: [GIT PULL] Crypto Update for 5.4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568836525;
        bh=Ppcqo0njTaWbTEH0HpXAidzscUG6hpIgS9kt5O0WjcU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=qAyOyLm/1BbxMH+icEtz75s60WiDrhHYj7UrJXmgLQ5c0sSgz9/bong4YA4ApQAWy
         9LS+EYLomqC7LcmO3N7+SvkTy5mDjjegiAESMfdUP8ZUMAbARikQAKW7ODX6iGGS/s
         9hDrCKjxhjEBhfJALpiQqecI3alODQXnJ9q+opiw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190916084901.GA20338@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190916084901.GA20338@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 9575d1a5c0780ea26ff8dd29c94a32be32ce3c85
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8b53c76533aa4356602aea98f98a2f3b4051464c
Message-Id: <156883652591.14539.7281930528516114167.pr-tracker-bot@kernel.org>
Date:   Wed, 18 Sep 2019 19:55:25 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Mon, 16 Sep 2019 18:49:01 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8b53c76533aa4356602aea98f98a2f3b4051464c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
