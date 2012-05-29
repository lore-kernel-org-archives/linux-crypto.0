From: Sonic Zhang <sonic.adi@gmail.com>
Subject: Re: [PATCH 1/2] crypto: Add new test cases for Blackfin CRC crypto driver.
Date: Tue, 29 May 2012 18:28:45 +0800
Message-ID: <CAJxxZ0NK5HnvBUxBWdKq+saJfyWG1Uk0nDpRJ-uAmApgZBP7CQ@mail.gmail.com>
References: <1337939654-12222-1-git-send-email-sonic.adi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	uclinux-dist-devel@blackfin.uclinux.org,
	Sonic Zhang <sonic.zhang@analog.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53021 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab2E2K2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 May 2012 06:28:46 -0400
In-Reply-To: <1337939654-12222-1-git-send-email-sonic.adi@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

PING

On Fri, May 25, 2012 at 5:54 PM, Sonic Zhang <sonic.adi@gmail.com> wrot=
e:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
> =A0crypto/tcrypt.c =A0| =A0 =A03 ++
> =A0crypto/testmgr.c | =A0 =A09 +++++
> =A0crypto/testmgr.h | =A0 90 ++++++++++++++++++++++++++++++++++++++++=
++++++++++++++
> =A03 files changed, 102 insertions(+), 0 deletions(-)
>
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 8f147bf..750cce4 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -1192,6 +1192,9 @@ static int do_test(int m)
> =A0 =A0 =A0 =A0case 109:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret +=3D tcrypt_test("vmac(aes)");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> + =A0 =A0 =A0 case 110:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret +=3D tcrypt_test("hmac(crc32)");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>
> =A0 =A0 =A0 =A0case 150:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret +=3D tcrypt_test("ansi_cprng");
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 5674878..eb6d20f 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -2220,6 +2220,15 @@ static const struct alg_test_desc alg_test_des=
cs[] =3D {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}, {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .alg =3D "hmac(crc32)",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .test =3D alg_test_hash,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .suite =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .hash =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .vecs =3D=
 bfin_crc_tv_template,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .count =
=3D BFIN_CRC_TEST_VECTORS
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }, {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.alg =3D "hmac(md5)",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.test =3D alg_test_hash,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.suite =3D {
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index 36e5a8e..34a9d51 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -14858,4 +14858,94 @@ static struct hash_testvec crc32c_tv_templat=
e[] =3D {
> =A0 =A0 =A0 =A0},
> =A0};
>
> +/*
> + * Blakcifn CRC test vectors
> + */
> +#define BFIN_CRC_TEST_VECTORS 6
> +
> +static struct hash_testvec bfin_crc_tv_template[] =3D {
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .psize =3D 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .digest =3D "\x00\x00\x00\x00",
> + =A0 =A0 =A0 },
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .key =3D "\x87\xa9\xcb\xed",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ksize =3D 4,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .psize =3D 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .digest =3D "\x87\xa9\xcb\xed",
> + =A0 =A0 =A0 },
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .key =3D "\xff\xff\xff\xff",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ksize =3D 4,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .plaintext =3D "\x01\x02\x03\x04\x05\x0=
6\x07\x08"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x09\x0a\x0=
b\x0c\x0d\x0e\x0f\x10"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x11\x12\x1=
3\x14\x15\x16\x17\x18"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x19\x1a\x1=
b\x1c\x1d\x1e\x1f\x20"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x21\x22\x2=
3\x24\x25\x26\x27\x28",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .psize =3D 40,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .digest =3D "\x84\x0c\x8d\xa2",
> + =A0 =A0 =A0 },
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .key =3D "\xff\xff\xff\xff",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ksize =3D 4,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .plaintext =3D "\x01\x02\x03\x04\x05\x0=
6\x07\x08"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x09\x0a\x0=
b\x0c\x0d\x0e\x0f\x10"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x11\x12\x1=
3\x14\x15\x16\x17\x18"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x19\x1a\x1=
b\x1c\x1d\x1e\x1f\x20"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x21\x22\x2=
3\x24\x25\x26",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .psize =3D 38,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .digest =3D "\x8c\x58\xec\xb7",
> + =A0 =A0 =A0 },
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .key =3D "\xff\xff\xff\xff",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ksize =3D 4,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .plaintext =3D "\x01\x02\x03\x04\x05\x0=
6\x07\x08"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x09\x0a\x0=
b\x0c\x0d\x0e\x0f\x10"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x11\x12\x1=
3\x14\x15\x16\x17\x18"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x19\x1a\x1=
b\x1c\x1d\x1e\x1f\x20"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x21\x22\x2=
3\x24\x25\x26\x27",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .psize =3D 39,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .digest =3D "\xdc\x50\x28\x7b",
> + =A0 =A0 =A0 },
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .key =3D "\xff\xff\xff\xff",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ksize =3D 4,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .plaintext =3D "\x01\x02\x03\x04\x05\x0=
6\x07\x08"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x09\x0a\x0=
b\x0c\x0d\x0e\x0f\x10"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x11\x12\x1=
3\x14\x15\x16\x17\x18"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x19\x1a\x1=
b\x1c\x1d\x1e\x1f\x20"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x21\x22\x2=
3\x24\x25\x26\x27\x28"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x29\x2a\x2=
b\x2c\x2d\x2e\x2f\x30"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x31\x32\x3=
3\x34\x35\x36\x37\x38"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x39\x3a\x3=
b\x3c\x3d\x3e\x3f\x40"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x41\x42\x4=
3\x44\x45\x46\x47\x48"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x49\x4a\x4=
b\x4c\x4d\x4e\x4f\x50"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x51\x52\x5=
3\x54\x55\x56\x57\x58"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x59\x5a\x5=
b\x5c\x5d\x5e\x5f\x60"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x61\x62\x6=
3\x64\x65\x66\x67\x68"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x69\x6a\x6=
b\x6c\x6d\x6e\x6f\x70"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x71\x72\x7=
3\x74\x75\x76\x77\x78"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x79\x7a\x7=
b\x7c\x7d\x7e\x7f\x80"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x81\x82\x8=
3\x84\x85\x86\x87\x88"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x89\x8a\x8=
b\x8c\x8d\x8e\x8f\x90"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x91\x92\x9=
3\x94\x95\x96\x97\x98"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\x99\x9a\x9=
b\x9c\x9d\x9e\x9f\xa0"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\xa1\xa2\xa=
3\xa4\xa5\xa6\xa7\xa8"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\xa9\xaa\xa=
b\xac\xad\xae\xaf\xb0"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\xb1\xb2\xb=
3\xb4\xb5\xb6\xb7\xb8"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\xb9\xba\xb=
b\xbc\xbd\xbe\xbf\xc0"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\xc1\xc2\xc=
3\xc4\xc5\xc6\xc7\xc8"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\xc9\xca\xc=
b\xcc\xcd\xce\xcf\xd0"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\xd1\xd2\xd=
3\xd4\xd5\xd6\xd7\xd8"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\xd9\xda\xd=
b\xdc\xdd\xde\xdf\xe0"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\xe1\xe2\xe=
3\xe4\xe5\xe6\xe7\xe8"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\xe9\xea\xe=
b\xec\xed\xee\xef\xf0",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .psize =3D 240,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .digest =3D "\x10\x19\x4a\x5c",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .np =3D 2,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .tap =3D { 31, 209 }
> + =A0 =A0 =A0 },
> +
> +};
> +
> =A0#endif /* _CRYPTO_TESTMGR_H */
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
