Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1691FC4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 15:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E57972196E
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 15:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570722312;
	bh=05X4axdLyCLYLLH3lhAqEPqmNC7yyW2t4Y9HikBumXM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=0H7P+jFHQPl5dSBLbRNJ6PEgjLffrQSt0pZlOA2oWqxGJ31eF7OoSXhxfSKRnsU/w
	 56F3Qo+u2KMRVaDqtLV5uF80gGspRNUQvFLsITY4h2l10P2Gipy2WRfODCWsvVgjLE
	 LHNmihByRRwuxRU4EqjE0/L5TWFr+JCg7MxXrUZM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfJJPpK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 11:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbfJJPpK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 11:45:10 -0400
Subject: Re: [GIT PULL] Crypto Fixes for 5.4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570722309;
        bh=05X4axdLyCLYLLH3lhAqEPqmNC7yyW2t4Y9HikBumXM=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=jV5YZ2egycifYk/MYo9X75iPxc8Pm5SO9+obmS05M0bkrKCIt8OEYTeX/idmbJIu1
         Rjpg28m0qDvSrgxI/GCmCNiEzRbIDub65MV/BzdwL+cN9TMsPARUa8TmvP5jN58h7s
         N+EEU1jA2ZZS4/tYVb2xQY6+t85xmYDeqFA0gUjQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191010123849.GA30001@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
 <20191010123849.GA30001@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191010123849.GA30001@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: f703964fc66804e6049f2670fc11045aa8359b1a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fb20da6af705597cefcf05fc99e48d5c066dbdff
Message-Id: <157072230975.27255.279790815979648894.pr-tracker-bot@kernel.org>
Date:   Thu, 10 Oct 2019 15:45:09 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Thu, 10 Oct 2019 23:38:49 +1100:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fb20da6af705597cefcf05fc99e48d5c066dbdff

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
