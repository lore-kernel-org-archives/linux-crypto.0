Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70887CD6E5D
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Oct 2023 12:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbjJKMgW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Oct 2023 08:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbjJKMgS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2023 08:36:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64932A9
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 05:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697027777; x=1728563777;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R9uUosXHevNDtsH3F53bk1Qt785AUcIe8768ljH9H8A=;
  b=S24f+k6CIWMnG6OxhP0XoLtioWLA2tWnKMcTwV4NXpQUSotWT+x7FKcu
   CfXyULMclpRF5S6J8phf2ARzygYKCd7vOjPHqwdSb+LGlWlc0aIB29LvX
   wxj0lzSwrnviLwkXRink7oc5QI0JvQGOheNI4LuV5ZPACU+6UbdPRPGzC
   mRJOlf7KnQ9k7bEIwutSfXJ73DmXWDxbwX4EJpN5NGAMJ3gpvUSysUBY0
   W15jJuesirt1Sh/TyHm3PKpEwFrPKsKUIBX2OPkfGIfUnH6ENbUcOLW80
   iQEr8a78G9odDNBSYfYO0LnOeiSEq/ykZVHfm2dHUMjt1ONNEgMrupOdr
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="374992871"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="374992871"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 05:36:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="870124663"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="870124663"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga002.fm.intel.com with ESMTP; 11 Oct 2023 05:36:16 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 05/11] units: Add BYTES_PER_*BIT
Date:   Wed, 11 Oct 2023 14:15:03 +0200
Message-ID: <20231011121934.45255-6-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231011121934.45255-1-damian.muszynski@intel.com>
References: <20231011121934.45255-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is going to be a new user of the BYTES_PER_[K/M/G]BIT definition
besides possibly existing ones. Add them to the header.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 include/linux/units.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/units.h b/include/linux/units.h
index 2793a41e73a2..ff1bd6b5f5b3 100644
--- a/include/linux/units.h
+++ b/include/linux/units.h
@@ -31,6 +31,10 @@
 #define MICROWATT_PER_MILLIWATT	1000UL
 #define MICROWATT_PER_WATT	1000000UL
 
+#define BYTES_PER_KBIT		(KILO / BITS_PER_BYTE)
+#define BYTES_PER_MBIT		(MEGA / BITS_PER_BYTE)
+#define BYTES_PER_GBIT		(GIGA / BITS_PER_BYTE)
+
 #define ABSOLUTE_ZERO_MILLICELSIUS -273150
 
 static inline long milli_kelvin_to_millicelsius(long t)
-- 
2.41.0

