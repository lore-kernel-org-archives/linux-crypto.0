From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 0/8] Partial decompression API
Date: Wed, 17 Dec 2008 17:36:35 +0100
Message-ID: <20081217163634.998961917@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65181 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751411AbYLQQmA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Dec 2008 11:42:00 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following patch series adds support for partial (de)compression to =
the
CRYPTO API, and modifies SquashFS 4 to use this:
  [1] crypto: testmgr - Correct comment about deflate parameters
  [2] crypto: compress - Add pcomp interface
  [3] crypto: testmgr - Add support for the pcomp interface
  [4] crypto: api - Add type init function to crypto_tfm
  [5] crypto: api - Export pcomp through comp
  [6] crypto: deflate - switch to pcomp
  [7] crypto: testmgr - swith deflate test to pcomp
  [8] squashfs: Make SquashFS 4 use the new pcomp crypto interface

All patches are relative to cryptodev-2.6.git, except for the last one,=
 which
is relative to squashfs-2.6.git.

The first patch is independent and can be applied immediately, but I in=
cluded
it in this series to avoid rejects.

The backwards-compatibility layer has been tested with IPComp and UBIFS=
=2E

Changes since last version (2008-11-24):
  - Add a new "pcomp" crypto interface, instead of modifying the existi=
ng
    "comp" interface, with a compatibility layer,
  - Modify the existing "deflate" module, instead of adding a new "zlib=
"
    module,
  - Add support for the configuration of (de)compression parameters,
  - Separate allocation for compression and decompression, to avoid mem=
ory
    wastage.

Thanks for your comments!

 crypto/Makefile              |    2=20
 crypto/api.c                 |   35 +++-
 crypto/deflate.c             |  342 +++++++++++++++++++++++++++++++---=
---------
 crypto/internal.h            |    8 +
 crypto/pcompress.c           |  187 +++++++++++++++++++++++
 crypto/proc.c                |    3=20
 crypto/testmgr.c             |  170 +++++++++++++++++++++
 crypto/testmgr.h             |   34 +++-
 fs/Kconfig                   |    3=20
 fs/squashfs/block.c          |   67 +++++---
 fs/squashfs/squashfs_fs_sb.h |    2=20
 fs/squashfs/super.c          |   32 +++-
 include/linux/crypto.h       |  169 ++++++++++++++++++++-
 13 files changed, 917 insertions(+), 137 deletions(-)

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =C2=B7 RPR Brussels
=46ortis =C2=B7 BIC GEBABEBB =C2=B7 IBAN BE41293037680010

--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
