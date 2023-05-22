Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0496C7EE29
	for <linux-crypto@archiver.kernel.org>; Mon, 22 May 2023 05:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbjEVFPr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 May 2023 01:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbjEVFPp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 May 2023 01:15:45 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E29A1;
        Sun, 21 May 2023 22:15:36 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q0xtA-00BjFj-4s; Mon, 22 May 2023 13:15:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 22 May 2023 13:15:20 +0800
Date:   Mon, 22 May 2023 13:15:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Linux Crypto List <linux-crypto@vger.kernel.org>,
        Huan Feng <huan.feng@starfivetech.com>,
        Jia Jie Ho <jiajie.ho@starfivetech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the crypto tree
Message-ID: <ZGr6aB9uJVnyfJQ9@gondor.apana.org.au>
References: <20230522105257.562cb1ec@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522105257.562cb1ec@canb.auug.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 22, 2023 at 10:52:57AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the crypto tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

Sorry, a fix is pending and will be pushed out soon.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
