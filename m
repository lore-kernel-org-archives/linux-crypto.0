Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:55708 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729559AbeKFDoN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 22:44:13 -0500
Date: Mon, 5 Nov 2018 21:23:14 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] crypto: streebog - add Streebog hash function
Message-ID: <20181105182314.c7xdsolvxr2iyd5n@sole.flsd.net>
References: <20181024032356.3388-1-vt@altlinux.org>
 <20181024032356.3388-2-vt@altlinux.org>
 <CAKv+Gu9LSUNwW_3E3QtxV123u=mU-B+p6FFRAkWq8_e9Jsgb2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9LSUNwW_3E3QtxV123u=mU-B+p6FFRAkWq8_e9Jsgb2w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ard,

On Mon, Nov 05, 2018 at 02:22:21PM +0100, Ard Biesheuvel wrote:
> 
> > +static const struct streebog_uint512 buffer512 = { {
> > +       cpu_to_le64(0x200ULL),
> 
> Can we keep the memory representation in native endianness, and only
> swab the in/output [where needed]?

I hope you do not insist on that?

The code is using same primitives to add/xor/permute with data from
these arrays (buffer512[] and C[], those which use cpu_to_le64), and
from generic data buffers. Having these arrays in native endianness will
cause complexities - code split and duplications. For example, XLPS
permutation will require two versions, with one accessing (y) as is and
another as cpu_to_le64(y).

The code is based on canonical implementation by RFC 6986 ("GOST R
34.11-2012: Hash Function") author, and I don't want it do deviate that
much from the original, which would complicate algorithm reviews.

Thanks,
