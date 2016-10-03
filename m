From: Alex Cope <alexcope@google.com>
Subject: Re: Moving from blkcipher to skcipher
Date: Mon, 3 Oct 2016 10:58:03 -0700
Message-ID: <CA+cSK116PYracoP=tDhNg_q5+S-JLo+6H3rRAmuORErwW1EM5w@mail.gmail.com>
References: <CA+cSK1134BGVm7FprZcrDxVoU7P33GkJP17itLGvTpc8ECB9zw@mail.gmail.com>
 <3528786.X6pky90e93@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org,
        Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:33261 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751400AbcJCR6F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Oct 2016 13:58:05 -0400
Received: by mail-vk0-f48.google.com with SMTP id z126so167909009vkd.0
        for <linux-crypto@vger.kernel.org>; Mon, 03 Oct 2016 10:58:04 -0700 (PDT)
In-Reply-To: <3528786.X6pky90e93@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I was unclear in my initial message. I'm implementing a block cipher
mode of operation. I'm hoping there is a another block cipher mode of
operation that already uses skcipher, so I can use it as a reference
and avoid re-inventing the wheel. In particular, it would be helpful
if there is some implementation of a block cipher mode of operation
that is directly above the underlying block cipher, like CTR or CBC,
rather than something like CTS or rfc3686 which wrap around another
block cipher mode of operation.

On Mon, Oct 3, 2016 at 10:36 AM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Montag, 3. Oktober 2016, 10:06:23 CEST schrieb Alex Cope:
>
> Hi Alex,
>
>> I'm currently working on implementing HEH encryption, and am in the
>> process of switching from the blkcipher interface to the skcipher
>> interface.  All the examples I have found that use skcipher are
>> wrapping another mode of operation I.E. cts in cts(cbc(aes)) rather
>> than being directly above the block cipher I.E. ctr in ctr(aes). Are
>> there any existing examples of the latter type that I could use as a
>> reference? If not, is there an estimate on when that work will be
>> available?
>
> The issue is that a blkcipher is a synchronous version of the skcipher. So,
> you could easily move from blkcipher to skcipher and just rename the invoked
> API, provided you change the initialization to the following which triggers a
> synchronous operation:
>
> tfm = crypto_alloc_skcipher(kccavs_test->name, 0, CRYPTO_ALG_ASYNC);
>
> Note, you can only use ciphers marked as blkcipher or cipher in /proc/crypto
> with that.
>
> If you want to use all symmetric cipher implementation, you must use the async
> skcipher operation which is identical to the previous ablkcipher API. An
> example is given in the crypto API documentation, such as http://
> www.chronox.de/crypto-API/Code.html#id-1.8.2
>
> Ciao
> Stephan
