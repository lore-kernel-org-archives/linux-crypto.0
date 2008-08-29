From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 0/3] [RFC] zlib crypto module
Date: Fri, 29 Aug 2008 15:41:58 +0200
Message-ID: <20080829134158.108976037@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org, squashfs-devel@lists.sourceforge.net
Return-path: <linux-embedded-owner@vger.kernel.org>
Sender: linux-embedded-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

These patches add a (de)compression module for the "zlib" format using =
the
crypto API:
  [1] crypto: Add a zlib crypto module
  [2] tcrypt: Add a self test for the zlib crypto module
  [3] squashfs: Switch from zlib/inflate to "zlib" crypto module

The last patch is a proof-of-concept to make SquashFS 3.4 use this new =
zlib
crypto module. This makes it easier to e.g. change the decompression al=
gorithm
in SquashFS or to make use of a hardware-accelerated zlib crypto module=
=2E

It can be extended to other compressed file systems, like e.g. AxFS and=
 CRAMFS.

All comments are welcome. Thanks!

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
