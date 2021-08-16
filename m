Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DB8C4338F
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 02:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57B84600D4
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 02:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhHPCIc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Aug 2021 22:08:32 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53052 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhHPCIc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Aug 2021 22:08:32 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mFS2Q-0002cg-A7; Mon, 16 Aug 2021 10:07:42 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mFS2J-0002cw-Pr; Mon, 16 Aug 2021 10:07:35 +0800
Date:   Mon, 16 Aug 2021 10:07:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Stephan Mueller <smueller@chronox.de>, sachinp@linux.vnet.ibm.com,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: DRBG - select SHA512
Message-ID: <20210816020735.GA10021@gondor.apana.org.au>
References: <304ee0376383d9ceecddbfd216c035215bbff861.camel@chronox.de>
 <20210716081411.GA2062@gondor.apana.org.au>
 <YRft/tuKE6MjHhY7@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRft/tuKE6MjHhY7@zn.tnic>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 14, 2021 at 06:23:26PM +0200, Borislav Petkov wrote:
> On Fri, Jul 16, 2021 at 04:14:12PM +0800, Herbert Xu wrote:
> > Stephan Mueller <smueller@chronox.de> wrote:
> > > With the swtich to use HMAC(SHA-512) as the default DRBG type, the
> > > configuration must now also select SHA-512.
> > > 
> > > Fixes: 9b7b94683a9b "crypto: DRBG - switch to HMAC SHA512 DRBG as default
> > > DRBG"
> > > Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
> > > Signed-off-by: Stephan Mueller <smueller@chronox.com>
> > > ---
> > > crypto/Kconfig | 2 +-
> > > 1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Patch applied.  Thanks.
> 
> Is that patch going to Linus anytime soon?
> 
> I still see it on latest rc5+:

I'll push it up this week.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
