Return-Path: <SRS0=b5ak=PZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:48009 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbfAQXP0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 18:15:26 -0500
Message-Id: <20190117231501.162093731@linutronix.de>
Date: Fri, 18 Jan 2019 00:14:20 +0100
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [patch 4/9] crypto: aegis - Convert to SPDX license identifiers
References: <20190117231416.111952141@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The license boiler plate text is not ideal for machine parsing. The kernel
uses SPDX license identifiers for that purpose, which replace the boiler
plate text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---

P.S.: This patch is part of a larger cleanup, but independent of other
      patches and is intended to be picked up by the maintainer directly. 

---
 crypto/aegis128.c  |    6 +-----
 crypto/aegis128l.c |    6 +-----
 crypto/aegis256.c  |    6 +-----
 3 files changed, 3 insertions(+), 15 deletions(-)

--- a/crypto/aegis128.c
+++ b/crypto/aegis128.c
@@ -1,13 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * The AEGIS-128 Authenticated-Encryption Algorithm
  *
  * Copyright (c) 2017-2018 Ondrej Mosnacek <omosnacek@gmail.com>
  * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
  */
 
 #include <crypto/algapi.h>
--- a/crypto/aegis128l.c
+++ b/crypto/aegis128l.c
@@ -1,13 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * The AEGIS-128L Authenticated-Encryption Algorithm
  *
  * Copyright (c) 2017-2018 Ondrej Mosnacek <omosnacek@gmail.com>
  * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
  */
 
 #include <crypto/algapi.h>
--- a/crypto/aegis256.c
+++ b/crypto/aegis256.c
@@ -1,13 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * The AEGIS-256 Authenticated-Encryption Algorithm
  *
  * Copyright (c) 2017-2018 Ondrej Mosnacek <omosnacek@gmail.com>
  * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
  */
 
 #include <crypto/algapi.h>
