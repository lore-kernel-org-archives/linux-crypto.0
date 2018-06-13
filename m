From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH V3 1/2] powerpc/powernv: Export opal_check_token symbol
Date: Wed, 13 Jun 2018 00:28:57 -0700
Message-ID: <1528874937.14408.2.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@lists.ozlabs.org, herbert@gondor.apana.org.au,
 stewart@linux.ibm.com, linux-crypto@vger.kernel.org
To: mpe@ellerman.id.au
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org


Export opal_check_token symbol for modules to check the availability
of OPAL calls before using them.

Signed-off-by: Haren Myneni <haren@us.ibm.com>

diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index 48fbb41..838b79b 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -923,6 +923,7 @@ void opal_shutdown(void)
 EXPORT_SYMBOL_GPL(opal_flash_write);
 EXPORT_SYMBOL_GPL(opal_flash_erase);
 EXPORT_SYMBOL_GPL(opal_prd_msg);
+EXPORT_SYMBOL_GPL(opal_check_token);
 
 /* Convert a region of vmalloc memory to an opal sg list */
 struct opal_sg_list *opal_vmalloc_to_sg_list(void *vmalloc_addr,
