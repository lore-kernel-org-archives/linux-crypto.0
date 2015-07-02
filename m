From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: [PATCH 5/6] [RFC] crypto/testmgr: add null test for 842 algorithm
Date: Thu, 2 Jul 2015 15:41:19 -0700
Message-ID: <20150702224119.GF1712@linux.vnet.ibm.com>
References: <20150702223800.GA1712@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	gustavold@linux.vnet.ibm.com
To: Dan Streetman <ddstreet@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:58313 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbbGBWlY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 18:41:24 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <nacc@linux.vnet.ibm.com>;
	Thu, 2 Jul 2015 16:41:33 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 9A7221FF002E
	for <linux-crypto@vger.kernel.org>; Thu,  2 Jul 2015 16:32:31 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t62MfLkK42991750
	for <linux-crypto@vger.kernel.org>; Thu, 2 Jul 2015 15:41:21 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t62MfKmn016804
	for <linux-crypto@vger.kernel.org>; Thu, 2 Jul 2015 16:41:20 -0600
Content-Disposition: inline
In-Reply-To: <20150702223800.GA1712@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently, when the nx-842-pseries driver loads, the following message
is emitted:

alg: No test for 842 (842-nx)

It seems like the simplest way to fix this message (other than adding a
proper test) is to just insert the null test into the list in the
testmgr.

Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>

---
 crypto/testmgr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d0a42bd3aae9..ff0f76e0d0b4 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1982,6 +1982,9 @@ static int alg_test_null(const struct alg_test_desc *desc,
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
 	{
+		.alg = "842",
+		.test = alg_test_null,
+	}, {
 		.alg = "__cbc-cast5-avx",
 		.test = alg_test_null,
 	}, {
-- 
2.1.4
