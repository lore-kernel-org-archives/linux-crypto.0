Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDFBC433FE
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Oct 2022 06:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJIGUL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 9 Oct 2022 02:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiJIGUK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Oct 2022 02:20:10 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78058140ED
        for <linux-crypto@vger.kernel.org>; Sat,  8 Oct 2022 23:20:07 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ohPfJ-00CrEn-I2; Sun, 09 Oct 2022 17:19:58 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Oct 2022 14:19:57 +0800
Date:   Sun, 9 Oct 2022 14:19:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Taehee Yoo <ap420073@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "ebiggers@google.com" <ebiggers@google.com>
Subject: Re: [PATCH] crypto: x86: Do not acquire fpu context for too long
Message-ID: <Y0JoDWx0Q5BmO/wR@gondor.apana.org.au>
References: <20221004044912.24770-1-ap420073@gmail.com>
 <Yzu8Kd2botr3eegj@gondor.apana.org.au>
 <f7c52ed1-8061-8147-f676-86190118cc56@gmail.com>
 <MW5PR84MB18420D6E1A31D9C765EF6ED4AB5A9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
 <CAMj1kXGmKunh-OCvGFf8T6KJJXSHRYzacjSojBD3__u0o-3D1w@mail.gmail.com>
 <MW5PR84MB1842762F8B2ABC27A1A13614AB5E9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR84MB1842762F8B2ABC27A1A13614AB5E9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 08, 2022 at 07:48:07PM +0000, Elliott, Robert (Servers) wrote:
>
> Perhaps the cycles mode needs to call cond_resched() too?

Yes, just make the cond_resched unconditional.  Having a few too many
rescheds shouldn't be an issue.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
