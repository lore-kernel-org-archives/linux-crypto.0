From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 0/7] Partial (de)compression API
Date: Tue, 13 Jan 2009 16:59:39 +0100
Message-ID: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:47620 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753051AbZAMP7x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2009 10:59:53 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


The following patch series adds support for partial (de)compression to =
the
CRYPTO API, and modifies SquashFS 4 to use this:
  [1] crypto: compress - Add pcomp interface
  [2] crypto: testmgr - Add support for the pcomp interface
  [3] crypto: api - Add type init function to crypto_tfm
  [4] crypto: api - Export pcomp through comp
  [5] crypto: deflate - switch to pcomp
  [6] crypto: testmgr - swith deflate test to pcomp
  [7] squashfs: Make SquashFS 4 use the new pcomp crypto interface

The backwards-compatibility layer has been tested with IPComp and UBIFS=
=2E

Changes since last version (2008-12-17):
  - Model the "pcomp" crypto interface on the new crypto types,
  - Remove the comp_request parameter from *_{,de}compress_init(),
  - Update for recent Squashfs changes (Squashfs is now in mainline).

Thanks for your comments!

 crypto/Kconfig                     |    6 +-
 crypto/Makefile                    |    2 +
 crypto/api.c                       |   20 ++-
 crypto/deflate.c                   |  350 ++++++++++++++++++++++++++--=
--------
 crypto/pcompress.c                 |  203 +++++++++++++++++++++
 crypto/testmgr.c                   |  185 +++++++++++++++++++-
 crypto/testmgr.h                   |   33 ++++-
 fs/Kconfig                         |    3 +-
 fs/squashfs/block.c                |   81 +++++----
 fs/squashfs/squashfs_fs_sb.h       |    2 +-
 fs/squashfs/super.c                |   36 +++-
 include/crypto/compress.h          |  147 +++++++++++++++
 include/crypto/internal/compress.h |   29 +++
 include/linux/crypto.h             |    9 +-
 14 files changed, 953 insertions(+), 153 deletions(-)

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
