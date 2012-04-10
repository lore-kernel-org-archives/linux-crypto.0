From: Kent Yoder <key@linux.vnet.ibm.com>
Subject: [PATCH v2 17/17] powerpc: crypto: enable the PFO-based encryption
 device
Date: Tue, 10 Apr 2012 10:11:39 -0500
Message-ID: <1334070699.16827.35.camel@key-ThinkPad-W510>
References: <1334070249.16827.1.camel@key-ThinkPad-W510>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: key@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
 linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1334070249.16827.1.camel@key-ThinkPad-W510>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
List-Id: linux-crypto.vger.kernel.org

This patch adds the cas bits to advertise support for the Platform
Facilities Option (PFO) based encryption accelerator device. The nx
device driver provides support for this hardware feature.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/prom_init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 26f6317..604b4c4 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -702,6 +702,7 @@ static void __init early_cmdline_parse(void)
 #endif
 #define OV5_TYPE1_AFFINITY	0x80	/* Type 1 NUMA affinity */
 #define OV5_PFO_HW_RNG		0x80	/* PFO Random Number Generator */
+#define OV5_PFO_HW_ENCR		0x20	/* PFO Encryption Accelerator */
 
 /* Option Vector 6: IBM PAPR hints */
 #define OV6_LINUX		0x02	/* Linux is our OS */
@@ -769,7 +770,7 @@ static unsigned char ibm_architecture_vec[] = {
 	0,
 	0,
 	0,
-	OV5_PFO_HW_RNG,
+	OV5_PFO_HW_RNG | OV5_PFO_HW_ENCR,
 
 	/* option vector 6: IBM PAPR hints */
 	4 - 2,				/* length */
-- 
1.7.1
