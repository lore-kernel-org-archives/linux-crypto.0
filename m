Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:49158 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbeKEX4e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 18:56:34 -0500
Date: Mon, 5 Nov 2018 17:36:31 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] crypto: streebog - add Streebog hash function
Message-ID: <20181105143630.3m5z2kmbtesaqcgc@sole.flsd.net>
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

I will address your suggestions in v4. And below is my comments for a
few of them.

On Mon, Nov 05, 2018 at 02:22:21PM +0100, Ard Biesheuvel wrote:
> > +static const struct streebog_uint512 buffer512 = { {
> > +       cpu_to_le64(0x200ULL),
> 
> Can we keep the memory representation in native endianness, and only
> swab the in/output [where needed]?

Yes. This will slightly affect performance on big-endian architectures,
but, probably this is not a concern.

> Also, did you test this code on a big-endian system?

Yes, on s390x on qemu.

> > +               .cra_name        =      "sb256",
> 
> Please use the full name 'streebog256' (and 512 below)

First, I thought of shortening name like Whirlpool do with wp256, but
now I rethought this and agree.

Thanks!
