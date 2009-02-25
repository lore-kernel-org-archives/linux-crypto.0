From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH 0/6] Partial (de)compression Crypto API
Date: Wed, 25 Feb 2009 14:43:08 +0100
Message-ID: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:63854 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751274AbZBYNnS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 08:43:18 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


	Hi Herbert,

The following patch series adds support for partial (de)compression to =
the
CRYPTO API, and modifies SquashFS 4 to use this:

  - [1] netlink: Move netlink attribute parsing support to lib/
  - [2] crypto: compress - Add pcomp interface
  - [3] crypto: testmgr - Add support for the pcomp interface
  - [4] crypto: new zlib crypto module, using pcomp
  - [5] crypto: testmgr - add zlib test
  - [6] squashfs: Make SquashFS 4 use the new pcomp crypto interface

The patches are based on:
  linux-2.6.git + cryptodev-2.6.git

Changes since last version (2009-02-18):
  - Use netlink attributes for the (de)compression setup parameters
  - Move netlink attribute parsing support to lib/, enabled by CONFIG_N=
LATTR

David, Phillip: can I please have your ack?

If nobody objects, please apply.

Thanks!

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
