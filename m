From: sri sowj <srisowj4linux@gmail.com>
Subject: Re: Counter Size in CTR mode for AES Driver
Date: Sat, 11 Apr 2015 09:07:35 +0530
Message-ID: <CAHTT9VKt_uWGWuRcUQR98T-Z_MWC2ovZBxJNQiH+NOMmezfOuA@mail.gmail.com>
References: <CAHTT9V+VXHYMc1Nkc9hh0Ew7nZy28zTc=rip4op-+BvC80MsTw@mail.gmail.com>
	<3837185.yfoG22Ljkb@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:32923 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbbDKDhg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Apr 2015 23:37:36 -0400
Received: by qkx62 with SMTP id 62so59722338qkx.0
        for <linux-crypto@vger.kernel.org>; Fri, 10 Apr 2015 20:37:36 -0700 (PDT)
In-Reply-To: <3837185.yfoG22Ljkb@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephen,

Thanks a million for the information provided. I really appreciate
your time and efforts.

In CTR mode counter size is not fixed , it varies based on
requirements like for rfc 3686 its size is 4 bytes, for other "CTR
Mode" operations it is 8/16 bytes. So how does linux crypto HW drivers
like nx-aes-ctr.c or omap-aes.c etc handles these variations?

In CTR mode nonce and counters plays a significant role while
performing encryption or decryption? ,So I am trying to understand
these aspect from linux kernel driver aspects where crypto H/W engine
is present.

from the user it might be possible to get request consisting the
counter size of 4 or 8 or 16 bytes.There has to be a way to deal these
variations from linux kernel crypto subsystem , but i am finding
little hard time to understand this.

Just to give a thought, is it possible  to find size of these fields
like nonce or counter from IV size ?

BR,
Srisowj

On Sat, Apr 11, 2015 at 2:21 AM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Samstag, 11. April 2015, 00:30:30 schrieb sri sowj:
>
> Hi sri,
>
>> Hi All,
>>
>> I have seen multiple open source drivers for AES(CTR) mode for
>> different Crypto Hardware Engines, I was not really sure on
>> countersize,nonce etc.
>> Please can any one provide some info on the following
>>
>> #1:How does AES driver identifies the counter size during the CTR mode
>> of operation?
>
> I am not sure about the question, but the block chaining mode is orthogonal to
> the block cipher.
>
> Thus, the block cipher does not need to know of the counter size of CTR. That
> applies to any block chaining mode.
>>
>> looks like AES in CTR mode supports "countersize" of multiple lengths as
> below:
>> >>1: First is a counter which is made up of a nonce and counter. The nonce
>> >>is random, and the remaining bytes are counter bytes (which are
>> >>incremented).
>>  For example, a 16 byte block cipher might use the high 8 bytes as a
>> nonce, and the low 8 bytes as a counter.
>>
>> >>2: Second is a counter block, where all bytes are counter bytes and can be
>> >>incremented as carries are generated.
>>  For example, in a 16 byte block cipher, all 16 bytes are counter bytes
>>
>> #2: Does Linux Kernel Crypto subsystem increments the counter value
>> for every block of input or is it needs tp be taken care by Kernel
>> Driver for the respective Crypto H/W ?
>
> This depends on your choice -- the kernel crypto API provides crypto_inc() for
> the increment, it provides the ctr template to wrap a block chaining mode. The
> kernel crypto API does not restrict, it enables you.
>>
>>
>> #3:counters and nonces are something which will be extracted from the
>> IV i.e., IV = nonce + counter
>> Note if "l" is length of IV then first "l/2" is length of nonce and
>> next "l/2" is length of counter.
>
> What you describe may be on e convention. But the ctr.c template initializes
> the counter value to 0 during init time. So, you see that there is no hard
> fact. The counter is in fact just an IV.
>>
>> Any information regarding the above is really appreciable.
>>
>> BR,
>> SriSowj
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> Ciao
> Stephan
