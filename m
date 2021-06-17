Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A203EC2B9F4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 20:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C33E61042
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 20:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhFQUhC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 16:37:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34946 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231289AbhFQUhC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 16:37:02 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HKXgd9139325;
        Thu, 17 Jun 2021 16:34:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=wgMjmfC6qWMTt5P25xmmEgHenfvXjSNLe3pLV5/K0DM=;
 b=lEPg0FKELaDwZSqIIN1SysIHASZUnx2S1cF2qqBwJygzAt6qMOSQg+7kdDZVTENdmLAG
 GCo9Sdx1UpelolNUCRNnEsOHD5ZOIQoaxXU2M/Os+zwgKReR6QU1+CS+w/wUQwLMZ1r3
 jMr8Xt70P9AJXd3v9KsVCyntjINplCEct1MQruYSs3ynA5HyK2FVoQWsZ1VCHwO92y3e
 asx14TmztMVfKJ+WUBXIkXoHzRUAp7MeB2M7HmmtU+edHBnAq81+o2VEo5+3mDMFA4gX
 c7CTbb7GW+p18y2DK+I5TBREhc6kxDrN327L5hMcOhbg3oHsiIJ58AZ1N558bvvv3bIc wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 398bpeu9yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 16:34:48 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15HKY4be140389;
        Thu, 17 Jun 2021 16:34:48 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 398bpeu9y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 16:34:48 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15HKIIXm020726;
        Thu, 17 Jun 2021 20:34:47 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 394mjaepvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 20:34:47 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15HKYkJZ32375186
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Jun 2021 20:34:46 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B7E1112064;
        Thu, 17 Jun 2021 20:34:46 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F683112062;
        Thu, 17 Jun 2021 20:34:45 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.160.180.39])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 17 Jun 2021 20:34:45 +0000 (GMT)
Message-ID: <aa950b7b8e8077364267720274a7b9ec34e76e73.camel@linux.ibm.com>
Subject: [PATCH v6 09/17] powerpc/vas: Define QoS credit flag to allocate
 window
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Thu, 17 Jun 2021 13:34:43 -0700
In-Reply-To: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
References: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 69UkTn-bPZT26boIlgljm0MFOHYe80Lb
X-Proofpoint-ORIG-GUID: NwuxT2QSi0XWJd1Jbq___nYgtyiHxMVS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_16:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106170123
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


PowerVM introduces two different type of credits: Default and Quality
of service (QoS).

The total number of default credits available on each LPAR depends
on CPU resources configured. But these credits can be shared or
over-committed across LPARs in shared mode which can result in
paste command failure (RMA_busy). To avoid NX HW contention, the
hypervisor ntroduces QoS credit type which makes sure guaranteed
access to NX esources. The system admins can assign QoS credits
or each LPAR via HMC.

Default credit type is used to allocate a VAS window by default as
on PowerVM implementation. But the process can pass
VAS_TX_WIN_FLAG_QOS_CREDIT flag with VAS_TX_WIN_OPEN ioctl to open
QoS type window.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/uapi/asm/vas-api.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/uapi/asm/vas-api.h b/arch/powerpc/include/uapi/asm/vas-api.h
index ebd4b2424785..7c81301ecdba 100644
--- a/arch/powerpc/include/uapi/asm/vas-api.h
+++ b/arch/powerpc/include/uapi/asm/vas-api.h
@@ -13,11 +13,15 @@
 #define VAS_MAGIC	'v'
 #define VAS_TX_WIN_OPEN	_IOW(VAS_MAGIC, 0x20, struct vas_tx_win_open_attr)
 
+/* Flags to VAS TX open window ioctl */
+/* To allocate a window with QoS credit, otherwise use default credit */
+#define VAS_TX_WIN_FLAG_QOS_CREDIT	0x0000000000000001
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


