Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E79AC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Nov 2021 12:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhKWMlZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Nov 2021 07:41:25 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:59664 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbhKWMlX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Nov 2021 07:41:23 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 30113218E0;
        Tue, 23 Nov 2021 12:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637671094; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Bsvh3HxlZEQtzauvX7vByaoix125/xd1MhAqKeshESE=;
        b=AEHmH0lHpoxf9eMr1AZFc6SC2SbzgWP4GcIq1dTp3npNZ0selWdzWD4Mm7ILOVLuuYdD7j
        Ks4DQbShPwKvNpj/Y4vi2N0hfVOCVux35xcONKcdArZUNj3P9hVE6gL0VIujd3rvgOguPi
        6Xd7pv5Q7T37Vj0HACRDSNx8i09olZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637671094;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Bsvh3HxlZEQtzauvX7vByaoix125/xd1MhAqKeshESE=;
        b=gEM9jhUfy1IX+GKl5QmStmosYzw/tW7GmHF6K4NXxkf1h7oMWto6dYMfuBb35XiDx6wsfY
        VZ7b+RLM78osrZCg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id CEC91A3B89;
        Tue, 23 Nov 2021 12:38:12 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 8FDA751918BB; Tue, 23 Nov 2021 13:38:12 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCHv7 00/12] nvme: In-band authentication support
Date:   Tue, 23 Nov 2021 13:37:49 +0100
Message-Id: <20211123123801.73197-1-hare@suse.de>
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

Changes to v6:
- Use 'u8' for DH group id and hash id
- Use 'struct nvme_dhchap_key'
- Rename variables to drop 'DHCHAP'
- Include reviews from Chaitanya

Changes to v5:
- Unify nvme_auth_generate_key()
- Unify nvme_auth_extract_key()
- Fixed bug where re-authentication with wrong controller key would not fail
- Include reviews from Sagi

Changes to v4:
- Validate against blktest suite
- Fixup base64 decoding
- Transform secret with correct hmac algorithm

Changes to v3:
- Renamed parameter to 'dhchap_ctrl_key'
- Fixed bi-directional authentication
- Included reviews from Sagi
- Fixed base64 algorithm for transport encoding

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
 crypto/ffdhe_helper.c                  |  880 ++++++++++++++
 crypto/kpp.c                           |    6 +
 crypto/shash.c                         |    6 +
 drivers/nvme/host/Kconfig              |   12 +
 drivers/nvme/host/Makefile             |    1 +
 drivers/nvme/host/auth.c               | 1553 ++++++++++++++++++++++++
 drivers/nvme/host/auth.h               |   41 +
 drivers/nvme/host/core.c               |  141 ++-
 drivers/nvme/host/fabrics.c            |   83 +-
 drivers/nvme/host/fabrics.h            |    7 +
 drivers/nvme/host/nvme.h               |   31 +
 drivers/nvme/host/rdma.c               |    1 +
 drivers/nvme/host/tcp.c                |    1 +
 drivers/nvme/host/trace.c              |   32 +
 drivers/nvme/target/Kconfig            |   13 +
 drivers/nvme/target/Makefile           |    1 +
 drivers/nvme/target/admin-cmd.c        |    4 +
 drivers/nvme/target/auth.c             |  525 ++++++++
 drivers/nvme/target/configfs.c         |  138 ++-
 drivers/nvme/target/core.c             |   10 +
 drivers/nvme/target/fabrics-cmd-auth.c |  513 ++++++++
 drivers/nvme/target/fabrics-cmd.c      |   30 +-
 drivers/nvme/target/nvmet.h            |   73 ++
 include/crypto/ffdhe.h                 |   24 +
 include/crypto/hash.h                  |    2 +
 include/crypto/kpp.h                   |    2 +
 include/linux/base64.h                 |   16 +
 include/linux/nvme.h                   |  188 ++-
 lib/Makefile                           |    2 +-
 lib/base64.c                           |  103 ++
 32 files changed, 4436 insertions(+), 12 deletions(-)
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

