Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3EAC43334
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jun 2022 09:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbiF0JVy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jun 2022 05:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbiF0JVs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jun 2022 05:21:48 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3EE63C4;
        Mon, 27 Jun 2022 02:21:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VHWTzcl_1656321702;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VHWTzcl_1656321702)
          by smtp.aliyun-inc.com;
          Mon, 27 Jun 2022 17:21:43 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Elvira Khabirova <e.khabirova@omp.ru>,
        Vitaly Chikunov <vt@altlinux.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v4 0/2 RESEND] pkcs7: support SM2/SM3 and EC-RDSA/streebog algorithms
Date:   Mon, 27 Jun 2022 17:21:40 +0800
Message-Id: <20220627092142.21095-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series of patches integrates the two patches sended separately,
resolves the conflict, and rebases on the latest code.

The two patches respectively support the SM2/SM3 and EC-RDSA/streebog
algorithm combinations for the pkcs7 parser.

Elvira Khabirova (1):
  pkcs7: support EC-RDSA/streebog in SignerInfo

Tianjia Zhang (1):
  pkcs7: parser support SM2 and SM3 algorithms combination

 crypto/asymmetric_keys/pkcs7_parser.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

-- 
2.24.3 (Apple Git-128)

