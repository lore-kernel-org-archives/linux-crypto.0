Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F309BC433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 23:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A394921726
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 23:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564788034;
	bh=5MDWMZ+Bb+H1JLI7zlax6RlbYeorlnYGQAZD3xSaKLo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=PZEab4sG82My6PeklXbkNBpZStx13nFjuWesn4DF4dsT1XBgDLIpaTEdxMg22IUrX
	 sNmTTTQCiA1rhB+pOo5AD/c88FFKPEh3rFsPLIUg0aGSklcwftXmo0KjCbbin+PWY/
	 7UfuA0kFKr9KVyMCEJkJlC8uf/1f5eRVjF5AT/d0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388599AbfHBXUd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 19:20:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387495AbfHBXUd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 19:20:33 -0400
Received: from localhost (unknown [69.71.4.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F38422087E;
        Fri,  2 Aug 2019 23:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564788032;
        bh=5MDWMZ+Bb+H1JLI7zlax6RlbYeorlnYGQAZD3xSaKLo=;
        h=From:To:Cc:Subject:Date:From;
        b=CtHrXPeQaqIFT1kGAnW5DOoL8nsvXXEeu7tkt5g7Mxl5bfl8RedIJaHQArwrWFdyE
         L6JPaV9JlfPhnE00BtjeQHNIQxZJVil3TZyX3zyNKIgyRLxJhVb4OkCNmO4/AZdcIn
         J1SflbREfyPuEfw1L3nbDzBH3pDvS3rV2LZ8uIN8=
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 0/2] crypto: ccp - Remove unnecessary includes
Date:   Fri,  2 Aug 2019 18:20:10 -0500
Message-Id: <20190802232013.15957-1-helgaas@kernel.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

CCP includes <linux/pci.h> many times unnecessarily.  Add a couple
DMA-related includes for dma_direction and dma_get_mask(), which were
previously included indirectly via <linux/pci.h>.  Then remove the
unnecessary includes of <linux/pci.h>.

Bjorn Helgaas (2):
  crypto: ccp - Include DMA declarations explicitly
  crypto: ccp - Remove unnecessary linux/pci.h include

 drivers/crypto/ccp/ccp-crypto.h    | 1 -
 drivers/crypto/ccp/ccp-dev-v3.c    | 1 -
 drivers/crypto/ccp/ccp-dev-v5.c    | 1 -
 drivers/crypto/ccp/ccp-dev.h       | 2 +-
 drivers/crypto/ccp/ccp-dmaengine.c | 1 +
 drivers/crypto/ccp/ccp-ops.c       | 1 -
 drivers/crypto/ccp/psp-dev.h       | 1 -
 drivers/crypto/ccp/sp-dev.h        | 1 -
 8 files changed, 2 insertions(+), 7 deletions(-)

-- 
2.22.0.770.g0f2c4a37fd-goog

