Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48149C47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 17:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20790214E0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 17:21:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="V00Nwr6b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfJKRVf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 13:21:35 -0400
Received: from mx.0dd.nl ([5.2.79.48]:51016 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728086AbfJKRVf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 13:21:35 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 68AB55FBD4;
        Fri, 11 Oct 2019 19:21:33 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="V00Nwr6b";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 20AA24079D;
        Fri, 11 Oct 2019 19:21:33 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 20AA24079D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1570814493;
        bh=VKBpyBcunIosn/sC6Z7RuILrN+OdZB/cUALWtgo/tQ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V00Nwr6ba5hXAKpjMIg1vBWdiUuEw0xfxsNTNFfMsQCzBbOeB18mFKmnxTpgWdP1n
         6quBG0JByxK2Zs39hDxvNgTg+AaIymZ9QLGx4ZqU9pMy7eWn1RgFndM5/UhRqKN9Oj
         1UmKs1bSK/eevWBif8B1UzNQ7KLQKIFfreaUPYTR7x0lRJzKZiZlmq9kCa09sZKIYR
         nw/41Ks5Mn48lYDwGYU/IZHuG7Pp4ClkadtT/ytnOtwxVlTwFQlBWR59T8FehQesOo
         XNXhqIXdCsX8F9njztaNIiWewxxjBCq1EHy0r1o4OqSGkoIywGpeD2pN1ixJDkNu/R
         rfshSdQOd0qlQ==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Fri, 11 Oct 2019 17:21:33 +0000
Date:   Fri, 11 Oct 2019 17:21:33 +0000
Message-ID: <20191011172133.Horde.sxiyClHzSJAUvHtYJdMQEbN@www.vdorst.com>
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
 <CABb3=+a5zegft0e8ixCVe0xc=FAV1W-bse3x5qhytQ8GKJTJPA@mail.gmail.com>
In-Reply-To: <CABb3=+a5zegft0e8ixCVe0xc=FAV1W-bse3x5qhytQ8GKJTJPA@mail.gmail.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Andy,

Quoting Andy Polyakov <appro@cryptogams.org>:

> Hi,
>
> On 10/8/19 1:38 PM, Andy Polyakov wrote:
>>>> <snip>
>>>
>>> Hi Ard,
>>>
>>> Is it also an option to include my mip32r2 optimized poly1305 version?
>>>
>>> Below the results which shows a good improvement over the Andy Polyakov
>>> version.
>>> I swapped the poly1305 assembly file and rename the function to
>>> <func_name>_mips
>>> Full WireGuard source with the changes [0]
>>>
>>> bytes |  RvD | openssl | delta | delta / openssl
>>>  ...
>>>  4096 | 9160 | 11755   | -2595 | -22,08%
>
> Update is pushed to cryptogams. Thanks to René for ideas, feedback and
> testing! There is even a question about supporting DSP ASE, let's
> discuss details off-list first.
>

Thanks!
I see that you have found an other spot to save 1 cycle.

Last results: poly1305: 4096 bytes,     188.671 MB/sec,     9066 cycles

I also wonder if we can also replace the "li $x, -4" and "and $x" with  
"sll $x"
combination on other places like [0], also on line 1169?

Replace this on line 1169, works on my device.

-       li      $in0,-4
         srl     $ctx,$tmp4,2
-       and     $in0,$in0,$tmp4
         andi    $tmp4,$tmp4,3
+       sll     $in0, $ctx, 2
         addu    $ctx,$ctx,$in0

> As for multiply-by-1-n-add.
>
>> I assume that the presented results depict regression after switch to
>> cryptogams module. Right? RvD implementation distinguishes itself in two
>> ways:
>>
>> 1. some of additions in inner loop are replaced with multiply-by-1-n-add;
>> ...
>>
>> I recall attempting 1. and chosen not to do it with following rationale.
>> On processor I have access to, Octeon II, it made no significant
>> difference. It was better, but only marginally. And it's understandable,
>> because Octeon II should have lesser difficulty pairing those additions
>> with multiply-n-add instructions. But since multiplication is an
>> expensive operation, it can be pretty slow, I reckoned that on processor
>> less potent than Octeon II it might be more appropriate to minimize
>> amount of multiplication-n-add instructions.
>
> As an example, MIPS 1004K manual discusses that that there are two
> options for multiplier for this core, proper and poor-man's. Proper
> multiplier unit can issue multiplication or multiplication-n-add each
> cycle, with multiplication latency apparently being 4. Poor-man's unit
> on the other hand can issue multiplication each 32nd[!] cycle with
> corresponding latency. This means that core with poor-man's unit would
> perform ~13% worse than it could have been. Updated module does use
> multiply-by-1-n-add, so this note is effectively for reference in case
> "poor man" wonders.
>
> Cheers.

Thanks for this information.
I wonder how many devices do exist with the "poor man" version.

Greats,

René

[0]:  
https://github.com/dot-asm/cryptogams/blob/d22ade312a7af958ec955620b0d241cf42c37feb/mips/poly1305-mips.pl#L461



