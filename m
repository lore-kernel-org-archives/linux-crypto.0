From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: unmet direct dependencies  (CRYPTO && EXPERIMENTAL)
Date: Mon, 27 Dec 2010 13:13:31 +0100
Message-ID: <201012271313.31686.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:54516 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750958Ab0L0MNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Dec 2010 07:13:35 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

a "make randconfig 1>/dev/null" gave today :

warning: (CRYPTO_LRW && CRYPTO && EXPERIMENTAL || CRYPTO_XTS && CRYPTO =
&& EXPERIMENTAL || CRYPTO_GHASH && CRYPTO) selects=20
CRYPTO_GF128MUL which has unmet direct dependencies (CRYPTO && EXPERIME=
NTAL)

for the current git kernel sources.
Is this an already known issue ?

--=20
MfG/Kind regards
Toralf F=C3=B6rster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
