Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C90C432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 19:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 444492080F
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 19:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TyhNG6ph"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfLCTbq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 14:31:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35986 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727433AbfLCTbp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 14:31:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3JOcB9165372;
        Tue, 3 Dec 2019 19:31:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=qEl+pOhRr3g+RbA74TF3EJsh7AdX920CBSilgxsTtEA=;
 b=TyhNG6phCS4TQJ7F8PPU0jytfzaRchoWR6IbfN7EznnBQ/F0L+jvwdG88mZ1u5+kgpLZ
 6BEjm/u8DxAD7qZI9poq6jroazrTa9BNAxhYM69DmOYZUbgPdQmY/v181yS9PZ6BRHAe
 dVgcPbpj1uBaxy1L8FZEJX2WJ1QZcyt5mwJH/+AeDtnFjhhnLpifjoic1/NHm8BF1BzP
 n2A3L5DnkRiFSDZ/18BPHf0h9mIJXhhup5SwnS/RqYcjjGY+YpewUOJACi52ZrSpIfS2
 rEBf2OHZwpAj/ui+N+1Bzw+xcxwwOnOvBPuVku/rNgOToZFrLVf5oW0Bl+e82BcctOSd Sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wkgcq9x9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 19:31:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3JEcmg133392;
        Tue, 3 Dec 2019 19:31:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2wn7pqmm1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 19:31:34 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB3JVT6O009168;
        Tue, 3 Dec 2019 19:31:30 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 11:31:29 -0800
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 0/5] padata lockdep, cpumask, and doc fixes
Date:   Tue,  3 Dec 2019 14:31:09 -0500
Message-Id: <20191203193114.238912-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=984
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030143
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series depends on all of Herbert's recent padata fixes to reduce
merge conflicts on his end:

  crypto: pcrypt - Do not clear MAY_SLEEP flag in original request
  padata: Remove unused padata_remove_cpu
  [v3] crypto: pcrypt - Avoid deadlock by using per-instance padata queues
  crypto: pcrypt - Fix user-after-free on module unload
  padata: Remove broken queue flushing 

If this should be based on something else, please let me know.

Thanks,
Daniel

v2:
 - documentation patch RST-ized according to Jon's comments
 - "validate cpumask" patch added
 - rebased onto v5.4 and updated since Herbert's fixes have changed

Daniel Jordan (5):
  padata: validate cpumask without removed CPU during offline
  padata: always acquire cpu_hotplug_lock before pinst->lock
  padata: remove cpumask change notifier
  padata: remove reorder_objects
  padata: update documentation

 Documentation/core-api/index.rst  |   1 +
 Documentation/core-api/padata.rst | 169 ++++++++++++++++++++++++++++++
 Documentation/padata.txt          | 163 ----------------------------
 crypto/pcrypt.c                   |   1 -
 include/linux/cpuhotplug.h        |   1 +
 include/linux/padata.h            |  28 ++---
 kernel/padata.c                   | 124 ++++++++--------------
 7 files changed, 220 insertions(+), 267 deletions(-)
 create mode 100644 Documentation/core-api/padata.rst
 delete mode 100644 Documentation/padata.txt


base-commit: 219d54332a09e8d8741c1e1982f5eae56099de85
prerequisite-patch-id: e31e7b28eb12a2c7e1e04261f4e890f83a57bd19
prerequisite-patch-id: 00f7ca687bd9df6281e9ced0925a865b2fa7b297
prerequisite-patch-id: 9f3bb985b34d29ff30e44b8829545736de02186f
prerequisite-patch-id: fe09ee84131ee649b90ee291fbbeda32e90c42fe
prerequisite-patch-id: f2e5a29f78e2403677ad50d870d90022932bc2b6
-- 
2.24.0

