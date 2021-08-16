Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CF6C4338F
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 02:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 752CC61440
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 02:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhHPCkN convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Aug 2021 22:40:13 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:27797 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhHPCkM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Aug 2021 22:40:12 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4Gnyzv5hMNzBBtB;
        Mon, 16 Aug 2021 04:39:39 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3zLKgHYKhixx; Mon, 16 Aug 2021 04:39:39 +0200 (CEST)
Received: from vm-hermes.si.c-s.fr (vm-hermes.si.c-s.fr [192.168.25.253])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4Gnyzv2JJNzBBrY;
        Mon, 16 Aug 2021 04:39:39 +0200 (CEST)
Received: by vm-hermes.si.c-s.fr (Postfix, from userid 33)
        id 824B8248; Mon, 16 Aug 2021 04:45:14 +0200 (CEST)
Received: from 37.165.172.2 ([37.165.172.2]) by messagerie.c-s.fr (Horde
 Framework) with HTTP; Mon, 16 Aug 2021 04:45:14 +0200
Date:   Mon, 16 Aug 2021 04:45:14 +0200
Message-ID: <20210816044514.Horde.WAvjInneMUMGu0ryEZHgrQ8@messagerie.c-s.fr>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, sachinp@linux.vnet.ibm.com,
        Stephan Mueller <smueller@chronox.de>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] crypto: DRBG - select SHA512
References: <304ee0376383d9ceecddbfd216c035215bbff861.camel@chronox.de>
 <20210716081411.GA2062@gondor.apana.org.au> <YRft/tuKE6MjHhY7@zn.tnic>
 <20210816020735.GA10021@gondor.apana.org.au>
In-Reply-To: <20210816020735.GA10021@gondor.apana.org.au>
User-Agent: Internet Messaging Program (IMP) H5 (6.2.3)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> a écrit :

> On Sat, Aug 14, 2021 at 06:23:26PM +0200, Borislav Petkov wrote:
>> On Fri, Jul 16, 2021 at 04:14:12PM +0800, Herbert Xu wrote:
>> > Stephan Mueller <smueller@chronox.de> wrote:
>> > > With the swtich to use HMAC(SHA-512) as the default DRBG type, the
>> > > configuration must now also select SHA-512.
>> > >
>> > > Fixes: 9b7b94683a9b "crypto: DRBG - switch to HMAC SHA512 DRBG  
>> as default
>> > > DRBG"
>> > > Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
>> > > Signed-off-by: Stephan Mueller <smueller@chronox.com>
>> > > ---
>> > > crypto/Kconfig | 2 +-
>> > > 1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > Patch applied.  Thanks.
>>
>> Is that patch going to Linus anytime soon?
>>
>> I still see it on latest rc5+:
>
> I'll push it up this week.

The fixes tag has a problem it seems. Should be corrected before pushing.

Christophe

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


