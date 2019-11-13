Return-Path: <SRS0=5LAy=ZF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C61C43331
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 10:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EBAD222BD
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 10:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfKMKzj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Nov 2019 05:55:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35198 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726422AbfKMKzj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Nov 2019 05:55:39 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADAmb5K035573
        for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2019 05:55:38 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w8ex23wh5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2019 05:55:37 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.ibm.com>;
        Wed, 13 Nov 2019 10:55:35 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 13 Nov 2019 10:55:34 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADAtXMH53936244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 10:55:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AA504203F;
        Wed, 13 Nov 2019 10:55:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFEC542049;
        Wed, 13 Nov 2019 10:55:32 +0000 (GMT)
Received: from funtu.com (unknown [9.152.224.114])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 10:55:32 +0000 (GMT)
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     ebiggers@kernel.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        Harald Freudenberger <freude@linux.ibm.com>
Subject: [PATCH 0/3] provide paes selftests
Date:   Wed, 13 Nov 2019 11:55:20 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19111310-0008-0000-0000-0000032EA309
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111310-0009-0000-0000-00004A4DAC09
Message-Id: <20191113105523.8007-1-freude@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=267 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130102
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch series provides a reworked version of the paes
in-kernel cipher implementation together with the introdution
of in-kernel selftests for the ciphers implemented there.

Please note that the paes patch is developed against linux-next
respectively Herbert Xu's crypto tree as the fixes from Eric Biggers
which move the paes cipers from blkciper to skciper are a
requirement for the paes rework.

For more details about each patch please have a look into the
individual patch headers.

Harald Freudenberger (3):
  s390/pkey: Add support for key blob with clear key value
  s390/crypto: Rework on paes implementation
  crypto/testmgr: add selftests for paes-s390

 arch/s390/crypto/paes_s390.c         | 163 +++++++++----
 crypto/testmgr.c                     |  36 +++
 crypto/testmgr.h                     | 334 +++++++++++++++++++++++++++
 drivers/s390/crypto/pkey_api.c       |  60 ++++-
 drivers/s390/crypto/zcrypt_ccamisc.h |   1 +
 5 files changed, 545 insertions(+), 49 deletions(-)

-- 
2.17.1

