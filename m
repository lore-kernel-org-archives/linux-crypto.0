From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 8/8] crypto: testmgr: Use the xxx_zero_message_hash from
 headers
Date: Mon, 12 Oct 2015 21:31:20 +0200
Message-ID: <561C0A88.7010309@gmail.com>
References: <201510130309.4gXCrZOa%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: thomas.lendacky@amd.com, geert+renesas@glider.be,
	ulf.hansson@linaro.org, wsa@the-dreams.de, keescook@chromium.org,
	maxime.ripard@free-electrons.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36458 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbbJLTbY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Oct 2015 15:31:24 -0400
In-Reply-To: <201510130309.4gXCrZOa%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Le 12/10/2015 21:24, kbuild test robot a =E9crit :
> Hi LABBE,
>=20
> [auto build test ERROR on crypto/master -- if it's inappropriate base=
, please suggest rules for selecting the more suitable base]
>=20
> url:    https://github.com/0day-ci/linux/commits/LABBE-Corentin/crypt=
o-hash-add-zero-length-message-hash-for-shax-and-md5/20151013-005943
> config: arm-mmp (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tes=
ts.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=3Darm=20
>=20
> All errors (new ones prefixed by >>):
>=20
>    In file included from crypto/testmgr.c:48:0:
>>> crypto/testmgr.h:370:13: error: 'md5_zero_message_hash' undeclared =
here (not in a function)
>       .digest =3D md5_zero_message_hash,
>                 ^
>>> crypto/testmgr.h:715:13: error: 'sha1_zero_message_hash' undeclared=
 here (not in a function)
>       .digest =3D sha1_zero_message_hash,
>                 ^
>>> crypto/testmgr.h:715:3: error: initializer element is not constant
>       .digest =3D sha1_zero_message_hash,
>       ^
>    crypto/testmgr.h:715:3: error: (near initialization for 'sha1_tv_t=
emplate[0].digest')
>>> crypto/testmgr.h:906:13: error: 'sha224_zero_message_hash' undeclar=
ed here (not in a function)
>       .digest =3D sha224_zero_message_hash,
>                 ^
>    crypto/testmgr.h:906:3: error: initializer element is not constant
>       .digest =3D sha224_zero_message_hash,
>       ^
>    crypto/testmgr.h:906:3: error: (near initialization for 'sha224_tv=
_template[0].digest')
>>> crypto/testmgr.h:1077:13: error: 'sha256_zero_message_hash' undecla=
red here (not in a function)
>       .digest =3D sha256_zero_message_hash,
>                 ^
>    crypto/testmgr.h:1077:3: error: initializer element is not constan=
t
>       .digest =3D sha256_zero_message_hash,
>       ^
>    crypto/testmgr.h:1077:3: error: (near initialization for 'sha256_t=
v_template[0].digest')
>=20
> vim +/md5_zero_message_hash +370 crypto/testmgr.h
>=20
>    364	 * MD5 test vectors from RFC1321
>    365	 */
>    366	#define MD5_TEST_VECTORS	7
>    367=09
>    368	static struct hash_testvec md5_tv_template[] =3D {
>    369		{
>  > 370			.digest	=3D md5_zero_message_hash,
>    371		}, {
>    372			.plaintext =3D "a",
>    373			.psize	=3D 1,
>=20
> ---
> 0-DAY kernel test infrastructure                Open Source Technolog=
y Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Cor=
poration
>=20

Oups I forgot to add sha and md5 header, I will resend tomorow.

Regards
