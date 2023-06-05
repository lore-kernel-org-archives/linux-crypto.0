Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D08E5C7EE23
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Jun 2023 21:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjFEVGP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Jun 2023 17:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjFEVGP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Jun 2023 17:06:15 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9287CEE
        for <linux-crypto@vger.kernel.org>; Mon,  5 Jun 2023 14:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685999174; x=1717535174;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=X01aYUlY5nr4tSH2ADl/f2B8cruoOFdc9GJrxm+Gu4E=;
  b=HTOxIj8VYO2phHK+WIqC8dzH8eaSqztyVY5tqf0ZW6M4NVKCOl2KYOP9
   WrRw4KPCFgPBYbOcTkOYQw3zuzrZeGbjlhT5xYzUeqgQpSwjhNiqgBXTV
   wcuvVOFCqTws5agcZd4F/dYOMfOicAAp5Bn8DGoe30LWV2cze91XcVEYX
   yAbyoC8Tkot09Y7Vjb8nDhsDhcNE9vr8tTOecTiol9wzShmUY2T7ACvyo
   0B93d75L8LPV3lkuIHFfhPqHUe57gzDmikF9jRagukES6sTfbQxLRyUXS
   eUCHqlNqh7LhrsNxntl0gMl5ywHep0c6t1HOWzstA1sk8SxKXExrz/jjl
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="422309615"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="422309615"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 14:06:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="778710818"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="778710818"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.175])
  by fmsmga004.fm.intel.com with ESMTP; 05 Jun 2023 14:06:12 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [RESEND 0/2] crypto: qat - unmap buffers before free
Date:   Mon,  5 Jun 2023 22:06:05 +0100
Message-Id: <20230605210607.7185-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The callbacks functions for RSA and DH free the memory allocated for the
source and destination buffers before unmapping it.
This sequence is not correct.

Change the cleanup sequence to unmap the buffers before freeing them.

Resending adding Reviewed-by Andy got from an internal review.

Hareshx Sankar Raj (2):
  crypto: qat - unmap buffer before free for DH
  crypto: qat - unmap buffers before free for RSA

 .../crypto/intel/qat/qat_common/qat_asym_algs.c    | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

-- 
2.40.1

