Return-Path: <SRS0=6fPk=5K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38C3C43331
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 11:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A78A2078E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 11:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585136474;
	bh=BP2jiU2nHSs72zTiTsKQNe3tjeFwce4/Q5J+5DRmMaI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=JFiOx98dvPLlJMLXzRC+fVviQrb0U1/WSu1hCetK6I/ddnNlkg8j2XfXO8qsfAENP
	 FKb6FmLRFlqLD4RQVni0auY8H64wxTL20z3JRrTVu7GypALv3lG45GoiMwlFPAnLsZ
	 bjS2+jVZ6OC6gy9KFZ5+2eRPHHAW6eSw2mOizero=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgCYLlN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Mar 2020 07:41:13 -0400
Received: from foss.arm.com ([217.140.110.172]:47168 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbgCYLlN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Mar 2020 07:41:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 484FC31B;
        Wed, 25 Mar 2020 04:41:13 -0700 (PDT)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE1593F71F;
        Wed, 25 Mar 2020 04:41:12 -0700 (PDT)
From:   Mark Brown <broonie@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 0/3] arm64: Open code .arch_extension
Date:   Wed, 25 Mar 2020 11:41:07 +0000
Message-Id: <20200325114110.23491-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently several assembler files override the default architecture to
enable extensions in order to allow them to implement optimised routines
for systems with those extensions. Since inserting BTI landing pads into
assembler functions will require us to change the default architecture we
need a way to enable extensions without hard coding the architecture.
The assembler has the .arch_extension feature but this was introduced
for arm64 in gas 2.26 which is too modern for us to rely on it.

We could just update the base architecture used by these assembler files
but this would mean the assembler would no longer catch attempts to use
newer instructions so instead introduce a macro which sets the default
architecture centrally.  Doing this will also make our use of .arch and
.cpu to select the base architecture more consistent.

Mark Brown (3):
  arm64: asm: Provide macro to control enabling architecture extensions
  arm64: lib: Use ARM64_EXTENSIONS()
  arm64: crypto: Use ARM64_EXTENSIONS()

 arch/arm64/crypto/aes-ce-ccm-core.S   | 3 ++-
 arch/arm64/crypto/aes-ce-core.S       | 2 +-
 arch/arm64/crypto/aes-ce.S            | 2 +-
 arch/arm64/crypto/crct10dif-ce-core.S | 3 ++-
 arch/arm64/crypto/ghash-ce-core.S     | 3 ++-
 arch/arm64/crypto/sha1-ce-core.S      | 3 ++-
 arch/arm64/crypto/sha2-ce-core.S      | 3 ++-
 arch/arm64/include/asm/linkage.h      | 6 ++++++
 arch/arm64/lib/crc32.S                | 2 +-
 9 files changed, 19 insertions(+), 8 deletions(-)

-- 
2.20.1

