Return-Path: <SRS0=gnyg=NA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF73DECDE3D
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Oct 2018 03:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75E8B214FA
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Oct 2018 03:24:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="J86Z/P/2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75E8B214FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbeJTLdA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Oct 2018 07:33:00 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:54556 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbeJTLdA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Oct 2018 07:33:00 -0400
Received: by mail-it1-f196.google.com with SMTP id l191-v6so6477480ita.4
        for <linux-crypto@vger.kernel.org>; Fri, 19 Oct 2018 20:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=NZ10Ylsl3AN9EZ+hzni4RNeIwZbU1+s0IaMEe6oKYpE=;
        b=J86Z/P/2z/3W7yX8WtBchlG5ztpgIn7z4W/TkWWKZzU435tHiUxDFI/pW7epzelYPE
         /Si7PHgJ21R5uU1R9fSb4fUixr6xVkukHYyWGk8IM2orf+nEgL9KiwEy10sEHNMnKhSO
         xUfyl/4y2foq5DlHF8YAEHCz2ci72B/m6V9kY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=NZ10Ylsl3AN9EZ+hzni4RNeIwZbU1+s0IaMEe6oKYpE=;
        b=Wh23Kc6CKN27wA+8D4Dy8A91WA5tGtMdBvP4XmcVT5i0J7UlJhOAR3nNzHPu4qk3Ox
         2L3Jph+vuWpFSuP+C/tm/QlU0oiYckvek46JSxdlxg0Fm5w7EIYbNDrBi8H77Au5BBfX
         7svqi1hF3ddJpx5DD766cwkXZXjQWdQZ2k/cmF+y1zFziBpDbSXb660A3x6g+EsuvtQB
         DfgNZac1pytklnCd+SmBCq61Molr6Km//dnevp7DSt5GHH446R79h+nw8sz5NwQpgYuf
         5OI5kQ91kvmqocyK06ctsSzuEzmbuKS2+2oHbnA6N84hOPt7loWDBkqkGsccvQY2GTdG
         xUug==
X-Gm-Message-State: ABuFfoir/DFkV3eN0ZeHxoOfUXg0DXvHc6O1Gyr/WMdXVFW+sb/Z9ukm
        5aumB5xTyXHEuQEnd4h3P4D5woRKemKwgCKn5mEuIQ==
X-Google-Smtp-Source: ACcGV60mDPOC0aclh7eqvxfviaNiAiyfUENwniL4SzQat3uoWmJIPbGFIAt8AECs+JIC7R7N80QtCFIC2YecXOylfvs=
X-Received: by 2002:a24:e08f:: with SMTP id c137-v6mr4998647ith.71.1540005846200;
 Fri, 19 Oct 2018 20:24:06 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a6b:5910:0:0:0:0:0 with HTTP; Fri, 19 Oct 2018 20:24:05
 -0700 (PDT)
In-Reply-To: <CA+_SqcDszvqfH7qvEyi8QW2RqkA1kpV6L7VWxhtw5Ogzeovhbg@mail.gmail.com>
References: <20181015175424.97147-1-ebiggers@kernel.org> <CAHmME9p1aiqWZ4+viaLscO8+qmixdVhMA1MAtMAFEHPG36DcPg@mail.gmail.com>
 <CA+_SqcDszvqfH7qvEyi8QW2RqkA1kpV6L7VWxhtw5Ogzeovhbg@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 20 Oct 2018 11:24:05 +0800
Message-ID:
 <CAKv+Gu9be0LDSzkinzwJ50LN+g7Omdjh5Z7xUmpoQc+oCzxZ_Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/12] crypto: Adiantum support
To:     Paul Crowley <paulcrowley@google.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kaiser <gkaiser@google.com>,
        Michael Halcrow <mhalcrow@google.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181020032405.N1EfKQk8e3fM1F9mvbBKU8-3ibEk5t3udrbVHyj16AQ@z>

On 20 October 2018 at 02:19, Paul Crowley <paulcrowley@google.com> wrote:
> On Fri, 19 Oct 2018 at 08:58, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>> Before merging this into the kernel, do you want to wait until you've
>> received some public review from academia?
>
> I would prefer not to wait. Unlike a new primitive whose strength can
> only be known through attempts at cryptanalysis, Adiantum is a
> construction based on
> well-understood and trusted primitives; it is secure if the proof
> accompanying it is correct. Given that (outside competitions or
> standardization efforts) no-one ever issues public statements that
> they think algorithms or proofs are good, what I'm expecting from
> academia is silence :) The most we could hope for would be getting the
> paper accepted at a conference, and we're pursuing that but there's a
> good chance that won't happen simply because it's not very novel. It
> basically takes existing ideas and applies them using a stream cipher
> instead of a block cipher, and a faster hashing mode; it's also a
> small update from HPolyC. I've had some private feedback that the
> proof seems correct, and that's all I'm expecting to get.

Hi Paul, Eric,

The Adiantum paper claims

"On an ARM Cortex-A7 processor, Adiantum decrypts 4096-byte messages
at 11 cycles per byte, five times faster than AES-256-XTS, with a
constant-time implementation."

which is surprising to me. The bit slicing NEON AES core runs at ~14
cycle per byte on a Cortex-A15 (when encrypting), so 55 cycles per
byte on A7 sounds rather high. Is it really that bad?

Also, the paper mentions that the second hash pass and the stream
cipher en/decryption pass could be executed in parallel, while your
implementation performs three distinct passes. Do you have any
estimates on the potential performance gain of implementing that? In
my experience (which is mostly A53 rather than A7 based, mind you),
removing memory accesses can help tremendously to speed up the
execution on low end cores.
