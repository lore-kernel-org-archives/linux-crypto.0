From: Xiong Zhou <jencce.kernel@gmail.com>
Subject: Re: linux-next: Tree for May 15 (crypto /crct10dif)
Date: Fri, 17 May 2013 11:06:06 +0800
Message-ID: <CADJHv_s0qd3OkFAooNZono+jGZ92TEcqpVX9z8B0Nf0+VEpHPA@mail.gmail.com>
References: <20130515132627.817585a3d9fb3a3e502eb586@canb.auug.org.au>
	<5193CCEC.7070909@infradead.org>
	<alpine.DEB.2.02.1305161152530.31865@M2420>
	<CAMuHMdUmD2DMNeezetHNbe9DgQXpTN4BEfEmJSztyzCivQpyXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tim.c.chen@linux.intel.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux-Next <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:58903 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3EQDGI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 May 2013 23:06:08 -0400
In-Reply-To: <CAMuHMdUmD2DMNeezetHNbe9DgQXpTN4BEfEmJSztyzCivQpyXQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2013/5/16 Geert Uytterhoeven <geert@linux-m68k.org>:
> On Thu, May 16, 2013 at 5:57 AM, Xiong Zhou <jencce.kernel@gmail.com> wrote:
>> --- a/crypto/Kconfig
>> +++ b/crypto/Kconfig
>> @@ -378,6 +378,7 @@ config CRYPTO_CRC32_PCLMUL
>>
>>  config CRYPTO_CRCT10DIF
>>         tristate "CRCT10DIF algorithm"
>> +       depends on CRC_T10DIF
>
> This is a library symbol, so "select CRC_T10DIF"?

En.. make sense, Thanks.

Xiong

>
>>         select CRYPTO_HASH
>>         help
>>           CRC T10 Data Integrity Field computation is being cast as
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
