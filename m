Return-Path: <SRS0=phSf=Q6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1014EC43381
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Feb 2019 06:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA50F20854
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Feb 2019 06:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550904897;
	bh=Fi5RcKlY33Q/JZGZ95BKFi0vQ+WhbtLEdR4ENFo+40s=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=RpOIXK57Eth7B1a4LMKXeXckYsHPwuq8H+HAnxXM7pkQDHyZSNG+T+QMNLNvv1Mlb
	 DRui5iXDraMrxDuZlBTscADT0zx+ahOT3sF5ectosmWXR2FDZr8mdXQCceqAXOgVXZ
	 qxM65FGMLOxDJqjNpCL7zlh3o3gBBIEbW1tj3i40=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfBWGy5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Feb 2019 01:54:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfBWGy4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Feb 2019 01:54:56 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13461206B6;
        Sat, 23 Feb 2019 06:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550904896;
        bh=Fi5RcKlY33Q/JZGZ95BKFi0vQ+WhbtLEdR4ENFo+40s=;
        h=From:To:Cc:Subject:Date:From;
        b=P7m68T8ccurxE4wMdJyrygKuwFNMQK54rgWSwkb8gEp+Arghq7unl+fVdQ5WMrJ79
         XZQK6ezLeqU1Gojbr5V091WpS8JHgUnlM3yQyu+eYtUbFrUakN8tViEkpoBOm7F+mV
         R3JUogbIqnTPu9lp0D7luMJpb2qusMtEpJdDtHf4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] crypto: arm64/chacha - fix for big endian
Date:   Fri, 22 Feb 2019 22:54:06 -0800
Message-Id: <20190223065408.6279-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I ran the crypto self-tests on big endian arm and arm64 kernels in QEMU.
The arm64 implementation of ChaCha (and XChaCha) is failing, so this
series fixes it.

Please consider sending to Linus for v5.0 if there's time, as this fixes
commits that are new in v5.0.

Eric Biggers (2):
  crypto: arm64/chacha - fix chacha_4block_xor_neon() for big endian
  crypto: arm64/chacha - fix hchacha_block_neon() for big endian

 arch/arm64/crypto/chacha-neon-core.S | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

-- 
2.20.1

