Return-Path: <SRS0=Wqm9=S4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E70C43218
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 01:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE3B520891
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 01:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbfDZBDj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 21:03:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:25287 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbfDZBDi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 21:03:38 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Apr 2019 18:03:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,395,1549958400"; 
   d="scan'208";a="168039284"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 25 Apr 2019 18:03:37 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hJpH6-0009BP-Mb; Fri, 26 Apr 2019 09:03:36 +0800
Date:   Fri, 26 Apr 2019 09:03:09 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     kbuild-all@01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [RFC PATCH cryptodev] crypto: cc_sec_disable can be static
Message-ID: <20190426010309.GA57833@ivb42>
References: <201904260948.KwQ0CBJd%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201904260948.KwQ0CBJd%lkp@intel.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Fixes: f98f6e2134bd ("crypto: ccree - add support for sec disabled mode")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 cc_driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 255d236..13b54a2 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -35,7 +35,7 @@ bool cc_dump_bytes;
 module_param_named(dump_bytes, cc_dump_bytes, bool, 0600);
 MODULE_PARM_DESC(cc_dump_bytes, "Dump buffers to kernel log as debugging aid");
 
-bool cc_sec_disable;
+static bool cc_sec_disable;
 module_param_named(sec_disable, cc_sec_disable, bool, 0600);
 MODULE_PARM_DESC(cc_sec_disable, "Disable security functions");
 
