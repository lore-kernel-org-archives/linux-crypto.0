Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9ACC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 06:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EE3E61186
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 06:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhIJGou (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Sep 2021 02:44:50 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:42220 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbhIJGou (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Sep 2021 02:44:50 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 269EE22403;
        Fri, 10 Sep 2021 06:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631256219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=QEJRGB5eJSLBJyT+VeKEGPTZToodWTZ+5+CrranJ4Ig=;
        b=rAb1drNfkOxPrbmt3BhadXDkD7hVdV52zWnCWC5JOu7qz2xXRa8fj/vFsQze5Rs9oHKk4k
        nQTfUWEYboj06ifqcfmmMXcfmEOj32GDNe7EdR8IZxFpaf0HmXCZq3zYgwMxnGXZXLnFUR
        9tWZDgDgOP0GGvpXAOKRnN9bL+ctssA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631256219;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=QEJRGB5eJSLBJyT+VeKEGPTZToodWTZ+5+CrranJ4Ig=;
        b=9V+GrQcBe3Q6bm9p3MCM1T6AvMEVpGLbDbSJSms80eexfJnw0SiUmfWLPTMgGGUy4AzIHb
        UZOz6pLJjRtPlYCQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id D03DEA3B88;
        Fri, 10 Sep 2021 06:43:36 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 8AB2E518E31A; Fri, 10 Sep 2021 08:43:36 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 00/12] nvme: In-band authentication support
Date:   Fri, 10 Sep 2021 08:43:10 +0200
Message-Id: <20210910064322.67705-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi all,

recent updates to the NVMe spec have added definitions for in-band
authentication, and seeing that it provides some real benefit
especially for NVMe-TCP here's an attempt to implement it.

Tricky bit here is that the specification orients itself on TLS 1.3,
but supports only the FFDHE groups. Which of course the kernel doesn't
support. I've been able to come up with a patch for this, but as this
is my first attempt to fix anything in the crypto area I would invite
people more familiar with these matters to have a look.

Also note that this is just for in-band authentication. Secure
concatenation (ie starting TLS with the negotiated parameters) is not
implemented; one would need to update the kernel TLS implementation
for this, which at this time is beyond scope.

As usual, comments and reviews are welcome.

Changes to v2:
- Dropped non-standard algorithms
- Reworked base64 based on fs/crypto/fname.c
- Fixup crash with no keys

Changes to the original submission:
- Included reviews from Vladislav
- Included reviews from Sagi
- Implemented re-authentication support
- Fixed up key handling

Hannes Reinecke (12):
  crypto: add crypto_has_shash()
  crypto: add crypto_has_kpp()
  crypto/ffdhe: Finite Field DH Ephemeral Parameters
  lib/base64: RFC4648-compliant base64 encoding
  nvme: add definitions for NVMe In-Band authentication
  nvme-fabrics: decode 'authentication required' connect error
  nvme: Implement In-Band authentication
  nvme-auth: Diffie-Hellman key exchange support
  nvmet: Parse fabrics commands on all queues
  nvmet: Implement basic In-Band Authentication
  nvmet-auth: Diffie-Hellman key exchange support
  nvmet-auth: expire authentication sessions

 crypto/Kconfig                         |    8 +
 crypto/Makefile                        |    1 +
 crypto/ffdhe_helper.c                  |  880 +++++++++++++++
 crypto/kpp.c                           |    6 +
 crypto/shash.c                         |    6 +
 drivers/nvme/host/Kconfig              |   13 +
 drivers/nvme/host/Makefile             |    1 +
 drivers/nvme/host/auth.c               | 1441 ++++++++++++++++++++++++
 drivers/nvme/host/auth.h               |   33 +
 drivers/nvme/host/core.c               |   79 +-
 drivers/nvme/host/fabrics.c            |   77 +-
 drivers/nvme/host/fabrics.h            |    6 +
 drivers/nvme/host/nvme.h               |   30 +
 drivers/nvme/host/trace.c              |   32 +
 drivers/nvme/target/Kconfig            |   12 +
 drivers/nvme/target/Makefile           |    1 +
 drivers/nvme/target/admin-cmd.c        |    4 +
 drivers/nvme/target/auth.c             |  442 ++++++++
 drivers/nvme/target/configfs.c         |  102 +-
 drivers/nvme/target/core.c             |   10 +
 drivers/nvme/target/fabrics-cmd-auth.c |  506 +++++++++
 drivers/nvme/target/fabrics-cmd.c      |   30 +-
 drivers/nvme/target/nvmet.h            |   70 ++
 include/crypto/ffdhe.h                 |   24 +
 include/crypto/hash.h                  |    2 +
 include/crypto/kpp.h                   |    2 +
 include/linux/base64.h                 |   16 +
 include/linux/nvme.h                   |  186 ++-
 lib/Makefile                           |    2 +-
 lib/base64.c                           |  100 ++
 30 files changed, 4111 insertions(+), 11 deletions(-)
 create mode 100644 crypto/ffdhe_helper.c
 create mode 100644 drivers/nvme/host/auth.c
 create mode 100644 drivers/nvme/host/auth.h
 create mode 100644 drivers/nvme/target/auth.c
 create mode 100644 drivers/nvme/target/fabrics-cmd-auth.c
 create mode 100644 include/crypto/ffdhe.h
 create mode 100644 include/linux/base64.h
 create mode 100644 lib/base64.c

-- 
2.29.2

