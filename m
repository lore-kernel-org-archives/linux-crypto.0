From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 12/22] staging: ccree: align box comment correctly
Date: Tue, 15 Aug 2017 09:26:40 +0300
Message-ID: <1502778412-16255-13-git-send-email-gilad@benyossef.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix indentation in first comment.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index b7d6586..b95c3ce 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -1,18 +1,18 @@
  /*
- * Copyright (C) 2012-2017 ARM Limited or its affiliates.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
- */
+  * Copyright (C) 2012-2017 ARM Limited or its affiliates.
+  *
+  * This program is free software; you can redistribute it and/or modify
+  * it under the terms of the GNU General Public License version 2 as
+  * published by the Free Software Foundation.
+  *
+  * This program is distributed in the hope that it will be useful,
+  * but WITHOUT ANY WARRANTY; without even the implied warranty of
+  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  * GNU General Public License for more details.
+  *
+  * You should have received a copy of the GNU General Public License
+  * along with this program; if not, see <http://www.gnu.org/licenses/>.
+  */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-- 
2.1.4
