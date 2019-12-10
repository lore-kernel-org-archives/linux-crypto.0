Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4400BC2D0BF
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 16:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1891C2073D
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 16:45:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hgTjGNuJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfLJQoy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 11:44:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35162 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727603AbfLJQox (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 11:44:53 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBAGboui035560;
        Tue, 10 Dec 2019 16:44:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=DvRWT6CyyrCzRdhYiXvqt+Gm4VF8bj63CS4+c8VSgaM=;
 b=hgTjGNuJT9MEJ69ULPu8bGkLQFLcjAcl4cOkzbMEvyW0My104Br80ZyQAIMd83A6conH
 L7KVIo5eR7BeKAuOL1pN0n5vXUGXMMZNu5eFMYJaNWZfmZJZ+xTrSJ+xdHSZIcE3SMnd
 TPWWzdHN3H9MKopJLpVmA3Y4/y/O0z7IRfKFHf6lj7FiWzb0QH3nRMtZKfEW2qALY0Qt
 dPuJJyR6u3co72kOGXqrz87HGKFUPQIdsGWrEy3hkAiLXTvL2Wsy+KHTCbb6T/EAN/i3
 Kxh9gIaUOB10E2HoeTmwxO19G4zFHZol2oPs6YEgGesDiX3oCXI0DxEaQ6ZDSWVODfsW 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wr4qrfadv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 16:44:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBAGP27w005185;
        Tue, 10 Dec 2019 16:44:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wt6bckhc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 16:44:36 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBAGiWlJ007455;
        Tue, 10 Dec 2019 16:44:32 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Dec 2019 08:44:31 -0800
Date:   Tue, 10 Dec 2019 11:44:41 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH v2 5/5] padata: update documentation
Message-ID: <20191210164441.gikjbbusik4fan5y@ca-dmjordan1.us.oracle.com>
References: <20191203193114.238912-1-daniel.m.jordan@oracle.com>
 <20191203193114.238912-6-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203193114.238912-6-daniel.m.jordan@oracle.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9467 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912100141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9467 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912100142
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Small fixup for this patch.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9d3a5c54a41d..eefd665d41a1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12253,7 +12253,7 @@ L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	kernel/padata.c
 F:	include/linux/padata.h
-F:	Documentation/padata.txt
+F:	Documentation/core-api/padata.rst
 
 PAGE POOL
 M:	Jesper Dangaard Brouer <hawk@kernel.org>
-- 
2.24.0

