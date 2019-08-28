Return-Path: <SRS0=KXmQ=WY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B36C3A5A1
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 23:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6947E2189D
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 23:39:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mrdP4VYF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfH1XjA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Aug 2019 19:39:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44904 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfH1XjA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Aug 2019 19:39:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SNYPiU177339;
        Wed, 28 Aug 2019 23:38:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=GhdPiCSY9MkVGCnGCBcOj7hNHDN3GuDPlSlaUmyDeaA=;
 b=mrdP4VYFIrZ7wKh/BPHh4lSBwfF2lL+RgLlZ49TRtLNel2CxpcCIR6W4ZPcm2UzX6M92
 aMTm1hTbtLxcfUfjeyco8ePZ3R9+badhp/75jqHFYX92PFRlnLp3XT4WU0Af5VHre3cq
 J1sqJZXrqZuqm93cxB3IK6GjwckSemYKyv817WehRTrfo3Pw3+3SCQA4I5qyuHv0y4cM
 gMvWjqwFiuvpdQxmag3tWZ99Ap1XcEpAz87FbFQt0D4I8IG30OwaDaPWyiiphWryvcUx
 u+od6gxEfxLmyy77eW/PhdhsPTJmQE7A2VyJqp9x4uVzS10pqMVRPFUEZ2TuVRiLmABu 8g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2up3d5g0g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 23:38:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SMEVCV043222;
        Wed, 28 Aug 2019 22:16:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2undw7xt84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 22:16:31 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7SMGUwp010166;
        Wed, 28 Aug 2019 22:16:30 GMT
Received: from zissou.us.oracle.com (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 15:16:29 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 0/5] padata flushing and CPU hotplug fixes
Date:   Wed, 28 Aug 2019 18:14:20 -0400
Message-Id: <20190828221425.22701-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908280214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908280219
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,
Here are some miscellaneous padata fixes, mostly to do with CPU hotplug.
This time around there's a new hotplug state to make the CPU remove path
cleaner, and the CC list grew a bit.

Daniel

v2:
 - patches 1-3 are new; 4-5 have changed since v1[*]
 - attempted to fix padata flushing as requested (Herbert)
 - changed hotplug state in which __padata_remove_cpu() is
   called (Herbert)
 - purged cpumask_clear_cpu() calls from same function (Herbert)
 - dropped v1's patch 3/2 (Herbert)
 - after more thought, left the Fixes: tag on the last patch the same

testing:
 - testcase was tcrypt mode=215 sec=1 throughout
 - ran all cpumask combos among parallel cpumasks, serial cpumasks, and CPU
   hotplug in a 3-CPU VM
 - lockdep to check patch 4
 - tested at each patch in this set with and without
   CONFIG_CRYPTO_PCRYPT

Series based on recent mainline plus all padata patches in cryptodev:
    git://oss.oracle.com/git/linux-dmjordan.git padata-cpuhp-v2

[*] https://lore.kernel.org/linux-crypto/20190809192857.26585-1-daniel.m.jordan@oracle.com/

Daniel Jordan (5):
  padata: make flushing work with async users
  padata: remove reorder_objects
  padata: get rid of padata_remove_cpu() for real
  padata: always acquire cpu_hotplug_lock before pinst->lock
  padata: validate cpumask without removed CPU during offline

 Documentation/padata.txt   | 18 ++------
 include/linux/cpuhotplug.h |  1 +
 include/linux/padata.h     |  5 +-
 kernel/padata.c            | 95 +++++++++++---------------------------
 4 files changed, 36 insertions(+), 83 deletions(-)


base-commit: d1abaeb3be7b5fa6d7a1fbbd2e14e3310005c4c1
prerequisite-patch-id: a5bfed8ea60d5a784b8b3e21ccb5657ced2aa1e3
prerequisite-patch-id: 96d53aecccb5af242ba5ee342d75810ecd9bfb84
prerequisite-patch-id: 965d8a63c1461f00219aec2d817f2ca85d49cfb3
prerequisite-patch-id: 8e6c2988331b46c9467ac568157c6c575cbe6578
-- 
2.23.0

