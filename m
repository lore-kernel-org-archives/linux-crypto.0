Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5A3C432BE
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Aug 2021 12:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 086B360EFF
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Aug 2021 12:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239115AbhHJMnQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Aug 2021 08:43:16 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:40758 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240713AbhHJMnP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Aug 2021 08:43:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1C0562205B;
        Tue, 10 Aug 2021 12:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628599372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=7TVDZAujBf7sFXgpvFDzO1aGEdIfIwzMjsRhQOMUQwo=;
        b=eH5whLwpBBtkeVGA5erzBsS4CVSDqYbCLEhgMQ1QThRwz+h17KYCkOBQyc7pr/AclHaNfz
        xqwyHKpqLwRWky7gsxXByFojp7xUC+MZJ5OIezyY0I2oDKNEln1SP4n9iTagR79cxsrYJ8
        rXZ9fHg91MMKcUKSsu0+f/GWQoiri+w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628599372;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=7TVDZAujBf7sFXgpvFDzO1aGEdIfIwzMjsRhQOMUQwo=;
        b=eAC0vzIta0tLf0R2qApvcnMGvTYMa5/NnAC4UbEdBOLdzGJV4i7ywFusl/2ocQgo/W2Xfs
        d97U/KD0xEXsVWDA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 9B006A3B8C;
        Tue, 10 Aug 2021 12:42:50 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 50C32518C540; Tue, 10 Aug 2021 14:42:50 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 00/13] nvme: In-band authentication support
Date:   Tue, 10 Aug 2021 14:42:17 +0200
Message-Id: <20210810124230.12161-1-hare@suse.de>
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

Changes to the original submission:
- Included reviews from Vladislav
- Included reviews from Sagi
- Implemented re-authentication support
- Fixed up key handling

Hannes Reinecke (13):
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
  nvme: add non-standard ECDH and curve25517 algorithms

 crypto/Kconfig                         |    8 +
 crypto/Makefile                        |    1 +
 crypto/ffdhe_helper.c                  |  880 ++++++++++++++
 crypto/kpp.c                           |    6 +
 crypto/shash.c                         |    6 +
 drivers/nvme/host/Kconfig              |   12 +
 drivers/nvme/host/Makefile             |    1 +
 drivers/nvme/host/auth.c               | 1470 ++++++++++++++++++++++++
 drivers/nvme/host/auth.h               |   33 +
 drivers/nvme/host/core.c               |   79 +-
 drivers/nvme/host/fabrics.c            |   77 +-
 drivers/nvme/host/fabrics.h            |    6 +
 drivers/nvme/host/nvme.h               |   30 +
 drivers/nvme/host/trace.c              |   32 +
 drivers/nvme/target/Kconfig            |   10 +
 drivers/nvme/target/Makefile           |    1 +
 drivers/nvme/target/admin-cmd.c        |    4 +
 drivers/nvme/target/auth.c             |  442 +++++++
 drivers/nvme/target/configfs.c         |  102 +-
 drivers/nvme/target/core.c             |   10 +
 drivers/nvme/target/fabrics-cmd-auth.c |  506 ++++++++
 drivers/nvme/target/fabrics-cmd.c      |   30 +-
 drivers/nvme/target/nvmet.h            |   70 ++
 include/crypto/ffdhe.h                 |   24 +
 include/crypto/hash.h                  |    2 +
 include/crypto/kpp.h                   |    2 +
 include/linux/base64.h                 |   16 +
 include/linux/nvme.h                   |  188 ++-
 lib/Makefile                           |    2 +-
 lib/base64.c                           |  115 ++
 30 files changed, 4154 insertions(+), 11 deletions(-)
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

