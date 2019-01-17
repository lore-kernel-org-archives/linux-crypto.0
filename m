Return-Path: <SRS0=b5ak=PZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:48012 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbfAQXP1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 18:15:27 -0500
Message-Id: <20190117231500.970473486@linutronix.de>
Date: Fri, 18 Jan 2019 00:14:18 +0100
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [patch 2/9] crypto: aegis - Cleanup license mess
References: <20190117231416.111952141@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Precise and non-ambiguous license information is important. The recently
added aegis header file has a SPDX license identifier, which is nice, but
at the same time it has a contradictionary license boiler plate text.

  SPDX-License-Identifier: GPL-2.0

versus 

  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation; either version 2 of the License, or (at your option)
  * any later version

Oh well.

As the other aegis related files are licensed under the GPL v2 or later,
it's assumed that the boiler plate code is correct, but the SPDX license
identifier is wrong.

Fix the SPDX identifier and remove the boiler plate as it is redundant.

Fixes: f606a88e5823 ("crypto: aegis - Add generic AEGIS AEAD implementations")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---

P.S.: This patch is part of a larger cleanup, but independent of other
      patches and is intended to be picked up by the maintainer directly.

---
 crypto/aegis.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/crypto/aegis.h
+++ b/crypto/aegis.h
@@ -1,14 +1,9 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * AEGIS common definitions
  *
  * Copyright (c) 2018 Ondrej Mosnacek <omosnacek@gmail.com>
  * Copyright (c) 2018 Red Hat, Inc. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
  */
 
 #ifndef _CRYPTO_AEGIS_H
