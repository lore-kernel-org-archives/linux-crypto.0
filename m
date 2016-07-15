From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] crypto: nx - off by one bug in nx_of_update_msc()
Date: Fri, 15 Jul 2016 14:09:13 +0300
Message-ID: <20160715110912.GE9258@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kernel-janitors@vger.kernel.org
To: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Kent Yoder <key@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38836 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517AbcGOLKI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jul 2016 07:10:08 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The props->ap[] array is defined like this:

	struct alg_props ap[NX_MAX_FC][NX_MAX_MODE][3];

So we can see that if msc->fc and msc->mode are == to NX_MAX_FC or
NX_MAX_MODE then we're off by one.

Fixes: ae0222b7289d ('powerpc/crypto: nx driver code supporting nx encryption')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 0794f1c..42f0f22 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -392,7 +392,7 @@ static void nx_of_update_msc(struct device   *dev,
 		     ((bytes_so_far + sizeof(struct msc_triplet)) <= lenp) &&
 		     i < msc->triplets;
 		     i++) {
-			if (msc->fc > NX_MAX_FC || msc->mode > NX_MAX_MODE) {
+			if (msc->fc >= NX_MAX_FC || msc->mode >= NX_MAX_MODE) {
 				dev_err(dev, "unknown function code/mode "
 					"combo: %d/%d (ignored)\n", msc->fc,
 					msc->mode);
