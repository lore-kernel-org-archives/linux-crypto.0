Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322EBC32756
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 16:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D21C52089E
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 16:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565368550;
	bh=h8yvuZKp/qw8bEdg0bWJTyQ7WnGy6ktEzKdG6fMM9VE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=iu3T43j7jRxGzTEebfniGWohmWmofFRg5JW34NBHQD0ZILsqB3DAhjok82NPEIgfZ
	 0bk/k06Y4v0adX+1CKUXRa2kjCwyRU9S4TDPlw7MR8zAhooFkbgqoYX3wjgCB+BHFt
	 XdjW10zQxtdMs30ahf7nEO9j3obH3TtrkpkSH3fQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437316AbfHIQfJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 12:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437309AbfHIQfI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 12:35:08 -0400
Subject: Re: [GIT] Crypto Fixes for 5.3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565368507;
        bh=h8yvuZKp/qw8bEdg0bWJTyQ7WnGy6ktEzKdG6fMM9VE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=jgUBbpC1BfHogbhUqwTIijlz0UQBHCBT1z/GEilZdVa0HJBti9oE3xXRwdXfjoRmM
         /PV4pMudKZg4PifJZpj+a4ayjf8Msyoi/4oW2Qo/WfFXfwFu97+81ZT2XLw0/XATrH
         WtySJ/Bo8iGrqQypCgO77HJohjgzAXhgIOF076UI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190809061548.GA10530@gondor.apana.org.au>
References: <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
 <20190312045818.bgpiuxogmaxyscdv@gondor.apana.org.au>
 <20190515060552.ecfwhazt2fnthepg@gondor.apana.org.au>
 <20190719031206.nxyxk4vj6dg7hwxg@gondor.apana.org.au>
 <20190809061548.GA10530@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190809061548.GA10530@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: e2664ecbb2f26225ac6646876f2899558ffb2604
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e577dc152e232c78e5774e4c9b5486a04561920b
Message-Id: <156536850756.6429.4109081202813215233.pr-tracker-bot@kernel.org>
Date:   Fri, 09 Aug 2019 16:35:07 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Fri, 9 Aug 2019 16:15:48 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e577dc152e232c78e5774e4c9b5486a04561920b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
