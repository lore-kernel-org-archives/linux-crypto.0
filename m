Return-Path: <SRS0=mh6u=CI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94CD8C433E6
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Aug 2020 23:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63052206F0
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Aug 2020 23:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598828554;
	bh=g19HIBCaikce97qaQS6+Cx2QnvGVLPKIY6Z7TpJ8ii4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=rlkLwsHq6RHyCENtJjcE8/eQT24gXmb2b5NpqOxKt24s008JRJaZGlI9Ks6LPhu2t
	 nNr6ZjR5qYrOXlRr8mIh0YKB+cryxDLWnKEtrxaaNXq5iq/xGvNbmW4RjEof2sH+T6
	 CLqJ90g/Q2zOAzKKlNtWPL6gE68F1p7tEZYqP4Ds=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgH3XCa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 30 Aug 2020 19:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgH3XCa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Aug 2020 19:02:30 -0400
Subject: Re: [GIT PULL] Crypto Fixes for 5.9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598828549;
        bh=g19HIBCaikce97qaQS6+Cx2QnvGVLPKIY6Z7TpJ8ii4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=j+nif+htGcLBFfcUeeHjIm3caLH7+uGx2iCUsoNSZWwbWMLxblF8NC1woGU8FOmf9
         QsHwF4znMnJkaV0iXHKWEZ4PrqyK0Xj9RPL0Br2GwZNv1Sxl384bxf9ERfg72mU8w1
         uR60rocPfr//Xkz+0pGb33DeMgR1oOeCv2Nb6OWM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200830223304.GA16882@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au> <20200830223304.GA16882@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200830223304.GA16882@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: c195d66a8a75c60515819b101975f38b7ec6577f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e43327c706f28d9e66fc4242af4aefdd69e8ff24
Message-Id: <159882854967.16047.10951519758747174964.pr-tracker-bot@kernel.org>
Date:   Sun, 30 Aug 2020 23:02:29 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Mon, 31 Aug 2020 08:33:04 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e43327c706f28d9e66fc4242af4aefdd69e8ff24

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
