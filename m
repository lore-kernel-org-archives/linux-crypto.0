From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 01/10] powerpc: export of_get_ibm_chip_id function
Date: Wed,  6 May 2015 12:50:57 -0400
Message-ID: <1430931066-4536-2-git-send-email-ddstreet@ieee.org>
References: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
 <1430931066-4536-1-git-send-email-ddstreet@ieee.org>
Cc: Dan Streetman <ddstreet@ieee.org>,
	Seth Jennings <sjennings@variantweb.net>,
	Robert Jennings <rob@pochix.net>,
	Rob Herring <robh@kernel.org>,
	Anton Blanchard <anton@samba.org>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430931066-4536-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Export the of_get_ibm_chip_id() function.  This will be used by the
PowerNV NX-842 driver.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 arch/powerpc/kernel/prom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 308c5e1..ea2cea7 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -800,6 +800,7 @@ int of_get_ibm_chip_id(struct device_node *np)
 	}
 	return -1;
 }
+EXPORT_SYMBOL(of_get_ibm_chip_id);
 
 /**
  * cpu_to_chip_id - Return the cpus chip-id
-- 
2.1.0
