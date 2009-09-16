From: Frans Pop <elendil@planet.nl>
Subject: Build error on arm in crypto/cast6.c
Date: Wed, 16 Sep 2009 16:01:34 +0200
Message-ID: <200909161601.35662.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:54646 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbZIPOBd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2009 10:01:33 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

$ git describe master
v2.6.31-4547-g0cb583f

gcc version 4.3.2

crypto/cast6.c:372:39: error: macro "W" passed 2 arguments, but takes j=
ust 1
crypto/cast6.c:372: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98,=E2=
=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=80=98__attrib=
ute__=E2=80=99 before =E2=80=98{=E2=80=99 token
crypto/cast6.c:413:16: error: macro "W" passed 2 arguments, but takes j=
ust 1
crypto/cast6.c: In function =E2=80=98cast6_setkey=E2=80=99:
crypto/cast6.c:413: error: =E2=80=98W=E2=80=99 undeclared (first use in=
 this function)
crypto/cast6.c:413: error: (Each undeclared identifier is reported only=
 once
crypto/cast6.c:413: error: for each function it appears in.)
crypto/cast6.c:414:20: error: macro "W" passed 2 arguments, but takes j=
ust 1

Strange thing is that this file does not look to have changed.

Maybe it's a result of enabling the new config option CRYPTO_DEV_MV_CES=
A?

Cheers,
=46JP
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
