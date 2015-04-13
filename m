From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] crypto/arm: accelerated SHA-512 using ARM generic ASM
 and NEON
Date: Mon, 13 Apr 2015 11:34:51 +0200
Message-ID: <CAKv+Gu_7RAAvWRpfAvTCs3zNPvbfrD=V7AHcJr+Qcj0B9Sf9TA@mail.gmail.com>
References: <1428676148-28210-1-git-send-email-ard.biesheuvel@linaro.org>
	<F695F357-2A5C-4DFC-9F0E-188CDBBE7C01@linaro.org>
	<CAKv+Gu-6mZwrVSCvS+ZWWwwM-294nWAqX4_J3r5Z8NM7KKC0=Q@mail.gmail.com>
	<2845656.4sNJ3XBxnz@wuerfel>
	<CAKv+Gu9TU6ETRQDvp7M7Q43xAR5A25scgP3tsvZMmzBQNOK7Cg@mail.gmail.com>
	<20150413041343.GB11091@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Arnd Bergmann <arnd@arndb.de>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"samitolvanen@google.com" <samitolvanen@google.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34575 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbbDMJev (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Apr 2015 05:34:51 -0400
Received: by iget9 with SMTP id t9so52124833ige.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 Apr 2015 02:34:51 -0700 (PDT)
In-Reply-To: <20150413041343.GB11091@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 13 April 2015 at 06:13, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Sat, Apr 11, 2015 at 09:15:10PM +0200, Ard Biesheuvel wrote:
>>
>> @Herbert: could you please apply this onto cryptodev before sending
>> out your pull request for v4.1?
>
> Done.
>
>> And please disregard $subject, I will post a v3 with a similar
>> 'depends on' added (unless you're ok to add it yourself)
>
> Please resend the patch.  But I'll process it after the merge
> window closes so no hurry.
>


OK, all fine.

Thanks Herbert!
