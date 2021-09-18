Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C54C433FE
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Sep 2021 08:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD4CF61212
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Sep 2021 08:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243678AbhIRIJF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 Sep 2021 04:09:05 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:45271 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243677AbhIRIJF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Sep 2021 04:09:05 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0Uolxtge_1631952457;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Uolxtge_1631952457)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Sep 2021 16:07:38 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Elvira Khabirova <e.khabirova@omp.ru>,
        Vitaly Chikunov <vt@altlinux.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Eric Biggers <ebiggers@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "Gilad Ben-Yossef" <gilad@benyossef.com>,
        Pascal van Leeuwen <pvanleeuwen@rambus.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        "YiLin . Li" <YiLin.Li@linux.alibaba.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v4 0/2] pkcs7: support SM2/SM3 and EC-RDSA/streebog algorithms
Date:   Sat, 18 Sep 2021 16:07:35 +0800
Message-Id: <20210918080737.17252-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
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
2.19.1.3.ge56e4f7

