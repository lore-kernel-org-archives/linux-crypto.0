Return-Path: <SRS0=rgpc=NK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE970C2BC61
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Oct 2018 08:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B6A72080A
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Oct 2018 08:17:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B6A72080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbeJ3RKG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Oct 2018 13:10:06 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:35434 "EHLO
        fornost.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbeJ3RKG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Oct 2018 13:10:06 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gHPDQ-0002U4-Qz; Tue, 30 Oct 2018 19:17:32 +1100
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gHPDI-0000kv-Ql; Tue, 30 Oct 2018 19:17:24 +1100
Date:   Tue, 30 Oct 2018 19:17:24 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        Michael Halcrow <mhalcrow@google.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>
Subject: Re: [RFC PATCH v2 11/12] crypto: adiantum - add Adiantum support
Message-ID: <20181030081724.GA2730@gondor.apana.org.au>
References: <20181015175424.97147-1-ebiggers@kernel.org>
 <20181015175424.97147-12-ebiggers@kernel.org>
 <CAKv+Gu9wrOOk-LGPYmxgLbv86uXzMeHN6th3mMEDT3Vg893HWw@mail.gmail.com>
 <20181020071206.GE876@sol.localdomain>
 <CAKv+Gu9zBKK7ughbBAKkHdfgX2KrBXkF6MhH3xrSdLegrjjYJQ@mail.gmail.com>
 <20181024220614.GA13497@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <20181024220614.GA13497@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181030081724.h6C3N1QkQshdXYYz4rt2NhtGjBWkODdToIX7lR2bJvk@z>

On Wed, Oct 24, 2018 at 03:06:17PM -0700, Eric Biggers wrote:
>
> The patch I've been using just exposes a file /proc/cryptobench (note: it maybe
> should be made into a char device instead) to which you can write commands like:
> 
> 	algtype=skcipher algname=adiantum(xchacha12,aes) keysize=32 bufsize=4096 niter=1000
> 
> Then userspace reads back the result:
> 
> 	SUCCESS algname=adiantum(xchacha12,aes) driver_name=adiantum(xchacha12-software,aes-aesni,nhpoly1305-generic) measurement=0x30a5abd5776e0af enc_time=44831104 dec_time=38303077
> 
> It's then pretty straightforward to wrap this API in a userspace script that
> does all the benchmarks you need, and formats the results nicely.
> 
> For correctness testing there's also an option 'sgl_fuzz' that randomizes the
> scatterlist division.
> 
> Currently the patch is missing some features such as AEAD support, but at some
> point I'd like to get it into a state where it can be included upstream.

I completely agree that a new interface would be much better for
tcrypt.

However, we're trying to avoid using /proc for new APIs.  So perhaps
netlink would be a better choice given the existing configuration and
stats APIs that already exist for it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
