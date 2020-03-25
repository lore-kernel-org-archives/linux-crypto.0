Return-Path: <SRS0=6fPk=5K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04040C54FD0
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 13:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFF4A2078A
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 13:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585144528;
	bh=6RlZyPXVuG0EpJVI1TSR9uGH3XHEFxDRjr6QIxALRys=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=1UwwDbGr1R/bbGa4vEQb/YJ3CCHtwEHfXoM7xvxMWNrS9915y9BJ4btH6SWxCDRfQ
	 k3fibhGF3pdioZVeLfJe/BrhrDS76x0IOF51J05FbTWn1tz0O/wIFY/nZphA8N+WH3
	 flSeXfpY8mXoGOO2uV6xfgmSBpvjpzMXUERzs32c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgCYNz1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Mar 2020 09:55:27 -0400
Received: from foss.arm.com ([217.140.110.172]:48796 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727277AbgCYNz1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Mar 2020 09:55:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C8921FB;
        Wed, 25 Mar 2020 06:55:27 -0700 (PDT)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 941983F71E;
        Wed, 25 Mar 2020 06:55:26 -0700 (PDT)
From:   Mark Brown <broonie@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 0/2] arm64: Make extension enablement consistent
Date:   Wed, 25 Mar 2020 13:55:20 +0000
Message-Id: <20200325135522.7782-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently we use a mix of .arch and .cpu to enable architecture
extensions, make things consistent by converting the two instances of
.cpu to .arch which is more common and a bit more idiomatic for our
goal.

Mark Brown (2):
  arm64: crypto: Consistently enable extension
  arm64: lib: Consistently enable crc32 extension

 arch/arm64/crypto/crct10dif-ce-core.S | 2 +-
 arch/arm64/lib/crc32.S                | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.20.1

