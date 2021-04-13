Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0653C433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 08:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87EFD613A9
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 08:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhDMIYy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 04:24:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229446AbhDMIYx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 04:24:53 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13D83Mjr063515;
        Tue, 13 Apr 2021 04:24:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=xAabvqf+7v65N95vm6otfwdaGYBW7MTh6Z+fcF2lOwU=;
 b=BVJYS8QU4MVM7/SX5YU5Z0J0bV2QbwIwa/vcF923w7NIx31UuY/0maQ4YgaZTEzD1cFc
 4iCtGhbWD0bc3HizE+5pf1mG9EC3LMbNU0IVpow7HKKDrr7E/YgFNzdnzeskDfSOwgWd
 5cJK0H9xZ7OUmymAv4OaiJr9u6QlyBF5Q+9oEowxZutzNOdCRtpyqM38AfBz55yeGGRI
 Rvj7MzTKzw1qtui75E6yDBKzSdSfyz1FnhwEhrR58kbsFFelDr8NjJk2WV1BkdqZUe8K
 oWe89R6EOR6p637tCWoCLAyfCHyyQwRNgJHsaJyaCThHZTNymbNxCmGIMShoJ/wIQfRs YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37vtvy84se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 04:24:23 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13D84mpZ068829;
        Tue, 13 Apr 2021 04:24:23 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37vtvy84ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 04:24:23 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13D8MFOx028362;
        Tue, 13 Apr 2021 08:24:22 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 37u3n9q301-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 08:24:22 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13D8OLRY21561820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 08:24:22 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9575136051;
        Tue, 13 Apr 2021 08:24:21 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EC4413604F;
        Tue, 13 Apr 2021 08:24:20 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.232.48])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 13 Apr 2021 08:24:20 +0000 (GMT)
Message-ID: <6d38f5eeb1661f613bc020c4e71b3ea33e87afa1.camel@linux.ibm.com>
Subject: [V2 PATCH 07/16] powerpc/vas: Define QoS credit flag to allocate
 window
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com
Date:   Tue, 13 Apr 2021 01:24:18 -0700
In-Reply-To: <68aa9f2860f9acffa41469d3858883c938634722.camel@linux.ibm.com>
References: <68aa9f2860f9acffa41469d3858883c938634722.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DQ0iIL8ez2RDtJ7WA6rB16noJqk-RoSf
X-Proofpoint-GUID: BQxwn9ahUtXEm5gjLD20a33l4OebmkkW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_03:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 impostorscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104130055
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


pHyp introduces two different type of credits: Default and Quality
of service (QoS).

The total number of default credits available on each LPAR depends
on CPU resources configured. But these credits can be shared or
over-committed across LPARs in shared mode which can result in
paste command failure (RMA_busy). To avoid NX HW contention, phyp
introduces QoS credit type which makes sure guaranteed access to NX
resources. The system admins can assign QoS credits for each LPAR
via HMC.

Default credit type is used to allocate a VAS window by default as
on powerVM implementation. But the process can pass VAS_WIN_QOS_CREDITS
flag with VAS_TX_WIN_OPEN ioctl to open VAS QoS type window.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
---
 arch/powerpc/include/uapi/asm/vas-api.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/uapi/asm/vas-api.h b/arch/powerpc/include/uapi/asm/vas-api.h
index ebd4b2424785..eb7c8694174f 100644
--- a/arch/powerpc/include/uapi/asm/vas-api.h
+++ b/arch/powerpc/include/uapi/asm/vas-api.h
@@ -13,11 +13,15 @@
 #define VAS_MAGIC	'v'
 #define VAS_TX_WIN_OPEN	_IOW(VAS_MAGIC, 0x20, struct vas_tx_win_open_attr)
 
+/* Flags to VAS TX open window ioctl */
+/* To allocate a window with QoS credit, otherwise default credit is used */
+#define	VAS_WIN_QOS_CREDITS	0x0000000000000001
+
 struct vas_tx_win_open_attr {
 	__u32	version;
 	__s16	vas_id;	/* specific instance of vas or -1 for default */
 	__u16	reserved1;
-	__u64	flags;	/* Future use */
+	__u64	flags;
 	__u64	reserved2[6];
 };
 
-- 
2.18.2


