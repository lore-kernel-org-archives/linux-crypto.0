Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFE4C7618B
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 09:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37E84206DD
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 09:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfG2JVz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 05:21:55 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56528 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbfG2JVy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 05:21:54 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hs1qp-0004iR-LY; Mon, 29 Jul 2019 19:21:51 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hs1qn-0008MW-Lh; Mon, 29 Jul 2019 19:21:49 +1000
Date:   Mon, 29 Jul 2019 19:21:49 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] crypto: aegis128 - deal with missing simd.h header on
 some architecures
Message-ID: <20190729092149.GA32129@gondor.apana.org.au>
References: <20190729074434.21064-1-ard.biesheuvel@linaro.org>
 <20190729091204.GA32006@gondor.apana.org.au>
 <CAKv+Gu9WW_wGKZaXHjLxgUF0zNYBpEFZnjVyFy0tGmiGmb0-ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9WW_wGKZaXHjLxgUF0zNYBpEFZnjVyFy0tGmiGmb0-ag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 29, 2019 at 12:15:20PM +0300, Ard Biesheuvel wrote:
>
> It is simply a matter of adding simd.h to the various
> arch/<...>/include/asm/Kbuild files, but we'd have to do that for all
> architectures.

How does errno.h get added then? It doesn't appear to be in the
m68k (or arm) Kbuild file either.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
