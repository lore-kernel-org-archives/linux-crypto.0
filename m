Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B11C43217
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Dec 2021 15:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358939AbhLBP1d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Dec 2021 10:27:33 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:42080 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358938AbhLBP1c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Dec 2021 10:27:32 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9A9B71FDFC;
        Thu,  2 Dec 2021 15:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638458648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=3jrv8XXfzAYeFjpUwXdrOdb6w3FpaD0XbnQueuej7IU=;
        b=UigLECO3ezIGusjqzcpDNd788/GNTSui1hfE3raDsejYUyCXQdSl/k8e59SxZzioy9zank
        0paZFZ5q6pL5DcRZHfY0Y74rq+3AJ7Ai13bCt4cX9ribk9knDR/3IhXnxkD7iV0DLn8wai
        m+poG4fo0R/5eWdMIlnUdeLe2VcU0u8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638458648;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=3jrv8XXfzAYeFjpUwXdrOdb6w3FpaD0XbnQueuej7IU=;
        b=3uPFjB+ZL9MGblVoMQMimn8eAlw2F1Ae6st+d0T4PTYk8bdHdQpHHratiSE/US26+wQ6xV
        j2dtxavVV59MqSAg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id DFFF1A3B8A;
        Thu,  2 Dec 2021 15:24:07 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 1B6C55191DE8; Thu,  2 Dec 2021 16:24:07 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCHv8 00/12] nvme: In-band authentication support
Date:   Thu,  2 Dec 2021 16:23:46 +0100
Message-Id: <20211202152358.60116-1-hare@suse.de>
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

The ffdhe implementation given here is preliminary; there is a
patchset from Nicolai Stange to implement FFDHE as a 'real'
crypto algorithm, and also implements ephemeral keys for in-kernel DH.
Once that is merged I'll be updating this patchset.

Also note that this is just for in-band authentication. Secure
concatenation (ie starting TLS with the negotiated parameters) is not
implemented; one would need to update the kernel TLS implementation
for this, which at this time is beyond scope.

The nvme-cli support has already been merged; please use the latest
nvme-cli git repository to build the most recent version.

A copy of this patchset can be found at
git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel
branch auth.v8

As usual, comments and reviews are welcome.

Changes to v7:
- Space out hash list and dhgroup list in nvme negotiate data
  to be conformant with the spec
- Update sequence number handling to start with a random value and
  ignore '0' as mandated by the spec
- Update nvme_auth_generate_key to return the key as suggested by Sagi
- Add nvmet_parse_fabrics_io_cmd() as suggested by hch

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
  nvmet: parse fabrics commands on io queues
  nvmet: Implement basic In-Band Authentication
  nvmet-auth: Diffie-Hellman key exchange support
  nvmet-auth: expire authentication sessions

 crypto/Kconfig                         |    8 +
 crypto/Makefile                        |    1 +
 crypto/ffdhe_helper.c                  |  880 +++++++++++++
 crypto/kpp.c                           |    6 +
 crypto/shash.c                         |    6 +
 drivers/nvme/host/Kconfig              |   12 +
 drivers/nvme/host/Makefile             |    1 +
 drivers/nvme/host/auth.c               | 1569 ++++++++++++++++++++++++
 drivers/nvme/host/auth.h               |   42 +
 drivers/nvme/host/core.c               |  141 ++-
 drivers/nvme/host/fabrics.c            |   83 +-
 drivers/nvme/host/fabrics.h            |    7 +
 drivers/nvme/host/nvme.h               |   31 +
 drivers/nvme/host/rdma.c               |    1 +
 drivers/nvme/host/tcp.c                |    1 +
 drivers/nvme/host/trace.c              |   32 +
 drivers/nvme/target/Kconfig            |   13 +
 drivers/nvme/target/Makefile           |    1 +
 drivers/nvme/target/admin-cmd.c        |    6 +-
 drivers/nvme/target/auth.c             |  523 ++++++++
 drivers/nvme/target/configfs.c         |  138 ++-
 drivers/nvme/target/core.c             |   15 +
 drivers/nvme/target/fabrics-cmd-auth.c |  534 ++++++++
 drivers/nvme/target/fabrics-cmd.c      |   55 +-
 drivers/nvme/target/nvmet.h            |   75 +-
 include/crypto/ffdhe.h                 |   24 +
 include/crypto/hash.h                  |    2 +
 include/crypto/kpp.h                   |    2 +
 include/linux/base64.h                 |   16 +
 include/linux/nvme.h                   |  188 ++-
 lib/Makefile                           |    2 +-
 lib/base64.c                           |  103 ++
 32 files changed, 4503 insertions(+), 15 deletions(-)
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

