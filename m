Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E9BC433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 11:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiGEL10 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 07:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiGEL1W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 07:27:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A776815FD5;
        Tue,  5 Jul 2022 04:27:21 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265BIXkt027767;
        Tue, 5 Jul 2022 11:27:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=+c/e5HXtOr27Vq02A5ZPdwKuyJtKKSdm/wxxkb5X3u0=;
 b=abRZeYLuLbMCsbzDx0aePN5/OkvYTulSYXMc02CrQlWa5cfdHv1EXUD7Uc5vI9yvdhPF
 1B6/CP4RM2dEXLs4O8IoI7djzGD0KMp9n3JRf//3XH0T9F4uETl6EqQ+OfNJzfJf1z3A
 Fgd+60lTjp3toi77BMIOocEg0wrLCuKEOcdUpZmSBggUYcCzon88OcImdURYWKTHvKof
 8mAlA4NkFm+ds3Z9G8z2zVERdTHkMOUQA1vbuPAZR95ZzjKccLbZY0YE1ZmxLr/j4L4b
 LVJ2ba4xcOM8bl5ZBiBtJrmfvEo2Ogpm4OE3wuaB0MtS2efUwYujqpCBbcpTng1rTquh vw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4mahr69h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 11:27:21 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 265BLdv9003786;
        Tue, 5 Jul 2022 11:27:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3h2dn93xp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 11:27:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 265BRODx30474534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 11:27:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EBB411C04A;
        Tue,  5 Jul 2022 11:27:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E904A11C04C;
        Tue,  5 Jul 2022 11:27:14 +0000 (GMT)
Received: from ibm.com (unknown [9.171.9.129])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jul 2022 11:27:14 +0000 (GMT)
From:   Holger Dengler <dengler@linux.ibm.com>
To:     "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Juergen Christ <jchrist@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1 0/1] s390/archrandom: use buffered random data
Date:   Tue,  5 Jul 2022 13:27:11 +0200
Message-Id: <20220705112712.4433-1-dengler@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: C53kkzS9jv6caUIyy8HmQBplr1cG2dV-
X-Proofpoint-ORIG-GUID: C53kkzS9jv6caUIyy8HmQBplr1cG2dV-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 clxscore=1011 impostorscore=0 mlxlogscore=766 priorityscore=1501
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207050047
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The trng instruction on s390 is a long-running instruction and also
condition the raw random data. The result size is always an integer multiple
of 32 bytes. The runtime for the minimum result of 32 bytes is 20-190us
(depending on the machine generation).

To call trng for each arch_get_random_seed_long() call wastes a lot of time.
Doing so in interrupt context as well, can have dramatically impact on
machines with a huge interrupt load, e.g. machines with multiple 10GB
Ethernet cards and high network traffic.

The following patch introduces a buffering for the trng call results, which
reduces the number of calls by factor 4. In interrupt context, the trng call
will be completely avoided, but if buffered random data is available, it
will be used there.

Holger Dengler (1):
  s390/arch_random: Buffer true random data

 arch/s390/crypto/arch_random.c     | 51 +++++++++++++++++++++++++++++-
 arch/s390/include/asm/archrandom.h | 17 ++++------
 2 files changed, 56 insertions(+), 12 deletions(-)

-- 
2.36.1

