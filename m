Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF87CC0044D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 18:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9351420674
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 18:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732234AbgCPSIL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 14:08:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52430 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732335AbgCPSIL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 14:08:11 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02GI1kSj052543;
        Mon, 16 Mar 2020 14:07:51 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yrubn3nvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Mar 2020 14:07:51 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02GI4geL003117;
        Mon, 16 Mar 2020 18:07:49 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 2yrpw61x9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Mar 2020 18:07:49 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02GI7m7b49414570
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 18:07:48 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BBAC7805F;
        Mon, 16 Mar 2020 18:07:48 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D305178086;
        Mon, 16 Mar 2020 18:07:25 +0000 (GMT)
Received: from localhost (unknown [9.85.153.64])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 16 Mar 2020 18:07:25 +0000 (GMT)
From:   Raphael Moreira Zinsly <rzinsly@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, mpe@ellerman.id.au,
        haren@linux.ibm.com, abali@us.ibm.com
Subject: [PATCH 0/5] selftests/powerpc: Add NX-GZIP engine testcase 
Date:   Mon, 16 Mar 2020 15:07:09 -0300
Message-Id: <20200316180714.18631-1-rzinsly@linux.ibm.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-16_07:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 clxscore=1011 impostorscore=0 phishscore=0 mlxscore=0
 mlxlogscore=866 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160078
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch series are intended to test the power8 and power9 Nest
Accelerator (NX) GZIP engine that is being introduced by
https://lists.ozlabs.org/pipermail/linuxppc-dev/2020-March/205659.html
More information about how to access the NX can be found in that patch, also a
complete userspace library and more documentation can be found at:
https://github.com/libnxz/power-gzip


Thanks,
Raphael


