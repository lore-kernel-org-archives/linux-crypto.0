Return-Path: <SRS0=MZ7V=QG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FB3C282D7
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 09:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39F552184D
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 09:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfA3JNm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Jan 2019 04:13:42 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:36880 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfA3JNm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Jan 2019 04:13:42 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1golwA-0004YS-Bn; Wed, 30 Jan 2019 17:13:38 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1golw4-0000JP-O9; Wed, 30 Jan 2019 17:13:32 +0800
Date:   Wed, 30 Jan 2019 17:13:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/3] crypto: crct10dif assembly cleanup and
 optimizations
Message-ID: <20190130091332.gbcce2oyb24ienu2@gondor.apana.org.au>
References: <20190130031444.28935-1-ebiggers@kernel.org>
 <CAKv+Gu95j-ZJC7vbUzJKqNczht1cjgx09sBiSRcwg+qn-HtXew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu95j-ZJC7vbUzJKqNczht1cjgx09sBiSRcwg+qn-HtXew@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 30, 2019 at 09:33:57AM +0100, Ard Biesheuvel wrote:
> 
> So what remains is the way these implementations are encapsulated by
> the crct10dif() library function, which is raster nasty, making
> CRC-T10DIF an excellent use case to discuss whether we can make any
> improvements to address some of the concerns that were also raised in
> the zinc discussion. I threw some code together a while ago [0] (and
> posted it as well, IIRC). In the mean time, a 'static call'
> infrastructure is being proposed that could be used in a similar way
> to avoid function pointers. I'm also interested in hearing opinions on
> whether the indirect call overhead is actually significant in use
> cases such as this one.

I think even if the overhead wasn't significant it would still make
sense to make the move just for the sake of simplicity.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
