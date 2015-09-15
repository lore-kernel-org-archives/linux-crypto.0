From: David Howells <dhowells@redhat.com>
Subject: [PATCH] modsign: Fix GPL/OpenSSL licence incompatibility
Date: Tue, 15 Sep 2015 16:03:36 +0100
Message-ID: <20150915150336.14206.34368.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Woodhouse <David.Woodhouse@intel.com>,
	Julian Andres Klode <jak@jak-linux.org>,
	linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: torvalds@linux-foundation.org, jmorris@namei.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbbIOPDm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Sep 2015 11:03:42 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: David Woodhouse <dwmw2@infradead.org>

The GPL does not permit us to link against the OpenSSL library. Use
LGPL for sign-file and extract-file instead.

Reported-by: Julian Andres Klode <jak@jak-linux.org>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Julian Andres Klode <jak@jak-linux.org>
---

 scripts/extract-cert.c |   10 +++++-----
 scripts/sign-file.c    |   13 ++++++++-----
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/scripts/extract-cert.c b/scripts/extract-cert.c
index 10d23ca9f617..6ce5945a0b89 100644
--- a/scripts/extract-cert.c
+++ b/scripts/extract-cert.c
@@ -1,15 +1,15 @@
 /* Extract X.509 certificate in DER form from PKCS#11 or PEM.
  *
- * Copyright =C2=A9 2014 Red Hat, Inc. All Rights Reserved.
- * Copyright =C2=A9 2015 Intel Corporation.
+ * Copyright =C2=A9 2014-2015 Red Hat, Inc. All Rights Reserved.
+ * Copyright =C2=A9 2015      Intel Corporation.
  *
  * Authors: David Howells <dhowells@redhat.com>
  *          David Woodhouse <dwmw2@infradead.org>
  *
  * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
+ * modify it under the terms of the GNU Lesser General Public License
+ * as published by the Free Software Foundation; either version 2.1
+ * of the licence, or (at your option) any later version.
  */
 #define _GNU_SOURCE
 #include <stdio.h>
diff --git a/scripts/sign-file.c b/scripts/sign-file.c
index 058bba3103e2..c3899ca4811c 100755
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -1,12 +1,15 @@
 /* Sign a module file using the given key.
  *
- * Copyright (C) 2014 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
+ * Copyright =C2=A9 2014-2015 Red Hat, Inc. All Rights Reserved.
+ * Copyright =C2=A9 2015      Intel Corporation.
+ *
+ * Authors: David Howells <dhowells@redhat.com>
+ *          David Woodhouse <dwmw2@infradead.org>
  *
  * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
+ * modify it under the terms of the GNU Lesser General Public License
+ * as published by the Free Software Foundation; either version 2.1
+ * of the licence, or (at your option) any later version.
  */
 #define _GNU_SOURCE
 #include <stdio.h>
