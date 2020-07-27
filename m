Return-Path: <SRS0=C5/f=BG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=BAYES_00,
	BODY_QUOTE_MALF_MSGID,DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E55C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jul 2020 11:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32D132072E
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jul 2020 11:20:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="knfjx0yj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgG0LUa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jul 2020 07:20:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56136 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbgG0LUa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jul 2020 07:20:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RBBZ28075719;
        Mon, 27 Jul 2020 11:20:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=lQWs9kg9IFM5e6VZiFkeBZJuoy2fP6/5G7myqm/lmzU=;
 b=knfjx0yj4HwU7K+kriVrucT1nSheX0aKxyD4KmqQYdPuliDfk0GXJm+w62F/JYyzk+PC
 XQFkRwhZKzav6jVTSU2nf5WFm6dJ9OrmVjWmKcU4XVP0mjPDJ5rfyE4pTHA89MYb9w06
 c2IOHDOCJaVvHqNYd5KVUTebwNU/hlFcBsSyVliCCl6knSiQgKXyaTu9tIjpWA6kn9JK
 w7KlgJTTZhWXGDGx7GtljfsrJSsViAmGdVg0NPTV0pRkFeehOkL4yhpCa7lxN6Clhl6r
 m9or6qdL2Xd3bzVQYeeCo1gYpBLi3UpIhAVgSLdYzW2ZVeB3R2tJuIw0XX7CYw2cehKb ig== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32hu1j0xar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 27 Jul 2020 11:20:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RBEH0h045361;
        Mon, 27 Jul 2020 11:20:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32hu5qgscd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 11:20:27 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06RBKQDL016253;
        Mon, 27 Jul 2020 11:20:26 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 04:20:26 -0700
Date:   Mon, 27 Jul 2020 14:20:20 +0300
From:   <dan.carpenter@oracle.com>
To:     j-keerthy@ti.com
Cc:     linux-crypto@vger.kernel.org
Subject: [bug report] crypto: sa2ul - Add crypto driver
Message-ID: <20200727112020.GE389488@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=920 mlxscore=0
 suspectscore=3 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=912
 lowpriorityscore=0 malwarescore=0 clxscore=1011 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=3 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270083
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Keerthy,

The patch 7694b6ca649f: "crypto: sa2ul - Add crypto driver" from Jul
13, 2020, leads to the following static checker warning:

	drivers/crypto/sa2ul.c:1201 sa_run()
	error: 'mdptr' dereferencing possible ERR_PTR()

drivers/crypto/sa2ul.c
  1176          rxd->enc = req->enc;
  1177          rxd->ddev = ddev;
  1178          rxd->src = src;
  1179          rxd->dst = dst;
  1180          rxd->iv_idx = req->ctx->iv_idx;
  1181          rxd->enc_iv_size = sa_ctx->cmdl_upd_info.enc_iv.size;
  1182          rxd->tx_in->callback = req->callback;
  1183          rxd->tx_in->callback_param = rxd;
  1184  
  1185          tx_out = dmaengine_prep_slave_sg(pdata->dma_tx, src,
  1186                                           src_nents, DMA_MEM_TO_DEV,
  1187                                           DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
  1188  
  1189          if (!tx_out) {
  1190                  dev_err(pdata->dev, "OUT prep_slave_sg() failed\n");
  1191                  ret = -EINVAL;
  1192                  goto err_cleanup;
  1193          }
  1194  
  1195          /*
  1196           * Prepare metadata for DMA engine. This essentially describes the
  1197           * crypto algorithm to be used, data sizes, different keys etc.
  1198           */
  1199          mdptr = (u32 *)dmaengine_desc_get_metadata_ptr(tx_out, &pl, &ml);
                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
What about if this has an error?

  1200  
  1201          sa_prepare_tx_desc(mdptr, (sa_ctx->cmdl_size + (SA_PSDATA_CTX_WORDS *
  1202                                     sizeof(u32))), cmdl, sizeof(sa_ctx->epib),
  1203                             sa_ctx->epib);
  1204  
  1205          ml = sa_ctx->cmdl_size + (SA_PSDATA_CTX_WORDS * sizeof(u32));
  1206          dmaengine_desc_set_metadata_len(tx_out, req->mdata_size);
  1207  
  1208          dmaengine_submit(tx_out);
  1209          dmaengine_submit(rxd->tx_in);
  1210  
  1211          dma_async_issue_pending(dma_rx);
  1212          dma_async_issue_pending(pdata->dma_tx);
  1213  
  1214          return -EINPROGRESS;

regards,
dan carpenter
