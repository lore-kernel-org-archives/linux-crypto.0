Return-Path: <SRS0=jN6o=RF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C676DC43381
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Mar 2019 17:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8219720863
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Mar 2019 17:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551546604;
	bh=irm/fxrw4900tiFWh8/w7p7T3niqOYV1XogIMq503t4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=VjTu4Mi+8++ZuDy1Sd8yWBUd1ERxCPbgwrIkXSDo2KUiMs8kRNPWgXMROpaG09+sq
	 3GfwJORdXEPA8sNm2mVPV2Qo0yDfvcF0h0HIh8YE64D844snOV3xXLiDaoBVnbQzE/
	 yGVcPB6kW2LWJM8LfL4lEQJkxMHhF/JkU3qjQ3a8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfCBRKE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Mar 2019 12:10:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbfCBRKD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Mar 2019 12:10:03 -0500
Subject: Re: [GIT] Crypto Fixes for 5.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551546603;
        bh=irm/fxrw4900tiFWh8/w7p7T3niqOYV1XogIMq503t4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=GqEmSvturQBFbvy2WwwR9GEFlpEZW/7rTqcMSJkTcUNa3aWATl5reJLl5JuElUWgK
         0wWYivNMLx/XnjY58yFWUTw6539Q5RKTNL/ZyDYbs/0TrM3vccc1nqjb2Kysj9CMmS
         UV+iEYtAnAjJdSAIXhuR2RiqXU8gVhxVSWQ/KIs0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190302024207.ue7zl6zvnidjy6it@gondor.apana.org.au>
References: <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
 <20190228055618.ix3iqmcuwlok5zjo@gondor.apana.org.au>
 <20190302024207.ue7zl6zvnidjy6it@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190302024207.ue7zl6zvnidjy6it@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
X-PR-Tracked-Commit-Id: f86d17e9efe010b894db231329ee36b24bcc1b24
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fa3294c58c58c4fa87ee0356b6cb1901db00533e
Message-Id: <155154660336.7313.8232856025470801006.pr-tracker-bot@kernel.org>
Date:   Sat, 02 Mar 2019 17:10:03 +0000
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pull request you sent on Sat, 2 Mar 2019 10:42:07 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fa3294c58c58c4fa87ee0356b6cb1901db00533e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
