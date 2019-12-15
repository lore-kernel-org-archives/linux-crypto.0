Return-Path: <SRS0=cN8K=2F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D9EC43603
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Dec 2019 13:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6065F20726
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Dec 2019 13:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfLONCv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Dec 2019 08:02:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2848 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbfLONCv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Dec 2019 08:02:51 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBFCuisT146764;
        Sun, 15 Dec 2019 08:02:28 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wvue5v1mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 08:02:27 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xBFCujPx146817;
        Sun, 15 Dec 2019 08:02:27 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wvue5v1me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 08:02:27 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBFD24vp013160;
        Sun, 15 Dec 2019 13:02:26 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02wdc.us.ibm.com with ESMTP id 2wvqc5ucvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 13:02:26 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBFD2PqG22413572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Dec 2019 13:02:25 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EE047805C;
        Sun, 15 Dec 2019 13:02:25 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB45A7805E;
        Sun, 15 Dec 2019 13:02:24 +0000 (GMT)
Received: from [9.70.82.143] (unknown [9.70.82.143])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 15 Dec 2019 13:02:24 +0000 (GMT)
Subject: [PATCH 02/10] powerpc/vas: Initialize window attributes for GZIP
 compression
From:   Haren Myneni <haren@linux.ibm.com>
To:     herbert@gondor.apana.org.au
Cc:     mpe@ellerman.id.au, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, hch@infradead.org,
        npiggin@gmail.com, mikey@neuling.org, sukadev@linux.vnet.ibm.com
In-Reply-To: <1576414240.16318.4066.camel@hbabu-laptop>
References: <1576414240.16318.4066.camel@hbabu-laptop>
Content-Type: text/plain; charset="UTF-8"
Date:   Sun, 15 Dec 2019 05:00:35 -0800
Message-ID: <1576414835.16318.4078.camel@hbabu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-15_03:2019-12-13,2019-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 phishscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912150124
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Initialize send and receive window attributes for GZIP high and
normal priority types.

Signed-off-by: Haren Myneni <haren@us.ibm.com>
---
 arch/powerpc/platforms/powernv/vas-window.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/vas-window.c b/arch/powerpc/platforms/powernv/vas-window.c
index b51eac5..cc0f530 100644
--- a/arch/powerpc/platforms/powernv/vas-window.c
+++ b/arch/powerpc/platforms/powernv/vas-window.c
@@ -827,7 +827,8 @@ void vas_init_rx_win_attr(struct vas_rx_win_attr *rxattr, enum vas_cop_type cop)
 {
 	memset(rxattr, 0, sizeof(*rxattr));
 
-	if (cop == VAS_COP_TYPE_842 || cop == VAS_COP_TYPE_842_HIPRI) {
+	if (cop == VAS_COP_TYPE_842 || cop == VAS_COP_TYPE_842_HIPRI ||
+		cop == VAS_COP_TYPE_GZIP || cop == VAS_COP_TYPE_GZIP_HIPRI) {
 		rxattr->pin_win = true;
 		rxattr->nx_win = true;
 		rxattr->fault_win = false;
@@ -903,7 +904,8 @@ void vas_init_tx_win_attr(struct vas_tx_win_attr *txattr, enum vas_cop_type cop)
 {
 	memset(txattr, 0, sizeof(*txattr));
 
-	if (cop == VAS_COP_TYPE_842 || cop == VAS_COP_TYPE_842_HIPRI) {
+	if (cop == VAS_COP_TYPE_842 || cop == VAS_COP_TYPE_842_HIPRI ||
+		cop == VAS_COP_TYPE_GZIP || cop == VAS_COP_TYPE_GZIP_HIPRI) {
 		txattr->rej_no_credit = false;
 		txattr->rx_wcred_mode = true;
 		txattr->tx_wcred_mode = true;
@@ -987,9 +989,14 @@ static bool tx_win_args_valid(enum vas_cop_type cop,
 	if (attr->wcreds_max > VAS_TX_WCREDS_MAX)
 		return false;
 
-	if (attr->user_win &&
-			(cop != VAS_COP_TYPE_FTW || attr->rsvd_txbuf_count))
-		return false;
+	if (attr->user_win) {
+		if (attr->rsvd_txbuf_count)
+			return false;
+
+		if (cop != VAS_COP_TYPE_FTW && cop != VAS_COP_TYPE_GZIP &&
+			cop != VAS_COP_TYPE_GZIP_HIPRI)
+			return false;
+	}
 
 	return true;
 }
-- 
1.8.3.1



