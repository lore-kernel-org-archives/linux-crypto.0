From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - print ring name in debug output
Date: Fri, 03 Apr 2015 08:40:58 -0700
Message-ID: <20150403154058.1144.75189.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16373 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbbDCPns (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Apr 2015 11:43:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ring name was allocated but never refenenced.
It was supposed to be printed out in debug output.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 .../crypto/qat/qat_common/adf_transport_debug.c    |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_transport_debug.c b/drivers/crypto/qat/qat_common/adf_transport_debug.c
index 6b69745..e419869 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/qat/qat_common/adf_transport_debug.c
@@ -100,6 +100,8 @@ static int adf_ring_show(struct seq_file *sfile, void *v)
 		empty = READ_CSR_E_STAT(csr, bank->bank_number);
 
 		seq_puts(sfile, "------- Ring configuration -------\n");
+		seq_printf(sfile, "ring name: %s\n",
+			   ring->ring_debug->ring_name);
 		seq_printf(sfile, "ring num %d, bank num %d\n",
 			   ring->ring_number, ring->bank->bank_number);
 		seq_printf(sfile, "head %x, tail %x, empty: %d\n",
