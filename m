Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793043905;
	b=uGn0mcX/29wz9zkai5yM1jojMcgxuxBkeoTiAzpLWjRY3A7xzK0028xoseAKPTOwnWfE
	 EVVt7tpestyb53H21eBBfWjZHwG7FXyYkKzVg6jI5aVQVlaPN/3yXAzQsMhzh0ChXg7HY
	 tJcdzvuz2RcLit4o7ATQPQwGxbNBAq6reJnOPtHVwbswL9kLhrQYs6hi4HHxvDopRWQNo
	 qqSH1bxusohm+mj+0R4IEJ/h/DXJIiGHy8tZMnrgsi2bnDtTxqBsGB9eP8mm8owBJ6DRq
	 z+svgQfjj5JSFuxBORLvP9vsutcMQxPe7SoJZM0K+KQJTOZzGuWkQ9tSW8oO6W/M5jg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793043905;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=xXV8ZpziOa667PdyUI9do8a4b7TkCYOayc0udoenc9s=;
	b=EALcL3w2T0/4MI+EEe5C0eIyg6+IsAQNRPd+LCbTZyM4j8R8tUURtvRfP3yks4QcmbVX
	 Z0Rv1qZQe4MX1vhu+eIb/EQPhoN5X4oq/zbwBRMGJyQ72LDd6CdYrxfTQ5zGjcQzqzKqj
	 tqzTN2R7DIG+G+lBZutsEkhf7sOhJV6HU9KKlX3nbegS789rrM8YQCVNzUKCZcuVGfoDM
	 PcwRSsb57pHJzhiVdvAU1y9AdMEHdl0+OMwE9rMVeyDtAy6DmaDGUaG0OQ+gdyLtx215O
	 mZePdtJnb3GAkVLGJP2VdnjnHHFriNhTwdapuobn5dvpFvsYqf9MLo0yjHXyFES8IqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BUhklh7t;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67AB606A31D;
	Mon, 26 Oct 2026 19:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BUhklh7t
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793043904;
	b=3BCgaVIba/YrCXf3iHYzKsF9CaRzJCYYjIBw3zkjQs2Opc4oVqoHEA+Nhgq2Q17pIvDR
	 1ipGB6oFOVteycZ947M/pVY0pXMK+Xl8ihF7oXxxJauTxNiwmCEgsUQsdMb4pmRYLvWm+
	 J/NDOr8gSyanbSCQfGYBq8WTAOwP7caS58iainFKRM4DERerF3jR3uioACKtD0xDYdDiN
	 H5+YGR0qkq8rRJCLeoUfQbTZu07eWHewC+DciQ/rsQ937GfxzGivhQrVbWFiBTmcJp2F0
	 gfu0X02Y6QDzQfenfYteF8lvTTaMdz7/tfvJsqtttsuWHfpEoMLGqUqSYjnTNiwsrMg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793043904;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=xXV8ZpziOa667PdyUI9do8a4b7TkCYOayc0udoenc9s=;
	b=bWTbG7vSNF2r5fsv9ohJwk1VzwgApSIjTgb+OhLrqQVObOx3qalcyG4ys2Es6dv3rrLn
	 Mwc0DiXmDW7pxrcD06D1J2tXNyEuscoCSgALBWvg3LoAHG0I+Ec452cdQSKOAry+7X3wX
	 LtoEqYIUgl3yidf6WejtFiii/l2uraohxr0kQVwAmAs57lc3y/VEa+Xzn2CU0IN9Nhiay
	 mdmag/UldwBC+7FTCBQI7w1RqSUgIQtXNyjCrXGD6MxPPaUdthL1G3TN94hXq1iXML4R7
	 nphcqRwo8oTqtU2cR8WbeiPQPnzn0SjYUXt1Cw2eeueXGNZoecm0bYUHxgdbBzJyKCQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8CF0A1F01825;
	Mon, 26 Oct 2026 19:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793043904;
	bh=xXV8ZpziOa667PdyUI9do8a4b7TkCYOayc0udoenc9s=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=BUhklh7tIVSUkY20sgVGSAWgQMATWRyU5Qg+jm6SBinoBqHxsvQM2LhlCwu95DhL4
	 80SKCnAE8yU1TIkC4j8GNddH29DiRmeDc2Wo+7qmPYaZ8qr/VPvh8MU+HJkgiMoMgd
	 dwee/y30llHjN71kDPYOZ1tfhCKntIGFMR2AUNxZQnTklA/5i14NJw1fP34FuA7JWG
	 QdHrGXW8/BSuyc6vxImsX+1C1jWRwgI4oziNnKav5CjrqSUpUN1KuhkUAVREOV0aTW
	 WnC10HQExagloPlubO3RQt0Tovtbe+j9cu4axAw1ok9t0GekNX95j+Nxdh59ChVmTo
	 LJfXBIlBdupVg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E459444E71;
	Mon, 26 Oct 2026 19:45:02 +0000 (UTC)
From: Alex Ousherovitch via B4 Relay <devnull+aousherovitch.rambus.com@kernel.org>
Subject: [PATCH v7 0/5] crypto: cmh - add Rambus CryptoManager Hub core
 driver and AES
Date: Mon, 26 Oct 2026 12:44:56 -0700
Message-Id: <20261026-cmh-b4-a-v7-v7-0-500a83faf500@rambus.com>
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
X-B4-Tracking: v=1; b=H4sIALit32oC/yXMywqAIBCF4VeJWTegFga9SrRIm3KCLmhJEL17V
 ouz+BbnvyCQZwpQZxd4ihx4XRKqPAPrumUk5D4ZlFBapqGdHZoSO4wVGhK6IKlEqSSkx+Zp4PO
 rNe3vcJiJ7P4m4L4fXH2PYm8AAAA=
X-Change-ID: 20261026-cmh-b4-a-v7-be063e120421
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793043901; l=11765;
 i=aousherovitch@rambus.com; s=20261026; h=from:subject:message-id;
 bh=Dmhu2TMlOwjin6ccYOzzIb5bLl98TPPd2SyyuMk4Fis=;
 b=TfTrTQhwLaq0rx15ElcOIIwuyU2TN+8qFbhPo/LzXSz3IWcg3vVHjUStSjv0ABubaxYakc6vI
 9mOafK1xPZHD/vJ32pSP1LtrjFxEbIeDybFam8Wr3SXgE4ROyH2xIHi
X-Developer-Key: i=aousherovitch@rambus.com; a=ed25519;
 pk=ECFtTdQUPAolK+qGZ6v7Xm3sRf7rnM7wxpTeFzbqpmA=
X-Endpoint-Received: by B4 Relay for aousherovitch@rambus.com/20261026 with
 auth_id=1330
X-Original-From: Alex Ousherovitch <aousherovitch@rambus.com>
Reply-To: aousherovitch@rambus.com

The Rambus CryptoManager Hub (CMH) is a hardware cryptographic
accelerator accessed through a mailbox-based VCQ (Virtual Command Queue)
interface.  Support for it was first posted as a single series;
following maintainer feedback it is now split into smaller,
independently reviewable parts, posted least-problematic-first (the
per-revision changelog and the prior postings are listed below).  This
part adds the core platform driver, the shared key/datastore layer and
the AES transforms, plus the device-tree binding and the MAINTAINERS
entry.  AES is the first and least-problematic algorithm family, so the
core has a user and the VCQ/DMA/completion data path is reviewable end to
end.  Later parts add the remaining symmetric ciphers (SM4,
ChaCha20-Poly1305) and the hwrng, the hashes and MACs, and finally the
asymmetric and post-quantum algorithms together with the /dev/cmh_mgmt
management interface.

The core driver binds the device, parses its device-tree description,
sets up DMA, the mailbox queue interface and the transaction manager,
and exposes sysfs/debugfs instrumentation.  The key/datastore patch adds
the key provisioning and system-object layer that the AES driver in this
series, and the algorithm drivers in the following series, build on.

The transaction manager runs as a kthread that packs VCQ entries, maps
DMA, and submits to the least-loaded mailbox; completion is handled by
per-mailbox threaded IRQs.  The data path is asynchronous: requests
return -EINPROGRESS and the driver honors CRYPTO_TFM_REQ_MAY_BACKLOG for
queue-full backpressure.  The CMH eSW is loaded independently by the
hardware before probe; the driver loads no firmware.

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

A first attempt to post this v7 was partially rejected by the lists'
DMARC checks (our outbound mail path altered some messages after they
were signed), so the cover letter and part of the series never arrived.
This is a complete, clean resend of the same v7 -- no code changes from
that attempt.

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

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
---
Alex Ousherovitch (5):
      dt-bindings: crypto: add Rambus CryptoManager Hub
      crypto: cmh - add core platform driver
      crypto: cmh - add key/datastore infrastructure
      crypto: cmh - add AES skcipher/aead/cmac
      MAINTAINERS: add Rambus CryptoManager Hub (CMH)

 Documentation/ABI/testing/debugfs-driver-cmh       |  171 ++
 Documentation/ABI/testing/sysfs-driver-cmh         |   67 +
 Documentation/crypto/device_drivers/cmh.rst        |  340 ++++
 Documentation/crypto/device_drivers/index.rst      |    1 +
 .../bindings/crypto/rambus,cmh-v1030.yaml          |  144 ++
 .../devicetree/bindings/vendor-prefixes.yaml       |    2 +
 MAINTAINERS                                        |   13 +
 drivers/crypto/Kconfig                             |    1 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/cmh/Kconfig                         |   62 +
 drivers/crypto/cmh/Makefile                        |   30 +
 drivers/crypto/cmh/cmh_aes.c                       |  755 +++++++
 drivers/crypto/cmh/cmh_aes_aead.c                  | 1013 ++++++++++
 drivers/crypto/cmh/cmh_aes_cmac.c                  |  476 +++++
 drivers/crypto/cmh/cmh_config.c                    |  619 ++++++
 drivers/crypto/cmh/cmh_debugfs.c                   |  307 +++
 drivers/crypto/cmh/cmh_dma.c                       |  482 +++++
 drivers/crypto/cmh/cmh_key.c                       |  130 ++
 drivers/crypto/cmh/cmh_main.c                      |  394 ++++
 drivers/crypto/cmh/cmh_mqi.c                       |  344 ++++
 drivers/crypto/cmh/cmh_rh.c                        | 1224 +++++++++++
 drivers/crypto/cmh/cmh_sys.c                       |  376 ++++
 drivers/crypto/cmh/cmh_sysfs.c                     |  108 +
 drivers/crypto/cmh/cmh_txn.c                       | 2118 ++++++++++++++++++++
 drivers/crypto/cmh/include/cmh.h                   |   24 +
 drivers/crypto/cmh/include/cmh_aes.h               |   24 +
 drivers/crypto/cmh/include/cmh_aes_abi.h           |   98 +
 drivers/crypto/cmh/include/cmh_ccp_abi.h           |  108 +
 drivers/crypto/cmh/include/cmh_config.h            |  105 +
 drivers/crypto/cmh/include/cmh_debugfs.h           |   93 +
 drivers/crypto/cmh/include/cmh_dma.h               |  249 +++
 drivers/crypto/cmh/include/cmh_drbg_abi.h          |   67 +
 drivers/crypto/cmh/include/cmh_eac_abi.h           |   44 +
 drivers/crypto/cmh/include/cmh_hc_abi.h            |  162 ++
 drivers/crypto/cmh/include/cmh_hcq_abi.h           |  222 ++
 drivers/crypto/cmh/include/cmh_key.h               |   73 +
 drivers/crypto/cmh/include/cmh_kic_abi.h           |   77 +
 drivers/crypto/cmh/include/cmh_mqi.h               |   35 +
 drivers/crypto/cmh/include/cmh_pke_abi.h           |  272 +++
 drivers/crypto/cmh/include/cmh_qse_abi.h           |  201 ++
 drivers/crypto/cmh/include/cmh_registers.h         |  161 ++
 drivers/crypto/cmh/include/cmh_rh.h                |   93 +
 drivers/crypto/cmh/include/cmh_sm3_abi.h           |   79 +
 drivers/crypto/cmh/include/cmh_sm4_abi.h           |  101 +
 drivers/crypto/cmh/include/cmh_sys.h               |  111 +
 drivers/crypto/cmh/include/cmh_sys_abi.h           |  148 ++
 drivers/crypto/cmh/include/cmh_sysfs.h             |   14 +
 drivers/crypto/cmh/include/cmh_txn.h               |  481 +++++
 drivers/crypto/cmh/include/cmh_vcq.h               |  288 +++
 49 files changed, 12508 insertions(+)
---
base-commit: 9695df3b1db4ac4534274d38ee16e3b9b0bf910e
change-id: 20261026-cmh-b4-a-v7-be063e120421

Best regards,
--  
Alex Ousherovitch <aousherovitch@rambus.com>


