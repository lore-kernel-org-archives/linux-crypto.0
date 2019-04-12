Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC72DC282CE
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87DE12070D
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfDLFZg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 01:25:36 -0400
Received: from mga17.intel.com ([192.55.52.151]:52678 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfDLFZg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 01:25:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Apr 2019 22:25:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,340,1549958400"; 
   d="scan'208";a="135133764"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 11 Apr 2019 22:25:33 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hEogv-0008Rk-ED; Fri, 12 Apr 2019 13:25:33 +0800
Date:   Fri, 12 Apr 2019 13:25:02 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Atul Gupta <atul.gupta@chelsio.com>
Cc:     kbuild-all@01.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, dt@chelsio.com, atul.gupta@chelsio.com
Subject: [RFC PATCH] chtls_rsk_opsv6 can be static
Message-ID: <20190412052502.GA27883@lkp-wsm-ep2>
References: <20190409152540.11729-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409152540.11729-1-atul.gupta@chelsio.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Fixes: b8351a17998b ("IPv6 changes for Inline TLS")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 chtls_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 1c533d9..01c33e4 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -38,7 +38,7 @@ static RAW_NOTIFIER_HEAD(listen_notify_list);
 static struct proto chtls_cpl_prot;
 struct request_sock_ops chtls_rsk_ops;
 static struct proto chtls_cpl_prot, chtls_cpl_protv6;
-struct request_sock_ops chtls_rsk_ops, chtls_rsk_opsv6;
+static struct request_sock_ops chtls_rsk_ops, chtls_rsk_opsv6;
 static uint send_page_order = (14 - PAGE_SHIFT < 0) ? 0 : 14 - PAGE_SHIFT;
 
 static void register_listen_notifier(struct notifier_block *nb)
