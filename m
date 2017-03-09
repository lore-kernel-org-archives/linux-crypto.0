From: Mahipal Reddy <mahipalreddy2006@gmail.com>
Subject: Re: [RFC PATCH v2 0/3] Cavium ThunderX ZIP driver
Date: Thu, 9 Mar 2017 23:55:52 +0530
Message-ID: <CALyTkE-HXr8GKRCuZCwGTe1zJ3s0vK2diyb7Jhuq9=K5wRzroQ@mail.gmail.com>
References: <1487135710-9692-1-git-send-email-Mahipal.Challa@cavium.com> <20170309104654.GD7185@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jan.Glauber@cavium.com, Vishnu Nair <Vishnu.Nair@cavium.com>,
        pathreya@cavium.com, Mahipal Challa <Mahipal.Challa@cavium.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33300 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753683AbdCISZy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2017 13:25:54 -0500
In-Reply-To: <20170309104654.GD7185@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 9, 2017 at 4:16 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Feb 15, 2017 at 10:45:07AM +0530, Mahipal Challa wrote:
>> Hi Herbert,
>>
>> This series adds support for hardware accelerated compression & decompression
>> as found on ThunderX (arm64) SOCs.
>>
>> As per your suggestion, we've switched to the new crypto acomp/scomp interface.
>>
>> To test the ZIP driver, we modified the kernel's ZSWAP to use acomp API's.
>>
>> Performance numbers from ZSWAP look promising.
>> The "average time" for compressing a 4KB page:
>>
>> Compression Software    : 278 usec
>> Compression HW deflate  :  17 usec
>> Compression HW LZS      :  11 usec
>>
>> Decompression Software  : 20 usec
>> Decompression HW deflate:  8 usec
>> Decompression HW LZS    :  6 usec
>>
>> Addressed the review comments from the RFC v1.
>>  - Added acomp/scomp crypto interface support.
>>  - Improved the error handling.
>>  - ZIP command completion codes are renamed suitably.
>>  - Removed some un-used code.
>>  - raw_smp_processor_id() replaced with smp_processor_id().
>>  - Some more miscellaneous changes.
>>
>> Patches are on top of "kernel/git/herbert/crypto-2.6.git" repository
>>
>> Please provide your feedback.
>
> All applied.  Thanks.
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Thank you Herbert.

Regards,
-Mahipal
