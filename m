Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02BC6C4CEC9
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 22:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C76F9214AF
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 22:28:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q1B6ZxoA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbfIRW2x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Sep 2019 18:28:53 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38284 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728823AbfIRW2w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Sep 2019 18:28:52 -0400
Received: by mail-ed1-f68.google.com with SMTP id a23so1393158edv.5
        for <linux-crypto@vger.kernel.org>; Wed, 18 Sep 2019 15:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=u9r2H5oTJTlz18m4wb3uliEwNf5zQTrl6vtAV/D7/5k=;
        b=q1B6ZxoAuag7I1kpSQnWegLrTXqIA6EPPUuHOXaAH0y3r/nxRLmOdf/+PJgqmN4XAb
         nhAyi56Gy3xNP2dIHsTxfQcy5O00rXwSyOPIXxec633mz5RxMhdNZAQ3PI9mswLdcuzb
         DQ3VwDSY/24jq9xJc63CbMbw0kC35Rl6MDvVBh1K1JVmXnBMnZMg4deLLYpo6G+U+3U0
         yTvB087tSH+YzfgWVPW9fHV4G8ElrBg7Dh9gnAzwsApzyrF3jkixMb/H4RxPefF7Yhip
         XrMGl29EnkfkvbyFXjO3nME6DtxVK/DG2zeKsMo9j976SiHlC6By2/yeyaxNL0W6w8l5
         l0Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=u9r2H5oTJTlz18m4wb3uliEwNf5zQTrl6vtAV/D7/5k=;
        b=tHPXzHWSrKuTDBYKWvDjMt/Bbg7XPwgqyLA83sgukYEt/Kow0nCNtMK2Nf+wr/Fmrf
         ryfGjOHbwVgWu84VbJT9WktV/azKf0ao/BXbpYXR+G4i8sQvIOsBw67UejipOA3O3EJb
         vfMvJ+iVJzpJzblCRW2G4BnuLT9fCrnv3PpViMCCNEZu0M5icqy3hmkdKAnBwJ42k8oq
         xGUTtikAny++yFO63Ov6agiV+wG3lZ2ZaJkanH0VHeqwGQ+vaYk+x1FKfUeBgZYYVxLV
         m/LvUyR4scgJjrhzW7DkEJskzUQtg/dBUat6vc6zSi+VriwpIOOXOxKFy+6oiZtUZwZu
         g0Ow==
X-Gm-Message-State: APjAAAVGgourFjW1KDtPSZLAdLJxOFND9epg4UXYxtMWvrm+0q34V471
        lFmHmtaw/tS956/26nvQ9chD446d
X-Google-Smtp-Source: APXvYqwsSKQ6gfT7eHwVDOAQPPh/1rS9Bm0+UJWSQx1kncf3aoyBACRM51Dcwvoge59tzui99dBuoA==
X-Received: by 2002:a50:a8c5:: with SMTP id k63mr12864241edc.122.1568845729494;
        Wed, 18 Sep 2019 15:28:49 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id a3sm811951eje.90.2019.09.18.15.28.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 15:28:48 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv4 0/3] crypto: inside-secure: Add support for the Chacha20 skcipher and the Chacha20-Poly1305 AEAD suites
Date:   Wed, 18 Sep 2019 23:25:55 +0200
Message-Id: <1568841958-14622-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Extend driver support with chacha20, rfc7539(chacha20,poly1305) and
rfc7539esp(chacha20,poly1305) ciphers.
The patchset has been tested with the eip197c_iesb and eip197c_iewxkbc
configurations on the Xilinx VCU118 development board, including the
crypto extra tests.

Note that this patchset applies on top of the earlier submitted
"Add support for the CBCMAC" series.

changes since v1:
- rebased on top of DES library changes done on cryptodev/master
- fixed crypto/Kconfig so that generic fallback is compiled as well

changes since v2:
- made switch entry SAFEXCEL_AES explit and added empty default, as
  requested by Antoine Tenart. Also needed to make SM4 patches apply.

changes since v3:
- for rfc7539 and rfc7539esp, allow more (smaller) AAD lenghts to be
  handled by the hardware instead of the fallback cipher (this allows
  running the tcrypt performance tests on the actual hardware)

Pascal van Leeuwen (3):
  crypto: inside-secure - Added support for the CHACHA20 skcipher
  crypto: inside-secure - Add support for the Chacha20-Poly1305 AEAD
  crypto: Kconfig - Add CRYPTO_CHACHA20POLY1305 to CRYPTO_DEV_SAFEXCEL

 drivers/crypto/Kconfig                         |   3 +-
 drivers/crypto/inside-secure/safexcel.c        |   3 +
 drivers/crypto/inside-secure/safexcel.h        |  11 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 336 ++++++++++++++++++++++++-
 4 files changed, 339 insertions(+), 14 deletions(-)

--
1.8.3.1
