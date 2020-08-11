Return-Path: <SRS0=IiXH=BV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A1CC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 00:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D85F20734
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 00:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgHKAkV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Aug 2020 20:40:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:53559 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726977AbgHKAkV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Aug 2020 20:40:21 -0400
IronPort-SDR: 46ZXExrzJ/ll7OPK2kzYgeHrxGX4WoqdvkVEIwegrfM7tw1dlEnonZxcrSxO5OM+DVOeeGc8CB
 gT9qw4UwChVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9709"; a="133702729"
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="133702729"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 17:40:20 -0700
IronPort-SDR: E5ACDydB78ZTtmKqPFjjc/T7NXZzfQXL1T2KcA0mpBLtvUOdUehRFPvv4bAioQewFUHiiCZpn8
 Rz8mRVIlDJFA==
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="438873919"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 17:40:19 -0700
From:   ira.weiny@intel.com
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ira Weiny <ira.weiny@intel.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Cyrpto: Clean up kmap() use
Date:   Mon, 10 Aug 2020 17:40:13 -0700
Message-Id: <20200811004015.2800392-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

While going through kmap() users the following 2 issues were found via code
inspection.

Ira Weiny (2):
  crypto/ux500: Fix kmap() bug
  crypto: Remove unused async iterators

 crypto/ahash.c                        | 41 +++------------------------
 drivers/crypto/ux500/hash/hash_core.c | 30 ++++++++++++--------
 include/crypto/internal/hash.h        | 13 ---------
 3 files changed, 22 insertions(+), 62 deletions(-)

-- 
2.28.0.rc0.12.gb6a658bd00c9

