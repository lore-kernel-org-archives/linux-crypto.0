Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9B835F184;
	Tue,  7 Jul 2026 05:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402638; cv=none; b=F1H4ueccpoCQFserDySggbEQReb1unCOeY6Up713fDC+7SAWs8QIMV39O0+3VoBvJJrB5/kNdfh0F9yI3XTj6tQQZftIFZIP1+MGB1lF2T9Um2d1zXyDpyPW2latGMg9zFDVqZCW6Tn00c8JEkXzvLhwY1CNaqrRU01hK5G0obw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402638; c=relaxed/simple;
	bh=kdYB5HIZ8XxwCPSNqTMnOdXSssECCaVCdvIOyP/NW0k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F6eNyPe55TNLA9JvRR3kjA0XEaRkf+QbfHcAp1MS4DHYXcJhcAp9cCaGWaeKPEe7cQ126iejao0e24JOAl2SHn4LS7R8EolifLmP8M1XK6hLbDCCSxfHpGQgTlGHHVYLpTpXxHcPUnKDRvzU34h19jDtwwmCs6Mj52Okq6eUWmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=USh7KgSg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="USh7KgSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F141F000E9;
	Tue,  7 Jul 2026 05:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402636;
	bh=m5P5buTEZLHTajtq565EH+TFnWS7XHOenGsKfPMwJHU=;
	h=From:To:Cc:Subject:Date;
	b=USh7KgSg1iEiXcZnoSgCBOnTjDUOJYMDbZ7fGS4FwG6ohtJSCIKshw843pDw0C02D
	 frlrGbOTSbFGNEaS1pchiyT8BBmHGqiFqQaKCzBH0ComP5FvCGjkUBrG/m6v/r3P5t
	 jLVuRravAPwg+AoBzufh3x3KLo3wAi0Z7Itxw2JMQVxbPUhC+4wnVV3MLcHUBqF/i1
	 FNNyh9dCfdE4r1WNykJhWUOzZoIh8+HjbUlQYyQFu1bqetjc4/lL+vog1H9wX640MP
	 LZ7Hq9r94G+CZJcG0wpL6vLc8ORli5dVRjmqRyoCZWQXeLfUTXZ+fE1P8bcUZRpUYX
	 i4astjyI42fSA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 00/33] Library APIs for AES encryption modes
Date: Mon,  6 Jul 2026 22:34:30 -0700
Message-ID: <20260707053503.209874-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series applies to v7.2-rc2.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git aes-modes-v1

This series adds library APIs for all the AES encryption modes that are
used in the kernel, both authenticated and unauthenticated: AES-ECB,
AES-CBC, AES-CBC-CTS, AES-CTR, AES-XCTR, AES-XTS, AES-GCM, and AES-CCM.

Patches 2-7 add the library APIs, and patches 8-13 wire them up to the
traditional crypto API (with just priority 110 for now).  These are
intended to be taken through libcrypto-next for 7.3.

The remaining patches (14-33) convert users of the traditional crypto
API to use the new library APIs instead.  Most of these will be for 7.4
or later.  For now please consider these to be proof-of-concept patches
for helping inform the API design.  Most of them I haven't tested, and
their performance also won't be optimal yet (since the arch-optimized
code for these AES modes needs to be migrated into the library first).
Nevertheless I think they do make it very clear that (as usual) the
library is much easier to use than the traditional crypto API, and we
can expect performance improvements once everything is wired up as well.

Apologies for the large patch series, but it ended up being easiest to
handle all the AES modes at once rather than try to do them one by one.
This ensures a consistent design for them, which is really important.
Additionally, the arch-optimized AES code tends to intermingle different
modes, and many depend on each other anyway.

But as a result, to keep this series manageable it doesn't include the
usual KUnit tests or the integration of the architecture-optimized code.
Those will be sent separately in follow-up series.

Feedback is appreciated, especially on patches 2-7 and the library APIs
they add.

Eric Biggers (33):
  crypto: xts - Split out __xts_verify_key() helper
  lib/crypto: aes: Add ECB support
  lib/crypto: aes: Add CBC and CBC-CTS support
  lib/crypto: aes: Add CTR and XCTR support
  lib/crypto: aes: Add XTS support
  lib/crypto: aes: Add GCM support
  lib/crypto: aes: Add CCM support
  crypto: aes - Add ECB support using library
  crypto: aes - Add CBC and CBC-CTS support using library
  crypto: aes - Add CTR and XCTR support using library
  crypto: aes - Add XTS support using library
  crypto: aes - Add GCM support using library
  crypto: aes - Add CCM support using library
  x86/sev: Use new AES-GCM library
  lib/crypto: aesgcm: Remove old AES-GCM library
  crypto: aes - Remove AES-CBC-MAC support
  lib/crypto: aes: Remove aes_cbcmac_* functions
  fscrypt: Use aes_ecb_encrypt() for v1 key derivation
  KEYS: encrypted: Use AES-CBC library instead of crypto_skcipher
  KEYS: trusted: dcp: Use AES-GCM library instead of crypto_aead
  libceph: Use AES-CBC library in ceph_aes_crypt()
  libceph: Reimplement messenger v2 encryption using AES-GCM library
  wifi: mac80211: Use AES-CTR library in fils_aead.c
  wifi: mac80211: Use AES-GCM library for GMAC suite
  wifi: mac80211: Use crypto libraries for GCMP and CCMP suites
  macsec: Use AES-GCM library instead of crypto_aead
  wifi: ipw2x00: Use AES-CCM library
  mac802154: Use AES-CCM and AES-CTR libraries
  bpf: crypto: Use AES-CBC and AES-ECB libraries
  bpf: crypto: Add AES-GCM support
  smb: client: Use AES-GCM and AES-CCM libraries
  ksmbd: Use AES-GCM and AES-CCM libraries
  net: tipc: Use AES-GCM library instead of crypto_aead

 .../crypto/libcrypto-auth-encryption.rst      |   20 +
 .../crypto/libcrypto-unauth-encryption.rst    |   49 +
 Documentation/crypto/libcrypto.rst            |    2 +
 MAINTAINERS                                   |    2 -
 arch/x86/Kconfig                              |    2 +-
 arch/x86/coco/sev/core.c                      |   44 +-
 arch/x86/include/asm/sev.h                    |    2 +-
 crypto/Kconfig                                |   15 +-
 crypto/Makefile                               |    3 -
 crypto/aes.c                                  |  937 +++++++++++++-
 crypto/bpf_crypto_skcipher.c                  |   83 --
 crypto/testmgr.c                              |    6 +-
 drivers/crypto/starfive/jh7110-aes.c          |    2 +-
 drivers/net/Kconfig                           |    4 +-
 drivers/net/macsec.c                          |  327 ++---
 drivers/net/wireless/intel/ipw2x00/Kconfig    |    2 +-
 .../intel/ipw2x00/libipw_crypto_ccmp.c        |  117 +-
 drivers/virt/coco/sev-guest/sev-guest.c       |    7 +-
 fs/crypto/Kconfig                             |    2 +-
 fs/crypto/keysetup_v1.c                       |    5 +-
 fs/smb/client/Kconfig                         |    7 +-
 fs/smb/client/cifsencrypt.c                   |   14 -
 fs/smb/client/cifsfs.c                        |    4 -
 fs/smb/client/cifsglob.h                      |    8 -
 fs/smb/client/cifsproto.h                     |   89 --
 fs/smb/client/connect.c                       |   14 +-
 fs/smb/client/smb2ops.c                       |  275 ++--
 fs/smb/client/smb2pdu.c                       |    2 -
 fs/smb/client/smb2proto.h                     |    1 -
 fs/smb/client/smb2transport.c                 |   39 -
 fs/smb/server/Kconfig                         |    6 +-
 fs/smb/server/Makefile                        |    2 +-
 fs/smb/server/auth.c                          |  227 ----
 fs/smb/server/auth.h                          |    2 -
 fs/smb/server/crypto_ctx.c                    |  176 ---
 fs/smb/server/crypto_ctx.h                    |   32 -
 fs/smb/server/server.c                        |   14 +-
 fs/smb/server/smb2pdu.c                       |  133 +-
 include/crypto/aes-cbc-macs.h                 |   22 +-
 include/crypto/aes-cbc.h                      |   77 ++
 include/crypto/aes-ccm.h                      |  244 ++++
 include/crypto/aes-ctr.h                      |   56 +
 include/crypto/aes-ecb.h                      |   49 +
 include/crypto/aes-gcm.h                      |  249 ++++
 include/crypto/aes-xts.h                      |   87 ++
 include/crypto/gcm.h                          |   23 +-
 include/crypto/xts.h                          |   18 +-
 include/linux/bpf_crypto.h                    |   24 -
 include/linux/ceph/messenger.h                |   22 +-
 include/net/macsec.h                          |    5 +-
 kernel/bpf/Kconfig                            |   14 +
 kernel/bpf/Makefile                           |    4 +-
 kernel/bpf/crypto.c                           |  302 ++---
 lib/crypto/Kconfig                            |   41 +-
 lib/crypto/Makefile                           |    3 -
 lib/crypto/aes.c                              | 1146 ++++++++++++++++-
 lib/crypto/aesgcm.c                           |  721 -----------
 lib/crypto/tests/Kconfig                      |    6 +
 lib/crypto/tests/aes_cbc_macs_kunit.c         |   68 +-
 net/ceph/Kconfig                              |    5 +-
 net/ceph/crypto.c                             |   66 +-
 net/ceph/crypto.h                             |    3 +-
 net/ceph/messenger_v2.c                       |  963 +++++---------
 net/mac80211/Kconfig                          |    7 +-
 net/mac80211/Makefile                         |    1 -
 net/mac80211/aead_api.c                       |  113 --
 net/mac80211/aead_api.h                       |   23 -
 net/mac80211/aes_ccm.h                        |   39 +-
 net/mac80211/aes_gcm.h                        |   38 +-
 net/mac80211/aes_gmac.c                       |   85 +-
 net/mac80211/aes_gmac.h                       |   10 +-
 net/mac80211/fils_aead.c                      |   90 +-
 net/mac80211/key.c                            |   42 +-
 net/mac80211/key.h                            |    8 +-
 net/mac80211/wpa.c                            |   23 +-
 net/mac802154/Kconfig                         |    6 +-
 net/mac802154/llsec.c                         |  158 +--
 net/mac802154/llsec.h                         |    8 +-
 net/tipc/Kconfig                              |    4 +-
 net/tipc/crypto.c                             |  467 ++-----
 net/tipc/msg.h                                |    3 -
 net/tipc/sysctl.c                             |    6 +
 security/keys/Kconfig                         |    4 +-
 security/keys/encrypted-keys/encrypted.c      |  194 +--
 security/keys/trusted-keys/Kconfig            |    1 +
 security/keys/trusted-keys/trusted_dcp.c      |   69 +-
 86 files changed, 4167 insertions(+), 4126 deletions(-)
 create mode 100644 Documentation/crypto/libcrypto-auth-encryption.rst
 create mode 100644 Documentation/crypto/libcrypto-unauth-encryption.rst
 delete mode 100644 crypto/bpf_crypto_skcipher.c
 delete mode 100644 fs/smb/server/crypto_ctx.c
 delete mode 100644 fs/smb/server/crypto_ctx.h
 create mode 100644 include/crypto/aes-cbc.h
 create mode 100644 include/crypto/aes-ccm.h
 create mode 100644 include/crypto/aes-ctr.h
 create mode 100644 include/crypto/aes-ecb.h
 create mode 100644 include/crypto/aes-gcm.h
 create mode 100644 include/crypto/aes-xts.h
 delete mode 100644 include/linux/bpf_crypto.h
 delete mode 100644 lib/crypto/aesgcm.c
 delete mode 100644 net/mac80211/aead_api.c
 delete mode 100644 net/mac80211/aead_api.h


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
2.54.0

