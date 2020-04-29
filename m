Return-Path: <SRS0=SZPK=6N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FFBAC83000
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Apr 2020 16:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 673E9214AF
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Apr 2020 16:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588179013;
	bh=JiQTaWVwC63SkuV2FBWui7b1YBsjH7ezXzl5EPROEi4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=HRfVAG1fguPHbcRkxvrkm6mk2YgkrQAT4+AsDygCUWcMUwvb/1PlJJPw3+wK6nZno
	 S/Nf61W+otlD7Jo6F6+v9uJutu/Hp5ZnPIzqHTQkDqbDqUVNALq2OxGqyuXl7qZAhn
	 x+bOn1BS9qbAtmb54c7SojunBtd0uFIavzt610Hw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgD2QuM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Apr 2020 12:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgD2QuM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Apr 2020 12:50:12 -0400
Subject: Re: [GIT PULL] Crypto Fixes for 5.7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588179012;
        bh=JiQTaWVwC63SkuV2FBWui7b1YBsjH7ezXzl5EPROEi4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=fSw5jXxAGJccqkxbT6sOjDi3Lc9LVJ7ghgu9ccO4L+h9II+CMG1R5FAUwS7n62Iyt
         vDL5JbEMruYBOxxCkwi8FM6v2TMpQcW2cDTuSwvDSr2a1wpieaLn8A7bnOznUEieYW
         crfb1S6Cd3mZd9ysvpdC6ft6AStjOEhFxu9O7Whs=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200429055420.GA26381@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
 <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au>
 <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
 <20200408061513.GA23636@gondor.apana.org.au>
 <20200429055420.GA26381@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200429055420.GA26381@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: 55b3209acbb01cb02b1ee6b1afe80d83b1aab36d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6c3efdc911b67816285719bd610152232cf5e8e4
Message-Id: <158817901233.22148.11028199197664884191.pr-tracker-bot@kernel.org>
Date:   Wed, 29 Apr 2020 16:50:12 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Wed, 29 Apr 2020 15:54:20 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6c3efdc911b67816285719bd610152232cf5e8e4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
