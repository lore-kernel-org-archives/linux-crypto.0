From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 01/27] staging: ccree: SPDXify driver
Date: Sun,  7 Jan 2018 12:14:12 +0000
Message-ID: <1515327285-8948-2-git-send-email-gilad@benyossef.com>
References: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Replace verbatim GPL v2 copy with SPDX tag.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/Kconfig            |  2 ++
 drivers/staging/ccree/Makefile           |  2 ++
 drivers/staging/ccree/cc_crypto_ctx.h    | 17 ++---------------
 drivers/staging/ccree/cc_debugfs.c       | 17 ++---------------
 drivers/staging/ccree/cc_debugfs.h       | 17 ++---------------
 drivers/staging/ccree/cc_hw_queue_defs.h | 17 ++---------------
 drivers/staging/ccree/cc_lli_defs.h      | 17 ++---------------
 drivers/staging/ccree/dx_crys_kernel.h   | 17 ++---------------
 drivers/staging/ccree/dx_host.h          | 17 ++---------------
 drivers/staging/ccree/dx_reg_common.h    | 17 ++---------------
 drivers/staging/ccree/hash_defs.h        | 17 ++---------------
 drivers/staging/ccree/ssi_aead.c         | 17 ++---------------
 drivers/staging/ccree/ssi_aead.h         | 17 ++---------------
 drivers/staging/ccree/ssi_buffer_mgr.c   | 17 ++---------------
 drivers/staging/ccree/ssi_buffer_mgr.h   | 17 ++---------------
 drivers/staging/ccree/ssi_cipher.c       | 17 ++---------------
 drivers/staging/ccree/ssi_cipher.h       | 17 ++---------------
 drivers/staging/ccree/ssi_driver.c       | 17 ++---------------
 drivers/staging/ccree/ssi_driver.h       | 17 ++---------------
 drivers/staging/ccree/ssi_fips.c         | 17 ++---------------
 drivers/staging/ccree/ssi_fips.h         | 17 ++---------------
 drivers/staging/ccree/ssi_hash.c         | 17 ++---------------
 drivers/staging/ccree/ssi_hash.h         | 17 ++---------------
 drivers/staging/ccree/ssi_ivgen.c        | 17 ++---------------
 drivers/staging/ccree/ssi_ivgen.h        | 17 ++---------------
 drivers/staging/ccree/ssi_pm.c           | 17 ++---------------
 drivers/staging/ccree/ssi_pm.h           | 17 ++---------------
 drivers/staging/ccree/ssi_request_mgr.c  | 17 ++---------------
 drivers/staging/ccree/ssi_request_mgr.h  | 17 ++---------------
 drivers/staging/ccree/ssi_sram_mgr.c     | 17 ++---------------
 drivers/staging/ccree/ssi_sram_mgr.h     | 17 ++---------------
 31 files changed, 62 insertions(+), 435 deletions(-)

diff --git a/drivers/staging/ccree/Kconfig b/drivers/staging/ccree/Kconfig
index 0b3092b..c94dfe8 100644
--- a/drivers/staging/ccree/Kconfig
+++ b/drivers/staging/ccree/Kconfig
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 config CRYPTO_DEV_CCREE
 	tristate "Support for ARM TrustZone CryptoCell C7XX family of Crypto accelerators"
 	depends on CRYPTO && CRYPTO_HW && OF && HAS_DMA
diff --git a/drivers/staging/ccree/Makefile b/drivers/staging/ccree/Makefile
index ab9f073..bb47144 100644
--- a/drivers/staging/ccree/Makefile
+++ b/drivers/staging/ccree/Makefile
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
 ccree-y := ssi_driver.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_aead.o ssi_ivgen.o ssi_sram_mgr.o ssi_pm.o
 ccree-$(CONFIG_CRYPTO_FIPS) += ssi_fips.o
diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index 0e34d9a..02e14f3 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #ifndef _CC_CRYPTO_CTX_H_
 #define _CC_CRYPTO_CTX_H_
diff --git a/drivers/staging/ccree/cc_debugfs.c b/drivers/staging/ccree/cc_debugfs.c
index 662fa07..ab2c986 100644
--- a/drivers/staging/ccree/cc_debugfs.c
+++ b/drivers/staging/ccree/cc_debugfs.c
@@ -1,18 +1,5 @@
-/*
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
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #include <linux/kernel.h>
 #include <linux/debugfs.h>
diff --git a/drivers/staging/ccree/cc_debugfs.h b/drivers/staging/ccree/cc_debugfs.h
index edfe9ba..354ec17 100644
--- a/drivers/staging/ccree/cc_debugfs.h
+++ b/drivers/staging/ccree/cc_debugfs.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #ifndef __CC_DEBUGFS_H__
 #define __CC_DEBUGFS_H__
diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index 7c25a4f..52d32d1 100644
--- a/drivers/staging/ccree/cc_hw_queue_defs.h
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #ifndef __CC_HW_QUEUE_DEFS_H__
 #define __CC_HW_QUEUE_DEFS_H__
diff --git a/drivers/staging/ccree/cc_lli_defs.h b/drivers/staging/ccree/cc_lli_defs.h
index 861634a..64b15ac 100644
--- a/drivers/staging/ccree/cc_lli_defs.h
+++ b/drivers/staging/ccree/cc_lli_defs.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #ifndef _CC_LLI_DEFS_H_
 #define _CC_LLI_DEFS_H_
diff --git a/drivers/staging/ccree/dx_crys_kernel.h b/drivers/staging/ccree/dx_crys_kernel.h
index 30719f4..fa99440 100644
--- a/drivers/staging/ccree/dx_crys_kernel.h
+++ b/drivers/staging/ccree/dx_crys_kernel.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #ifndef __CC_CRYS_KERNEL_H__
 #define __CC_CRYS_KERNEL_H__
diff --git a/drivers/staging/ccree/dx_host.h b/drivers/staging/ccree/dx_host.h
index e90afbc..69ef2fa 100644
--- a/drivers/staging/ccree/dx_host.h
+++ b/drivers/staging/ccree/dx_host.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #ifndef __CC_HOST_H__
 #define __CC_HOST_H__
diff --git a/drivers/staging/ccree/dx_reg_common.h b/drivers/staging/ccree/dx_reg_common.h
index 8334d9f..76c5539 100644
--- a/drivers/staging/ccree/dx_reg_common.h
+++ b/drivers/staging/ccree/dx_reg_common.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #ifndef __CC_REG_COMMON_H__
 #define __CC_REG_COMMON_H__
diff --git a/drivers/staging/ccree/hash_defs.h b/drivers/staging/ccree/hash_defs.h
index f52656f..92d5c10 100644
--- a/drivers/staging/ccree/hash_defs.h
+++ b/drivers/staging/ccree/hash_defs.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #ifndef _HASH_DEFS_H_
 #define _HASH_DEFS_H_
diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 1522b00..414098a 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1,18 +1,5 @@
-/*
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
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
index 2507be1..9567b8f 100644
--- a/drivers/staging/ccree/ssi_aead.h
+++ b/drivers/staging/ccree/ssi_aead.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 /* \file ssi_aead.h
  * ARM CryptoCell AEAD Crypto API
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 6846d93..ece17caf 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -1,18 +1,5 @@
-/*
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
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #include <linux/crypto.h>
 #include <linux/version.h>
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/ssi_buffer_mgr.h
index 395c93f..cc4b173 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.h
+++ b/drivers/staging/ccree/ssi_buffer_mgr.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 /* \file buffer_mgr.h
  * Buffer Manager
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index db21570..6178d38 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -1,18 +1,5 @@
-/*
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
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
index 5d94cd3..97b266b 100644
--- a/drivers/staging/ccree/ssi_cipher.h
+++ b/drivers/staging/ccree/ssi_cipher.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 /* \file ssi_cipher.h
  * ARM CryptoCell Cipher Crypto API
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 1254c69..3eabefb 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -1,18 +1,5 @@
-/*
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
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index bf83f3e..7383a83 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 /* \file ssi_driver.h
  * ARM CryptoCell Linux Crypto Driver
diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
index 9ca6857..2c58f90 100644
--- a/drivers/staging/ccree/ssi_fips.c
+++ b/drivers/staging/ccree/ssi_fips.c
@@ -1,18 +1,5 @@
-/*
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
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #include <linux/kernel.h>
 #include <linux/fips.h>
diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
index 8321dde..0d52003 100644
--- a/drivers/staging/ccree/ssi_fips.h
+++ b/drivers/staging/ccree/ssi_fips.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #ifndef __CC_FIPS_H__
 #define __CC_FIPS_H__
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 882f1c1..3c28904 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -1,18 +1,5 @@
-/*
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
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
index 81f57fc..fa2cdb1 100644
--- a/drivers/staging/ccree/ssi_hash.h
+++ b/drivers/staging/ccree/ssi_hash.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 /* \file ssi_hash.h
  * ARM CryptoCell Hash Crypto API
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index d1b8ce0..6b92649 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -1,18 +1,5 @@
-/*
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
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #include <linux/platform_device.h>
 #include <crypto/ctr.h>
diff --git a/drivers/staging/ccree/ssi_ivgen.h b/drivers/staging/ccree/ssi_ivgen.h
index eeca45e3..b6ac169 100644
--- a/drivers/staging/ccree/ssi_ivgen.h
+++ b/drivers/staging/ccree/ssi_ivgen.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #ifndef __CC_IVGEN_H__
 #define __CC_IVGEN_H__
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index 5b80b59..3d9d00b 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -1,18 +1,5 @@
-/*
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
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
diff --git a/drivers/staging/ccree/ssi_pm.h b/drivers/staging/ccree/ssi_pm.h
index 1f601bd..87bc389 100644
--- a/drivers/staging/ccree/ssi_pm.h
+++ b/drivers/staging/ccree/ssi_pm.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 /* \file ssi_pm.h
  */
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index c57c588..7686e14 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -1,18 +1,5 @@
-/*
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
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
diff --git a/drivers/staging/ccree/ssi_request_mgr.h b/drivers/staging/ccree/ssi_request_mgr.h
index eb068bf..8f9a9d3 100644
--- a/drivers/staging/ccree/ssi_request_mgr.h
+++ b/drivers/staging/ccree/ssi_request_mgr.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 /* \file request_mgr.h
  * Request Manager
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index f72d64a..1a2a7f4d 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -1,18 +1,5 @@
-/*
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
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #include "ssi_driver.h"
 #include "ssi_sram_mgr.h"
diff --git a/drivers/staging/ccree/ssi_sram_mgr.h b/drivers/staging/ccree/ssi_sram_mgr.h
index 181968a..d48649f 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.h
+++ b/drivers/staging/ccree/ssi_sram_mgr.h
@@ -1,18 +1,5 @@
-/*
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #ifndef __CC_SRAM_MGR_H__
 #define __CC_SRAM_MGR_H__
-- 
2.7.4
