Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15449C282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 09:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E47AA2184C
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 09:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfAXJYH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 04:24:07 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:40406 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbfAXJYH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 04:24:07 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gmbEw-0003Cw-7u; Thu, 24 Jan 2019 17:24:02 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gmbEt-0003Tq-Bk; Thu, 24 Jan 2019 17:23:59 +0800
Date:   Thu, 24 Jan 2019 17:23:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC/RFT PATCH 00/15] crypto: improved skcipher, aead, and hash
 tests
Message-ID: <20190124092359.hvizqdi2ptjdsot7@gondor.apana.org.au>
References: <20190123224926.250525-1-ebiggers@kernel.org>
 <20190124084818.GA650@sol.localdomain>
 <CAKv+Gu9zridWAYO3cR_KAAbupWfLd+FAMmcgAMuYE5Lgxoek-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9zridWAYO3cR_KAAbupWfLd+FAMmcgAMuYE5Lgxoek-w@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 24, 2019 at 09:50:35AM +0100, Ard Biesheuvel wrote:
>
> Thanks for yet another round of cleanup
> 
> I'll look into these, but I'd like to clarify one thing first.
> 
> IIUC, you are trying to deal with the case where a single scatterlist
> element describes a range that strides two pages, and I wonder if that
> is a valid use of scatterlists in the first place.
> 
> Herbert?

Yes it is valid.  IIRC the network stack may generate such a
scatterlist.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
