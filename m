Return-Path: <SRS0=xIDj=ZV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFBBC432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8F9421781
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575051857;
	bh=n+NkmqD27fWos2KHKNDd5pNR8TQ8HFSLTHEYzGWVWg8=;
	h=From:To:Subject:Date:List-ID:From;
	b=WoxyvRiUc/KkFhWZH2AJcJa6xG/kKXhJTmMk7HCbuNtoNDM7asglP6W9l0uT2IuHx
	 keRe90pSMFrg/Gy343gZdBv4n0vgQ+y3r+Rf/N9Hqhfur2yDaTQeyJZDoVI+K5aoQl
	 DVPXLNZGikY4op/aAd56wSChOFX+C8G2YUOGLugA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfK2SYR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Nov 2019 13:24:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbfK2SYR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Nov 2019 13:24:17 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A105B21736
        for <linux-crypto@vger.kernel.org>; Fri, 29 Nov 2019 18:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575051856;
        bh=n+NkmqD27fWos2KHKNDd5pNR8TQ8HFSLTHEYzGWVWg8=;
        h=From:To:Subject:Date:From;
        b=2os+iu2gz8NGPOVdxiLkBCNeMSjMeNUw4YBeUTvvAI6YCEhbO7Hn1NMaWSnTcUuXE
         Jk3jesGEGVpd2vaptA22GP1dbY6KZ2a2ElEykp9LqlHlv98TCC+gR3UeYb1Osxnl/M
         c2IuyqaTQ1vGu2quqanOvkB9UmfNy2qjfbSWDfy4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 0/6] crypto: skcipher - simplifications due to {,a}blkcipher removal
Date:   Fri, 29 Nov 2019 10:23:02 -0800
Message-Id: <20191129182308.53961-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series makes some simplifications to the skcipher algorithm type
that are possible now that blkcipher and ablkcipher (and hence also the
compatibility code to expose them via the skcipher API) were removed.

Eric Biggers (6):
  crypto: skcipher - remove crypto_skcipher::ivsize
  crypto: skcipher - remove crypto_skcipher::keysize
  crypto: skcipher - remove crypto_skcipher::setkey
  crypto: skcipher - remove crypto_skcipher::encrypt
  crypto: skcipher - remove crypto_skcipher::decrypt
  crypto: skcipher - remove crypto_skcipher_extsize()

 crypto/skcipher.c         | 22 ++++++----------------
 crypto/testmgr.c          | 10 ++++++----
 fs/ecryptfs/crypto.c      |  2 +-
 fs/ecryptfs/keystore.c    |  4 ++--
 include/crypto/skcipher.h | 20 +++++---------------
 5 files changed, 20 insertions(+), 38 deletions(-)

-- 
2.24.0

