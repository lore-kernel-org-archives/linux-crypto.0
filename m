Return-Path: <SRS0=vKog=AZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB83C433EA
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 20:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7E5E212CC
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 20:14:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YsHck65T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbgGNUOP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 16:14:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35110 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbgGNUOP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 16:14:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EKDIxF183199;
        Tue, 14 Jul 2020 20:14:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=yWBnHTtjwD/kifOL8R9vSVD5OGOOWWX50DnpIXyxMU4=;
 b=YsHck65TlRa7XfU0yLxxTaYXtOuZENW6/P3QuFKjLePTma//RrS9yk+RcpJrnF69DOBP
 T1D1jdwiO1VGCgKVZI3CWBLGs6PqXanuU1KoYCaoqKha56bLV/zuP4Lshdo70s+teZXj
 ss4huLCQi+x8/4fDtbpmznNSEXLfvUyqC4wzVbkDjACbrap7tH2CJwQHzV5xhocp9v0e
 Ju2Lp+ZG4I1iNkzMwvfSy9uDWGUxy0ML5u6lvb44W5utaxIWjgBs6GjPDmsjZyHi0u9K
 r5LHhexljn3Ycj1uOIAinIQO1ec1VE5jlNttYyXK45nDZZkPZaKkLaSFQ/HvtkalxY7n wA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3275cm7mnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 20:14:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EKDb5c025127;
        Tue, 14 Jul 2020 20:14:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 327q0pvn8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 20:14:01 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06EKE0Wx013769;
        Tue, 14 Jul 2020 20:14:00 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 13:13:59 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 0/6] padata cleanups
Date:   Tue, 14 Jul 2020 16:13:50 -0400
Message-Id: <20200714201356.889176-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=1 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140141
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These cleanups save ~5% of the padata text/data and make it a little
easier to use and develop going forward.

In particular, they pave the way to extend padata's multithreading support to
VFIO, a work-in-progress version of which can be found here:

    https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=shortlog;h=refs/heads/padata-mt-wip-v0.5

Based on v5.8-rc5.  As always, feedback is welcome.

Daniel

Daniel Jordan (6):
  padata: remove start function
  padata: remove stop function
  padata: inline single call of pd_setup_cpumasks()
  padata: remove effective cpumasks from the instance
  padata: fold padata_alloc_possible() into padata_alloc()
  padata: remove padata_parallel_queue

 Documentation/core-api/padata.rst |  18 +--
 crypto/pcrypt.c                   |  17 +--
 include/linux/padata.h            |  21 +---
 kernel/padata.c                   | 177 ++++++------------------------
 4 files changed, 46 insertions(+), 187 deletions(-)


base-commit: 11ba468877bb23f28956a35e896356252d63c983
-- 
2.27.0

