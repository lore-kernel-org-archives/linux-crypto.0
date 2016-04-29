From: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Subject: [PATCH] crypto: vmx - comply with ABIs that specify vrsave as reserved.
Date: Fri, 29 Apr 2016 11:03:05 -0300
Message-ID: <1461938585-7933-1-git-send-email-pfsmorigo@linux.vnet.ibm.com>
Cc: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org (open list:IBM Power VMX Cryptographic
	instructions)
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:57868 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbcD2OMT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 10:12:19 -0400
Received: from localhost
	by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <pfsmorigo@linux.vnet.ibm.com>;
	Fri, 29 Apr 2016 11:12:16 -0300
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It gives significant improvements ( ~+15%) on some modes.

These code has been adopted from OpenSSL project in collaboration
with the original author (Andy Polyakov <appro@openssl.org>).
---
 drivers/crypto/vmx/ppc-xlate.pl | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/crypto/vmx/ppc-xlate.pl b/drivers/crypto/vmx/ppc-xlate.pl
index b999733..9f4994c 100644
--- a/drivers/crypto/vmx/ppc-xlate.pl
+++ b/drivers/crypto/vmx/ppc-xlate.pl
@@ -139,6 +139,26 @@ my $vmr = sub {
     "	vor	$vx,$vy,$vy";
 };
 
+# Some ABIs specify vrsave, special-purpose register #256, as reserved
+# for system use.
+my $no_vrsave = ($flavour =~ /aix|linux64le/);
+my $mtspr = sub {
+    my ($f,$idx,$ra) = @_;
+    if ($idx == 256 && $no_vrsave) {
+	"	or	$ra,$ra,$ra";
+    } else {
+	"	mtspr	$idx,$ra";
+    }
+};
+my $mfspr = sub {
+    my ($f,$rd,$idx) = @_;
+    if ($idx == 256 && $no_vrsave) {
+	"	li	$rd,-1";
+    } else {
+	"	mfspr	$rd,$idx";
+    }
+};
+
 # PowerISA 2.06 stuff
 sub vsxmem_op {
     my ($f, $vrt, $ra, $rb, $op) = @_;
-- 
2.5.0
