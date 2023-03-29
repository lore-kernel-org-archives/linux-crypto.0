Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371C2C74A5B
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Mar 2023 08:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjC2Iiw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Mar 2023 04:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjC2Iiw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Mar 2023 04:38:52 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672F41BE
        for <linux-crypto@vger.kernel.org>; Wed, 29 Mar 2023 01:38:46 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1phRKJ-009sG1-8t; Wed, 29 Mar 2023 16:38:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 29 Mar 2023 16:38:39 +0800
Date:   Wed, 29 Mar 2023 16:38:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas BOURGOIN <thomas.bourgoin@foss.st.com>
Subject: Re: [PATCH] crypto: algif_hash - Allocate hash state with kmalloc
Message-ID: <ZCP5D+jQlkaEZTTg@gondor.apana.org.au>
References: <ZCJk8JQV+0N3VwPS@gondor.apana.org.au>
 <CAAUqJDtqmXOBNY0YzkuzfaK-zvzhHqazc+=vs=OouKLBAZ90Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAUqJDtqmXOBNY0YzkuzfaK-zvzhHqazc+=vs=OouKLBAZ90Pw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 28, 2023 at 01:01:01PM +0200, Ondrej Mosnáček wrote:
>
> Shouldn't sock_kmalloc() be used instead?

Thanks for the review!

No that isn't necessary because this is transient and not really
open to abuse by the user.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
