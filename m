Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEF4EB64DD
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Jun 2023 04:49:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjF2Etz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Jun 2023 00:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjF2Etx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jun 2023 00:49:53 -0400
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6F42134;
        Wed, 28 Jun 2023 21:49:49 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VmCqHnt_1688014183;
Received: from 30.97.48.232(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VmCqHnt_1688014183)
          by smtp.aliyun-inc.com;
          Thu, 29 Jun 2023 12:49:44 +0800
Message-ID: <e611d272-2574-5b13-3e9e-51402e7c5625@linux.alibaba.com>
Date:   Thu, 29 Jun 2023 12:49:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [v2 PATCH 0/5] crypto: Add akcipher interface without SGs
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Roberto Sassu <roberto.sassu@huaweicloud.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>, dmitry.kasatkin@gmail.com,
        Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <ZIg4b8kAeW7x/oM1@gondor.apana.org.au>
 <570802.1686660808@warthog.procyon.org.uk>
 <ZIrnPcPj9Zbq51jK@gondor.apana.org.au>
 <CAMj1kXHcDrL5YexGjwvHHY0UE1ES-KG=68ZJr7U=Ub5gzbaePg@mail.gmail.com>
 <ZJlf6VoKRf+OZJEo@gondor.apana.org.au>
 <CAMj1kXHQKN+mkXavvR1A57nXWpDBTiqZ+H3T65CSkJN0NmjfrQ@mail.gmail.com>
 <ZJlk2GkN8rp093q9@gondor.apana.org.au>
 <20230628062120.GA7546@sol.localdomain>
 <CAMj1kXEki6pK+6Gm-oHLVU3t=GzF8Kfz9QebTMKQcwtuqCsUgw@mail.gmail.com>
 <20230628173346.GA6052@sol.localdomain>
 <CAMj1kXGBrNZ6-WCGH7Bbw_T_2Og8JGErZPdLHLQVB58z+vrZ8A@mail.gmail.com>
 <CAHk-=wi5D7drbmMrdA+8rMGGvA-R1fUK3ZqZ=r1ccNMiDT8atA@mail.gmail.com>
 <3695542.1687977261@warthog.procyon.org.uk>
 <CAHk-=wg2-sXtHKGTsKfcMXLkvHRDiU1nQBYwB8sLo3jXfzq+cw@mail.gmail.com>
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAHk-=wg2-sXtHKGTsKfcMXLkvHRDiU1nQBYwB8sLo3jXfzq+cw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus,

On 2023/6/29 04:10, Linus Torvalds wrote:
> On Wed, 28 Jun 2023 at 11:34, David Howells <dhowells@redhat.com> wrote:
>>
>> What about something like the Intel on-die accelerators (e.g. IAA and QAT)?  I
>> think they can do async compression.
> 
> I'm sure they can. And for some made-up benchmark it might even help.
> Do people use it in real life?
> 
> The *big* wins come from being able to do compression/encryption
> inline, when you don't need to do double-buffering etc.
> 
> Anything else is completely broken, imnsho. Once you need to
> double-buffer your IO, you've already lost the whole point.

I'm not sure if I could say much about this for now, yet we're
slowly evaluating Intel IAA builtin DEFLATE engine for our
Cloud workloads and currently we don't have end-to-end numbers
yet.

Storage inline accelerators are great, especially
"do {en,de}cryption inline" since it consumes very little
on-chip memory, yet afaik "(de)compression" inline engine story
is different since it needs more SRAM space for their LZ sliding
windows for matching (e.g. 32kb for deflate each channel, 64kb
for LZ4 each channel, and much much more for Zstd, LZMA, etc.
I think those are quite expensive to integrate) in addition to
some additional memory for huffman/FSE tables.

So in production, inline "(de)compression" accelerators are
hardly seen as a part of storage at least in end consumer
markets.

Intel already has their on-die accelerators (IAA very recently),
yeah, it still needs double-buffer I/O, but we're considering
at least using in async writeback/readahead use cases as a
start for bulk async I/Os, which are not quite latency
sensitive.  Intel also shows their Zswap work [1] , yet I don't
dive into that since I'm only focusing on storage use cases.

As for crypto current apis (no matter acomp or scomp), I'm not
sure I will say more too since I mostly agree with what Eric
said previously.

Thanks,
Gao Xiang

[1] https://lore.kernel.org/r/20230605201536.738396-1-tom.zanussi@linux.intel.com/

> 
>             Linus
> 
