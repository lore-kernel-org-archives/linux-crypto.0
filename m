From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: [PATCH 3/6] nx-842-pseries: do not emit extra output if status is
 disabled
Date: Thu, 2 Jul 2015 15:40:09 -0700
Message-ID: <20150702224009.GD1712@linux.vnet.ibm.com>
References: <20150702223800.GA1712@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	gustavold@linux.vnet.ibm.com
To: Dan Streetman <ddstreet@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:44963 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbbGBWkP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 18:40:15 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <nacc@linux.vnet.ibm.com>;
	Thu, 2 Jul 2015 16:40:15 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 48E3619D8047
	for <linux-crypto@vger.kernel.org>; Thu,  2 Jul 2015 16:31:12 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t62MdUN939452778
	for <linux-crypto@vger.kernel.org>; Thu, 2 Jul 2015 15:39:30 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t62MeAEK030177
	for <linux-crypto@vger.kernel.org>; Thu, 2 Jul 2015 16:40:11 -0600
Content-Disposition: inline
In-Reply-To: <20150702223800.GA1712@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the device-tree indicates the nx-842 device's status is 'disabled',
we emit two messages:

nx_compress_pseries ibm,compression-v1: nx842_OF_upd_status: status 'disabled' is not 'okay'.
nx_compress_pseries ibm,compression-v1: nx842_OF_upd: device disabled

Given that 'disabled' is a valid state, and we are going to emit that
the device is disabled, only print out a non-'okay' status if it is not
'disabled'.

Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>

---
 drivers/crypto/nx/nx-842-pseries.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index e17f4d2e96e0..b84b0ceeb46e 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -566,8 +566,14 @@ static int nx842_OF_upd_status(struct nx842_devdata *devdata,
 	if (!strncmp(status, "okay", (size_t)prop->length)) {
 		devdata->status = AVAILABLE;
 	} else {
-		dev_info(devdata->dev, "%s: status '%s' is not 'okay'\n",
+		/*
+		 * Caller will log that the device is disabled, so only
+		 * output if there is an unexpected status.
+		 */
+		if (strncmp(status, "disabled", (size_t)prop->length)) {
+			dev_info(devdata->dev, "%s: status '%s' is not 'okay'\n",
 				__func__, status);
+		}
 		devdata->status = UNAVAILABLE;
 		ret = -ENODEV;
 	}
-- 
2.1.4
