Return-Path: <SRS0=MzAP=55=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1164C2BBFD
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Apr 2020 15:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA2FE2072D
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Apr 2020 15:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbgDMP7v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Apr 2020 11:59:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4962 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731168AbgDMP7v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Apr 2020 11:59:51 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03DFY5OW051657;
        Mon, 13 Apr 2020 11:59:37 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30b9vthffk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Apr 2020 11:59:37 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03DFuc0H025545;
        Mon, 13 Apr 2020 15:59:36 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 30b5h61eky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Apr 2020 15:59:36 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03DFxaqh16122652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 15:59:36 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BE68AC059;
        Mon, 13 Apr 2020 15:59:36 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B06C9AC05B;
        Mon, 13 Apr 2020 15:59:35 +0000 (GMT)
Received: from localhost (unknown [9.85.151.130])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 13 Apr 2020 15:59:35 +0000 (GMT)
From:   Raphael Moreira Zinsly <rzinsly@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        dja@axtens.net
Cc:     rzinsly@linux.ibm.com, herbert@gondor.apana.org.au,
        mpe@ellerman.id.au, haren@linux.ibm.com, abali@us.ibm.com
Subject: [PATCH V3 0/5] selftests/powerpc: Add NX-GZIP engine testcase 
Date:   Mon, 13 Apr 2020 12:59:11 -0300
Message-Id: <20200413155916.16900-1-rzinsly@linux.ibm.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-13_07:2020-04-13,2020-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxlogscore=862 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130116
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


This patch series are intended to test the POWER9 Nest
Accelerator (NX) GZIP engine that is being introduced by
https://lists.ozlabs.org/pipermail/linuxppc-dev/2020-March/205659.html
More information about how to access the NX can be found in that patch, also a
complete userspace library and more documentation can be found at:
https://github.com/libnxz/power-gzip

Changes in V3:
	- Defined a macro and increased the number of retries for page faults
	  to work in system with less memory, mentioning the issue on README.
	- Returned to use volatile on the touch pages routine and a few structs
	  on inc/nxu.h as they are handled by hardware and some compilers could
	  optmize it wrongly.
	- Moved common functions to gzip_vas.c.

