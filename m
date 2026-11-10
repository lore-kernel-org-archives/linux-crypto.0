Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794329561;
	b=seHvoOanJRGk/aUc+peKm6KHSjByXVxOjTl6VVltazmFgi7mjm+moYbpyetC1QEHxv0E
	 OXYybnG7Fw4Ew3JbEpDTgCPHWcC14UO6WhqVlO2L4EV48jQ5dKO7ZEIxOxfc/VRJ26h0G
	 Jjn2fZ+LPrv7K6GCe+j2MlOBAvtAyNbtmh76CvjjBk4Ykq7Eg1qtnyP/aaxjb5bLL2ezu
	 addH4tR/pFF2ZoSEunh0MfEdfrku09MXPgA/FPaDLIxrhqO9RM8xDiQ4VRWeOxOV888fh
	 yDKTUhkdOtG+RiCK1Pn3067Kpiffum3hR3SKzwEAHiqhUnvwL28anicBUijWD43lGww==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329561;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=0HYHB33MHi0fQh7zyL9BH0ZCGoAgjNWOtgnaXZufK7o=;
	b=tpUOBY+O/e3IQWazs5VZ5f0NbiAA/hGChW8TScn5tl9DQuV4jVrJTGnO4O4EJEIECDKc
	 ZPXrndb1CEStqSwUl+5oaNldoP59SxpEDtHWq5hayXFK30b/7uauLxbFXilQmyPKUp9E1
	 Lx4itm+sUQCLAsXQbrpa0kiE4PnTzjtAQ8ZO0MSRnC3kWMM7cGsX+ff9KgZ/9zSUtUYu2
	 ls7eLQBgjcGXBUuxx8uYly/kUyzMVjds6ZUHAAoAMOI/QMM7HnIW46aEqzNEzEWKyWmTx
	 sym74Dv30tEciAmxXAY4I/yvK/IMsXmp5AZzQQ8BdjZLFJ8xsW3oVTOf0HAqAqVIJEQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZFMkwlII;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C513360A2602;
	Tue, 10 Nov 2026 16:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZFMkwlII
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794329560;
	b=KlDEMiNPluO368mJR0u9N1qhe5toGpJfdJ52uHseNccQunxz3JlYWFxxMKsVhsnLFUTL
	 CmC7pT+7XT3ok9yIL+R14pVHAZJOs0ph5TvurmteAD2gzpG4h604gpXnJPI6qPGJiiNBz
	 W0TEFFz5jdFGKTZjgbfx+Q1Efh1y1y98945QWHuDYjKJEmL/iYokZI+q1UbGh7nSgWXwk
	 gTMkPD3gsAIqNOKhURb/Sfakw/XNqUgx6X2JuIX7PRFsuCIMbP7sGjSoSIBHR4mskn3ya
	 kexQymTlm9tLG7O31FwEm6Cju5LpkQfTHlU0h4epSByAHSHPVkUCpFT4Zd/pibr7H1g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794329560;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=0HYHB33MHi0fQh7zyL9BH0ZCGoAgjNWOtgnaXZufK7o=;
	b=ANzRARdzt9gBzZC9vuyF1mrXOfEJSRBUHIqYWx5d/KInXDFNIRQ1l/U1FeQOXfQxBL75
	 NyNgwpr6sQbpjpauJg5hNngUmdCPRASWs7uxXpF1RIZrg3y3raitrKgr3t1vUt+u6+ohY
	 M15+IVC19DuG8aVgKod/tsKCnXBKv3jJ5ztpIbrfFDjq1ZxJwqnQHeNi4PRxoeOdifb04
	 6KSFBZc3CRcBk0Xz/qT04BBa8UCkVskZVN4+9zc+Yj0viRr+HmCHCmn135koYD2lq4Us4
	 XahYDyqFhsRr32EGpcJ1UxRMhJC8YrZvDOcHE/yR4tp9G4yZ0fLilWHIhqWY9KOkihw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 984AF1F008A1;
	Tue, 10 Nov 2026 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329560;
	bh=0HYHB33MHi0fQh7zyL9BH0ZCGoAgjNWOtgnaXZufK7o=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=ZFMkwlIIqIDQMkUCFAhjetNGjiSrs0HXK9EWvTHn2WvDKTreXIBH0nHrmNP5a79Q5
	 FZslr0ZVPBtx9jjouxNHb1sgI7P2thzmkuIIPiPFpgqUfzSK/Hn/llLlDvpgiKPo+X
	 SUXSQPs96w8ziGm7Dc93Td2X00NN5OBSTxL1ye0JdhSbbzAPoMxfhH/sTW6oBF7E6a
	 Xobo3l3qdGP4vCFCvv3PwJtm6W5YRnWSaSB8Y5d2kQcEcBybfDm2cHxMoUVEyVGEUq
	 ekVb2tdxIfozKX+sA2544lf2lXyIFyPxyEgdG6B0VlaXVW7w0z+0qtVcFCNLoPX2iN
	 jWGzV9WFAZYhA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 245AE48BF7;
	Tue, 10 Nov 2026 16:52:38 +0000 (UTC)
From: Alex Ousherovitch via B4 Relay <devnull+aousherovitch.rambus.com@kernel.org>
Subject: [PATCH v8 0/5] crypto: cmh - add Rambus CryptoManager Hub core
 driver and AES
Date: Tue, 10 Nov 2026 08:52:26 -0800
Message-Id: <20261110-cmh-b4-a-v8-v8-0-4cea8ebc1d40@rambus.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMpL82oC/yXMyw5AMBBA0V+RWZukRWj8ilj0MRiJR1pEIv5ds
 TyLey8I5JkC1MkFng4OvMwRKk3ADnruCdlFQyayUkop0E4DmgI1Hgp17oRTOi9VRRCL1VPH53d
 r2t9hNyPZ7V3AfT82kkD+bwAAAA==
X-Change-ID: 20261110-cmh-b4-a-v8-a3d0d8a3687e
To: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>, 
 Joel Wittenauer <Joel.Wittenauer@cryptography.com>, 
 Thi Nguyen <thin@rambus.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 Alex Ousherovitch <aousherovitch@rambus.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794329557; l=12469;
 i=aousherovitch@rambus.com; s=20261026; h=from:subject:message-id;
 bh=OPjcdwl0aItTqUSrkHnKVvcAq8MljzyQ3KTBqVVBsX8=;
 b=rsodRVrG7u4Z6O1i9aqPazKtcSFXmyPT7O+eMVkGH9LP2FQRk5g5aWQxGQ9HdIBfP2sl3tBnn
 8KQ4Jf28l36ApELH4/MQS7Vg6opnvcv96cJFylidM0aPSPEmf9X69iU
X-Developer-Key: i=aousherovitch@rambus.com; a=ed25519;
 pk=ECFtTdQUPAolK+qGZ6v7Xm3sRf7rnM7wxpTeFzbqpmA=
X-Endpoint-Received: by B4 Relay for aousherovitch@rambus.com/20261026 with
 auth_id=1330
X-Original-From: Alex Ousherovitch <aousherovitch@rambus.com>
Reply-To: aousherovitch@rambus.com

The Rambus CryptoManager Hub (CMH) is a hardware cryptographic
accelerator accessed through a mailbox-based VCQ (Virtual Command Queue)
interface.  This part, the first of the split posting (lineage and
changelog below), adds the core platform driver, the shared
key/datastore layer and the AES transforms, plus the device-tree binding
and the MAINTAINERS entry.  AES is the first and least-problematic
algorithm family, so the core has a user and the VCQ/DMA/completion data
path is reviewable end to end.  Later parts add the remaining symmetric
ciphers (SM4, ChaCha20-Poly1305) and the hwrng, the hashes and MACs,
and finally the asymmetric and post-quantum algorithms together with the
/dev/cmh_mgmt management interface.

The core driver binds the device, parses its device-tree description,
sets up DMA, the mailbox queue interface and the transaction manager,
and exposes sysfs/debugfs instrumentation.  The key/datastore patch adds
the raw-key handling and the datastore (SYS) command helpers that the AES
driver in this series, and the algorithm drivers in the following series,
build on.

The transaction manager runs as a kthread that packs VCQ entries and
submits each request to the mailbox its core is bound to; completion is
handled by per-mailbox threaded IRQs, or a watchdog poll without them.
The data path is asynchronous: requests return -EINPROGRESS, and on a
full queue a CRYPTO_TFM_REQ_MAY_BACKLOG request is backlogged (-EBUSY)
while any other gets -ENOSPC.
The CMH eSW is loaded independently by the hardware before probe; the
driver loads no firmware.

The CMH is a platform device matched via device tree (compatible
"rambus,cmh-v1030").  Following the inside-secure,eip93 binding model
and the DT maintainer's guidance, the schema requires a SoC-specific
compatible ahead of the IP fallback and therefore carries no example.

Public hardware documentation:
  Product overview: https://www.rambus.com/security/crypto-hub/
  No public datasheets or downloadable briefs are currently available.
  The driver was developed against the Rambus CryptoManager Hub Hardware
  Reference Manual (Rambus Inc. confidential).  Detailed hardware
  reference is available under NDA from Rambus Inc.; contact the
  maintainers listed in MAINTAINERS for access during review.

Developed against Herbert Xu's cryptodev tree.  checkpatch.pl --strict,
sparse (C=2) and a W=1 -Werror build are clean, and dtschema's
dt-doc-validate accepts the binding.  Exercised on riscv64 and arm64 --
QEMU with the CMH hardware model and a Xilinx VMK180 FPGA with the CMH
IP -- under lockdep/PROVE_LOCKING, DEBUG_OBJECTS,
KASAN/UBSAN/KMEMLEAK/KFENCE and (arm64) KCSAN with no findings;
worst-case stack stays under 1 KB.

Changes in v8:
 - dt-bindings: rambus,slot-stride-bytes is 512 or 1024; reword
   rambus,cores for cores that no mailbox lists.
 - crypto: cmh: harden mailbox error recovery against concurrent
   interrupt and watchdog activity.
 - crypto: cmh: close transaction-manager races in timeout arming,
   doorbell ringing and backlog promotion, and wake the manager for a
   backlogged request.
 - crypto: cmh: never free memory the device may still write: DMA memory
   is freed or allocated only behind an acknowledged mailbox FLUSH, a
   mailbox that never acknowledges is retired with its buffers kept, and
   suspend is refused with -EBUSY instead of cancelling in-flight work.
 - crypto: cmh: crypto API conformance: MAY_BACKLOG requests are never
   refused (unbounded backlog), others get -ENOSPC on a full queue, final
   completions run with BH disabled, CRYPTO_ALG_ALLOCATES_MEMORY is set,
   and sysfs bind/unbind is disabled.
 - crypto: cmh: error codes: -EIO only for a device failure, -ECANCELED
   after recovery, -ENODEV on a retired mailbox, -EBADMSG for an AEAD tag
   mismatch.
 - crypto: cmh: AES: drop cfb(aes); zero-length xts(aes) returns -EINVAL;
   out-of-place AEAD no longer writes the destination AAD; an oversized
   CCM payload returns -EOVERFLOW; the empty CCM tag uses the AES
   library; the second leg of a counter-wrap CTR request is backlogged.
 - crypto: cmh: assorted small fixes and comment corrections.
 - Documentation and patch split: each patch documents and adds only
   what it needs; the PQC command sizes moved to the PQC series.
 - Rebased onto cryptodev-2.6 (7.4.0-rc1).

Changes in v7:
 - Corrected the DCO sign-off chain so the co-developer attribution is
   immediately followed by that author's own sign-off and the submitting
   author signs last (the DCO point first raised on v3).
 - crypto: cmh: close a debugfs force-drain vs teardown use-after-free --
   the response-handler lock now also covers freeing the per-mailbox state
   on teardown, so a force-drain can no longer race it.
 - crypto: cmh: reclaim abandoned mailbox scratch with a non-destructive
   flush ordered in the host command stream instead of a destructive
   per-mailbox MBX_COMMAND_FLUSH -- removing the cmh_tm_flush_mbx helper
   and its drain-wait -- so reclaiming scratch no longer cancels a crypto
   VCQ that shares the mailbox.
 - Added the per-revision changelog and the prior-posting links below.
   The previous posting was sent untagged as "[PATCH 0/5]" and was the
   sixth revision (v6), so this is v7.

Changes in v6:
 - Restructured the single v1-v5 series into smaller, independently
   reviewable per-maintainer chunks.  This first series is the core
   driver, the shared key/datastore layer and AES; later series add the
   remaining algorithms and the management ioctl interface.
 - dt-bindings: simplified the clock-names schema -- the oneOf collapses
   to a single items list (core, an optional core-div2 or rt, then rt,
   minItems: 1) -- and bounded the per-mailbox queue reg to the hardware
   range (maximum: 63), following the v5 DT review.
 - crypto: cmh: the response handler accumulates the IRQ status bits
   before clearing the pending flag and releases its mailbox IRQs on
   teardown even after a suspend; a wedged pinned mailbox now fails with
   -EIO instead of head-of-line blocking; a second probe is rejected; and
   debugfs ABORT injection and force-drain take the response-handler lock.
 - crypto: cmh: AES-CMAC hardware-accelerates the one-shot .digest()
   only and forwards the incremental and virtual-address paths to a
   generic cmac(aes) transform the driver allocates in .init_tfm()
   (CRYPTO_ALG_NO_FALLBACK + CRYPTO_ALG_REQ_VIRT, as the generic
   cmac(aes) shash has no export_core and cannot back crypto_ahash_fb()).
 - crypto: cmh: moved the datastore-type-to-core-id mapping into the
   management layer so the key/datastore code no longer depends on the
   management UAPI header; that header now lands with the ioctl
   implementation in a later series.

Changes in v5:
 - dt-bindings: reworked the compatible and rambus,cores per DT review --
   require a SoC-specific compatible ahead of the "rambus,cmh-v1030" IP
   fallback via the inside-secure,eip93 "not: {}" idiom (no example can
   validate until a real SoC is upstreamed), switch rambus,cores to a
   string-array of core names, and replace the positional clocks list with
   a count-bounded description.
 - crypto: cmh: transaction-manager / response-handler race fixes -- FLUSH
   and drain instead of restarting the eSW into freed slots, serialise the
   mailbox TAIL doorbell, ABORT a sync timeout only at the mailbox HEAD,
   and reject an over-large num_vcqs.

Changes in v4:
 - dt-bindings: renamed the per-mailbox child to queue@N and described its
   ring geometry as plain counts (rambus,num-slots / rambus,slot-stride-
   bytes) rather than log2; renamed the binding to rambus,cmh-v1030.yaml.
 - crypto: cmh: convert to module_platform_driver() + dev_err_probe() and
   drop the single-instance guard; remove informational probe logging; and
   drop the production module parameters (built-in constants, with
   debug-only knobs under debugfs).

Changes in v3:
 - dt-bindings: reworked the mailbox topology per DT review -- mailbox@N
   child nodes, with cores discovered from CORE_ENABLE rather than the DT
   -- and adopted the "rambus" vendor prefix with a device-specific
   "rambus,cmh-v1030" compatible (the IP revision).

Changes in v2:
 - crypto: cmh: gate probe on both eSW readiness bits (MISSION and
   MISSION2) so an operation offloaded to the sidecar engine cannot race an
   engine that is not yet up.

The CMH driver was first posted as a single series; following
maintainer feedback it is now split into smaller, independently reviewable
parts, numbered continuously across the split.  Earlier postings:
  v1: https://lore.kernel.org/linux-crypto/20260625173328.1140487-1-skrishnamoorthy@rambus.com/
  v2: https://lore.kernel.org/linux-crypto/20260709203037.1884436-1-skrishnamoorthy@rambus.com/
  v3: https://lore.kernel.org/linux-crypto/20260806195519.2703224-1-skrishnamoorthy@rambus.com/
  v4: https://lore.kernel.org/linux-crypto/20260825221539.255951-1-aousherovitch@rambus.com/
  v5: https://lore.kernel.org/linux-crypto/20260917225929.2494111-1-aousherovitch@rambus.com/
  v6: https://lore.kernel.org/linux-crypto/20261013174847.2192609-1-aousherovitch@rambus.com/
  v7: https://lore.kernel.org/linux-crypto/20261026-cmh-b4-a-v7-v7-0-500a83faf500@rambus.com/

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
---
Alex Ousherovitch (5):
      dt-bindings: crypto: add Rambus CryptoManager Hub
      crypto: cmh - add core platform driver
      crypto: cmh - add key/datastore infrastructure
      crypto: cmh - add AES skcipher/aead/cmac
      MAINTAINERS: add Rambus CryptoManager Hub (CMH)

 Documentation/ABI/testing/debugfs-driver-cmh       |  145 ++
 Documentation/ABI/testing/sysfs-driver-cmh         |   62 +
 Documentation/crypto/device_drivers/cmh.rst        |  308 +++
 Documentation/crypto/device_drivers/index.rst      |    1 +
 .../bindings/crypto/rambus,cmh-v1030.yaml          |  145 ++
 .../devicetree/bindings/vendor-prefixes.yaml       |    2 +
 MAINTAINERS                                        |   13 +
 drivers/crypto/Kconfig                             |    1 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/cmh/Kconfig                         |   48 +
 drivers/crypto/cmh/Makefile                        |   30 +
 drivers/crypto/cmh/cmh_aes.c                       |  705 ++++++
 drivers/crypto/cmh/cmh_aes_aead.c                  |  934 ++++++++
 drivers/crypto/cmh/cmh_aes_cmac.c                  |  459 ++++
 drivers/crypto/cmh/cmh_config.c                    |  625 +++++
 drivers/crypto/cmh/cmh_debugfs.c                   |  309 +++
 drivers/crypto/cmh/cmh_dma.c                       |  354 +++
 drivers/crypto/cmh/cmh_key.c                       |  138 ++
 drivers/crypto/cmh/cmh_main.c                      |  413 ++++
 drivers/crypto/cmh/cmh_mqi.c                       |  457 ++++
 drivers/crypto/cmh/cmh_rh.c                        | 1434 +++++++++++
 drivers/crypto/cmh/cmh_sys.c                       |   56 +
 drivers/crypto/cmh/cmh_sysfs.c                     |  108 +
 drivers/crypto/cmh/cmh_txn.c                       | 2531 ++++++++++++++++++++
 drivers/crypto/cmh/include/cmh.h                   |   24 +
 drivers/crypto/cmh/include/cmh_aes.h               |   24 +
 drivers/crypto/cmh/include/cmh_aes_abi.h           |   98 +
 drivers/crypto/cmh/include/cmh_config.h            |  110 +
 drivers/crypto/cmh/include/cmh_debugfs.h           |   94 +
 drivers/crypto/cmh/include/cmh_dma.h               |  195 ++
 drivers/crypto/cmh/include/cmh_key.h               |   76 +
 drivers/crypto/cmh/include/cmh_mqi.h               |   59 +
 drivers/crypto/cmh/include/cmh_registers.h         |  147 ++
 drivers/crypto/cmh/include/cmh_rh.h                |   98 +
 drivers/crypto/cmh/include/cmh_sys.h               |   23 +
 drivers/crypto/cmh/include/cmh_sys_abi.h           |  148 ++
 drivers/crypto/cmh/include/cmh_sysfs.h             |   14 +
 drivers/crypto/cmh/include/cmh_txn.h               |  666 +++++
 drivers/crypto/cmh/include/cmh_vcq.h               |  203 ++
 39 files changed, 11258 insertions(+)
---
base-commit: 82e91fe19fb838f235f7c8829afc1eb389c93bdf
change-id: 20261110-cmh-b4-a-v8-a3d0d8a3687e

Best regards,
--  
Alex Ousherovitch <aousherovitch@rambus.com>


