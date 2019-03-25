Return-Path: <SRS0=1oRy=R4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7670C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 12:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0AB320850
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 12:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730605AbfCYMDV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Mar 2019 08:03:21 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:51452 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731035AbfCYMDV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Mar 2019 08:03:21 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h8OJy-0001IY-TC; Mon, 25 Mar 2019 20:03:18 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h8OJv-0000Py-HL; Mon, 25 Mar 2019 20:03:15 +0800
Date:   Mon, 25 Mar 2019 20:03:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Samuel Neves <samuel.c.p.neves@gmail.com>
Subject: Re: [PATCH net-next v9 00/19] WireGuard: Secure Network Tunnel
Message-ID: <20190325120315.lvwvvfe4pi4jlqlc@gondor.apana.org.au>
References: <20190322071122.6677-1-Jason@zx2c4.com>
 <20190325115156.wj4verbfdd2rspo5@gondor.apana.org.au>
 <CAHmME9pAgi=Li_C5xEq7EfmNq5p4BRc3rDxXjiz+xz0rSYikXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pAgi=Li_C5xEq7EfmNq5p4BRc3rDxXjiz+xz0rSYikXA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason:

On Mon, Mar 25, 2019 at 12:57:20PM +0100, Jason A. Donenfeld wrote:
>
> I think we're slightly closer to being same page, but I haven't
> followed up here yet because I was waiting for something else first.
> 
> Your previous patchset left out a few implementations and wasn't
> totally complete with regards to the glue code. I'm going to whip
> something up now that is Zinc, but where there's already an existing
> assembly implementation in the tree (i.e. Martin's code), it uses that
> instead of what I've been posting until now. Then, after that lands, I
> can post stand-alone patches for replacing the various
> implementations, and we can discuss those separately, alongside all
> the various discussion of verification and benchmarks and so forth.
> 
> So, I'll have something to examine somewhat soon. Working on it now.

Great, looking forward to seeing it!

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
