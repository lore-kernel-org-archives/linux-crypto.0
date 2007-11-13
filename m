From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: IV copy strategy
Date: Wed, 14 Nov 2007 00:11:32 +0100
Message-ID: <20071113231132.GA10680@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:49526 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756739AbXKMXLg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2007 18:11:36 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Herbert,

I just run in a bug which I caused. Actually I don't understand it at
all. The bad patch seems to be:

|75a8ae21dfd08f425b72906cc30b53103b2e5105 is first bad commit
| commit 75a8ae21dfd08f425b72906cc30b53103b2e5105
| Author: Sebastian Siewior <sebastian@breakpoint.cc>
| Date:   Sun Oct 21 16:04:23 2007 +0800
|=20
|     [CRYPTO] geode: use consistent IV copy

and the bug report is:

|=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
|BUG kmalloc-64: Poison overwritten
|----------------------------------------------------------------------=
-------
|
|INFO: 0xc21dc3a0-0xc21dc3af. First byte 0xe3 instead of 0x6b
|INFO: Allocated in blkcipher_walk_first+0xe0/0x1a9 age=3D1 cpu=3D0 pid=
=3D2569
|INFO: Freed in blkcipher_walk_done+0x19d/0x1b7 age=3D0 cpu=3D0 pid=3D2=
569
|INFO: Slab 0xc1043b80 used=3D4 fp=3D0xc21dc380 flags=3D0x400000c3
|INFO: Object 0xc21dc380 @offset=3D896 fp=3D0xc21dc7e0
|
|Bytes b4 0xc21dc370:  18 09 00 00 39 73 00 00 5a 5a 5a 5a 5a 5a 5a 5a =
=2E...9s..ZZZZZZZZ
|  Object 0xc21dc380:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
kkkkkkkkkkkkkkkk
|  Object 0xc21dc390:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
kkkkkkkkkkkkkkkk
|  Object 0xc21dc3a0:  e3 53 77 9c 10 79 ae b8 27 08 94 2d be 77 18 1a =
=C3=A3Sw..y=C2=AE=C2=B8'..-=C2=BEw..
|  Object 0xc21dc3b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 =
kkkkkkkkkkkkkkk=C2=A5
| Redzone 0xc21dc3c0:  bb bb bb bb                                     =
=C2=BB=C2=BB=C2=BB=C2=BB
| Padding 0xc21dc3e8:  5a 5a 5a 5a 5a 5a 5a 5a                         =
ZZZZZZZZ
| [<c0150040>] check_bytes_and_report+0x8d/0xae
| [<c015029f>] check_object+0xbf/0x1b5
| [<c01b8131>] blkcipher_walk_first+0xe0/0x1a9
| [<c0150e97>] __slab_alloc+0x33a/0x433
| [<c01b8131>] blkcipher_walk_first+0xe0/0x1a9
| [<c0151b1f>] __kmalloc+0x7d/0xe8
| [<c01b8131>] blkcipher_walk_first+0xe0/0x1a9
| [<c01b8131>] blkcipher_walk_first+0xe0/0x1a9
| [<c01b8131>] blkcipher_walk_first+0xe0/0x1a9
| [<c015031e>] check_object+0x13e/0x1b5
| [<d00134e0>] geode_cbc_encrypt+0x32/0xca [geode_aes]
| [<c01510fb>] kfree+0xc0/0xca
|

I removed the write back of the IV=20
    memcpy(walk.iv, op->iv, AES_IV_LENGTH);

and everything goes back to normal. I checked walk.iv and it doesn't
change, it is still the same pointer. Do you free the walk.iv in the
meantime or is there another BUG I don't see? The IV length is 16 bytes=
=2E
Currently I'm lost ...

Sebastian
