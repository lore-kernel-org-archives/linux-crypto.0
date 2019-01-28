Return-Path: <SRS0=71ZY=QE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA2CCC282C8
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 08:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A138217D8
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 08:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548665835;
	bh=n+Fxqs+Towa5iZSUn5jShD0wmvGhwDOjCCRws252b/g=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=sUvcoOBugGB5j7qylkc7s8foNq33p67xxvcT4ILMYkWJJLfrs6vTf24r4RRxDlkDa
	 gid8RNatz4rZ8/RqomrU/76ExIW6roUWVLak9yKLYnqg+Mo6o+i2mMnyPBFOCgbWRO
	 UxN3tHh9n3ZezkdC3rjYNcT9S+Nt5ErLjEtX2Zz4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfA1I5P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Jan 2019 03:57:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfA1I5O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Jan 2019 03:57:14 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 262042148E;
        Mon, 28 Jan 2019 08:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548665834;
        bh=n+Fxqs+Towa5iZSUn5jShD0wmvGhwDOjCCRws252b/g=;
        h=From:To:Cc:Subject:Date:From;
        b=kUAJKTGQaJIK+uzekWTRZfzPw+yTHa9bVHE52j48Z9Bn3+Z4J44vdLSaogqPIr9uX
         6wqYNs8fD21xyco1u0WGkfGK02f9rU54bYcWbxiPdFYsTtYVnJqwipP1h69VRp0ymO
         EC27BtoRP5wWqO+I7NC2angzhI464/7Np4/FfRoc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] crypto: crct10dif assembly cleanup and optimizations
Date:   Mon, 28 Jan 2019 00:50:42 -0800
Message-Id: <20190128085045.6504-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The x86, arm, and arm64 asm implementations of crct10dif are very
difficult to understand partly because many of the comments, labels, and
macros are named incorrectly: the lengths mentioned are usually off by a
factor of two from the actual code.  Many other things are unnecessarily
convoluted as well, e.g. there are many more fold constants than
actually needed and some aren't fully reduced.

This series therefore cleans up all these implementations to be much
more maintainable.  I also made some small optimizations where I saw
opportunities, resulting in slightly better performance.

This is based on top of the pending patches from Ard Biesheuvel.

Eric Biggers (3):
  crypto: x86/crct10dif-pcl - cleanup and optimizations
  crypto: arm/crct10dif-ce - cleanup and optimizations
  crypto: arm64/crct10dif-ce - cleanup and optimizations

 arch/arm/crypto/crct10dif-ce-core.S     | 546 +++++++--------
 arch/arm/crypto/crct10dif-ce-glue.c     |   2 +-
 arch/arm64/crypto/crct10dif-ce-core.S   | 496 +++++++-------
 arch/arm64/crypto/crct10dif-ce-glue.c   |   4 +-
 arch/x86/crypto/crct10dif-pcl-asm_64.S  | 848 +++++++++---------------
 arch/x86/crypto/crct10dif-pclmul_glue.c |   3 +-
 6 files changed, 794 insertions(+), 1105 deletions(-)

-- 
2.20.1

