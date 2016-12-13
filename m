From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 3/7] hwrng: core: Rewrite the header
Date: Tue, 13 Dec 2016 15:51:11 +0100
Message-ID: <20161213145115.30082-3-clabbe.montjoie@gmail.com>
References: <20161213145115.30082-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161213145115.30082-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

checkpatch have lot of complaint about header.
Furthermore, the header have some offtopic/useless information.

This patch rewrite a proper header.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/core.c | 38 +++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 7029246..a8e63ae 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -1,33 +1,13 @@
 /*
-        Added support for the AMD Geode LX RNG
-	(c) Copyright 2004-2005 Advanced Micro Devices, Inc.
-
-	derived from
-
- 	Hardware driver for the Intel/AMD/VIA Random Number Generators (RNG)
-	(c) Copyright 2003 Red Hat Inc <jgarzik@redhat.com>
-
- 	derived from
-
-        Hardware driver for the AMD 768 Random Number Generator (RNG)
-        (c) Copyright 2001 Red Hat Inc <alan@redhat.com>
-
- 	derived from
-
-	Hardware driver for Intel i810 Random Number Generator (RNG)
-	Copyright 2000,2001 Jeff Garzik <jgarzik@pobox.com>
-	Copyright 2000,2001 Philipp Rumpf <prumpf@mandrakesoft.com>
-
-	Added generic RNG API
-	Copyright 2006 Michael Buesch <m@bues.ch>
-	Copyright 2005 (c) MontaVista Software, Inc.
-
-	Please read Documentation/hw_random.txt for details on use.
-
-	----------------------------------------------------------
-	This software may be used and distributed according to the terms
-        of the GNU General Public License, incorporated herein by reference.
-
+ * hw_random/core.c: HWRNG core API
+ *
+ * Copyright 2006 Michael Buesch <m@bues.ch>
+ * Copyright 2005 (c) MontaVista Software, Inc.
+ *
+ * Please read Documentation/hw_random.txt for details on use.
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
  */
 
 #include <linux/device.h>
-- 
2.10.2
