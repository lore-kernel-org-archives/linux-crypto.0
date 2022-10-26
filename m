Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0426CC38A02
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Oct 2022 00:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbiJZAO0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Oct 2022 20:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbiJZAOZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Oct 2022 20:14:25 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3DE281
        for <linux-crypto@vger.kernel.org>; Tue, 25 Oct 2022 17:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666743264; x=1698279264;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tkSoIn2Xuj2GMd87RXHCMCt8Vih6D7iZ1tj43pxDv48=;
  b=SfQUert9xE2VrSzbQFUfkJyNwkRUZ80ni/cr5WWvnGezfU0yGPh9Mapy
   jwq3trU335RojjbE0GygLFEYXAWU8Kw2y8ijfih0zUOFAQRGocfZ/UZGT
   ELx35BFXmvC8Kz8zElGMMSAxXc8dR2/69z6BPvwaGbQwxy9JMMwOOXDg4
   DcmrLpC9urTeUXYiBm4WRP0Y51XcFYzQd0G158Fd/5+Shl0yhEzH5nVDT
   RKp7ozJTg5yyMyXq/FLbJ8PvDBW/M3icjfO54S6zmq46ihv1FI0vWLdg0
   ZHTSJvBVEF1J1Hdta4Hg90QY3K0MYmI8CdIgTHQmPaWQJrwUAtxctwr2h
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="288219039"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="288219039"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 17:14:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="662999544"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="662999544"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by orsmga008.jf.intel.com with ESMTP; 25 Oct 2022 17:14:23 -0700
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH 0/4] Printing improvements for tcrypt
Date:   Tue, 25 Oct 2022 17:15:17 -0700
Message-Id: <20221026001521.4222-1-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The text tcrypt prints to dmesg is a bit inconsistent. This makes it
difficult to process tcrypt results using scripts. This little series
makes the prints more consistent.

Anirudh Venkataramanan (4):
  crypto: tcrypt - Use pr_cont to print test results
  crypto: tcrypt - Use pr_info/pr_err
  crypto: tcrypt - Drop module name from print string
  crypto: tcrypt - Drop leading newlines from prints

 crypto/tcrypt.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

-- 
2.37.2

