From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] wusbcore: Fix one more crypto-on-the-stack bug
Date: Mon, 12 Dec 2016 15:57:52 -0800
Message-ID: <CALCETrUazFL7h01Ej_TttFJrEMRTivZKDx8nLWkZRkBdfcH=ug@mail.gmail.com>
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
 <20161212214447.GA12142@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andy Lutomirski <luto@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:34088 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932219AbcLLX6O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Dec 2016 18:58:14 -0500
Received: by mail-ua0-f179.google.com with SMTP id 51so97315104uai.1
        for <linux-crypto@vger.kernel.org>; Mon, 12 Dec 2016 15:58:14 -0800 (PST)
In-Reply-To: <20161212214447.GA12142@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 12, 2016 at 1:44 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Dec 12, 2016 at 12:52:45PM -0800, Andy Lutomirski wrote:
>> The driver put a constant buffer of all zeros on the stack and
>> pointed a scatterlist entry at it.  This doesn't work with virtual
>> stacks.  Make the buffer static to fix it.
>>
>> Cc: stable@vger.kernel.org # 4.9 only
>> Reported-by: Eric Biggers <ebiggers3@gmail.com>
>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>> ---
>>  drivers/usb/wusbcore/crypto.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/wusbcore/crypto.c b/drivers/usb/wusbcore/crypto.c
>> index 79451f7ef1b7..a7e007a0cd49 100644
>> --- a/drivers/usb/wusbcore/crypto.c
>> +++ b/drivers/usb/wusbcore/crypto.c
>> @@ -216,7 +216,7 @@ static int wusb_ccm_mac(struct crypto_skcipher *tfm_cbc,
>>       struct scatterlist sg[4], sg_dst;
>>       void *dst_buf;
>>       size_t dst_size;
>> -     const u8 bzero[16] = { 0 };
>> +     static const u8 bzero[16] = { 0 };
>
> Hm, can static memory handle DMA?  That's a requirement of the USB
> stack, does this data later end up being sent down to a USB host
> controller?

I think it doesn't, but I'll switch it to use empty_zero_page instead.

--Andy
