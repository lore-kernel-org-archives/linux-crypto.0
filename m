Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A460C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Oct 2021 14:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13F3A610A1
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Oct 2021 14:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbhJROb5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Oct 2021 10:31:57 -0400
Received: from psionic.psi5.com ([62.113.204.72]:52578 "EHLO psionic.psi5.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232042AbhJRObl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Oct 2021 10:31:41 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Oct 2021 10:31:41 EDT
Received: from simon.ametek.lan (unknown [80.149.237.18])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by psionic.psi5.com (Postfix) with ESMTPSA id 3E287280481;
        Mon, 18 Oct 2021 16:22:23 +0200 (CEST)
To:     linux-crypto@vger.kernel.org
Cc:     linux-mm@kvack.org
From:   Simon Richter <Simon.Richter@hogyros.de>
Subject: Shoveling data into and out of the crypto subsystem
Message-ID: <8d718ae1-06a9-72c2-a3c0-71fd3f7af7b4@hogyros.de>
Date:   Mon, 18 Oct 2021 16:22:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kxmil7z8Nei9pLG1fB0Mogj8bu18VZJ6x"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kxmil7z8Nei9pLG1fB0Mogj8bu18VZJ6x
Content-Type: multipart/mixed; boundary="EHTJfrw2iSYlXRz8FRZkpZUhJPBqmKufJ";
 protected-headers="v1"
From: Simon Richter <Simon.Richter@hogyros.de>
To: linux-crypto@vger.kernel.org
Cc: linux-mm@kvack.org
Message-ID: <8d718ae1-06a9-72c2-a3c0-71fd3f7af7b4@hogyros.de>
Subject: Shoveling data into and out of the crypto subsystem

--EHTJfrw2iSYlXRz8FRZkpZUhJPBqmKufJ
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

I'm building a small accelerator card that should provide crypto=20
primitives, and I'm wondering how large data transfers from and to=20
userspace are supposed to work -- especially if these are file backed=20
and larger than available memory.

For testing, I've created an 8GB random file, and used kcapi-dgst on it:

     $ strace kcapi-dgst -c sha256 -i test8G.bin --hex
     [...]
     openat(AT_FDCWD, 0x7ffc7e4b5896, O_RDONLY|O_CLOEXEC) =3D 6
     fstat(6, 0x7ffc7e4a5da0)                =3D 0
     mmap(NULL, 8589934592, PROT_READ, MAP_SHARED, 6, 0) =3D 0x7f8d911cf0=
00
     accept(3, NULL, NULL)                   =3D 7
     sendmsg(7, 0x7ffc7e4a5ca0, MSG_MORE)    =3D 2147479552
     vmsplice(5, 0x7ffc7e4a5d00, 1, SPLICE_F_MORE|SPLICE_F_GIFT) =3D 4095=

     splice(4, NULL, 7, NULL, 4095, SPLICE_F_MORE) =3D 4095
     sendmsg(7, 0x7ffc7e4a5ca0, MSG_MORE)    =3D 2147479552
     vmsplice(5, 0x7ffc7e4a5d00, 1, SPLICE_F_MORE|SPLICE_F_GIFT) =3D 4095=

     splice(4, NULL, 7, NULL, 4095, SPLICE_F_MORE) =3D 4095
     sendmsg(7, 0x7ffc7e4a5ca0, MSG_MORE)    =3D 2147479552
     vmsplice(5, 0x7ffc7e4a5d00, 1, SPLICE_F_MORE|SPLICE_F_GIFT) =3D 4095=

     splice(4, NULL, 7, NULL, 4095, SPLICE_F_MORE) =3D 4095
     sendmsg(7, 0x7ffc7e4a5ca0, MSG_MORE)    =3D 2147479552
     vmsplice(5, 0x7ffc7e4a5d00, 1, SPLICE_F_MORE|SPLICE_F_GIFT) =3D 4095=

     splice(4, NULL, 7, NULL, 4095, SPLICE_F_MORE) =3D 4095
     sendto(7, 0x7f8f911ceffc, 4, MSG_MORE, NULL, 0) =3D 4
     recvmsg(7, 0x7ffc7e4a5cd0, 0)           =3D 32
     fstat(1, 0x7ffc7e4a5bc0)                =3D 0
     munmap(0x7f8d911cf000, 0)               =3D -1 EINVAL (Invalid argum=
ent)

This seems wrong to me:

  - Every sendmsg call is 2GB - 4kB. That probably makes sense when=20
trying to keep every transfer page aligned.
  - The vmsplice()/splice() transfers 4095 bytes -- that would likely=20
trigger a copy and leave the file pointer unaligned after
  - The last sendto() call then cleans up the remaining four bytes and=20
still uses MSG_MORE.
  - The munmap() call is just confused.

Is that the optimal way to transfer data from disk to an ahash?

Now my PCIe device can operate directly on DMA memory, and the way I've=20
understood the crypto API is that the "src" scatterlist can be mapped=20
using dma_map_sg, so somehow the data is in DMA memory at this point,=20
which makes me suspect that the data was copied several times in between =

as the result of mmap() is unsuitable for DMA.

crypto+mm Questions so far:

  - How does flow control work for the 2GB sendmsg(mmap()) if the data=20
needs to be made available for DMA -- presumably I can't dma_map_sg()=20
all of the pages if I have 4 GB physical memory?
  - Is there a zerocopy path for disk->crypto that can be used with=20
large data blobs?
  - Are there suitable paths for crypto->disk (for encryption and=20
compression)?
  - If the device implements PCIe Address Translation and Page Request=20
Interface, can I use the IOMMU to pin pages instead of doing that in a=20
driver, i.e. can a crypto driver indicate that the scatterlist can refer =

to virtual memory that need not be pinned or even present yet, and can=20
this be used to avoid copies or partial mappings?

Crypto only questions so far:

  - The ahash interface seems to still expect the result to be filled=20
out on return, when I kind of expected it to wait for me to send a=20
callback. Am I missing something, or do I need to suspend the current=20
thread and wake it up from an interrupt? Can I somehow report completion =

from an interrupt handler? Does it make sense to make interrupts CPU affi=
ne?
  - The result pointer for ahash points to vmalloc()ed memory -- is=20
there a way to get a DMA buffer instead (not that there's a performance=20
difference here, but space in the result DMA buffer is another resource=20
I need to track otherwise).
  - The POWER9 NX driver has a separate interface for gzip=20
compression/decompression of large blobs, is there a technical reason=20
why it cannot implement the crypto API?

Basically my goal is to have fast gzip compression and decompression=20
support with the same interface on both of my workstations, one of which =

has an FPGA card, and the other has two POWER9 CPUs with NX. :)

    Simon


--EHTJfrw2iSYlXRz8FRZkpZUhJPBqmKufJ--

--kxmil7z8Nei9pLG1fB0Mogj8bu18VZJ6x
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEtjuqOJSXmNjSiX3Tfr04e7CZCBEFAmFtgx4ACgkQfr04e7CZ
CBF5hgf+KP9/sFgcV5Mpos5IX8vFVdD220555Uk5kcZ40INSGX7yOfUVfxe2vWB/
ptXvBIdH8xnuFi/FVkC5kBxluhJ3P8LB4BaOHNKF8axy4C/NGqAZvoxvp7g7JO3z
OVyInUsOOFPIq8Jy4YPhqMCxjEMcqBtYlCL3B+ChGL3nBn9UIiuAs8Zl1hQZ8+ma
jeEPkuUxmOJG0OfZ215srskUkYQ5lUcMMkjba/+UUPYc+eNS0QTyyojDBBt5lXJk
a7HCpeHJxWvYAFWr7gQIk856x2FAjaHaK6bNPW4SE9CMhH8tEvtEEMpR7woYqwOv
NEYrVNswINp+rKNDY9OYGkqb2Xb14g==
=x8Q2
-----END PGP SIGNATURE-----

--kxmil7z8Nei9pLG1fB0Mogj8bu18VZJ6x--
