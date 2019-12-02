Return-Path: <SRS0=ccn8=ZY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F47C432C0
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Dec 2019 21:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8FCB206F0
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Dec 2019 21:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575322973;
	bh=N8k3B4WGDHNEZak+X7sgy4SpFPP3zLU12xO8+O5gvQQ=;
	h=From:To:Subject:Date:List-ID:From;
	b=1snMAfUuPHfHq2jXyS6S+amMqXe31VviEJvObkcM++ioIa6x6sXQXddEp1x3KF1l9
	 x/svt0B9od7JmE3LUls8KjpncHktiAPHZj0Avs7O5viZ5z6xPGuvZQs477BSU53dyY
	 L0kbfrq2nvn0vNpSDNNrt2cZO5h6BThT2QA5LtAQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfLBVmx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Dec 2019 16:42:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfLBVmx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Dec 2019 16:42:53 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7579E206F0
        for <linux-crypto@vger.kernel.org>; Mon,  2 Dec 2019 21:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575322972;
        bh=N8k3B4WGDHNEZak+X7sgy4SpFPP3zLU12xO8+O5gvQQ=;
        h=From:To:Subject:Date:From;
        b=RDtELOdpIBSG8ZHdqjiVEff97OSNh8yIAQe8f27/Wnb2Fr/SeZOR1gWA1NM1LTxmA
         TJDTy8wzpemWm901Nkh63eEX9Z2TcN6MS+pyoWtZuHzG8nVuasL5wAhDrnCWQtEQTR
         dHuUHnrDz+YL/21sMU7RsQvfHP9Aq9W+ojNtjA+w=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 0/2] crypto: api - remove crypto_tfm::crt_u
Date:   Mon,  2 Dec 2019 13:42:28 -0800
Message-Id: <20191202214230.164997-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series removes the per-algorithm-type union from struct crypto_tfm
now that its only remaining users are the "compress" and "cipher"
algorithm types, and it's not really needed for them.

This shrinks every crypto transform for every algorithm by 28 bytes on
64-bit platforms (12 bytes on 32-bit), and also removes some code.

Note that the new-style strongly-typed algorithms (i.e. everything other
than "compress" and "cipher") don't need crt_u, since they embed struct
crypto_tfm in a per-algorithm-type custom struct instead.

Eric Biggers (2):
  crypto: compress - remove crt_u.compress (struct compress_tfm)
  crypto: cipher - remove crt_u.cipher (struct cipher_tfm)

 crypto/api.c           | 15 +------
 crypto/cipher.c        | 92 +++++++++++++++++-------------------------
 crypto/compress.c      | 31 ++++++--------
 crypto/internal.h      |  3 --
 include/linux/crypto.h | 91 ++++++-----------------------------------
 5 files changed, 61 insertions(+), 171 deletions(-)

-- 
2.24.0.393.g34dc348eaf-goog

