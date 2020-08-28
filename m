Return-Path: <SRS0=6Tes=CG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F10C433E2
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Aug 2020 01:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FC992080C
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Aug 2020 01:53:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rMkCzEGL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgH1Bxq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 21:53:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52392 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgH1Bxq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 21:53:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S1jmYr027980;
        Fri, 28 Aug 2020 01:53:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=8qmTWE/HMndKXOQSs3EPRMRuatDNjhugVlS7ze1Wk4I=;
 b=rMkCzEGL/VC6cn30IfixQNqFTnPCVXcFxPNJfRfXgxwIYcky4BD5HIXf4Tdj0lZV6OyP
 oolGZM++kxwLnZJzQsW5S3qQsSz1ypPbjrqY9HCwOA4STtCmuc273EY3YKKcKl58kfMY
 BEdDD4OUDqcoPJ04IsdII+Bl2n2DmK3HR2oqO3BL+qdVv3CZW3i2Kzt8lm2VTDaTC7JV
 mxavuN6T1OHZABn7ogWHpYEZaNzSdAGjJ6Q9E0rJLeDs75LQOZQQ9CvMhUFP29QDxYXn
 ST/N0VI0e6mk35i4HaYVxfVp7ZzbL8i1cEk7GXejAJjOdinqcUprI0Rc9KQDG99SqyNL 5w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 336ht3hjmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Aug 2020 01:53:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S1okfR014746;
        Fri, 28 Aug 2020 01:53:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 333ru26vn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 01:53:34 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07S1rXGe031378;
        Fri, 28 Aug 2020 01:53:33 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 18:53:32 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2] padata: add another maintainer and another list
Date:   Thu, 27 Aug 2020 21:53:28 -0400
Message-Id: <20200828015328.86800-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200828015944.tk45hzuyzkabbrs3@ca-dmjordan1.us.oracle.com>
References: <20200828015944.tk45hzuyzkabbrs3@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280014
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

At Steffen's request, I'll help maintain padata for the foreseeable
future.

While at it, let's have patches go to lkml too since the code is now
used outside of crypto.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3b186ade3597..06a1b8a6d953 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13024,7 +13024,9 @@ F:	lib/packing.c
 
 PADATA PARALLEL EXECUTION MECHANISM
 M:	Steffen Klassert <steffen.klassert@secunet.com>
+M:	Daniel Jordan <daniel.m.jordan@oracle.com>
 L:	linux-crypto@vger.kernel.org
+L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/core-api/padata.rst
 F:	include/linux/padata.h
-- 
2.28.0

