Return-Path: <SRS0=SVjD=ZH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B45C432C3
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 09:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C88020733
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 09:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfKOJJ2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Nov 2019 04:09:28 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:39064 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfKOJJ1 (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Fri, 15 Nov 2019 04:09:27 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iVXba-0007sZ-2I; Fri, 15 Nov 2019 17:09:26 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iVXbV-0006HC-52; Fri, 15 Nov 2019 17:09:21 +0800
Date:   Fri, 15 Nov 2019 17:09:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v5 00/34] crypto: crypto API library interfaces for
 WireGuard
Message-ID: <20191115090921.jn45akou3cw4flps@gondor.apana.org.au>
References: <20191108122240.28479-1-ardb@kernel.org>
 <20191115060727.eng4657ym6obl4di@gondor.apana.org.au>
 <CAHmME9oOfhv6RN00m1c6c5qELC5dzFKS=mgDBQ-stVEWu00p_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9oOfhv6RN00m1c6c5qELC5dzFKS=mgDBQ-stVEWu00p_A@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 15, 2019 at 09:56:17AM +0100, Jason A. Donenfeld wrote:
> Hey Herbert,
> 
> I've been traveling and got back home yesterday. I was going to review
> these this afternoon if there's still opportunity.

Hi Jason:

Last I checked there weren't any major objections to this patch-set.
If there are any remaining issues we can resolve them with new
patches on top of this series.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
