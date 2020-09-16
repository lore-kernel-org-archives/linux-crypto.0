Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992E2C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 06:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60B03208E4
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 06:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600236871;
	bh=fBezOIWEZDC7yHPoih67DEaz66vwTKuktlg2OLr8V/I=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Mc7sBlgy7a0tRXZIL5WYhxMxPpBY1Nz+aoNBKSYiyUDbJw2OBaLFa4E+d0TqR3NX5
	 VA29QCWcCWFRLf02rmO4moVSAhauxmC//bGRDbV7vbA0FEGdD+5/53wzJo8d4JogAQ
	 hZc5gj/wMb75bcK1hwCJCBL6mKnmvxhaTjfiE3vs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgIPGOa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 02:14:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726093AbgIPGO3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 02:14:29 -0400
Received: from e123331-lin.nice.arm.com (adsl-245.46.190.88.tellas.gr [46.190.88.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3389C22204;
        Wed, 16 Sep 2020 06:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600236869;
        bh=fBezOIWEZDC7yHPoih67DEaz66vwTKuktlg2OLr8V/I=;
        h=From:To:Cc:Subject:Date:From;
        b=OaBBrKqkpIW/mdEmqqmwl3U005l3KxWgUqlSMH78ps1bbPpPBMjMndD/VM7wtlQJv
         nFbMaPozdSjB555B+CrrjrAc14oJ65mP6tPBxfqd4LgHdNmPOCaNE/rskzHuZc4aFD
         dDbMWjbXQZVFsxUm8QXtv1ec6t1fzlDMQE2UvirU=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Stefan Agner <stefan@agner.ch>,
        Peter Smith <Peter.Smith@arm.com>
Subject: [PATCH v2 0/2] crypto: arm/sha-neon - avoid ADRL instructions
Date:   Wed, 16 Sep 2020 09:14:16 +0300
Message-Id: <20200916061418.9197-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove some occurrences of ADRL in the SHA NEON code adopted from the
OpenSSL project.

I will leave it to the Clang folks to decide whether this needs to be
backported and how far, but a Cc stable seems reasonable here.

Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Stefan Agner <stefan@agner.ch>
Cc: Peter Smith <Peter.Smith@arm.com>

Ard Biesheuvel (2):
  crypto: arm/sha256-neon - avoid ADRL pseudo instruction
  crypto: arm/sha512-neon - avoid ADRL pseudo instruction

 arch/arm/crypto/sha256-armv4.pl       | 4 ++--
 arch/arm/crypto/sha256-core.S_shipped | 4 ++--
 arch/arm/crypto/sha512-armv4.pl       | 4 ++--
 arch/arm/crypto/sha512-core.S_shipped | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.17.1

