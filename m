Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8FCC10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBF0F20835
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733205AbfDRO1h (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:27:37 -0400
Received: from [5.180.42.13] ([5.180.42.13]:55210 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733192AbfDRO1h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 10:27:37 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hH80k-0004p8-My; Thu, 18 Apr 2019 22:27:34 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hH80h-0004El-Tw; Thu, 18 Apr 2019 22:27:31 +0800
Date:   Thu, 18 Apr 2019 22:27:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        George Cherian <george.cherian@cavium.com>,
        Nagadheeraj Rottela <rnagadheeraj@marvell.com>,
        Srikanth Jampala <jsrikanth@marvell.com>
Subject: Re: [PATCH] crypto: cavium - remove bogus code handling cryptd
Message-ID: <20190418142731.byua44w2thtwzpqm@gondor.apana.org.au>
References: <20190413042531.16231-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190413042531.16231-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 12, 2019 at 09:25:31PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The cavium crypto driver adds 'sizeof(struct ablkcipher_request)' to its
> request size because "the cryptd daemon uses this memory for request_ctx
> information".  This is incorrect and unnecessary; cryptd doesn't require
> wrapped algorithms to reserve extra request space.  So remove this.
> 
> Also remove the unneeded memset() of the tfm context to 0.
> It's already zeroed on allocation.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/crypto/cavium/cpt/cptvf_algs.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
