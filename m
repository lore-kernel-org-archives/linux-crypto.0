Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2BFAC4CECE
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 02:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A642721882
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 02:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571107543;
	bh=f9P3u6hsFtkLi5QBoLm8rjSE7jsCU7aMKmz2VezgSTs=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=jpgfrPAWcFxmRezu6cY6ycsTR8wI3Cfy5y3saBm8/9MKTwIAweZfPmvCGalL5yHgG
	 eGGpBjDzyDTzTwTBCLEWjN/VX73X5C5NmcYujPuGN1VLeLrWtxKNJdZJinQS8i/rng
	 JTnt4lYhwOfKkz3gGEosBsIGvF+c3VVMW1cW0uYQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfJOCpm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 22:45:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727212AbfJOCpm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 22:45:42 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9824620673;
        Tue, 15 Oct 2019 02:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571107541;
        bh=f9P3u6hsFtkLi5QBoLm8rjSE7jsCU7aMKmz2VezgSTs=;
        h=From:To:Cc:Subject:Date:From;
        b=MCzBL4FpKgSGqTsvWG+HoUAhZSo42Eyh/yqcFn81sUNysWMN8woq1aFOBvDK0IYaI
         ASaC6h51Ortg4rUyR28gpZW0BkqS308his4n7VAAVdHVqWM96ez81h5su6BYQmAvMI
         ALubkXHg0ar+2dlVoW/mKb+YVB78Tvco8hRR1VaI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Markus Stockhausen <stockhausen@collogia.de>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 0/3] crypto: powerpc - convert SPE AES algorithms to skcipher API
Date:   Mon, 14 Oct 2019 19:45:14 -0700
Message-Id: <20191015024517.52790-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series converts the glue code for the PowerPC SPE implementations
of AES-ECB, AES-CBC, AES-CTR, and AES-XTS from the deprecated
"blkcipher" API to the "skcipher" API.  This is needed in order for the
blkcipher API to be removed.

Patch 1-2 are fixes.  Patch 3 is the actual conversion.

Tested with:

	export ARCH=powerpc CROSS_COMPILE=powerpc-linux-gnu-
	make mpc85xx_defconfig
	cat >> .config << EOF
	# CONFIG_MODULES is not set
	# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
	CONFIG_DEBUG_KERNEL=y
	CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
	CONFIG_CRYPTO_AES=y
	CONFIG_CRYPTO_CBC=y
	CONFIG_CRYPTO_CTR=y
	CONFIG_CRYPTO_ECB=y
	CONFIG_CRYPTO_XTS=y
	CONFIG_CRYPTO_AES_PPC_SPE=y
	EOF
	make olddefconfig
	make -j32
	qemu-system-ppc -M mpc8544ds -cpu e500 -nographic \
		-kernel arch/powerpc/boot/zImage \
		-append cryptomgr.fuzz_iterations=1000

Note that xts-ppc-spe still fails the comparison tests due to the lack
of ciphertext stealing support.  This is not addressed by this series.

Changed since v1:

- Split fixes into separate patches.

- Made ppc_aes_setkey_skcipher() call ppc_aes_setkey(), rather than
  creating a separate expand_key() function.  This keeps the code
  shorter.

Eric Biggers (3):
  crypto: powerpc - don't unnecessarily use atomic scatterwalk
  crypto: powerpc - don't set ivsize for AES-ECB
  crypto: powerpc - convert SPE AES algorithms to skcipher API

 arch/powerpc/crypto/aes-spe-glue.c | 389 ++++++++++++-----------------
 crypto/Kconfig                     |   1 +
 2 files changed, 166 insertions(+), 224 deletions(-)

-- 
2.23.0

