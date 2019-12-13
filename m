Return-Path: <SRS0=mgHx=2D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA7FC341D2
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 539E22473A
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h4TfeN2Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfLMMiL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Dec 2019 07:38:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48386 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfLMMiK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Dec 2019 07:38:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDCY2Mp092523;
        Fri, 13 Dec 2019 12:38:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=GFRXEbvs1WJyznkLrTRiaHB/X5XfSBqZGUWKGkf2VHI=;
 b=h4TfeN2ZfEI4mdENdxjnlL0LX+Z+aVGLHqX2RoQ5zElDIJ3Ay7il5o7Wzy5+tyZAJ772
 MS/7wacGC6h+WgMa7R8gRwPiJbbTp3++bjoaYepZ3wR2qI46rctbwyztSg5lmCE4LE6F
 Q6eAx3Hmgd0kRNAJE7Qzi4gU5UasdgAx9i1ZB0xecOLAoGoK76qx2FJ9R9ZWUMU4bv1I
 4B6M2uaCoIShC7hXDHoqVgqjYMwDQVKgoakZ+YKYxyiW/3EeWdDvHsV1oyrtPM9uTHKl
 vvsmiW51CkHV8tNNvP7M0BlCQXQE/Npf82fvKlHjwtMcN3h90zBMDmYEimiPvgMq2WNy 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wrw4nnqry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 12:38:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDCYC8H115108;
        Fri, 13 Dec 2019 12:38:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2wumsbvt6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 12:38:07 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBDCc6qL025434;
        Fri, 13 Dec 2019 12:38:06 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 04:38:06 -0800
Date:   Fri, 13 Dec 2019 15:38:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     tudor.ambarus@microchip.com
Cc:     linux-crypto@vger.kernel.org
Subject: [bug report] crypto: atmel-aes - Fix saving of IV for CTR mode
Message-ID: <20191213123800.dsnxfh4tja2q5kbv@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=720
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912130101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=784 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912130101
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Tudor Ambarus,

The patch 371731ec2179: "crypto: atmel-aes - Fix saving of IV for CTR
mode" from Dec 5, 2019, leads to the following static checker warning:

	drivers/crypto/atmel-aes.c:1058 atmel_aes_ctr_transfer()
	warn: right shifting more than type allows 16 vs 16

drivers/crypto/atmel-aes.c
  1044          /* Check for transfer completion. */
  1045          ctx->offset += dd->total;
  1046          if (ctx->offset >= req->cryptlen)
  1047                  return atmel_aes_transfer_complete(dd);
  1048  
  1049          /* Compute data length. */
  1050          datalen = req->cryptlen - ctx->offset;
  1051          ctx->blocks = DIV_ROUND_UP(datalen, AES_BLOCK_SIZE);
  1052          ctr = be32_to_cpu(ctx->iv[3]);
  1053  
  1054          /* Check 16bit counter overflow. */
  1055          start = ctr & 0xffff;
  1056          end = start + ctx->blocks - 1;
  1057  
  1058          if (ctx->blocks >> 16 || end < start) {
                    ^^^^^^^^^^^^^^^^^
Impossible condition.

  1059                  ctr |= 0xffff;
  1060                  datalen = AES_BLOCK_SIZE * (0x10000 - start);
  1061                  fragmented = true;
  1062          }

regards,
dan carpenter
