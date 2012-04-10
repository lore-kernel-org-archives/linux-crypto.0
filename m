From: Kent Yoder <key@linux.vnet.ibm.com>
Subject: [PATCH v2 01/17] powerpc: Add new hvcall constants to support PFO
Date: Tue, 10 Apr 2012 10:08:09 -0500
Message-ID: <1334070489.16827.3.camel@key-ThinkPad-W510>
References: <1334070249.16827.1.camel@key-ThinkPad-W510>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, rcj@linux.vnet.ibm.com,
	key@linux.vnet.ibm.com, benh@kernel.crashing.org,
	linuxppc-dev@lists.ozlabs.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:37575 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab2DJPj3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Apr 2012 11:39:29 -0400
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <key@linux.vnet.ibm.com>;
	Tue, 10 Apr 2012 09:39:28 -0600
In-Reply-To: <1334070249.16827.1.camel@key-ThinkPad-W510>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Platform Facilities Option (PFO) adds several new h_calls and
more return codes.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/hvcall.h |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index 1c324ff..6122523 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -77,8 +77,27 @@
 #define H_MR_CONDITION  -43
 #define H_NOT_ENOUGH_RESOURCES -44
 #define H_R_STATE       -45
-#define H_RESCINDEND    -46
-#define H_MULTI_THREADS_ACTIVE -9005
+#define H_RESCINDED     -46
+#define H_P2		-55
+#define H_P3		-56
+#define H_P4		-57
+#define H_P5		-58
+#define H_P6		-59
+#define H_P7		-60
+#define H_P8		-61
+#define H_P9		-62
+#define H_TOO_BIG	-64
+#define H_OVERLAP	-68
+#define H_INTERRUPT	-69
+#define H_BAD_DATA	-70
+#define H_NOT_ACTIVE	-71
+#define H_SG_LIST	-72
+#define H_OP_MODE	-73
+#define H_COP_HW	-74
+#define H_UNSUPPORTED_FLAG_START	-256
+#define H_UNSUPPORTED_FLAG_END		-511
+#define H_MULTI_THREADS_ACTIVE	-9005
+#define H_OUTSTANDING_COP_OPS	-9006
 

 /* Long Busy is a condition that can be returned by the firmware
@@ -240,6 +259,8 @@
 #define H_GET_MPP		0x2D4
 #define H_HOME_NODE_ASSOCIATIVITY 0x2EC
 #define H_BEST_ENERGY		0x2F4
+#define H_RANDOM		0x300
+#define H_COP			0x304
 #define H_GET_MPP_X		0x314
 #define MAX_HCALL_OPCODE	H_GET_MPP_X
 
-- 
1.7.1
