Return-Path: <SRS0=9uPW=NC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74605C004D3
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Oct 2018 22:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5503E20665
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Oct 2018 22:40:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="q3ugX7oN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5503E20665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbeJWHAk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Oct 2018 03:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbeJWHAk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Oct 2018 03:00:40 -0400
Received: from gmail.com (unknown [104.132.51.88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAD0420651;
        Mon, 22 Oct 2018 22:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540248012;
        bh=kUhDvLM9qz5ALxLvMkiAEziqq3PEJSnAo4mtC6aMpPs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q3ugX7oNRu/ssI+8GSpIKVQ9Z8qXh/zlKcNNdysrRJ6bHOUbMfcYUj/ffNKd1/KMs
         c8reCMQmLLWxorbr5xQGKBxDdzfrAp/Bmk3ZKZaq6H2pogMyC4AYNYFQoxEatHVjc8
         SiTTGp4XTUpBvHtc26I3DxO11nX5tIiUYt2OL1+c=
Date:   Mon, 22 Oct 2018 15:40:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        Michael Halcrow <mhalcrow@google.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>
Subject: Re: [RFC PATCH v2 09/12] crypto: nhpoly1305 - add NHPoly1305 support
Message-ID: <20181022224008.GB59695@gmail.com>
References: <20181015175424.97147-1-ebiggers@kernel.org>
 <20181015175424.97147-10-ebiggers@kernel.org>
 <CAKv+Gu-5WM19g5HguDheAADbigKNxokDCFMekkt4OYdEEa8Avw@mail.gmail.com>
 <20181020053834.GC876@sol.localdomain>
 <CAKv+Gu-A_EhMBXq_nqzBzpgN36foo6hA3Ba3=j+WVM-jph=mrw@mail.gmail.com>
 <20181022184236.GA59695@gmail.com>
 <CAKv+Gu_vXmfNQT8j=G_Zz5C3-zDPPEQ2ne6ZZQw8mD0rifO8qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_vXmfNQT8j=G_Zz5C3-zDPPEQ2ne6ZZQw8mD0rifO8qA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181022224010.8_R3zBRGhG2MK41hfi9KH2YD7VXuMVaV6RbaUJt6eo4@z>

Hi Ard,

On Mon, Oct 22, 2018 at 07:25:27PM -0300, Ard Biesheuvel wrote:
> >
> > Hmm, I'm actually leaning towards the following instead.  Unrolling multiple
> > strides to try to reduce loads of the keys doesn't seem worthwhile in the C
> > implementation; for one, it bloats the code size a lot
> > (412 => 2332 bytes on arm32).
> >
> > static void nh_generic(const u32 *key, const u8 *message, size_t message_len,
> >                        __le64 hash[NH_NUM_PASSES])
> > {
> >         u64 sums[4] = { 0, 0, 0, 0 };
> >
> >         BUILD_BUG_ON(NH_PAIR_STRIDE != 2);
> >         BUILD_BUG_ON(NH_NUM_PASSES != 4);
> >
> >         while (message_len) {
> >                 u32 m0 = get_unaligned_le32(message + 0);
> >                 u32 m1 = get_unaligned_le32(message + 4);
> >                 u32 m2 = get_unaligned_le32(message + 8);
> >                 u32 m3 = get_unaligned_le32(message + 12);
> >
> >                 sums[0] += (u64)(u32)(m0 + key[ 0]) * (u32)(m2 + key[ 2]);
> >                 sums[1] += (u64)(u32)(m0 + key[ 4]) * (u32)(m2 + key[ 6]);
> >                 sums[2] += (u64)(u32)(m0 + key[ 8]) * (u32)(m2 + key[10]);
> >                 sums[3] += (u64)(u32)(m0 + key[12]) * (u32)(m2 + key[14]);
> >                 sums[0] += (u64)(u32)(m1 + key[ 1]) * (u32)(m3 + key[ 3]);
> >                 sums[1] += (u64)(u32)(m1 + key[ 5]) * (u32)(m3 + key[ 7]);
> >                 sums[2] += (u64)(u32)(m1 + key[ 9]) * (u32)(m3 + key[11]);
> >                 sums[3] += (u64)(u32)(m1 + key[13]) * (u32)(m3 + key[15]);
> 
> Are these (u32) casts really necessary? All the addends are u32 types,
> so I'd expect each (x + y) subexpression to have a u32 type already as
> well. Or am I missing something?
> 

The (u32) casts are only necessary when sizeof(int) > sizeof(u32), as then the
addends will be promoted to 'int'.  Of course, that's never the case for the
Linux kernel.  But I prefer it to be as robust and well-defined as possible,
since people might use this as a reference when coding other implementations,
which could end up finding their way into unusual and/or future platforms.

- Eric
