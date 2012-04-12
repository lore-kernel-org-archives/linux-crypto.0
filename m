From: Kent Yoder <key@linux.vnet.ibm.com>
Subject: [PATCH v3 15/17] powerpc: crypto: debugfs routines and docs for the
 nx device driver
Date: Thu, 12 Apr 2012 10:38:54 -0500
Message-ID: <1334245134.18090.36.camel@key-ThinkPad-W510>
References: <1334242825.18090.4.camel@key-ThinkPad-W510>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, rcj@linux.vnet.ibm.com,
	key@linux.vnet.ibm.com, benh@kernel.crashing.org,
	linuxppc-dev@lists.ozlabs.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1334242825.18090.4.camel@key-ThinkPad-W510>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

These routines add debugfs files supporting the Power7+ in-Nest encryption
accelerator driver.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 Documentation/ABI/testing/debugfs-pfo-nx-crypto |   45 ++++++++++
 drivers/crypto/nx/nx_debugfs.c                  |  103 +++++++++++++++++++++++
 2 files changed, 148 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-pfo-nx-crypto
 create mode 100644 drivers/crypto/nx/nx_debugfs.c

diff --git a/Documentation/ABI/testing/debugfs-pfo-nx-crypto b/Documentation/ABI/testing/debugfs-pfo-nx-crypto
new file mode 100644
index 0000000..685d5a4
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-pfo-nx-crypto
@@ -0,0 +1,45 @@
+What:		/sys/kernel/debug/nx-crypto/*
+Date:		March 2012
+KernelVersion:	3.4
+Contact:	Kent Yoder <key@linux.vnet.ibm.com>
+Description:
+
+  These debugfs interfaces are built by the nx-crypto driver, built in
+arch/powerpc/crypto/nx.
+
+Error Detection
+===============
+
+errors:
+- A u32 providing a total count of errors since the driver was loaded. The
+only errors counted here are those returned from the hcall, H_COP_OP.
+
+last_error:
+- The most recent non-zero return code from the H_COP_OP hcall. -EBUSY is not
+recorded here (the hcall will retry until -EBUSY goes away).
+
+last_error_pid:
+- The process ID of the process who received the most recent error from the
+hcall.
+
+Device Use
+==========
+
+aes_bytes:
+- The total number of bytes encrypted using AES in any of the driver's
+supported modes.
+
+aes_ops:
+- The total number of AES operations submitted to the hardware.
+
+sha256_bytes:
+- The total number of bytes hashed by the hardware using SHA-256.
+
+sha256_ops:
+- The total number of SHA-256 operations submitted to the hardware.
+
+sha512_bytes:
+- The total number of bytes hashed by the hardware using SHA-512.
+
+sha512_ops:
+- The total number of SHA-512 operations submitted to the hardware.
diff --git a/drivers/crypto/nx/nx_debugfs.c b/drivers/crypto/nx/nx_debugfs.c
new file mode 100644
index 0000000..7ab2e8d
--- /dev/null
+++ b/drivers/crypto/nx/nx_debugfs.c
@@ -0,0 +1,103 @@
+/**
+ * debugfs routines supporting the Power 7+ Nest Accelerators driver
+ *
+ * Copyright (C) 2011-2012 International Business Machines Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 only.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Author: Kent Yoder <yoder1@us.ibm.com>
+ */
+
+#include <linux/device.h>
+#include <linux/kobject.h>
+#include <linux/string.h>
+#include <linux/debugfs.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/crypto.h>
+#include <crypto/hash.h>
+#include <asm/vio.h>
+
+#include "nx_csbcpb.h"
+#include "nx.h"
+
+#ifdef CONFIG_DEBUG_FS
+
+/*
+ * debugfs
+ *
+ * For documentation on these attributes, please see:
+ *
+ * Documentation/ABI/testing/debugfs-pfo-nx-crypto
+ */
+
+int nx_debugfs_init(struct nx_crypto_driver *drv)
+{
+	struct nx_debugfs *dfs = &drv->dfs;
+
+	dfs->dfs_root = debugfs_create_dir(NX_NAME, NULL);
+
+	dfs->dfs_aes_ops =
+		debugfs_create_u32("aes_ops",
+				   S_IRUSR | S_IRGRP | S_IROTH,
+				   dfs->dfs_root, (u32 *)&drv->stats.aes_ops);
+	dfs->dfs_sha256_ops =
+		debugfs_create_u32("sha256_ops",
+				   S_IRUSR | S_IRGRP | S_IROTH,
+				   dfs->dfs_root,
+				   (u32 *)&drv->stats.sha256_ops);
+	dfs->dfs_sha512_ops =
+		debugfs_create_u32("sha512_ops",
+				   S_IRUSR | S_IRGRP | S_IROTH,
+				   dfs->dfs_root,
+				   (u32 *)&drv->stats.sha512_ops);
+	dfs->dfs_aes_bytes =
+		debugfs_create_u64("aes_bytes",
+				   S_IRUSR | S_IRGRP | S_IROTH,
+				   dfs->dfs_root,
+				   (u64 *)&drv->stats.aes_bytes);
+	dfs->dfs_sha256_bytes =
+		debugfs_create_u64("sha256_bytes",
+				   S_IRUSR | S_IRGRP | S_IROTH,
+				   dfs->dfs_root,
+				   (u64 *)&drv->stats.sha256_bytes);
+	dfs->dfs_sha512_bytes =
+		debugfs_create_u64("sha512_bytes",
+				   S_IRUSR | S_IRGRP | S_IROTH,
+				   dfs->dfs_root,
+				   (u64 *)&drv->stats.sha512_bytes);
+	dfs->dfs_errors =
+		debugfs_create_u32("errors",
+				   S_IRUSR | S_IRGRP | S_IROTH,
+				   dfs->dfs_root, (u32 *)&drv->stats.errors);
+	dfs->dfs_last_error =
+		debugfs_create_u32("last_error",
+				   S_IRUSR | S_IRGRP | S_IROTH,
+				   dfs->dfs_root,
+				   (u32 *)&drv->stats.last_error);
+	dfs->dfs_last_error_pid =
+		debugfs_create_u32("last_error_pid",
+				   S_IRUSR | S_IRGRP | S_IROTH,
+				   dfs->dfs_root,
+				   (u32 *)&drv->stats.last_error_pid);
+	return 0;
+}
+
+void
+nx_debugfs_fini(struct nx_crypto_driver *drv)
+{
+	debugfs_remove_recursive(drv->dfs.dfs_root);
+}
+
+#endif
-- 
1.7.1
