Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022142.outbound.protection.outlook.com [40.93.195.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BD75208D5;
	Tue, 13 Oct 2026 17:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.142
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791913743; cv=fail; b=Ro9yEG3tiz5Ni7IPungk9wSPERARKj0ILuWjpECObbM5xolXhFPc7YeL7OxgjQlkMKDhjvqUmfsPjdBaBEGsUDP2swurYl4JzUPaBF3Peti6Y3Hj1f7zQbJpbA5c33hXhe1Um/frOWy6Da23bOzCN/V4kVMsq114HZL5j6s7UZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791913743; c=relaxed/simple;
	bh=2tgTu65qkmhytKBt8p/aNaPE8HLZmHIs/2G0oJnroKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=o813WByvFfynAQk4Fj7wpdBY9dv6xhpIOutEA/phIgpUq3Y+E1cRmMm8RY0cP1+2sfl/VV+g0VtnXxe6TCTiBMtzm2XYrTVWbKYnb7GPDArsMPQ+5MsXwkfU146/jO2XqulxrSE0Gy9QyEyjTNX9IENvFt0DzoCS1hpfstLLGIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=cRADqUlX; arc=fail smtp.client-ip=40.93.195.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="cRADqUlX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aPihsuiq64m9kUDjX0etE2olmO2k5cVsOF+vaNqgJ/eKh8fgsJ/9sxzb4wL4ets8cSzbuVL0Rqa19qWl3EZcTRuvkfS0PiGBehlVnoygB6FcfltnHsiyC/FpNqOo2HqH0+fSs/u0kVKHv3RK3HReArZXtUXkZnwbetWKkS7bNSACTtze5D+aZAGnmAa9WLr6PjE9EwlwcHy7O03+P4oZ2YI2dF/3kY+7kJG4sQcU9Lig1vd9U1F0+JCAvbZ05jD5Na8bQOE8cURLvEbR02jcQ+8ictE6aZOm5o4cDxo2dgBnttE7An1Zq2MQi183ctm5t2+eMCe7KT3TyHjm+5IoxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOAFRi/yF/Qq6qQ+tzp1qrDwbsxk11RMCyAwRcmrqzc=;
 b=GWwk5c8iVWtOmTZgKWKhesD4lpkTKMvGFYdNbqxrbFZZoJHmMbkwxI7RtCeKaYAEcruMDRBsia8Ccx9S5JDfb7zGRfoAY4kamvQg5aXUcmoFAERZ8t8aR+ZdYuOmuuCh4sMEA5eFW2iWvulnzzmMXdwWwf9UlKbBYVC1Js3nNmor7GZYkMuCeyGw5275b9Mbyx8/m/NxmrMTaWbIa/W6OqMDPWNc4NN5aP0F9LLBOXGbQt5LHsNmzKJ9v4dHIxFTyVu2Fw6IGNE2ia06rGQ7R2PKQsrGTYAx3dmGGrvoPD6z8BZeYBuu/7rmhANN4GRoswTAMThMHsLBS559+b33Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOAFRi/yF/Qq6qQ+tzp1qrDwbsxk11RMCyAwRcmrqzc=;
 b=cRADqUlXIA7tSn5ZCclJw71Qo2cBtAdP4OZuWQ1Dq/chY5LpeHISUsvG1EJyAy9CeY7afTTxppujsLQeAjn5i82+qL9QBtmrddlYFPnXqSEPQ4QL+72b57lVXa/sS68dVKx2LoxEQB7tyRe/v1NAwPvLc4ONuEI4kf2vPOlCyYv3giOFmXv05qVh7KU5JBt2yo5N2KgAT/3kjFSLU651HUXBVTJD8lYO3puuGbRdL06nzItfGaw0cBuQfzL+bEHRb9Bg6poG259F3jXChbQVtjf6TaMy3J2gjxeo6wErFzzy9Zhwje/RBT9SVXdp+0DsDuGNQHbn9YETexapKPPcwg==
Received: from BN9PR03CA0173.namprd03.prod.outlook.com (2603:10b6:408:f4::28)
 by CH8PR04MB994550.namprd04.prod.outlook.com (2603:10b6:610:373::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 17:48:53 +0000
Received: from BN2PEPF000044AB.namprd04.prod.outlook.com
 (2603:10b6:408:f4:cafe::98) by BN9PR03CA0173.outlook.office365.com
 (2603:10b6:408:f4::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Tue, 13
 Oct 2026 17:48:52 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 192.86.86.210) smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 BN2PEPF000044AB.mail.protection.outlook.com (10.167.243.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.6
 via Frontend Transport; Tue, 13 Oct 2026 17:48:52 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTP id AFDE7180174C;
	Tue, 13 Oct 2026 17:48:51 +0000 (UTC)
From: Alex Ousherovitch <aousherovitch@rambus.com>
To: Alex Ousherovitch <aousherovitch@rambus.com>,
	Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Corbet <corbet@lwn.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Cc: devicetree@vger.kernel.org,
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thi Nguyen <thin@rambus.com>
Subject: [PATCH 0/5] crypto: cmh - add Rambus CryptoManager Hub core driver and AES
Date: Tue, 13 Oct 2026 10:48:42 -0700
Message-ID: <20261013174847.2192609-1-aousherovitch@rambus.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AB:EE_|CH8PR04MB994550:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: f78e077c-ae5e-40b4-f23d-08df29523ea8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|23010399003|7416014|82310400026|1800799024|11063799006|56012099006|261009221227099003|261009223027099003|10067099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	pp71fHAJZH8CG/gheShrErFdzxAf5UPYxGNcXYhLHDwXWgtAlNhdyYi9+TVzmLkfRRTr+ilg3sCr52xZXATOvQnhHlYhaeK/1ow4jKYsVkBDjEUQqIkuM2LpPxcDGoOmNW8XofSvWoA0H0JChKbanMPPTGCwp+9RFdFUo+3+hR4jqrMHPxNdcGRERLMM49JzDCAshcqv0B20+l+gpbOzgGjWkmW6OkET2kA5NIYrapTRV7ZeRJmuS9CvgIvbJljZYt7zFvta5dp2uhrYyHyx/PoIYAtAIvve4MlGuHVZnoLvEjDhVxSTr4bGSzhWmVB7+kK04KLZfNSpFQtZKaIIimCfsWGVwiCdUxAUcd68L5OxJjAxrZO8SssYsHsdznhTXDkdKmGA888RhwTcE8F/m+nbEQXZghP5hDKOrPSSl7aKpTBRmn7cQmMZgQCjXrQ9u+rJHcKnsciBeV79GpAAAyBiiOAPSOe+drqFsrk1MrsPk2A8CxDU6/paAuTIH8UfIF6K9Z9TzUdX+is5iCpo2gj/2OkrfnIcEZR09ch++QJnWQJPPe9szsKNLcQ/UapfYZZ1mgr5IKPW1wNAtz16qU/fFCmMtsP8SfmnHc0I0XMPtsPndM0+vQAzycpbwPUc3sUiJDnQnPrOT8/LcSM4Gw==
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(23010399003)(7416014)(82310400026)(1800799024)(11063799006)(56012099006)(261009221227099003)(261009223027099003)(10067099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vqgn0mciIzYuCEe9ji5touMc3olSsDU1cVct9tpbS9Y8oF0+/Oe1AbY0TdjNZcr+r1s2vcvL7UeLYXMfDl4fzHa5Z7mu4cUxQ627kh1jd0WCNaUgRLlnKqTKE9BruBbGuyHAqbXjJl/93Y85807NCh58TQlCP6s/KJZzIQe0n/ih7y1Dd4G2G5vH2CmouIr11ointoY9Xa4S/qD9mJLSgxL8uJF0VZVkbBKAhLQr+RV3EXOankXCx80PY3/SS9rULU5txtBDpiwrqiZzUWNiqFV4eioT3huhVGBOjHIhTRm9F4a/eTgcGZ7GxEgu+8Q1GGK5IEM0Onue2Lz3y+pBZW4+mMInekbJqGlUUKIpssvXnROfxmyRulBOiIFdT1jXmvrvDVc3HEm9K40bFN7gzuwd205NeLuEruMIEEmZjfdEmB8auUJ+8VushTv3wsdx
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 17:48:52.3539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f78e077c-ae5e-40b4-f23d-08df29523ea8
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR04MB994550

This is the first of a short, incremental set of submissions adding
support for the Rambus CryptoManager Hub (CMH), a hardware cryptographic
accelerator accessed through a mailbox-based VCQ (Virtual Command Queue)
interface.  To keep each posting small and independently reviewable, the
driver is submitted in self-contained parts; this first series adds the
core platform driver, the shared key/datastore layer and the AES
transforms (plus the device-tree binding and the MAINTAINERS entry).  AES
is the first and least-problematic algorithm family, so the core has a
user and the VCQ/DMA/completion data path is reviewable end to end.
Later series add the remaining symmetric ciphers (SM4, ChaCha20-Poly1305)
and the hwrng, the hashes and MACs, and finally the asymmetric and
post-quantum algorithms together with the /dev/cmh_mgmt management
interface.

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
  Product brief: https://go.rambus.com/ch-7xx-and-cc-7xx-product-brief
  No public datasheets are currently available.  The driver was
  developed against the Rambus CryptoManager Hub Hardware Reference
  Manual (Rambus Inc. confidential).  Detailed hardware reference is
  available under NDA from Rambus Inc.; contact the maintainers listed
  in MAINTAINERS for access during review.

Developed against Herbert Xu's cryptodev tree.  checkpatch.pl --strict,
sparse (C=2) and a W=1 -Werror build are clean, and dtschema's
dt-doc-validate accepts the binding.  Exercised on riscv64 and arm64 --
QEMU with the CMH hardware model and a Xilinx VMK180 FPGA with the CMH
IP -- under lockdep/PROVE_LOCKING, DEBUG_OBJECTS,
KASAN/UBSAN/KMEMLEAK/KFENCE and (arm64) KCSAN with no findings;
worst-case stack stays under 1 KB.

Alex Ousherovitch (5):
  dt-bindings: crypto: add Rambus CryptoManager Hub
  crypto: cmh - add core platform driver
  crypto: cmh - add key/datastore infrastructure
  crypto: cmh - add AES skcipher/aead/cmac
  MAINTAINERS: add Rambus CryptoManager Hub (CMH)

 Documentation/ABI/testing/debugfs-driver-cmh  |  171 ++
 Documentation/ABI/testing/sysfs-driver-cmh    |   67 +
 Documentation/crypto/device_drivers/cmh.rst   |  340 +++
 Documentation/crypto/device_drivers/index.rst |    1 +
 .../bindings/crypto/rambus,cmh-v1030.yaml     |  144 ++
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 MAINTAINERS                                   |   13 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/cmh/Kconfig                    |   62 +
 drivers/crypto/cmh/Makefile                   |   30 +
 drivers/crypto/cmh/cmh_aes.c                  |  755 ++++++
 drivers/crypto/cmh/cmh_aes_aead.c             | 1013 ++++++++
 drivers/crypto/cmh/cmh_aes_cmac.c             |  476 ++++
 drivers/crypto/cmh/cmh_config.c               |  619 +++++
 drivers/crypto/cmh/cmh_debugfs.c              |  307 +++
 drivers/crypto/cmh/cmh_dma.c                  |  482 ++++
 drivers/crypto/cmh/cmh_key.c                  |  119 +
 drivers/crypto/cmh/cmh_main.c                 |  394 +++
 drivers/crypto/cmh/cmh_mqi.c                  |  344 +++
 drivers/crypto/cmh/cmh_rh.c                   | 1211 +++++++++
 drivers/crypto/cmh/cmh_sys.c                  |  376 +++
 drivers/crypto/cmh/cmh_sysfs.c                |  108 +
 drivers/crypto/cmh/cmh_txn.c                  | 2235 +++++++++++++++++
 drivers/crypto/cmh/include/cmh.h              |   24 +
 drivers/crypto/cmh/include/cmh_aes.h          |   24 +
 drivers/crypto/cmh/include/cmh_aes_abi.h      |   98 +
 drivers/crypto/cmh/include/cmh_ccp_abi.h      |  108 +
 drivers/crypto/cmh/include/cmh_config.h       |  105 +
 drivers/crypto/cmh/include/cmh_debugfs.h      |   93 +
 drivers/crypto/cmh/include/cmh_dma.h          |  249 ++
 drivers/crypto/cmh/include/cmh_drbg_abi.h     |   67 +
 drivers/crypto/cmh/include/cmh_eac_abi.h      |   44 +
 drivers/crypto/cmh/include/cmh_hc_abi.h       |  162 ++
 drivers/crypto/cmh/include/cmh_hcq_abi.h      |  222 ++
 drivers/crypto/cmh/include/cmh_key.h          |   73 +
 drivers/crypto/cmh/include/cmh_kic_abi.h      |   77 +
 drivers/crypto/cmh/include/cmh_mqi.h          |   35 +
 drivers/crypto/cmh/include/cmh_pke_abi.h      |  272 ++
 drivers/crypto/cmh/include/cmh_qse_abi.h      |  201 ++
 drivers/crypto/cmh/include/cmh_registers.h    |  161 ++
 drivers/crypto/cmh/include/cmh_rh.h           |   93 +
 drivers/crypto/cmh/include/cmh_sm3_abi.h      |   79 +
 drivers/crypto/cmh/include/cmh_sm4_abi.h      |  101 +
 drivers/crypto/cmh/include/cmh_sys.h          |  111 +
 drivers/crypto/cmh/include/cmh_sys_abi.h      |  148 ++
 drivers/crypto/cmh/include/cmh_sysfs.h        |   14 +
 drivers/crypto/cmh/include/cmh_txn.h          |  493 ++++
 drivers/crypto/cmh/include/cmh_vcq.h          |  288 +++
 49 files changed, 12613 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-driver-cmh
 create mode 100644 Documentation/ABI/testing/sysfs-driver-cmh
 create mode 100644 Documentation/crypto/device_drivers/cmh.rst
 create mode 100644 Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
 create mode 100644 drivers/crypto/cmh/Kconfig
 create mode 100644 drivers/crypto/cmh/Makefile
 create mode 100644 drivers/crypto/cmh/cmh_aes.c
 create mode 100644 drivers/crypto/cmh/cmh_aes_aead.c
 create mode 100644 drivers/crypto/cmh/cmh_aes_cmac.c
 create mode 100644 drivers/crypto/cmh/cmh_config.c
 create mode 100644 drivers/crypto/cmh/cmh_debugfs.c
 create mode 100644 drivers/crypto/cmh/cmh_dma.c
 create mode 100644 drivers/crypto/cmh/cmh_key.c
 create mode 100644 drivers/crypto/cmh/cmh_main.c
 create mode 100644 drivers/crypto/cmh/cmh_mqi.c
 create mode 100644 drivers/crypto/cmh/cmh_rh.c
 create mode 100644 drivers/crypto/cmh/cmh_sys.c
 create mode 100644 drivers/crypto/cmh/cmh_sysfs.c
 create mode 100644 drivers/crypto/cmh/cmh_txn.c
 create mode 100644 drivers/crypto/cmh/include/cmh.h
 create mode 100644 drivers/crypto/cmh/include/cmh_aes.h
 create mode 100644 drivers/crypto/cmh/include/cmh_aes_abi.h
 create mode 100644 drivers/crypto/cmh/include/cmh_ccp_abi.h
 create mode 100644 drivers/crypto/cmh/include/cmh_config.h
 create mode 100644 drivers/crypto/cmh/include/cmh_debugfs.h
 create mode 100644 drivers/crypto/cmh/include/cmh_dma.h
 create mode 100644 drivers/crypto/cmh/include/cmh_drbg_abi.h
 create mode 100644 drivers/crypto/cmh/include/cmh_eac_abi.h
 create mode 100644 drivers/crypto/cmh/include/cmh_hc_abi.h
 create mode 100644 drivers/crypto/cmh/include/cmh_hcq_abi.h
 create mode 100644 drivers/crypto/cmh/include/cmh_key.h
 create mode 100644 drivers/crypto/cmh/include/cmh_kic_abi.h
 create mode 100644 drivers/crypto/cmh/include/cmh_mqi.h
 create mode 100644 drivers/crypto/cmh/include/cmh_pke_abi.h
 create mode 100644 drivers/crypto/cmh/include/cmh_qse_abi.h
 create mode 100644 drivers/crypto/cmh/include/cmh_registers.h
 create mode 100644 drivers/crypto/cmh/include/cmh_rh.h
 create mode 100644 drivers/crypto/cmh/include/cmh_sm3_abi.h
 create mode 100644 drivers/crypto/cmh/include/cmh_sm4_abi.h
 create mode 100644 drivers/crypto/cmh/include/cmh_sys.h
 create mode 100644 drivers/crypto/cmh/include/cmh_sys_abi.h
 create mode 100644 drivers/crypto/cmh/include/cmh_sysfs.h
 create mode 100644 drivers/crypto/cmh/include/cmh_txn.h
 create mode 100644 drivers/crypto/cmh/include/cmh_vcq.h


---

The CMH driver was first posted as a single series; it is now
split into smaller, independently reviewable series per maintainer
feedback.  Earlier single-series postings:
  v1: https://lore.kernel.org/linux-crypto/20260625173328.1140487-1-skrishnamoorthy@rambus.com/
  v2: https://lore.kernel.org/linux-crypto/20260709203037.1884436-1-skrishnamoorthy@rambus.com/
  v3: https://lore.kernel.org/linux-crypto/20260806195519.2703224-1-skrishnamoorthy@rambus.com/
  v4: https://lore.kernel.org/linux-crypto/20260825221539.255951-1-aousherovitch@rambus.com/
  v5: https://lore.kernel.org/linux-crypto/20260917225929.2494111-1-aousherovitch@rambus.com/
base-commit: 9695df3b1db4ac4534274d38ee16e3b9b0bf910e

-- 
2.43.7

