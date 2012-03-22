From: =?utf-8?B?TWljaGHFgiBXcsOzYmVs?= <michal.wrobel@flytronic.pl>
Subject: [PATCH] crypto: ixp4xx - include fix
Date: Thu, 22 Mar 2012 13:00:10 +0100
Message-ID: <20120322120010.GA4695@FLYC077.flytronic.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from v031479.home.net.pl ([89.161.171.237]:52439 "HELO
	v031479.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932152Ab2CVMGz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Mar 2012 08:06:55 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Before commit de47725421ad5627a5c905f4e40bb844ebc06d29 ("include: repla=
ce
linux/module.h with "struct module" wherever possible") <linux/module.h=
> was
implicitly included through <linux/platform_device.h> -> <linux/device.=
h>.

Signed-off-by: Micha=C5=82 Wr=C3=B3bel <michal.wrobel@flytronic.pl>
---
 drivers/crypto/ixp4xx_crypto.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_cry=
pto.c
index 4c20c5b..45704be 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/gfp.h>
+#include <linux/module.h>
=20
 #include <crypto/ctr.h>
 #include <crypto/des.h>
--=20
1.7.5.4
