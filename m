Return-Path: <SRS0=SwA+=7B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75ADC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 19:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AECFD20873
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 19:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589914938;
	bh=p2x2LclJ0xI5fOs4bKaK0KKKNU41HHkLK1/dnIsHhbo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=P4VYHtOgg9JTlQSVggIuIZXkpUJ5gTS8v7c1wTOBhL0YOfW0kbcx/FsnKKf8JTWjH
	 d+Yt951dKxzdOtFr1MkRkAXOuLBSGdZO3aMrvkmddgPQhPjGGvavbLC/VlLm5j84wA
	 aULwjC4aF/34JKZqhXUBQ5QScBaKDg7ByijXpgEE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgESTCR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 15:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbgESTCR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 15:02:17 -0400
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E025207E8;
        Tue, 19 May 2020 19:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589914937;
        bh=p2x2LclJ0xI5fOs4bKaK0KKKNU41HHkLK1/dnIsHhbo=;
        h=From:To:Cc:Subject:Date:From;
        b=ed4rYd06KgneWuTtKnnW/R+djaWb82I8QTBhJc0jZJlJ0rzytKbNy+1RtJlXBofD1
         4brbfdRk+QiBYQNEfFB8eZdX4hEzXS7eGt2YhLnfNCZkBWNU+kPSapCxJ5YW9kBvRu
         cR5tu2Ri5IFMPTwexevC84whByKeQ+IAON2s07GQ=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and testmgr
Date:   Tue, 19 May 2020 21:02:09 +0200
Message-Id: <20200519190211.76855-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Stephan reports that the arm64 implementation of cts(cbc(aes)) deviates
from the generic implementation in what it returns as the output IV. So
fix this, and add some test vectors to catch other non-compliant
implementations.

Stephan, could you provide a reference for the NIST validation tool and
how it flags this behaviour as non-compliant? Thanks.

Cc: Stephan Mueller <smueller@chronox.de>

Ard Biesheuvel (2):
  crypto: arm64/aes - align output IV with generic CBC-CTS driver
  crypto: testmgr - add output IVs for AES-CBC with ciphertext stealing

 arch/arm64/crypto/aes-modes.S |  2 ++
 crypto/testmgr.h              | 12 ++++++++++++
 2 files changed, 14 insertions(+)

-- 
2.20.1

