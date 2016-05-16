From: Gadre Nayan <gadrenayan@gmail.com>
Subject: Re: Decrypting data in RX path
Date: Mon, 16 May 2016 20:10:56 +0530
Message-ID: <CAKJ7aR5gJ=ebBgYPq6=eUQoVLi8xXz9EsRnRqWvh2_EG6s7p1g@mail.gmail.com>
References: <CAKJ7aR5v5LmgZ5XAv8+9mAtksdSu=LJz=oK9AmHO2t4bDiqSzw@mail.gmail.com>
	<6061728.aByMvLa2kt@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33982 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbcEPOk5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 May 2016 10:40:57 -0400
Received: by mail-io0-f196.google.com with SMTP id d62so15198126iof.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 May 2016 07:40:56 -0700 (PDT)
In-Reply-To: <6061728.aByMvLa2kt@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

1. The context of the question "best place to decrypt in
kernel(module/driver)" is I want to encrypt network packets sent from
my system and decrypt them back to work with crypto apis. So the
encryption part I have done in  a Kernel thread, decryption part could
be either in driver or a pre-routing hook. Which is appropriate.

2. I went through the esp_input function for rx.

As I understand, It allocates a decrypt request and and calls
crypto_aead_decrypt(req).

A. Since this request is asynchronous, it would be handled through
condition variables, Am i right on this?
B. Also the IPSEC routines like input and output would run in softirq context ?
C. esp_input_done() is a callback for decrypt, so as soon as
crypto_aead_decrypt(req) is called and the encryption does not happen
immediately, it will return the error _EINPROGRESS. Now this will
cause the esp_input function to return immediately. So then when is
the deferred decryption checked. I see esp_input_done2 as well. How is
the flow and call of these callbacks happening.

Apologize for being so verbose.

Thanks.





On Mon, May 16, 2016 at 6:02 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Montag, 16. Mai 2016, 17:24:12 schrieb Gadre Nayan:
>
> Hi Gadre,
>
>> Hi,
>>
>> I am able to encrypt data using the asynchronous kernel crypto API's.
>> I can observe the encrypted data on the protocol analyzer.
>>
>> I wanted to decry-pt the data now on the receiver side, So I have
>> following questions.
>>
>> 1. What is the best place to decrypt the data, in kernel space (module
>> (pre-routing hook) or driver) OR user space using (maybe using raw
>> sockets or after socket recv).
>
> This is a very broad question and cannot be answered without knowning the
> context.
>>
>> What precautions should be taken in terms of locking while using
>> crypto api's in kernel space in RX path (Softirq context) --> Can
>> someone point to existing sample in kernel where decryption is done in
>> RX path.
>
> net/ipv4/esp4.c:esp_input for rx and esp_output for tx.
>>
>>
>> 2. If I encrypt data in kernel space can I decrypt it in User-space
>> using same encryption methods and Keys.
>
> Sure, if you have the keys and all information about the used crypto.
>>
>> Thanks.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Ciao
> Stephan
