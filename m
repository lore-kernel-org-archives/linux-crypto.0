From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: linux-4.6/drivers/crypto/ux500/hash/hash_core.c: 2 * possible bad
 size ?
Date: Wed, 8 Jun 2016 14:52:21 +0200
Message-ID: <CACRpkdarppP5BFZ6co-sLgsvwD0Yswp21Sz7VcCEZVeX4mcrAw@mail.gmail.com>
References: <CAMzoamabHQ0SaMmkTfwDGGZBpOxSE6Qci4TwEUAEMbtWO3X-Ew@mail.gmail.com>
 <20160518074650.GA6097@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Binderman <linuxdev.baldrick@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	David Binderman <dcb314@hotmail.com>,
	Andreas Westin <andreas.westin@stericsson.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Joakim Bech <joakim.bech@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33362 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161498AbcFHMwX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2016 08:52:23 -0400
Received: by mail-oi0-f44.google.com with SMTP id k23so10767968oih.0
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jun 2016 05:52:22 -0700 (PDT)
In-Reply-To: <20160518074650.GA6097@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 18, 2016 at 9:46 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, May 16, 2016 at 07:13:12PM +0100, David Binderman wrote:
>> Hello there,
>>
>> 1.
>>
>> linux-4.6/drivers/crypto/ux500/hash/hash_core.c:784]: (warning) Division by
>> result of sizeof(). memmove() expects a size in bytes, did you intend to
>> multiply instead?
>>
>> Source code is
>>
>>                 memmove(req_ctx->state.buffer,
>>                     device_data->state.buffer,
>>                     HASH_BLOCK_SIZE / sizeof(u32));
>>
>> Maybe better code
>>
>>                 memmove(req_ctx->state.buffer,
>>                     device_data->state.buffer,
>>                     HASH_BLOCK_SIZE);

Yeah obviously the latter as in hash_alg.h:

struct hash_state {
(...)
    u32        buffer[HASH_BLOCK_SIZE / sizeof(u32)];

That could just as well be an u8 of HASH_BLOCK_SIZE.

Sending a patch for this.

>> linux-4.6/drivers/crypto/ux500/hash/hash_core.c:835]: (warning) Division by
>> result of sizeof(). memmove() expects a size in bytes, did you intend to
>> multiply instead?
>>
>> Duplicate.
>
> Thanks for noticing these bugs.  This driver hasn't been maintained
> since 2012, so unless someone steps up I'm going to just delete it.

I'm trying to take a look at it because I'm using this platform
for tests and it's nice to have all features enabled.

And it has some problems (I added prints to also print successful tests):

[    3.864746] alg: hash: Test 1 SUCCEEDED for sha1-ux500
[    3.870147] alg: hash: Test 2 SUCCEEDED for sha1-ux500
[    3.875610] alg: hash: Test 3 SUCCEEDED for sha1-ux500
[    3.881408] alg: hash: Test 4 SUCCEEDED for sha1-ux500
[    3.886596] alg: hash: Chunking test 1 SUCCEEDED for sha1-ux500
[    3.892639] alg: hash: Chunking test 2 FAILED for sha1-ux500
[    3.898284] result:
[    3.900421] 00000000: 76 b4 ed 2f d7 11 1d c8 64 4c 38 b0 f8 27 19 89
[    3.906860] 00000010: 58 1e bb 3a
[    3.915588] expected:
[    3.917846] 00000000: 97 01 11 c4 e7 7b cc 88 cc 20 45 9c 02 b6 9b 4a
[    3.928314] 00000010: a8 f5 82 17
[    3.937255] alg: hash: Test 1 SUCCEEDED for sha256-ux500
[    3.948089] alg: hash: Test 2 SUCCEEDED for sha256-ux500
[    3.961944] alg: hash: Test 3 SUCCEEDED for sha256-ux500
[    3.967590] alg: hash: Test 4 SUCCEEDED for sha256-ux500
[    3.973083] alg: hash: Chunking test 1 SUCCEEDED for sha256-ux500
[    3.979248] alt: hash: Failed to export() for sha256-ux500
[    3.984802] hash: partial update failed on test 1 for sha256-ux500: ret=38
[    3.992004] alg: hash: Test 1 SUCCEEDED for hmac-sha1-ux500
[    3.997650] alg: hash: Test 2 SUCCEEDED for hmac-sha1-ux500
[    4.003356] alg: hash: Test 3 SUCCEEDED for hmac-sha1-ux500
[    4.009002] alg: hash: Test 4 SUCCEEDED for hmac-sha1-ux500
[    4.014678] alg: hash: Test 5 SUCCEEDED for hmac-sha1-ux500
[    4.020385] alg: hash: Test 6 SUCCEEDED for hmac-sha1-ux500
[    4.026062] alg: hash: Chunking test 1 SUCCEEDED for hmac-sha1-ux500
[    4.032470] alt: hash: Failed to export() for hmac-sha1-ux500
[    4.038208] hash: partial update failed on test 1 for hmac-sha1-ux500: ret=38
[    4.045623] alg: hash: Test 1 SUCCEEDED for hmac-sha256-ux500
[    4.051483] alg: hash: Test 2 SUCCEEDED for hmac-sha256-ux500
[    4.057342] alg: hash: Test 3 SUCCEEDED for hmac-sha256-ux500
[    4.063201] alg: hash: Test 4 SUCCEEDED for hmac-sha256-ux500
[    4.069030] alg: hash: Test 5 SUCCEEDED for hmac-sha256-ux500
[    4.074890] alg: hash: Test 6 SUCCEEDED for hmac-sha256-ux500
[    4.080780] alg: hash: Test 7 SUCCEEDED for hmac-sha256-ux500
[    4.086608] alg: hash: Test 8 SUCCEEDED for hmac-sha256-ux500
[    4.092468] alg: hash: Test 9 SUCCEEDED for hmac-sha256-ux500
[    4.098297] alg: hash: Chunking test 1 SUCCEEDED for hmac-sha256-ux500
[    4.104888] alt: hash: Failed to export() for hmac-sha256-ux500
[    4.110809] hash: partial update failed on test 1 for
hmac-sha256-ux500: ret=38
[    4.118164] hash1 hash1: successfully registered
[    4.123687] alg: No test for aes (aes-ux500)
[    4.132354] alg: No test for des (des-ux500)
[    4.136749] alg: No test for des3_ede (des3_ede-ux500)
[    4.151306] alg: skcipher: Test 1 failed (invalid result) on
encryption for cbc-des-ux500
[    4.159484] 00000000: 03 91 6b cc 4a f6 3a 53 9c 4d 2e 2b 91 83 44 f6
[    4.165954] 00000010: aa 6a 15 6a dc b5 e0 3d
[    4.170501] cryp1 cryp1: successfully registered

The simple tests always work, it's those stressful ones that create
problems.

Joakim: did you have a memory of this code working? Should
I check the vendor tree for fixes?

Yours,
Linus Walleij
