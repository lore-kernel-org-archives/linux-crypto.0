From: Leonidas S Barbosa <leosilva@linux.vnet.ibm.com>
Subject: [PATCH] Fixing opcode issue on vmx-crypto
Date: Fri, 21 Aug 2015 17:27:43 -0300
Message-ID: <20150821202740.GA25407@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: LKML <linux-kernel@vger.kernel.org>,
	Paulo Smorigo <pfsmorigo@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-next@vger.kernel.org,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


In build time vadduqm opcode  is not being mapped
correctly.

Adding a new map in ppc-xlate to do this.

Signed-off-by: Leonidas S Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/ppc-xlate.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/vmx/ppc-xlate.pl b/drivers/crypto/vmx/ppc-xlate.pl
index a591884..b999733 100644
--- a/drivers/crypto/vmx/ppc-xlate.pl
+++ b/drivers/crypto/vmx/ppc-xlate.pl
@@ -169,6 +169,7 @@ my $vpmsumd	= sub { vcrypto_op(@_, 1224); };
 my $vpmsubh	= sub { vcrypto_op(@_, 1096); };
 my $vpmsumw	= sub { vcrypto_op(@_, 1160); };
 my $vaddudm	= sub { vcrypto_op(@_, 192);  };
+my $vadduqm	= sub { vcrypto_op(@_, 256);  };

 my $mtsle	= sub {
     my ($f, $arg) = @_;
--
2.1.0
