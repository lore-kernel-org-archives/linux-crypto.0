From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH 0/5] Partial (de)compression Crypto API
Date: Wed, 18 Feb 2009 16:53:17 +0100
Message-ID: <1234972402-24298-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57291 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751720AbZBRPxY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Feb 2009 10:53:24 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


The following patch series adds support for partial (de)compression to =
the
CRYPTO API, and modifies SquashFS 4 to use this:

  [1] crypto: compress - Add pcomp interface
  [2] crypto: testmgr - Add support for the pcomp interface
  [3] crypto: new zlib crypto module, using pcomp
  [4] crypto: testmgr - add zlib test
  [5] squashfs: Make SquashFS 4 use the new pcomp crypto interface

The patches are based on:
  linux-2.6.git + cryptodev-2.6.git + commit 3f683d61 ("crypto: api - F=
ix
  crypto_alloc_tfm/create_create_tfm return convention")

Changes since last version (2009-02-13):
  - Convert crypto_pcomp to a new-style crypto module, using crypto_all=
oc_tfm()
    instead of crypto_alloc_base()
  - Pass crypto_pcomp pointers instead of crypto_tfm pointers where app=
ropriate
  - Use crypto_destroy_tfm() instead of crypto_free_tfm(), to take into=
 account
    the offset info the slab object
  - Remove redundant check for CRYPTO_ALG_TYPE_PCOMPRESS in
    crypto_pcomp_init_tfm()
  - Use separate setup functions for compression and decompression
  - Sanitize naming to crypto_{,de}compress_{setup,init,update,final}()
  - Remove backwards-compatibility layer (export pcomp through comp), a=
s
    requested by Herbert Xu
  - Create a new "zlib" pcomp module instead of modifying the existing
    "deflate" comp module=20
  - Readd accidentally removed ".cra_module =3D THIS_MODULE", which all=
owed the
    zlib module to be rmmoded while it was in use
  - Fix the pcomp/testmgr dependency

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
