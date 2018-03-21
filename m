From: Nick Terrell <terrelln@fb.com>
Subject: Re: [PATCH 0/1] cover-letter/lz4: Implement lz4 with dynamic offset
 length.
Date: Wed, 21 Mar 2018 19:56:10 +0000
Message-ID: <1663C9A3-7DAC-4A11-894C-C99E07BEDAD2@fb.com>
References: <CGME20180321044137epcas5p221e7ee4a0b7464eaa00dad8320f0251d@epcas5p2.samsung.com>
 <1521607242-3968-1-git-send-email-maninder1.s@samsung.com>
 <20180321082628.GB2746@jagdpanzerIV>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Maninder Singh <maninder1.s@samsung.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        Kees Cook <keescook@chromium.org>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "ccross@android.com" <ccross@android.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pankaj.m@samsung.com" <pankaj.m@samsung.com>,
        "a.sahrawat@samsung.com" <a.sahrawat@samsung.com>,
        "v.narang@samsung.com" <v.narang@samsung.com>,
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180321082628.GB2746@jagdpanzerIV>
Content-Language: en-US
Content-ID: <AE61E8E61085A24C990A2A0D8471A8C7@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On (03/21/18 10:10), Maninder Singh wrote:
> LZ4 specification defines 2 byte offset length for 64 KB data.
> But in case of ZRAM we compress data per page and in most of
> architecture PAGE_SIZE is 4KB. So we can decide offset length based
> on actual offset value. For this we can reserve 1 bit to decide offset
> length (1 byte or 2 byte). 2 byte required only if ofsset is greater than=
 127,
> else 1 byte is enough.
>=20
> With this new implementation new offset value can be at MAX 32 KB.
>=20
> Thus we can save more memory for compressed data.
>=20
> results checked with new implementation:-
>=20
> comression size for same input source
> (LZ4_DYN < LZO < LZ4)
>=20
> LZO
> =3D=3D=3D=3D=3D=3D=3D
> orig_data_size: 78917632
> compr_data_size: 15894668
> mem_used_total: 17117184
>=20
> LZ4
> =3D=3D=3D=3D=3D=3D=3D=3D
> orig_data_size: 78917632
> compr_data_size: 16310717
> mem_used_total: 17592320
>=20
> LZ4_DYN
> =3D=3D=3D=3D=3D=3D=3D
> orig_data_size: 78917632
> compr_data_size: 15520506
> mem_used_total: 16748544

This seems like a reasonable extension to the algorithm, and it looks like
LZ4_DYN is about a 5% improvement to compression ratio on your benchmark.
The biggest question I have is if it is worthwhile to maintain a separate
incompatible variant of LZ4 in the kernel without any upstream for a 5%
gain? If we do want to go forward with this, we should perform more
benchmarks.

I commented in the patch, but because the `dynOffset` variable isn't a
compile time static in LZ4_decompress_generic(), I suspect that the patch
causes a regression in decompression speed for both LZ4 and LZ4_DYN. You'll
need to re-run the benchmarks to first show that LZ4 before the patch
performs the same as LZ4 after the patch. Then re-run the LZ4 vs LZ4_DYN
benchmarks.

I would also like to see a benchmark in user-space (with the code), so we
can see the performance of LZ4 before and after the patch, as well as LZ4
vs LZ4_DYN without anything else going on. I expect the extra branches in
the decoding loop to have an impact on speed, and I would like to see how
big the impact is without noise.=20

CC-ing Yann Collet, the author of LZ4
