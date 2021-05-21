Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E841C43461
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 09:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0136F613CA
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 09:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236601AbhEUJgU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 05:36:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10826 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236586AbhEUJgT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 05:36:19 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14L9YINS175692;
        Fri, 21 May 2021 05:34:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=KPIrsNBG3jw+H+sZqYv0mJnkmpfU9yg0jZVq1syPJH4=;
 b=djNPL/YGgWsV7NupDXh4eU8wln0vfPIJdttNZgqI0BnVVOuIFUVKYgS/7cvtkj7V44eR
 ns42+A/GQZ96d2VoadtGzNVV/nSoHiYtwB+U18gS3ov4QEQX4W3GNmW+akJh4C3rq92/
 QUxjSpPvoIy/MvLf5sWCHaOzKjM6K8/+x6kDhr1HwmA8kiF1IbfF3rgW5a/F1MyH2nxg
 5PweBiC4Zpj/R+fpq6bkewrRKwQ9G5HkzAipcgqoJFqzBYIiBa1NymnF8+2hyFxKLIuC
 4cEKvrUbalnHoFCSPcwLhXSPkyYUuQ6DCqtacaXpMqsRupkJW2FDdkJos+rz7KbSfGLN Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38p4bfh2tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 May 2021 05:34:51 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14L9Yp9G177510;
        Fri, 21 May 2021 05:34:51 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38p4bfh2sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 May 2021 05:34:51 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14L9YLCd030833;
        Fri, 21 May 2021 09:34:49 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03wdc.us.ibm.com with ESMTP id 38j5x9xk51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 May 2021 09:34:49 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14L9Yn7128246520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 09:34:49 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25CC8B2066;
        Fri, 21 May 2021 09:34:49 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05820B2065;
        Fri, 21 May 2021 09:34:48 +0000 (GMT)
Received: from sig-9-65-94-165.ibm.com (unknown [9.65.94.165])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 21 May 2021 09:34:47 +0000 (GMT)
Message-ID: <ee29a7dcc64e759926668fd1bb78d3dc7f1d1d94.camel@linux.ibm.com>
Subject: [PATCH v4 08/16] powerpc/vas: Define QoS credit flag to allocate
 window
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Fri, 21 May 2021 02:34:45 -0700
In-Reply-To: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
References: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QpxOgXbGvbBN2OuOKG8fEI-tVXkO-IyE
X-Proofpoint-GUID: irCefDQKXAbIXRhmxG3BJCYfEEZcOP8J
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-21_03:2021-05-20,2021-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105210061
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


