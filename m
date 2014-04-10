From: Sonic Zhang <sonic.adi@gmail.com>
Subject: Re: [PATCH] crypt: bfin_crc: access crc registers by ioread32 and
 iowrite32 functions
Date: Thu, 10 Apr 2014 11:50:37 +0800
Message-ID: <CAJxxZ0OgK2EP51wv1_rqigfLOvMAXMiuNciDws2xSyxnaTFUdg@mail.gmail.com>
References: <1395910353-2853-1-git-send-email-sonic.adi@gmail.com>
	<201404091932.02072.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	adi-buildroot-devel@lists.sourceforge.net,
	Sonic Zhang <sonic.zhang@analog.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:60594 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965373AbaDJDuh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Apr 2014 23:50:37 -0400
Received: by mail-oa0-f52.google.com with SMTP id l6so3808758oag.39
        for <linux-crypto@vger.kernel.org>; Wed, 09 Apr 2014 20:50:37 -0700 (PDT)
In-Reply-To: <201404091932.02072.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Marek,

On Thu, Apr 10, 2014 at 1:32 AM, Marek Vasut <marex@denx.de> wrote:
> On Thursday, March 27, 2014 at 09:52:33 AM, Sonic Zhang wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> Move architecture independant crc header file out of the blackfin folder.
>>
>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>
> [...]
>
>> @@ -530,13 +532,14 @@ static irqreturn_t bfin_crypto_crc_handler(int irq,
>> void *dev_id) {
>>       struct bfin_crypto_crc *crc = dev_id;
>>
>> -     if (crc->regs->status & DCNTEXP) {
>> -             crc->regs->status = DCNTEXP;
>> +     if (ioread32(&crc->regs->status) & DCNTEXP) {
>> +             iowrite32(DCNTEXP, &crc->regs->status);
>>
>>               /* prepare results */
>> -             put_unaligned_le32(crc->regs->result, crc->req->result);
>> +             put_unaligned_le32(ioread32(&crc->regs->result),
>> +                     crc->req->result);
>>
>> -             crc->regs->control &= ~BLKEN;
>> +             iowrite32(ioread32(&crc->regs->control) & ~BLKEN, &crc->regs-
>>control);
>
> You should avoid combining the IO accessors into each other like this, it's
> rather cryptic. Please introduce some variable like so:
>
> u32 reg;
> reg = ioread32(...);
> reg &= ~....
> iowrite32(reg, ...);
>
> [...]

OK

>
> Why do you not use readl()/writel() ?

ioread and iowrite are inline function, which do parameter type
checking, while readl and writel don't as a macro.
I am fine if you prefer readl/writel in crypto code.

Thanks

Sonic Zhang
