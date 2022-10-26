Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CF8ECDFA1
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Oct 2022 19:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiJZTPz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbiJZTPn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2022 15:15:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8636B3FED5
        for <linux-crypto@vger.kernel.org>; Wed, 26 Oct 2022 12:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666811740; x=1698347740;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=H65tcWnvs+uwHQTTLjQOxB+vE4DfXwsnfp33X1kgVcI=;
  b=lIZbsBZUZUE7EFhpZEyqPCiSNikr5CbdJNPqArPhvNj8j4KBR95zI62V
   vBRJ+Wr3W+SoHlfBeisgzv0cIgDeONfbUvKDS3vZQf5lzVGZ/5rqITLL+
   iDJAUzCL7LxpUo6n3Fo6Snxea/LuxWn75J5dafh12LTgoeY7tt0J9hqeB
   avqTouRjFNK1fwpaEX9Xexz51dGEWgM3VaIue7nH4OaxGGCY8zWqfaGvK
   q+DMt7AWor09a1T58d0Rsb/hP7B7JEXyyIefjPDXyj/YktC7nbNEj6CPi
   f/L2Sr+di/NLCZz+e/nIFrYCpIg9xaZDgqrpJo9WrVkE284tM0zpFDvhs
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="334662184"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="334662184"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 12:15:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="757430820"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="757430820"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by orsmga004.jf.intel.com with ESMTP; 26 Oct 2022 12:15:18 -0700
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Robert Elliott <elliott@hpe.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH v2 0/4] Printing improvements for tcrypt
Date:   Wed, 26 Oct 2022 12:16:12 -0700
Message-Id: <20221026191616.9169-1-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The text tcrypt prints to dmesg is a bit inconsistent. This makes it
difficult to process tcrypt results using scripts. This little series
makes the prints more consistent.

Changes v1 -> v2: Rebase to tag v6.1-p2, resolve conflict in patch 2/4

Anirudh Venkataramanan (4):
  crypto: tcrypt - Use pr_cont to print test results
  crypto: tcrypt - Use pr_info/pr_err
  crypto: tcrypt - Drop module name from print string
  crypto: tcrypt - Drop leading newlines from prints

 crypto/tcrypt.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

-- 
2.37.2

