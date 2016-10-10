From: Tyler Hicks <tyhicks@canonical.com>
Subject: Re: Observed a ecryptFS crash
Date: Mon, 10 Oct 2016 16:57:16 -0500
Message-ID: <7d199752-3257-944c-e306-81ded499b131@canonical.com>
References: <00B10D30F2BAA743B48953A4D86C96D54CB653@SZXEMI506-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="uRFL1I8ak2US6uAq3uCun2MAiG8304buL"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "ecryptfs@vger.kernel.org" <ecryptfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yaodongdong <yaodongdong@huawei.com>,
        Wangbintian <bintian.wang@huawei.com>,
        yingjindong <yingjindong@huawei.com>,
        Xiakaixu <xiakaixu@huawei.com>, Yezongbo <yezongbo@huawei.com>,
        "likan (A)" <likan82@huawei.com>
To: liushuoran <liushuoran@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38182 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbcJJV5X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Oct 2016 17:57:23 -0400
In-Reply-To: <00B10D30F2BAA743B48953A4D86C96D54CB653@SZXEMI506-MBS.china.huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uRFL1I8ak2US6uAq3uCun2MAiG8304buL
Content-Type: multipart/mixed; boundary="W6pnXDKfeW8GPE0xUSAJRQLVLMrQ1ttKP";
 protected-headers="v1"
From: Tyler Hicks <tyhicks@canonical.com>
To: liushuoran <liushuoran@huawei.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "ecryptfs@vger.kernel.org" <ecryptfs@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Yaodongdong <yaodongdong@huawei.com>, Wangbintian <bintian.wang@huawei.com>,
 yingjindong <yingjindong@huawei.com>, Xiakaixu <xiakaixu@huawei.com>,
 Yezongbo <yezongbo@huawei.com>, "likan (A)" <likan82@huawei.com>
Message-ID: <7d199752-3257-944c-e306-81ded499b131@canonical.com>
Subject: Re: Observed a ecryptFS crash
References: <00B10D30F2BAA743B48953A4D86C96D54CB653@SZXEMI506-MBS.china.huawei.com>
In-Reply-To: <00B10D30F2BAA743B48953A4D86C96D54CB653@SZXEMI506-MBS.china.huawei.com>

--W6pnXDKfeW8GPE0xUSAJRQLVLMrQ1ttKP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/29/2016 07:29 AM, liushuoran wrote:
> Hi Tyhicks,
>=20
> We observed a ecryptFS crash occasionally in Linux kernel 4.1.18. The c=
all trace is attached below. Is it a known issue=EF=BC=9F Look forward to=
 hearing from you. Thanks in advance!

It isn't known to me but I'm rarely testing eCryptfs with SELinux these
days. I don't recall any bug reports with a similar call trace, either.

You left out some potentially useful information below the "--[ cut here
]--" line and above the "Call trace:" line.

Tyler

>=20
> [19314.529479s][pid:2694,cpu3,GAC_Executor[0]]Call trace:
> [19314.529510s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0000f3898>] do_r=
aw_spin_lock+0x20/0x200
> [19314.529510s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc001031fb0>] _raw=
_spin_lock+0x28/0x34
> [19314.529541s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0003908e0>] seli=
nux_inode_free_security+0x3c/0x94
> [19314.529541s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc000386b04>] secu=
rity_inode_free+0x2c/0x38
> [19314.529541s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0001fff88>] __de=
stroy_inode+0x2c/0x180
> [19314.529571s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc000201660>] dest=
roy_inode+0x30/0xa0
> [19314.529571s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0002017d8>] evic=
t+0x108/0x1c0
> [19314.529571s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc000202588>] iput=
+0x184/0x258
> [19314.529602s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0002f27d0>] ecry=
ptfs_evict_inode+0x30/0x3c
> [19314.529602s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc00020177c>] evic=
t+0xac/0x1c0
> [19314.529602s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0002018d4>] disp=
ose_list+0x44/0x5c
> [19314.529632s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc000202d28>] evic=
t_inodes+0xcc/0x12c
> [19314.529632s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0001e5d04>] gene=
ric_shutdown_super+0x58/0xe4
> [19314.529632s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0001e7164>] kill=
_anon_super+0x30/0x74
> [19314.529663s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0002f16a4>] ecry=
ptfs_kill_block_super+0x24/0x54
> [19314.529663s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0001e6690>] deac=
tivate_locked_super+0x60/0x8c
> [19314.529663s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0001e6754>] deac=
tivate_super+0x98/0xa4
> [19314.529693s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc000206d54>] clea=
nup_mnt+0x50/0xd0
> [19314.529693s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc000206e48>] __cl=
eanup_mnt+0x20/0x2c
> [19314.529693s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0000c1bac>] task=
_work_run+0xbc/0xf8
> [19314.529724s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0000a3e98>] do_e=
xit+0x2d4/0xa14
> [19314.529724s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0000a56a8>] do_g=
roup_exit+0x60/0xf8
> [19314.529724s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0000b26ac>] get_=
signal+0x284/0x598
> [19314.529754s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc00008950c>] do_s=
ignal+0x170/0x5b8
> [19314.529754s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc000089be0>] do_n=
otify_resume+0x70/0x78
> [19314.529785s][pid:2694,cpu3,GAC_Executor[0]]Code: aa0003f3 aa1e03e0 9=
7fe7718 5289d5a0 (b9400661)=20
> [19314.529907s][pid:2694,cpu3,GAC_Executor[0]]---[ end trace 382e4b6264=
b035b5 ]---
> [19314.529907s][pid:2694,cpu3,GAC_Executor[0]]Kernel panic - not syncin=
g: Fatal exception
>=20
> Regards,
> Shuoran
>=20



--W6pnXDKfeW8GPE0xUSAJRQLVLMrQ1ttKP--

--uRFL1I8ak2US6uAq3uCun2MAiG8304buL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJX/A68AAoJENaSAD2qAscKcrUP/1kzSZ8Ey8exl0kuPfDTDfZ1
oX3N+h86/AnQBTg/PyRbJpw0wGw96YeMDf/iP/is0BfWT4B6HWCZmOkXIs6LsH7d
nCMZnG+0nzgDcjLreAok/GhcRyXje8yxFhwFIHZax+PfLeUJczls/FAE8FzEKNNp
lxvIb6/9+B6n1xynjZqlGX9yJzcfdZAq7MbySQWP9aTjwkc4cJX+T7Dexe9zRCFB
mU2bcu4UjVqYh7VjeEVFpSgaYHl/i2imrKbCBCy0iKDzFrp+Amr3eexXpUYl1pMt
DpiMIiVQQzwM6FDm62r/rk+D6FCY8gxqkzKWV0v8drIy0vH6JCXEoXKF80MQ5KYv
QFcuTpwuI+mCh5RIQ+6mWnb5LgXTfcRU0anCZAnU+Z05xL4cVC0NxuiIumN3FyG4
vhSFN+Sza3Hf4XemPcx+p2MyUwfImLUzWvcpK319B1lFNjnf3UFCpT3GQgikcli0
pNEkvUuHkF0toPaPXEpdskaWIRtSa4HE4YOhrVDbFzMebw/Qb4EepwjnnPlMyYO8
foMp06GYh2g1P/COWtyxdM8V0nxzQHuf7JEkb68DaJt+7ePp7PieQeHModEc1nWr
/o3eO9ZOEq9hFBo7kIVSaf6j8vduvtPgpNZu/nhoJzsu0YN8HXdsrAPER1m2wumH
YqMi/xq0FBskbl0Xyuqw
=He57
-----END PGP SIGNATURE-----

--uRFL1I8ak2US6uAq3uCun2MAiG8304buL--
