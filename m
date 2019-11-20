Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 905FAC432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 18:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AC5B2089F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 18:56:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O/hAMQTq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfKTS4p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 13:56:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53708 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727172AbfKTS4o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 13:56:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIs5X8015693;
        Wed, 20 Nov 2019 18:56:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=61wJRANyMuTZKvHLQag+hVNYJ6+7P82yKFAegw51pcc=;
 b=O/hAMQTq7aq4XlwUoNFzDQnuoA+gyT7m5p6i5NqKnRnMROV3D8Oni6UTGfYg4hHYn6Vf
 yLsjsiKuTee9Rsm4JTHwX2UaWap5oF4kfafZ1JCcTYRiz+NMyqZ4vH7tUtOOrOH+8FPD
 l5n+JeIGkYaEIFmTThKDszGu68vcJYJp2KRIBQUbgeTd7e90GQO/JCPthsB5ezZ04hFo
 CmXGiFgoYRfUcwzFFc/ivRrAY4xOKLV+YRjLoIpu1PcGm+oG2NipqOpqFGLRaK+0Hpsl
 Xx+uno6mEZep/HWBQY5HuJaklQ/I4t7/Fqdq4ZTEeWPfVouYIl5vifZjkWOmKPccSa0W Kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wa92pyh3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:56:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIqtts119562;
        Wed, 20 Nov 2019 18:56:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2wcemhajh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:56:36 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAKIuYJ6006488;
        Wed, 20 Nov 2019 18:56:34 GMT
Received: from zissou.us.oracle.com (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 10:56:34 -0800
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 0/4] padata lockdep, cpumask, and doc fixes
Date:   Wed, 20 Nov 2019 13:54:08 -0500
Message-Id: <20191120185412.302-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=846
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=908 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200156
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These are on top of v5.4-rc8 plus Herbert's recent padata changes:

  [PATCH] padata: Remove broken queue flushing
  https://lore.kernel.org/linux-crypto/20191119051731.yev6dcsp2znjaagz@gondor.apana.org.au/

  [PATCH] crypto: pcrypt - Fix user-after-free on module unload
  https://lore.kernel.org/linux-crypto/20191119094131.x7gkxdi5clyxk3zd@gondor.apana.org.au/

  [v2 PATCH] crypto: pcrypt - Avoid deadlock by using per-instance padata queues
  https://lore.kernel.org/linux-crypto/20191119185827.nerskpvddkcsih25@gondor.apana.org.au/

  [PATCH] padata: Remove unused padata_remove_cpu
  https://lore.kernel.org/linux-crypto/20191119223250.jaefneeatsa52nhh@gondor.apana.org.au/

I can rebase to something else if that's easier.  Thanks.

Daniel Jordan (4):
  padata: update documentation
  padata: remove reorder_objects
  padata: always acquire cpu_hotplug_lock before pinst->lock
  padata: remove cpumask change notifier

 Documentation/padata.txt | 74 ++++++++++++++--------------------------
 crypto/pcrypt.c          |  1 -
 include/linux/padata.h   | 12 -------
 kernel/padata.c          | 60 +++-----------------------------
 4 files changed, 31 insertions(+), 116 deletions(-)


base-commit: af42d3466bdc8f39806b26f593604fdc54140bcb
prerequisite-patch-id: e31e7b28eb12a2c7e1e04261f4e890f83a57bd19
prerequisite-patch-id: 00f7ca687bd9df6281e9ced0925a865b2fa7b297
prerequisite-patch-id: 0478fe82b9102aeae08f602b170eacc5cf6334de
prerequisite-patch-id: f575fef550bb0cbf5418d3ccd15724d8b4b30858
-- 
2.23.0

