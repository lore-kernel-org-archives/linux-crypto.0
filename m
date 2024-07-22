Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A68166308
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jul 2024 14:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721658121; cv=none; b=AmUiBQqT+zC0q8a8SU+5012cgI8MZZRfDVR7xK70nX7vJaaWusjHKtaAcmYzr5u+cACXG3JOv/rOnDaUH2CeW8VOS6YCQ2OEXZl2slsudpOBQClqEP22msVrGopwZ7IuylDvEX6oXyUHq8q8boMQR1l4pOHM3+YbLbDfv6HLSBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721658121; c=relaxed/simple;
	bh=sO48rBfePwJJwOuzkWv9CUXSJWa4aJoG3UxyflX83Ss=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ujknw0gNwdPd14EhlcJK9TPaBWBlKuyVvscGa7r1MRwvkIf1mkjnKKJwW9uFvMjzLUs7Z36ctZpLJgRCkjEcXpezxjGcgwEV0ooy0BtHpyACzfumBV23Lbb4LdboXnJDaqQpre+ocKjJFMycxAvcipmElcINy0lGZ3wyGtHXGNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tWMyjQHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tWMyjQHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A47C116B1;
	Mon, 22 Jul 2024 14:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721658121;
	bh=sO48rBfePwJJwOuzkWv9CUXSJWa4aJoG3UxyflX83Ss=;
	h=From:To:Cc:Subject:Date:From;
	b=tWMyjQHbegfVwskT3GBJxlDZclJfEJjSZBivYlo8bqDxSeilqd6YDNt2uhKs6uiL5
	 6AKnYrh5VLi+5uiL0GwaXuraj8iMiaQDqox8197nt2zWa7TtQR+c6iziT3Hv4ypGtT
	 83ywrel3YtZXmMmT8soAKy1wZSCDu/8Jj+CdGP2ExesPyMhW7kHEIO4L4cYHEoj+Gc
	 OsNAkq4XH/+jJY4sh80yYh9ZQpiodhcPAaUBGvzER0tGEq379dRUA/xRN6FTAuDasx
	 /XwVwEFS/brY4WX5sgR4aBsESyGE/59vMAIFrXW7MJ2HtZfYoVd0tSfqhML59sRD76
	 yPg/oLm7TaqMA==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCHv8 0/9] nvme: implement secure concatenation
Date: Mon, 22 Jul 2024 16:21:13 +0200
Message-Id: <20240722142122.128258-1-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hannes Reinecke <hare@suse.de>

Hi all,

here's my attempt to implement secure concatenation for NVMe-of TCP
as outlined in TP8018.
The original (v5) patchset had been split in two, and this is the
second part based on top of the patchset 'nvme: fixes for secure
concatenation' sent earlier to the mailinglist.

Secure concatenation means that a TLS PSK is generated from the key
material negotiated by the DH-HMAC-CHAP protocol, and the TLS PSK
is then used for a subsequent TLS connection.
The difference between the original definition of secure concatenation
and the method outlined in TP8018 is that with TP8018 the connection
is reset after DH-HMAC-CHAP negotiation, and a new connection is setup
with the generated TLS PSK.

To implement that Sagi came up with the idea to directly reset the
admin queue once the DH-CHAP negotiation has completed; that way
it will be transparent to the upper layers and we don't have to
worry about exposing queues which should not be used.

As usual, comments and reviews are welcome.

Patchset can be found at
git.kernel.org:/pub/scm/linux/kernel/git/hare/nvme.git
branch secure-concat.v8

Changes to v7:
- Add patch to display nvme target TLS status in debugfs
- Include reviews from Sagi

Changes to v6:
- Rebase to nvme-6.11

Changes to v5:
- Include reviews from Sagi
- Split patchset in two parts

Changes to v4:
- Rework reset admin queue functionality based on an idea
  from Sagi (thanks!)
- kbuild robot fixes
- Fixup dhchap negotiation with non-empty C2 value

Changes to v3:
- Include reviews from Sagi
- Do not start I/O queues after DH-HMAC-CHAP negotiation
- Use bool to indicate TLS has been enabled on a queue
- Add 'tls_keyring' sysfs attribute
- Add 'tls_configured_key' sysfs attribute

Changes to v2:
- Fixup reset after dhchap negotiation
- Disable namespace scanning on I/O queues after
  dhchap negotiation
      - Reworked TLS key handling (again)

Changes to the original submission:
- Sanitize TLS key handling
- Fixup modconfig compilation

Hannes Reinecke (9):
  crypto,fs: Separate out hkdf_extract() and hkdf_expand()
  nvme: add nvme_auth_generate_psk()
  nvme: add nvme_auth_generate_digest()
  nvme: add nvme_auth_derive_tls_psk()
  nvme-keyring: add nvme_tls_psk_refresh()
  nvme-tcp: request secure channel concatenation
  nvme-fabrics: reset admin connection for secure concatenation
  nvmet-tcp: support secure channel concatenation
  nvmet: add tls_concat and tls_key debugfs entries

 crypto/Makefile                        |   1 +
 crypto/hkdf.c                          | 112 +++++++++
 drivers/nvme/common/auth.c             | 303 +++++++++++++++++++++++++
 drivers/nvme/common/keyring.c          |  50 ++++
 drivers/nvme/host/auth.c               | 108 ++++++++-
 drivers/nvme/host/fabrics.c            |  34 ++-
 drivers/nvme/host/fabrics.h            |   3 +
 drivers/nvme/host/nvme.h               |   2 +
 drivers/nvme/host/sysfs.c              |   4 +-
 drivers/nvme/host/tcp.c                |  56 ++++-
 drivers/nvme/target/auth.c             |  72 +++++-
 drivers/nvme/target/debugfs.c          |  27 +++
 drivers/nvme/target/fabrics-cmd-auth.c |  49 +++-
 drivers/nvme/target/fabrics-cmd.c      |  33 ++-
 drivers/nvme/target/nvmet.h            |  38 +++-
 drivers/nvme/target/tcp.c              |  23 +-
 fs/crypto/hkdf.c                       |  68 +-----
 include/crypto/hkdf.h                  |  18 ++
 include/linux/nvme-auth.h              |   7 +
 include/linux/nvme-keyring.h           |   7 +
 include/linux/nvme.h                   |   7 +
 21 files changed, 926 insertions(+), 96 deletions(-)
 create mode 100644 crypto/hkdf.c
 create mode 100644 include/crypto/hkdf.h

-- 
2.35.3

