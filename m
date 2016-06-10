From: Anton Blanchard <anton@ozlabs.org>
Subject: [PATCH 1/2] crypto: vmx: Fix ABI detection
Date: Fri, 10 Jun 2016 16:47:02 +1000
Message-ID: <1465541223-17537-1-git-send-email-anton@ozlabs.org>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: pfsmorigo@linux.vnet.ibm.com, benh@kernel.crashing.org,
	paulus@samba.org, mpe@ellerman.id.au, herbert@gondor.apana.org.au,
	davem@davemloft.net, strosake@austin.ibm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:60945 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbcFJGrJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jun 2016 02:47:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Anton Blanchard <anton@samba.org>

When calling ppc-xlate.pl, we pass it either linux-ppc64 or
linux-ppc64le. The script however was expecting linux64le, a result
of its OpenSSL origins. This means we aren't obeying the ppc64le
ABIv2 rules.

Fix this by checking for linux-ppc64le.

Fixes: 5ca55738201c ("crypto: vmx - comply with ABIs that specify vrsave as reserved.")
Cc: stable@vger.kernel.org
Signed-off-by: Anton Blanchard <anton@samba.org>
---
 drivers/crypto/vmx/ppc-xlate.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/vmx/ppc-xlate.pl b/drivers/crypto/vmx/ppc-xlate.pl
index 9f4994c..b18e67d 100644
--- a/drivers/crypto/vmx/ppc-xlate.pl
+++ b/drivers/crypto/vmx/ppc-xlate.pl
@@ -141,7 +141,7 @@ my $vmr = sub {
 
 # Some ABIs specify vrsave, special-purpose register #256, as reserved
 # for system use.
-my $no_vrsave = ($flavour =~ /aix|linux64le/);
+my $no_vrsave = ($flavour =~ /linux-ppc64le/);
 my $mtspr = sub {
     my ($f,$idx,$ra) = @_;
     if ($idx == 256 && $no_vrsave) {
-- 
2.7.4
