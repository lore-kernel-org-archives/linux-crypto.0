Return-Path: <SRS0=AFir=YB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA33DC4360C
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 17:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6CBA21835
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 17:46:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="A2Wbepbv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfJHRqP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Oct 2019 13:46:15 -0400
Received: from mx.0dd.nl ([5.2.79.48]:36106 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfJHRqP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Oct 2019 13:46:15 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 3B3A85FA7F;
        Tue,  8 Oct 2019 19:46:13 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="A2Wbepbv";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id DFE083CFEC;
        Tue,  8 Oct 2019 19:46:12 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com DFE083CFEC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1570556772;
        bh=kV+vIzA0zWoS69BQ6fB51H6yvivNuyeQpXt6POzp6Io=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A2WbepbvnkKQYQPbULmUp3r2HUUl9ErA8tWJdHXVXmzK5Wk2rhk1u/LOLyW8W3SMa
         758DzCX3o6D62aLeza/Y+X2WfWPTl9dEwzIPzwQi9n/c2V8hsF0ByAx1UgXomb/7xE
         vrm2+eaPnsalFKYsFQojAkqHlEHc28q/VAX/wxQzxrRT6Y+PjTyu24EWxJXGm4w55t
         JUVE9bOTP2L8PkJ7DPJb+LMjOzAhWzEKncFewOmnoYsp2SuN7TBlUlyaJ3pcOZbW5a
         hHZfTBK/GEoROTk6/EOdzJTaczeeLCyh7hrtHnnYmUHhfeu8D5i04rFT4h7TGA85Th
         5nULvP25/DKgg==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Tue, 08 Oct 2019 17:46:12 +0000
Date:   Tue, 08 Oct 2019 17:46:12 +0000
Message-ID: <20191008174612.Horde.fE366514ZTQOYvEAC1f2Wnv@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Andy Polyakov <appro@cryptogams.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH v3 19/29] crypto: mips/poly1305 - incorporate
 OpenSSL/CRYPTOGAMS optimized implementation
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
 <20191007164610.6881-20-ard.biesheuvel@linaro.org>
 <20191007210242.Horde.FiSEhRSAuhKHgFx9ROLFIco@www.vdorst.com>
 <a1c1ade1-f62a-3422-c161-a1d62ea67203@cryptogams.org>
In-Reply-To: <a1c1ade1-f62a-3422-c161-a1d62ea67203@cryptogams.org>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Andy Polyakov <appro@cryptogams.org>:

> Hi,
>
> On 10/7/19 11:02 PM, René van Dorst wrote:
>> Quoting Ard Biesheuvel <ard.biesheuvel@linaro.org>:
>>
>>> This is a straight import of the OpenSSL/CRYPTOGAMS Poly1305
>>> implementation
>>> for MIPS authored by Andy Polyakov, and contributed by him to the OpenSSL
>>> project.
>
> Formally speaking this is a little bit misleading statement. Cryptogams
> poly1305-mips module implements both 64- and 32-bit code paths, while
> what you'll find in OpenSSL is 64-only implementation. But in either case...

Hi Andy,

Sorry for the confustion and that it is misleading.
I took the assembly output generated by  
arch/mips/crypto/poly1305-mips.pl which
is included in Ard series [0]. Output is generated while compiling mips32r2
kernel with Ard series included.
So it should generated the mips32r2 variant [1] and I appended the function
names with "_mips" so they match the current WireGuard implementation. So that
it is now a drop-in replacement.

>>> <snip>
>>
>> Hi Ard,
>>
>> Is it also an option to include my mip32r2 optimized poly1305 version?
>>
>> Below the results which shows a good improvement over the Andy Polyakov
>> version.
>> I swapped the poly1305 assembly file and rename the function to
>> <func_name>_mips
>> Full WireGuard source with the changes [0]
>>
>> bytes |  RvD | openssl | delta | delta / openssl
>> ...
>> 4096 | 9160 | 11755   | -2595 | -22,08%
>
> I assume that the presented results depict regression after switch to
> cryptogams module. Right?

Yes, by only swapping poly1305 assembly file.

> RvD implementation distinguishes itself in two ways:
>
> 1. some of additions in inner loop are replaced with multiply-by-1-n-add;
> 2. carry chain at the end of the inner loop is effectively fused with
> beginning of the said loop/taken out of the loop.
>
> I recall attempting 1. and chosen not to do it with following rationale.
> On processor I have access to, Octeon II, it made no significant
> difference. It was better, but only marginally. And it's understandable,
> because Octeon II should have lesser difficulty pairing those additions
> with multiply-n-add instructions. But since multiplication is an
> expensive operation, it can be pretty slow, I reckoned that on processor
> less potent than Octeon II it might be more appropriate to minimize
> amount of multiplication-n-add instructions. In other words idea is not
> (and never has been) to get fixated on specific processor at hand, but
> try to find a sensible compromise that would produce reasonable
> performance on a range of processors. Of course problem is that it's
> just an assumption I made here, and it could turn wrong in practice:-)

I used poly1305-donna32.c [4] as reference for my version.
Using multiply-n-add is a logical choice for mips32r2 with this code.
I only using multiply-by-1-n-add after the multiply-n-add for adding the carry
of the previous calculation. It seems to have no downside.
I manually checked for stales by adding nop instruction after multiply-n-add.
But the benchmark result shows me an increase in cpu cycles with the nops.

So using multiply-by-1-n-add only for additions is slow.

> So I wonder which processor do you run on, René?

I am using a Mediatek MT7621 mips32r2 running at 880MHz. [3]

> 70MB/sec for 1KB blocks for chacha20poly1305 on 1GHz Octeon II. You
> report ~34MB/sec, so it ought to be something different. Given second
> data point it might be appropriate to reconsider and settle for
> multiply-by-1-n-add.
>

multiply-by-1-n-add is slow as a standalone feature.
I would not recommend it.

> As for 2. I haven't considered it. Since it's a back-to-back dependency
> chain, if fused with top of the loop, it actually has more promising
> potential than 1. And it would improve all results, not only MISP32R2.
> Would you trust me with adopting it to my module? Naturally with due credit.

Yes that is totally fine.
I hope that you found more spots that we can improve.

>
> Cheers.

Bench results with the generic version of chacha20 and poly1305 that  
comes with
WireGuard.

[ 1328.931574] wireguard: chacha20poly1305 self-tests: pass
[ 1329.151368] wireguard: chacha20poly1305_encrypt:    1 bytes,        
0.228 MB/sec,     1779 cycles
[ 1329.371232] wireguard: chacha20poly1305_encrypt:   16 bytes,        
3.716 MB/sec,     1752 cycles
[ 1329.592467] wireguard: chacha20poly1305_encrypt:   64 bytes,       
13.005 MB/sec,     2016 cycles
[ 1329.816587] wireguard: chacha20poly1305_encrypt:  128 bytes,       
18.200 MB/sec,     2902 cycles
[ 1330.128756] wireguard: chacha20poly1305_encrypt: 1408 bytes,       
28.735 MB/sec,    20550 cycles
[ 1330.441997] wireguard: chacha20poly1305_encrypt: 1420 bytes,       
28.032 MB/sec,    21247 cycles
[ 1330.752105] wireguard: chacha20poly1305_encrypt: 1440 bytes,       
28.426 MB/sec,    21268 cycles
[ 1330.969983] wireguard: chacha20poly1305_decrypt:    1 bytes,        
0.222 MB/sec,     1827 cycles
[ 1331.189853] wireguard: chacha20poly1305_decrypt:   16 bytes,        
3.620 MB/sec,     1799 cycles
[ 1331.411065] wireguard: chacha20poly1305_decrypt:   64 bytes,       
12.695 MB/sec,     2060 cycles
[ 1331.635191] wireguard: chacha20poly1305_decrypt:  128 bytes,       
17.919 MB/sec,     2947 cycles
[ 1331.947393] wireguard: chacha20poly1305_decrypt: 1408 bytes,       
28.735 MB/sec,    20597 cycles
[ 1332.260602] wireguard: chacha20poly1305_decrypt: 1420 bytes,       
28.032 MB/sec,    21287 cycles
[ 1332.570649] wireguard: chacha20poly1305_decrypt: 1440 bytes,       
28.426 MB/sec,    21307 cycles
[ 1332.782310] wireguard: poly1305:    0 bytes,       0.000 MB/sec,     
   176 cycles
[ 1332.992837] wireguard: poly1305:    1 bytes,       1.240 MB/sec,     
   290 cycles
[ 1333.202706] wireguard: poly1305:   16 bytes,      21.672 MB/sec,     
   262 cycles
[ 1333.413510] wireguard: poly1305:   64 bytes,      55.639 MB/sec,     
   434 cycles
[ 1333.632105] wireguard: poly1305:  576 bytes,     103.875 MB/sec,     
  2280 cycles
[ 1333.863911] wireguard: poly1305: 1280 bytes,     110.473 MB/sec,     
  4816 cycles
[ 1334.096050] wireguard: poly1305: 1408 bytes,     111.046 MB/sec,     
  5275 cycles
[ 1334.326574] wireguard: poly1305: 1420 bytes,     109.691 MB/sec,     
  5387 cycles
[ 1334.556580] wireguard: poly1305: 1440 bytes,     111.098 MB/sec,     
  5390 cycles
[ 1334.788215] wireguard: poly1305: 1536 bytes,     111.474 MB/sec,     
  5740 cycles
[ 1335.071139] wireguard: poly1305: 4096 bytes,     114.843 MB/sec,     
14957 cycles
[ 1335.281688] wireguard: chacha20:    0 bytes,       0.000 MB/sec,     
    43 cycles
[ 1335.494245] wireguard: chacha20:    1 bytes,       0.652 MB/sec,     
   592 cycles
[ 1335.704250] wireguard: chacha20:    2 bytes,       1.306 MB/sec,     
   593 cycles
[ 1335.914301] wireguard: chacha20:    3 bytes,       1.928 MB/sec,     
   603 cycles
[ 1336.124247] wireguard: chacha20:    4 bytes,       2.613 MB/sec,     
   593 cycles
[ 1336.334283] wireguard: chacha20:    8 bytes,       5.178 MB/sec,     
   599 cycles
[ 1336.544339] wireguard: chacha20:   16 bytes,      10.146 MB/sec,     
   612 cycles
[ 1336.754727] wireguard: chacha20:   64 bytes,      36.003 MB/sec,     
   696 cycles
[ 1336.989007] wireguard: chacha20:  576 bytes,      40.593 MB/sec,     
  5908 cycles
[ 1337.262407] wireguard: chacha20: 1280 bytes,      41.015 MB/sec,     
13081 cycles
[ 1337.538436] wireguard: chacha20: 1408 bytes,      40.954 MB/sec,     
14381 cycles
[ 1337.821086] wireguard: chacha20: 1420 bytes,      39.813 MB/sec,     
14947 cycles
[ 1338.101206] wireguard: chacha20: 1440 bytes,      40.237 MB/sec,     
14975 cycles
[ 1338.384518] wireguard: chacha20: 1536 bytes,      41.015 MB/sec,     
15686 cycles
[ 1338.785923] wireguard: chacha20: 4096 bytes,      41.406 MB/sec,     
41757 cycles

Again my version but also with chacha20 results.
[ 1481.872439] wireguard: chacha20 self-tests: pass
[ 1481.900361] wireguard: poly1305 self-tests: pass
[ 1481.912533] wireguard: chacha20poly1305 self-tests: pass
[ 1482.130557] wireguard: chacha20poly1305_encrypt:    1 bytes,        
0.251 MB/sec,     1603 cycles
[ 1482.350349] wireguard: chacha20poly1305_encrypt:   16 bytes,        
4.157 MB/sec,     1558 cycles
[ 1482.570994] wireguard: chacha20poly1305_encrypt:   64 bytes,       
15.319 MB/sec,     1696 cycles
[ 1482.794197] wireguard: chacha20poly1305_encrypt:  128 bytes,       
22.021 MB/sec,     2386 cycles
[ 1483.088083] wireguard: chacha20poly1305_encrypt: 1408 bytes,       
36.657 MB/sec,    16105 cycles
[ 1483.381047] wireguard: chacha20poly1305_encrypt: 1420 bytes,       
35.480 MB/sec,    16746 cycles
[ 1483.670908] wireguard: chacha20poly1305_encrypt: 1440 bytes,       
36.117 MB/sec,    16713 cycles
[ 1483.889186] wireguard: chacha20poly1305_decrypt:    1 bytes,        
0.245 MB/sec,     1653 cycles
[ 1484.108959] wireguard: chacha20poly1305_decrypt:   16 bytes,        
4.044 MB/sec,     1605 cycles
[ 1484.329609] wireguard: chacha20poly1305_decrypt:   64 bytes,       
14.934 MB/sec,     1743 cycles
[ 1484.552815] wireguard: chacha20poly1305_decrypt:  128 bytes,       
21.630 MB/sec,     2433 cycles
[ 1484.836716] wireguard: chacha20poly1305_decrypt: 1408 bytes,       
36.523 MB/sec,    16158 cycles
[ 1485.129692] wireguard: chacha20poly1305_decrypt: 1420 bytes,       
35.480 MB/sec,    16794 cycles
[ 1485.419518] wireguard: chacha20poly1305_decrypt: 1440 bytes,       
35.979 MB/sec,    16760 cycles
[ 1485.632222] wireguard: poly1305:    0 bytes,       0.000 MB/sec,     
   154 cycles
[ 1485.842700] wireguard: poly1305:    1 bytes,       1.360 MB/sec,     
   257 cycles
[ 1486.052492] wireguard: poly1305:   16 bytes,      25.513 MB/sec,     
   212 cycles
[ 1486.263004] wireguard: poly1305:   64 bytes,      72.887 MB/sec,     
   323 cycles
[ 1486.478211] wireguard: poly1305:  576 bytes,     161.993 MB/sec,     
  1440 cycles
[ 1486.705407] wireguard: poly1305: 1280 bytes,     177.001 MB/sec,     
  2986 cycles
[ 1486.926708] wireguard: poly1305: 1408 bytes,     178.185 MB/sec,     
  3266 cycles
[ 1487.157166] wireguard: poly1305: 1420 bytes,     174.693 MB/sec,     
  3363 cycles
[ 1487.387048] wireguard: poly1305: 1440 bytes,     178.527 MB/sec,     
  3338 cycles
[ 1487.618013] wireguard: poly1305: 1536 bytes,     179.150 MB/sec,     
  3546 cycles
[ 1487.874161] wireguard: poly1305: 4096 bytes,     186.718 MB/sec,     
  9162 cycles
[ 1488.081633] wireguard: chacha20:    0 bytes,       0.000 MB/sec,     
    28 cycles
[ 1488.294111] wireguard: chacha20:    1 bytes,       0.693 MB/sec,     
   557 cycles
[ 1488.504097] wireguard: chacha20:    2 bytes,       1.380 MB/sec,     
   557 cycles
[ 1488.714109] wireguard: chacha20:    3 bytes,       2.066 MB/sec,     
   560 cycles
[ 1488.924084] wireguard: chacha20:    4 bytes,       2.776 MB/sec,     
   554 cycles
[ 1489.134096] wireguard: chacha20:    8 bytes,       5.540 MB/sec,     
   557 cycles
[ 1489.344120] wireguard: chacha20:   16 bytes,      10.970 MB/sec,     
   562 cycles
[ 1489.554217] wireguard: chacha20:   64 bytes,      42.424 MB/sec,     
   583 cycles
[ 1489.784540] wireguard: chacha20:  576 bytes,      48.394 MB/sec,     
  4947 cycles
[ 1490.042459] wireguard: chacha20: 1280 bytes,      48.950 MB/sec,     
10947 cycles
[ 1490.307525] wireguard: chacha20: 1408 bytes,      49.010 MB/sec,     
12035 cycles
[ 1490.579962] wireguard: chacha20: 1420 bytes,      47.261 MB/sec,     
12558 cycles
[ 1490.850028] wireguard: chacha20: 1440 bytes,      47.927 MB/sec,     
12570 cycles
[ 1491.122613] wireguard: chacha20: 1536 bytes,      48.925 MB/sec,     
13128 cycles
[ 1491.494187] wireguard: chacha20: 4096 bytes,      49.218 MB/sec,     
34941 cycles

Greats,

René

[0]:  
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/commit/?h=wireguard-crypto-library-api-v3&id=62d2dc65ab455a95eb5deb8bdef1dd7bb4cc754d
[1]:  
https://github.com/vDorst/wireguard/commit/5498f0900829e01b571644ea1f799f48a31eb290
[2]:  
https://github.com/vDorst/wireguard/blob/45ede7c0cd675fd0de6b95af33eb3ac9746a8901/src/crypto/zinc/speedtest/poly1305.h
[3]: https://www.mediatek.com/products/homeNetworking/mt7621n-a
[4]:  
https://github.com/vDorst/wireguard/blob/fbb8035a46a84ac7c5ee53c875c1de6f202d0884/src/crypto/zinc/poly1305/poly1305-donna32.c#L40


