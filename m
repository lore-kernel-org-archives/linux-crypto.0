From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: [PATCH 1/6] crypto/nx-842-pseries: nx842_OF_upd_status should return
 ENODEV if device is not 'okay'
Date: Thu, 2 Jul 2015 15:38:48 -0700
Message-ID: <20150702223848.GB1712@linux.vnet.ibm.com>
References: <20150702223800.GA1712@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	gustavold@linux.vnet.ibm.com
To: Dan Streetman <ddstreet@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:46088 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbbGBWix (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 18:38:53 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <nacc@linux.vnet.ibm.com>;
	Thu, 2 Jul 2015 18:38:55 -0400
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 0E891C90046
	for <linux-crypto@vger.kernel.org>; Thu,  2 Jul 2015 18:29:58 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t62McoJS51445774
	for <linux-crypto@vger.kernel.org>; Thu, 2 Jul 2015 22:38:50 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t62McoFl010643
	for <linux-crypto@vger.kernel.org>; Thu, 2 Jul 2015 18:38:50 -0400
Content-Disposition: inline
In-Reply-To: <20150702223800.GA1712@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The current documention mentions explicitly that EINVAL should be
returned if the device is not available, but nx842_OF_upd_status()
always returns 0. However, nx842_probe() specifically checks for
non-ENODEV returns from nx842_of_upd() (which in turn calls
nx842_OF_upd_status()) and emits an extra error in that case. It seems
like the proper return code of a disabled device is ENODEV.

Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>

---
 drivers/crypto/nx/nx-842-pseries.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 3040a6091bf2..819c23c546e3 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -556,7 +556,7 @@ static int nx842_OF_set_defaults(struct nx842_devdata *devdata)
  *
  * Returns:
  *  0 - Device is available
- *  -EINVAL - Device is not available
+ *  -ENODEV - Device is not available
  */
 static int nx842_OF_upd_status(struct nx842_devdata *devdata,
 					struct property *prop) {
@@ -569,6 +569,7 @@ static int nx842_OF_upd_status(struct nx842_devdata *devdata,
 		dev_info(devdata->dev, "%s: status '%s' is not 'okay'\n",
 				__func__, status);
 		devdata->status = UNAVAILABLE;
+		ret = -ENODEV;
 	}
 
 	return ret;
-- 
2.1.4
