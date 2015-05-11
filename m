From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] crypto: arm/sha512 - accelerated SHA-512 using ARM
 generic ASM and NEON
Date: Mon, 11 May 2015 09:23:32 +0200
Message-ID: <CAKv+Gu_G=mKAmc_RXQjt4osbUHDyPwdY1h08kmbOTkQJfXFPyA@mail.gmail.com>
References: <1431074782-22141-1-git-send-email-ard.biesheuvel@linaro.org>
	<20150511065952.GB2598@gondor.apana.org.au>
	<CAKv+Gu9+xrX2nB43cskOoL63WjZGTDdq9ZTO-maWas5u=ng=JQ@mail.gmail.com>
	<20150511072025.GA2789@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:38735 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbbEKHXd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 03:23:33 -0400
Received: by igbhj9 with SMTP id hj9so63014869igb.1
        for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 00:23:33 -0700 (PDT)
In-Reply-To: <20150511072025.GA2789@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11 May 2015 at 09:20, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, May 11, 2015 at 09:00:49AM +0200, Ard Biesheuvel wrote:
>>
>> Yes, you are right. Let me figure out what's going on and send you a
>> new version.
>
> Don't worry.  I fixed it up while applying the patch.
>

OK, thanks!
