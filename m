Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-it1-f193.google.com ([209.85.166.193]:38852 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387873AbeKFETI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 23:19:08 -0500
Received: by mail-it1-f193.google.com with SMTP id k141-v6so12375103itk.3
        for <linux-crypto@vger.kernel.org>; Mon, 05 Nov 2018 10:58:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20181105182314.c7xdsolvxr2iyd5n@sole.flsd.net>
References: <20181024032356.3388-1-vt@altlinux.org> <20181024032356.3388-2-vt@altlinux.org>
 <CAKv+Gu9LSUNwW_3E3QtxV123u=mU-B+p6FFRAkWq8_e9Jsgb2w@mail.gmail.com> <20181105182314.c7xdsolvxr2iyd5n@sole.flsd.net>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 5 Nov 2018 19:58:05 +0100
Message-ID: <CAKv+Gu_uahQEP-4mc10KQThQM6rTF4o5xqi6YgEq8Od87x3KgQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] crypto: streebog - add Streebog hash function
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 5 November 2018 at 19:23, Vitaly Chikunov <vt@altlinux.org> wrote:
> Ard,
>
> On Mon, Nov 05, 2018 at 02:22:21PM +0100, Ard Biesheuvel wrote:
>>
>> > +static const struct streebog_uint512 buffer512 = { {
>> > +       cpu_to_le64(0x200ULL),
>>
>> Can we keep the memory representation in native endianness, and only
>> swab the in/output [where needed]?
>
> I hope you do not insist on that?
>
> The code is using same primitives to add/xor/permute with data from
> these arrays (buffer512[] and C[], those which use cpu_to_le64), and
> from generic data buffers. Having these arrays in native endianness will
> cause complexities - code split and duplications. For example, XLPS
> permutation will require two versions, with one accessing (y) as is and
> another as cpu_to_le64(y).
>
> The code is based on canonical implementation by RFC 6986 ("GOST R
> 34.11-2012: Hash Function") author, and I don't want it do deviate that
> much from the original, which would complicate algorithm reviews.
>

That is a very good reason, so unless anyone has concerns about the
performance on BE systems, let's leave it as is.
