Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F8EC4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02CAA2133F
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:15:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="lcxwTBTP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389554AbfJDPP1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:15:27 -0400
Received: from mx.0dd.nl ([5.2.79.48]:46496 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388802AbfJDPP1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 11:15:27 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id E3C665FB12;
        Fri,  4 Oct 2019 17:15:24 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="lcxwTBTP";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 9C6A73878C;
        Fri,  4 Oct 2019 17:15:24 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 9C6A73878C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1570202124;
        bh=jsst+PI2pMp+1JvEIFpsF7jonkZjytFXzl3OPPTnof0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lcxwTBTPUbVwFvro3HJGj+olfvfFTLi8T++OpqJ92V8lE/AdoIoAvEWyRNlzk3LEn
         e7Bqy05FWIO+Vyfd1FkrreD/Ia+vj7UexaKoU1yv6k2TNAdWaeTREf8D3pvdp++2O1
         OLHFgaEgSdxa7zqs177xm1KApwcqfZHEbtU6Y+VJPZcc5WAuO7uqHZHYsLc/S8BC5Z
         wwLky+/gaRdes8U5ZhvPL931PBWfzmY4fHvGekZgDgSD0wDSWlao+vbLPqlB0NyKGl
         zK9PheCclMue1aFiktD8dZX7mbfNd8q2tn1L5EXhQjMdJacyHASvSbVn9TWDGQ84oa
         i+tCKQhkRrN1w==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Fri, 04 Oct 2019 15:15:24 +0000
Date:   Fri, 04 Oct 2019 15:15:24 +0000
Message-ID: <20191004151524.Horde.zXUzQP5eBQt7Ybx5I75Ig5X@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 05/20] crypto: mips/chacha - import accelerated 32r2
 code from Zinc
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-6-ard.biesheuvel@linaro.org>
 <20191004134644.GE112631@zx2c4.com>
 <CAKv+Gu_X9DBgUiPqcyJ2hOQqi_FEBVpHOr9uG1ZAh-RWv6-z9Q@mail.gmail.com>
 <CAHmME9ojUTysb2kHKbSWaR+2Qat3qF1cNrVtphu3V+C+P_g8yQ@mail.gmail.com>
In-Reply-To: <CAHmME9ojUTysb2kHKbSWaR+2Qat3qF1cNrVtphu3V+C+P_g8yQ@mail.gmail.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

Quoting "Jason A. Donenfeld" <Jason@zx2c4.com>:

> On Fri, Oct 4, 2019 at 4:44 PM Ard Biesheuvel  
> <ard.biesheuvel@linaro.org> wrote:
>> The round count is passed via the fifth function parameter, so it is
>> already on the stack. Reloading it for every block doesn't sound like
>> a huge deal to me.
>
> Please benchmark it to indicate that, if it really isn't a big deal. I
> recall finding that memory accesses on common mips32r2 commodity
> router hardware was extremely inefficient. The whole thing is designed
> to minimize memory accesses, which are the primary bottleneck on that
> platform.

I also think it isn't a big deal, but I shall benchmark it this weekend.
If I am correct a memory write will first put in cache. So if you read
it again and it is in cache it is very fast. 1 or 2 clockcycles.
Also the value isn't used directly after it is read.
So cpu don't have to stall on this read.

Greats,

René

>
> Seems like this thing might be best deferred for after this all lands.
> IOW, let's get this in with the 20 round original now, and later you
> can submit a change for the 12 round and René and I can spend time
> dusting off our test rigs and seeing which strategy works best. I very
> nearly tossed out a bunch of old router hardware last night when
> cleaning up. Glad I saved it!



