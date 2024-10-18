Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F89120E30E
	for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2024 06:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729233237; cv=none; b=MuJVR0ah4DHMfUWwDWuutDFFXSLloB29ITfBNdK+FKgGKFy8mV9x/RhzTn0WlrXMrbgcleZVwnTi5jqWoNuYmLzhC0hKV2FZui97FSSSGs+x7o16KoVQEUE6RPGPJH1B2KtKzLsef42pRDJQIFxPDlNwGKPZRTSZtGVDDkiN1uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729233237; c=relaxed/simple;
	bh=yWTqKc0bphAi9csONg41m8dvP/jLwdRyQd/BjPvGmZ4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DJizeC71y14UesNp54FkTDsM39CBpL/VTATdEhVOSBaj2ppec3AirSeixBDqn54UL7pjtcE5HT6MPaWRhXHRNTO4mlm+frW26CyyYE4F4xRIl34q4u+du2NMy7CngbdVmT0q/yurBukqhUD6XDWqhZL91uApIvaZOkFniV7ROn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FLsBlQBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FLsBlQBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6266EC4CEC3;
	Fri, 18 Oct 2024 06:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729233237;
	bh=yWTqKc0bphAi9csONg41m8dvP/jLwdRyQd/BjPvGmZ4=;
	h=From:To:Cc:Subject:Date:From;
	b=FLsBlQBaHsHc5f5hK1iTAQXXx47LFLMkxPF5OTg+SVeYYV4Y0bps5dh9jVy2jtLOB
	 vhnCxZ1VJxjIJHLOimTdryVSZwZsaBavLDX89oPHyuB0F1Ug9itcMzVrcIWGPXhgEo
	 vIJNTFTiVuBkSq8z0L564I8cHu/Qs7iTDYyduFSTA6JoW+2ONlu/Vk2IxfmtbjbqNB
	 zKW8j7xyxTxkwpgkSlGoqTw2mzV+CprBra+h7t/Y6rv6Eutomd7dsZwE0ErnGwfarC
	 KaQ2hZodOIMDBv2rjUqyWnbzdEgSvjXRTOA+jWzxG5p7SDs/QeliohuV1fS5cE//HW
	 OE7BqW5zykN8A==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCHv11 0/9] nvme: implement secure concatenaion
Date: Fri, 18 Oct 2024 08:33:34 +0200
Message-Id: <20241018063343.39798-1-hare@kernel.org>
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
branch secure-concat.v11

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

 crypto/Kconfig                         |   6 +
 crypto/Makefile                        |   1 +
 crypto/hkdf.c                          | 573 +++++++++++++++++++++++++
 drivers/nvme/common/Kconfig            |   1 +
 drivers/nvme/common/auth.c             | 346 +++++++++++++++
 drivers/nvme/common/keyring.c          |  64 +++
 drivers/nvme/host/auth.c               | 108 ++++-
 drivers/nvme/host/fabrics.c            |  34 +-
 drivers/nvme/host/fabrics.h            |   3 +
 drivers/nvme/host/nvme.h               |   2 +
 drivers/nvme/host/sysfs.c              |   4 +-
 drivers/nvme/host/tcp.c                |  56 ++-
 drivers/nvme/target/auth.c             |  72 +++-
 drivers/nvme/target/debugfs.c          |  27 ++
 drivers/nvme/target/fabrics-cmd-auth.c |  49 ++-
 drivers/nvme/target/fabrics-cmd.c      |  33 +-
 drivers/nvme/target/nvmet.h            |  38 +-
 drivers/nvme/target/tcp.c              |  23 +-
 fs/crypto/Kconfig                      |   1 +
 fs/crypto/hkdf.c                       |  85 +---
 include/crypto/hkdf.h                  |  20 +
 include/linux/nvme-auth.h              |   7 +
 include/linux/nvme-keyring.h           |   9 +
 include/linux/nvme.h                   |   7 +
 24 files changed, 1462 insertions(+), 107 deletions(-)
 create mode 100644 crypto/hkdf.c
 create mode 100644 include/crypto/hkdf.h

-- 
2.35.3

