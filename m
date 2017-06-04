From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 09/18] staging: ccree: remove custom bitfield macros
Date: Sun,  4 Jun 2017 11:02:30 +0300
Message-ID: <1496563362-7954-10-git-send-email-gilad@benyossef.com>
References: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Cc: Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

With all users removed or re-factored to use the standard
kernel bit fields ops we can now drop the custom
bit field macros.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_bitops.h        | 39 ------------------
 drivers/staging/ccree/cc_hw_queue_defs.h |  2 +-
 drivers/staging/ccree/cc_lli_defs.h      |  2 -
 drivers/staging/ccree/cc_regs.h          | 71 +++-----------------------------
 drivers/staging/ccree/ssi_driver.h       |  1 -
 5 files changed, 7 insertions(+), 108 deletions(-)
 delete mode 100644 drivers/staging/ccree/cc_bitops.h

diff --git a/drivers/staging/ccree/cc_bitops.h b/drivers/staging/ccree/cc_bitops.h
deleted file mode 100644
index cbdc1ab..0000000
--- a/drivers/staging/ccree/cc_bitops.h
+++ /dev/null
@@ -1,39 +0,0 @@
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
-
-/*!
- * \file cc_bitops.h
- * Bit fields operations macros.
- */
-#ifndef _CC_BITOPS_H_
-#define _CC_BITOPS_H_
-
-#include <linux/bitops.h>
-#include <linux/bitfield.h>
-
-#define BITMASK(mask_size) (((mask_size) < 32) ?       \
-       ((1UL << (mask_size)) - 1) : 0xFFFFFFFFUL)
-
-#define BITMASK_AT(mask_size, mask_offset) (BITMASK(mask_size) << (mask_offset))
-
-#define BITFIELD_GET(word, bit_offset, bit_size) \
-	(((word) >> (bit_offset)) & BITMASK(bit_size))
-#define BITFIELD_SET(word, bit_offset, bit_size, new_val)   do {    \
-	word = ((word) & ~BITMASK_AT(bit_size, bit_offset)) |	    \
-		(((new_val) & BITMASK(bit_size)) << (bit_offset));  \
-} while (0)
-
-#endif /*_CC_BITOPS_H_*/
diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index e750817..8dc9b6e 100644
--- a/drivers/staging/ccree/cc_hw_queue_defs.h
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -19,8 +19,8 @@
 
 #include <linux/types.h>
 
-#include "cc_regs.h"
 #include "dx_crys_kernel.h"
+#include <linux/bitfield.h>
 
 /******************************************************************************
 *				DEFINITIONS
diff --git a/drivers/staging/ccree/cc_lli_defs.h b/drivers/staging/ccree/cc_lli_defs.h
index 78811aa..851d390 100644
--- a/drivers/staging/ccree/cc_lli_defs.h
+++ b/drivers/staging/ccree/cc_lli_defs.h
@@ -19,8 +19,6 @@
 
 #include <linux/types.h>
 
-#include "cc_bitops.h"
-
 /* Max DLLI size
  *  AKA DX_DSCRPTR_QUEUE_WORD1_DIN_SIZE_BIT_SIZE
  */
diff --git a/drivers/staging/ccree/cc_regs.h b/drivers/staging/ccree/cc_regs.h
index 6abb6ff..53675e3 100644
--- a/drivers/staging/ccree/cc_regs.h
+++ b/drivers/staging/ccree/cc_regs.h
@@ -24,7 +24,12 @@
 #ifndef _CC_REGS_H_
 #define _CC_REGS_H_
 
-#include "cc_bitops.h"
+#include <linux/bitfield.h>
+
+#define AXIM_MON_BASE_OFFSET CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_COMP)
+#define AXIM_MON_COMP_VALUE GENMASK(DX_AXIM_MON_COMP_VALUE_BIT_SIZE + \
+		DX_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
+		DX_AXIM_MON_COMP_VALUE_BIT_SHIFT)
 
 #define AXIM_MON_BASE_OFFSET CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_COMP)
 #define AXIM_MON_COMP_VALUE GENMASK(DX_AXIM_MON_COMP_VALUE_BIT_SIZE + \
@@ -35,68 +40,4 @@
 #define CC_REG_OFFSET(unit_name, reg_name)               \
 	(DX_BASE_ ## unit_name + DX_ ## reg_name ## _REG_OFFSET)
 
-#define CC_REG_BIT_SHIFT(reg_name, field_name)               \
-	(DX_ ## reg_name ## _ ## field_name ## _BIT_SHIFT)
-
-/* Read-Modify-Write a field of a register */
-#define MODIFY_REGISTER_FLD(unitName, regName, fldName, fldVal)         \
-do {								            \
-	u32 regVal;						    \
-	regVal = READ_REGISTER(CC_REG_ADDR(unitName, regName));       \
-	CC_REG_FLD_SET(unitName, regName, fldName, regVal, fldVal); \
-	WRITE_REGISTER(CC_REG_ADDR(unitName, regName), regVal);       \
-} while (0)
-
-/*! Bit fields get */
-#define CC_REG_FLD_GET(unit_name, reg_name, fld_name, reg_val)	      \
-	(DX_ ## reg_name ## _ ## fld_name ## _BIT_SIZE == 0x20 ?	      \
-	reg_val /*!< \internal Optimization for 32b fields */ :			      \
-	BITFIELD_GET(reg_val, DX_ ## reg_name ## _ ## fld_name ## _BIT_SHIFT, \
-		     DX_ ## reg_name ## _ ## fld_name ## _BIT_SIZE))
-
-/*! Bit fields access */
-#define CC_REG_FLD_GET2(unit_name, reg_name, fld_name, reg_val)	      \
-	(CC_ ## reg_name ## _ ## fld_name ## _BIT_SIZE == 0x20 ?	      \
-	reg_val /*!< \internal Optimization for 32b fields */ :			      \
-	BITFIELD_GET(reg_val, CC_ ## reg_name ## _ ## fld_name ## _BIT_SHIFT, \
-		     CC_ ## reg_name ## _ ## fld_name ## _BIT_SIZE))
-
-/* yael TBD !!!
- * all HW includes should start with CC_ and not DX_ !!
- */
-
-
-/*! Bit fields set */
-#define CC_REG_FLD_SET(                                               \
-	unit_name, reg_name, fld_name, reg_shadow_var, new_fld_val)      \
-do {                                                                     \
-	if (DX_ ## reg_name ## _ ## fld_name ## _BIT_SIZE == 0x20)       \
-		reg_shadow_var = new_fld_val; /*!< \internal Optimization for 32b fields */\
-	else                                                             \
-		BITFIELD_SET(reg_shadow_var,                             \
-			DX_ ## reg_name ## _ ## fld_name ## _BIT_SHIFT,  \
-			DX_ ## reg_name ## _ ## fld_name ## _BIT_SIZE,   \
-			new_fld_val);                                    \
-} while (0)
-
-/*! Bit fields set */
-#define CC_REG_FLD_SET2(                                               \
-	unit_name, reg_name, fld_name, reg_shadow_var, new_fld_val)      \
-do {                                                                     \
-	if (CC_ ## reg_name ## _ ## fld_name ## _BIT_SIZE == 0x20)       \
-		reg_shadow_var = new_fld_val; /*!< \internal Optimization for 32b fields */\
-	else                                                             \
-		BITFIELD_SET(reg_shadow_var,                             \
-			CC_ ## reg_name ## _ ## fld_name ## _BIT_SHIFT,  \
-			CC_ ## reg_name ## _ ## fld_name ## _BIT_SIZE,   \
-			new_fld_val);                                    \
-} while (0)
-
-/* Usage example:
- * u32 reg_shadow = READ_REGISTER(CC_REG_ADDR(CRY_KERNEL,AES_CONTROL));
- * CC_REG_FLD_SET(CRY_KERNEL,AES_CONTROL,NK_KEY0,reg_shadow, 3);
- * CC_REG_FLD_SET(CRY_KERNEL,AES_CONTROL,NK_KEY1,reg_shadow, 1);
- * WRITE_REGISTER(CC_REG_ADDR(CRY_KERNEL,AES_CONTROL), reg_shadow);
- */
-
 #endif /*_CC_REGS_H_*/
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 658a7ed..4c6eef9 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -40,7 +40,6 @@
 /* Registers definitions from shared/hw/ree_include */
 #include "dx_reg_base_host.h"
 #include "dx_host.h"
-#define DX_CC_HOST_VIRT /* must be defined before including dx_cc_regs.h */
 #include "cc_regs.h"
 #include "dx_reg_common.h"
 #include "cc_hal.h"
-- 
2.1.4
