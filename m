From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 5/5] crypto: chacha20 - Fix keystream alignment for chacha20_block()
Date: Wed, 22 Nov 2017 22:06:08 +0000
Message-ID: <CAKv+Gu-6inNDCPq0_2Y4ZS27xg7Su1-qTvLfQ4sBKozYNTNqzQ@mail.gmail.com>
References: <20171122195139.121269-1-ebiggers3@gmail.com> <20171122195139.121269-6-ebiggers3@gmail.com>
 <CAKv+Gu__YdYWXgGfNSng8fDj9F0pw-i4zbAaN+uxES+r6mRMpw@mail.gmail.com> <20171122212950.GA74584@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Martin Willi <martin@strongswan.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:42759 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbdKVWGJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Nov 2017 17:06:09 -0500
Received: by mail-io0-f178.google.com with SMTP id u42so24710931ioi.9
        for <linux-crypto@vger.kernel.org>; Wed, 22 Nov 2017 14:06:09 -0800 (PST)
In-Reply-To: <20171122212950.GA74584@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 22 November 2017 at 21:29, Eric Biggers <ebiggers3@gmail.com> wrote:
> On Wed, Nov 22, 2017 at 08:51:57PM +0000, Ard Biesheuvel wrote:
>> On 22 November 2017 at 19:51, Eric Biggers <ebiggers3@gmail.com> wrote:
>> > From: Eric Biggers <ebiggers@google.com>
>> >
>> > When chacha20_block() outputs the keystream block, it uses 'u32' stores
>> > directly.  However, the callers (crypto/chacha20_generic.c and
>> > drivers/char/random.c) declare the keystream buffer as a 'u8' array,
>> > which is not guaranteed to have the needed alignment.
>> >
>> > Fix it by having both callers declare the keystream as a 'u32' array.
>> > For now this is preferable to switching over to the unaligned access
>> > macros because chacha20_block() is only being used in cases where we can
>> > easily control the alignment (stack buffers).
>> >
>>
>> Given this paragraph, I think we agree the correct way to fix this
>> would be to make chacha20_block() adhere to its prototype, so if we
>> deviate from that, there should be a good reason. On which
>> architecture that cares about alignment is this expected to result in
>> a measurable performance benefit?
>>
>
> Well, variables on the stack tend to be 4 or even 8-byte aligned anyway, so this
> change probably doesn't make a difference in practice currently.  But it still
> should be fixed, in case it does become a problem.
>

Agreed.

> We could certainly leave the type as u8 array and use put_unaligned_le32()
> instead; that would be a simpler change.  But that would be slower on
> architectures where a potentially-unaligned access requires multiple
> instructions.
>

The access itself would be slower, yes. But given the amount of work
performed in chacha20_block(), I seriously doubt that would actually
matter in practice.
