Return-Path: <SRS0=kzJ7=3K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A63D4C2D0DB
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 09:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8745B20882
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 09:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgAUJ5d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jan 2020 04:57:33 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:48737 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728682AbgAUJ5c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jan 2020 04:57:32 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04397;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0ToHgJlF_1579600649;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0ToHgJlF_1579600649)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 21 Jan 2020 17:57:30 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Introduce OSCCA SM2 asymmetric cipher algorithm 
Date:   Tue, 21 Jan 2020 17:57:12 +0800
Message-Id: <20200121095718.52404-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

This new module implement the SM2 public key algorithm. It was
published by State Encryption Management Bureau, China.
List of specifications for SM2 elliptic curve public key cryptography:

* GM/T 0003.1-2012
* GM/T 0003.2-2012
* GM/T 0003.3-2012
* GM/T 0003.4-2012
* GM/T 0003.5-2012

IETF: https://tools.ietf.org/html/draft-shen-sm2-ecdsa-02
oscca: http://www.oscca.gov.cn/sca/xxgk/2010-12/17/content_1002386.shtml
scctc: http://www.gmbz.org.cn/main/bzlb.html

The sm2 algorithm is based on libgcrypt's mpi implementation, and has
made some additions to the kernel's original mpi library, and added the
implementation of ec to better support elliptic curve-like algorithms.

sm2 has good support in both openssl and gnupg projects, and sm3 and sm4
of the OSCCA algorithm family have also been implemented in the kernel.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

Thanks,
Tianjia


