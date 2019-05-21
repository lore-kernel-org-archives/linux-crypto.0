Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23254C04AAF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 13:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9425217D9
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 13:34:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="v5L0ne9l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbfEUNeI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 09:34:08 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:51174 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727986AbfEUNeI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 09:34:08 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 457cDY6p7wz9v1nn;
        Tue, 21 May 2019 15:34:05 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=v5L0ne9l; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id n2tkmpse9POB; Tue, 21 May 2019 15:34:05 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 457cDY5mh8z9v1nh;
        Tue, 21 May 2019 15:34:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1558445645; bh=4k6PLmXdY0SvqmTbZLBIzVnywVWKh7ktdtBKLg7zhR0=;
        h=From:Subject:To:Cc:Date:From;
        b=v5L0ne9l7IeJ6j1RlEtDlB3tznGmL91nYxqqzqAQ9628UCkLw7a61V7lU7BlOMeaI
         b0O1Pfn3sC/WTzObfEfPlukMzbiQDm5GZ/6SBtxI8+0WZYgmM+uRDgWxmfFVG8vyhS
         VJTPMoNWaUD4+epVtwrFHblur8GZGQQvo7qCoHJ0=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 455248B80D;
        Tue, 21 May 2019 15:34:07 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 45QZsARu0znr; Tue, 21 May 2019 15:34:07 +0200 (CEST)
Received: from po16846vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 0F4598B803;
        Tue, 21 May 2019 15:34:07 +0200 (CEST)
Received: by po16846vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id A260268458; Tue, 21 May 2019 13:34:06 +0000 (UTC)
Message-Id: <cover.1558445259.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v1 00/15] Fixing selftests failure on Talitos driver
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Tue, 21 May 2019 13:34:06 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Several test failures have popped up following recent changes to crypto
selftests.

This series fixes (most of) them.

The last three patches are trivial cleanups.

Christophe Leroy (15):
  crypto: talitos - fix skcipher failure due to wrong output IV
  crypto: talitos - rename alternative AEAD algos.
  crypto: talitos - reduce max key size for SEC1
  crypto: talitos - check AES key size
  crypto: talitos - fix CTR alg blocksize
  crypto: talitos - check data blocksize in ablkcipher.
  crypto: talitos - fix ECB algs ivsize
  crypto: talitos - Do not modify req->cryptlen on decryption.
  crypto: talitos - HMAC SNOOP NO AFEU mode requires SW icv checking.
  crypto: talitos - properly handle split ICV.
  crypto: talitos - Align SEC1 accesses to 32 bits boundaries.
  crypto: talitos - fix AEAD processing.
  Revert "crypto: talitos - export the talitos_submit function"
  crypto: talitos - use IS_ENABLED() in has_ftr_sec1()
  crypto: talitos - use SPDX-License-Identifier

 drivers/crypto/talitos.c | 281 ++++++++++++++++++++++-------------------------
 drivers/crypto/talitos.h |  45 ++------
 2 files changed, 139 insertions(+), 187 deletions(-)

-- 
2.13.3

