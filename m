Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6787CC3F2CD
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 04:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43694206C3
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 04:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgCWEG0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 00:06:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20598 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725208AbgCWEG0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 00:06:26 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02N43rkl000505;
        Mon, 23 Mar 2020 00:06:09 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ywf2emycr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 00:06:09 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02N44f9B003164;
        Mon, 23 Mar 2020 00:06:09 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ywf2emyc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 00:06:09 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02N41qmj022200;
        Mon, 23 Mar 2020 04:06:08 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 2ywaw913dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 04:06:08 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02N467M719268064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 04:06:07 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB00F124053;
        Mon, 23 Mar 2020 04:06:07 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05AF7124055;
        Mon, 23 Mar 2020 04:06:07 +0000 (GMT)
Received: from [9.70.82.143] (unknown [9.70.82.143])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Mar 2020 04:06:06 +0000 (GMT)
Subject: [PATCH v4 7/9] crypto/nx: Enable and setup GZIP compression type
From:   Haren Myneni <haren@linux.ibm.com>
To:     herbert@gondor.apana.org.au
Cc:     mpe@ellerman.id.au, dja@axtens.net, mikey@neuling.org,
        sukadev@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, npiggin@gmail.com
In-Reply-To: <1584934879.9256.15321.camel@hbabu-laptop>
References: <1584934879.9256.15321.camel@hbabu-laptop>
Content-Type: text/plain; charset="UTF-8"
Date:   Sun, 22 Mar 2020 21:05:37 -0700
Message-ID: <1584936337.9256.15329.camel@hbabu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-22_08:2020-03-21,2020-03-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 suspectscore=1 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003230021
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Changes to probe GZIP device-tree nodes, open RX windows and setup
GZIP compression type. No plans to provide GZIP usage in kernel right
now, but this patch enables GZIP for user space usage.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
---
 drivers/crypto/nx/nx-common-powernv.c | 43 ++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
index 82dfa60..f570691 100644
--- a/drivers/crypto/nx/nx-common-powernv.c
+++ b/drivers/crypto/nx/nx-common-powernv.c
@@ -65,6 +65,7 @@ struct nx_coproc {
  * Using same values as in skiboot or coprocessor type representing
  * in NX workbook.
  */
+#define NX_CT_GZIP	(2)	/* on P9 and later */
 #define NX_CT_842	(3)
 
 static int (*nx842_powernv_exec)(const unsigned char *in,
@@ -819,6 +820,9 @@ static int __init vas_cfg_coproc_info(struct device_node *dn, int chip_id,
 	if (type == NX_CT_842)
 		ret = nx_set_ct(coproc, priority, VAS_COP_TYPE_842_HIPRI,
 			VAS_COP_TYPE_842);
+	else if (type == NX_CT_GZIP)
+		ret = nx_set_ct(coproc, priority, VAS_COP_TYPE_GZIP_HIPRI,
+				VAS_COP_TYPE_GZIP);
 
 	if (ret)
 		goto err_out;
@@ -867,12 +871,16 @@ static int __init vas_cfg_coproc_info(struct device_node *dn, int chip_id,
 	return ret;
 }
 
-static int __init nx_coproc_init(int chip_id, int ct_842)
+static int __init nx_coproc_init(int chip_id, int ct_842, int ct_gzip)
 {
 	int ret = 0;
 
 	if (opal_check_token(OPAL_NX_COPROC_INIT)) {
 		ret = opal_nx_coproc_init(chip_id, ct_842);
+
+		if (!ret)
+			ret = opal_nx_coproc_init(chip_id, ct_gzip);
+
 		if (ret) {
 			ret = opal_error_code(ret);
 			pr_err("Failed to initialize NX for chip(%d): %d\n",
@@ -902,8 +910,8 @@ static int __init find_nx_device_tree(struct device_node *dn, int chip_id,
 static int __init nx_powernv_probe_vas(struct device_node *pn)
 {
 	int chip_id, vasid, ret = 0;
+	int ct_842 = 0, ct_gzip = 0;
 	struct device_node *dn;
-	int ct_842 = 0;
 
 	chip_id = of_get_ibm_chip_id(pn);
 	if (chip_id < 0) {
@@ -920,19 +928,24 @@ static int __init nx_powernv_probe_vas(struct device_node *pn)
 	for_each_child_of_node(pn, dn) {
 		ret = find_nx_device_tree(dn, chip_id, vasid, NX_CT_842,
 					"ibm,p9-nx-842", &ct_842);
+
+		if (!ret)
+			ret = find_nx_device_tree(dn, chip_id, vasid,
+				NX_CT_GZIP, "ibm,p9-nx-gzip", &ct_gzip);
+
 		if (ret)
 			return ret;
 	}
 
-	if (!ct_842) {
-		pr_err("NX842 FIFO nodes are missing\n");
+	if (!ct_842 || !ct_gzip) {
+		pr_err("NX FIFO nodes are missing\n");
 		return -EINVAL;
 	}
 
 	/*
 	 * Initialize NX instance for both high and normal priority FIFOs.
 	 */
-	ret = nx_coproc_init(chip_id, ct_842);
+	ret = nx_coproc_init(chip_id, ct_842, ct_gzip);
 
 	return ret;
 }
@@ -1072,10 +1085,19 @@ static __init int nx_compress_powernv_init(void)
 		nx842_powernv_exec = nx842_exec_icswx;
 	} else {
 		/*
+		 * Register VAS user space API for NX GZIP so
+		 * that user space can use GZIP engine.
+		 * 842 compression is supported only in kernel.
+		 */
+		ret = vas_register_coproc_api(THIS_MODULE);
+
+		/*
 		 * GZIP is not supported in kernel right now.
 		 * So open tx windows only for 842.
 		 */
-		ret = nx_open_percpu_txwins();
+		if (!ret)
+			ret = nx_open_percpu_txwins();
+
 		if (ret) {
 			nx_delete_coprocs();
 			return ret;
@@ -1096,6 +1118,15 @@ static __init int nx_compress_powernv_init(void)
 
 static void __exit nx_compress_powernv_exit(void)
 {
+	/*
+	 * GZIP engine is supported only in power9 or later and nx842_ct
+	 * is used on power8 (icswx).
+	 * VAS API for NX GZIP is registered during init for user space
+	 * use. So delete this API use for GZIP engine.
+	 */
+	if (!nx842_ct)
+		vas_unregister_coproc_api();
+
 	crypto_unregister_alg(&nx842_powernv_alg);
 
 	nx_delete_coprocs();
-- 
1.8.3.1



