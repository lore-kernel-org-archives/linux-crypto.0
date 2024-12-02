Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D17204F6B
	for <linux-crypto@vger.kernel.org>; Mon,  2 Dec 2024 14:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733149811; cv=none; b=HoI9KfbPqyk5W9UmmZ13yPRTXr/1F+08eLpCJCB11jBHEc58laagjJIkE5y4IdkH7x+/kid2yH3TY7GNSAVC2qI7hJZ/w3sluINifpVsY8LCDzbp3sUOFzCuyiEnJWFZvePHLFQXJKH6qheRzjcQYQOMu/1ufDXHPo+7i9XPcak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733149811; c=relaxed/simple;
	bh=dPQQiFg6E3MYIWuowOkKPwCdJodOw4dHVqO+lw/k2I8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D96oBInHovtsvcOnoF9BQcd3zy4M+ANwZEhbeVFF+p96v/fZ5hSoIKDSzhfaphLASn7uTwBebvwwojWx3NrrcgFOrF+dMipS+8y8OJob+7Q/i6oc7tpwJcPse0kkqYYYGU+eDRYkEIWR9+tWcw9qF3qsSxYhnczFFlEjh0YGZsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SD8HrFz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SD8HrFz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215F9C4CED1;
	Mon,  2 Dec 2024 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733149810;
	bh=dPQQiFg6E3MYIWuowOkKPwCdJodOw4dHVqO+lw/k2I8=;
	h=From:To:Cc:Subject:Date:From;
	b=SD8HrFz7/BsGeyolj5W9gxmlwPtnVFXsVFro601aPZzzyhHk0/9uGXQvOVJQqHt3/
	 LQd5npX14atl4Y7q4jnBqk6UIWiCQYzIYl3BDZOPx/jBQfAOVdi49q5lRlWEMt/IVh
	 4gvcvs5bkZkUDajtl3pDMHQ7G9t1ZVIh4Dlry0CnzCGq/+Q6ody1AcmqWNFFMieEJs
	 H/iYQwLyiRX5YojsFTsFYSCzGfmsL/h4STt3R+MLyr0Fc7c1Dtt6lImcPRKWaiJlOO
	 OVFhd/e1qqtBtHz9tN5Xvs9zdB3XkrYOH+L7Xdvh3yIMnDKp/CnwwDRLVFUvj+eM6j
	 DL36StxzHgBMQ==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCHv12 00/10] nvme: implement secure concatenation
Date: Mon,  2 Dec 2024 15:29:49 +0100
Message-Id: <20241202142959.81321-1-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

here's my attempt to implement secure concatenation for NVMe-of TCP
as outlined in TP8018.
The original (v5) patchset had been split in two, the first part of
which has already been merged with nvme-6.11, and this is the second part
which actually implements secure concatenation.

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

A blktest submission is in
https://github.com/osandov/blktests/pull/147
in case anyone want to run their own tests.

As usual, comments and reviews are welcome.

Patchset can be found at
git.kernel.org:/pub/scm/linux/kernel/git/hare/nvme.git
branch secure-concat.v12

Changes to v11:
- Include reviews from Sagi

Changes to v10:
- Include reviews from Eric Biggers
- Drop test vectors for SHA1
- Add test vectors for SHA384 and SHA512
- Include reviews from Mark O'Donovan

Changes to v9:
- Include reviews from Eric Biggers
- Fixup secure concatenation after reset
- Rebased to nvme-6.12

Changes to v8:
- Include reviews from Eric Biggers
- Make hkdf a proper module
- Add testcases for hkdf

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

Hannes Reinecke (10):
  crypto,fs: Separate out hkdf_extract() and hkdf_expand()
  nvme: add nvme_auth_generate_psk()
  nvme: add nvme_auth_generate_digest()
  nvme: add nvme_auth_derive_tls_psk()
  nvme-keyring: add nvme_tls_psk_refresh()
  nvme: always include <linux/key.h>
  nvme-tcp: request secure channel concatenation
  nvme-fabrics: reset admin connection for secure concatenation
  nvmet-tcp: support secure channel concatenation
  nvmet: add tls_concat and tls_key debugfs entries

 crypto/Kconfig                         |   6 +
 crypto/Makefile                        |   1 +
 crypto/hkdf.c                          | 573 +++++++++++++++++++++++++
 drivers/nvme/common/Kconfig            |   1 +
 drivers/nvme/common/auth.c             | 346 +++++++++++++++
 drivers/nvme/common/keyring.c          |  65 ++-
 drivers/nvme/host/auth.c               | 113 ++++-
 drivers/nvme/host/fabrics.c            |  34 +-
 drivers/nvme/host/fabrics.h            |   3 +
 drivers/nvme/host/nvme.h               |   2 +
 drivers/nvme/host/sysfs.c              |   4 +-
 drivers/nvme/host/tcp.c                |  68 ++-
 drivers/nvme/target/auth.c             |  72 +++-
 drivers/nvme/target/debugfs.c          |  27 ++
 drivers/nvme/target/fabrics-cmd-auth.c |  49 ++-
 drivers/nvme/target/fabrics-cmd.c      |  33 +-
 drivers/nvme/target/nvmet.h            |  38 +-
 drivers/nvme/target/tcp.c              |  24 +-
 fs/crypto/Kconfig                      |   1 +
 fs/crypto/hkdf.c                       |  85 +---
 include/crypto/hkdf.h                  |  20 +
 include/linux/nvme-auth.h              |   7 +
 include/linux/nvme-keyring.h           |  11 +
 include/linux/nvme.h                   |   7 +
 24 files changed, 1480 insertions(+), 110 deletions(-)
 create mode 100644 crypto/hkdf.c
 create mode 100644 include/crypto/hkdf.h

-- 
2.35.3

