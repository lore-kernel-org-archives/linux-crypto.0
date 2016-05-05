From: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Subject: [PATCH] crypto: vmx - comply with ABIs that specify vrsave as reserved.
Date: Thu,  5 May 2016 11:09:27 -0300
Message-ID: <1462457367-15445-1-git-send-email-pfsmorigo@linux.vnet.ibm.com>
References: <20160503081345.GA17118@gondor.apana.org.au>
Cc: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org (open list:IBM Power VMX Cryptographic
	instructions)
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:60966 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbcEEOJm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 10:09:42 -0400
Received: from localhost
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <pfsmorigo@linux.vnet.ibm.com>;
	Thu, 5 May 2016 11:09:40 -0300
In-Reply-To: <20160503081345.GA17118@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It gives significant improvements ( ~+15%) on some modes.

These code has been adopted from OpenSSL project in collaboration
with the original author (Andy Polyakov <appro@openssl.org>).

Signed-off-by: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
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
2.5.5
