Return-Path: <SRS0=BVES=6E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39B9C54FD0
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 20:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D6CF206E9
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 20:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDTU4N (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Apr 2020 16:56:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6070 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbgDTU4M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Apr 2020 16:56:12 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03KKXaDw011406;
        Mon, 20 Apr 2020 16:56:02 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmuxvj6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 16:56:02 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03KKtD6c011904;
        Mon, 20 Apr 2020 20:56:01 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 30fs668s2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 20:56:01 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03KKu0fP53019118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 20:56:00 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E16CF7805C;
        Mon, 20 Apr 2020 20:55:59 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B9997805F;
        Mon, 20 Apr 2020 20:55:58 +0000 (GMT)
Received: from localhost (unknown [9.85.196.70])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 20:55:58 +0000 (GMT)
From:   Raphael Moreira Zinsly <rzinsly@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        dja@axtens.net
Cc:     rzinsly@linux.ibm.com, herbert@gondor.apana.org.au,
        mpe@ellerman.id.au, haren@linux.ibm.com, abali@us.ibm.com
Subject: [PATCH V4 0/5] selftests/powerpc: Add NX-GZIP engine testcase 
Date:   Mon, 20 Apr 2020 17:55:33 -0300
Message-Id: <20200420205538.25181-1-rzinsly@linux.ibm.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_08:2020-04-20,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200162
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


This patch series are intended to test the POWER9 Nest
Accelerator (NX) GZIP engine that is being introduced by
https://lists.ozlabs.org/pipermail/linuxppc-dev/2020-March/205659.html
More information about how to access the NX can be found in that patch,
also a complete userspace library and more documentation can be found at:
https://github.com/libnxz/power-gzip

Changes in V4:
	- Removed nx-helpers.h and moved relevant code to copy-paste.h.
	- Removed nx-gzip.h and symlinked the vas-api.h uapi instead.
	- Renamed inc to include and fixed warnings.
	- Proper integrated the code to the selftests Makefile system
	  with help from Michael Ellerman.


Thanks,
Raphael

