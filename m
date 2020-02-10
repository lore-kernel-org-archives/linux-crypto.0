Return-Path: <SRS0=9Lzg=36=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48392C352A3
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 12:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B59920708
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 12:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730696AbgBJMor (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Feb 2020 07:44:47 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:59349 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727857AbgBJMoq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Feb 2020 07:44:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04428;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Tpb9ZmV_1581338682;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Tpb9ZmV_1581338682)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 10 Feb 2020 20:44:42 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, jmorris@namei.org,
        serge@hallyn.com, ebiggers@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] IMA hash algorithm supports sm3
Date:   Mon, 10 Feb 2020 20:44:38 +0800
Message-Id: <20200210124440.23929-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixed an issue where the sm3 algorithm name mismatch in the crypto subsystem hash_algo_name.
Make IMA support sm3 hash algorithm, added support for sm3 in IMA algorithm Kconfig configuration.


