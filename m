Received: from lelvem-ot02.ext.ti.com (lelvem-ot02.ext.ti.com [198.47.23.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE37F1990C7;
	Tue, 19 Aug 2025 06:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755586766; cv=none; b=Eeh+gI/Ue+vXka8isNzFkT47ZBMa48wpl3Bis7CIu6B4mUPv/495wJLoIPX1MdHaXJ1gAfFKaOVFsNMPP6GMEBQir7HCqcnl+JRI3cv8ZuuXsUDZbNdOLeMWRnYyjeGG44wDwOmxLk7aEIJslHZ07zSNAL/dqyH4kVNR8zwkwGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755586766; c=relaxed/simple;
	bh=75RkLqnNhDcq7id9uQWAunD22njATN34YA6N620o9co=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=G5h6fR6LL1PDP4Xnh8UmSUrkkLxr+dQJh2AwTlACQEJckqKcNpkHWZfiqdEzUzdzwVo6nhxqw1IJbpxtKp7hYxaOpB9/sV2sTEbPKW9s9diXuJkv7xMhkMTTj9mohoYpMSkpmIwD24nEBHP2goloSAdxhwl6JfSeW82xmbquYMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=MgMTtsbZ; arc=none smtp.client-ip=198.47.23.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="MgMTtsbZ"
Received: from lelvem-sh02.itg.ti.com ([10.180.78.226])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTP id 57J6xD8m3342625;
	Tue, 19 Aug 2025 01:59:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1755586753;
	bh=vZ4TP7cS8iNEl5xCsSOk3ODpY5HuA/rh6Ke2a4K7Gbw=;
	h=From:To:CC:Subject:Date;
	b=MgMTtsbZCjpjL/VsqUk1rLzVqsd//L0KyLG6hygzzWuai07R2VTnoiiHy047wbgcA
	 wBookMJy8IYqSbt4xCjIfVz3PmzdmvH+19qfGVvuGYOfD0nEWml2eZJIF+kxNzu62q
	 ERnWgkD7KlhJG5RXmk3Efoe8yX6jdxqW1T8pXq7o=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
	by lelvem-sh02.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 57J6xDVN857503
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Tue, 19 Aug 2025 01:59:13 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Tue, 19
 Aug 2025 01:59:12 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55 via
 Frontend Transport; Tue, 19 Aug 2025 01:59:12 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 57J6xBRB2593378;
	Tue, 19 Aug 2025 01:59:11 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller"
	<davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski
	<krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kamlesh
 Gurudasani <kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Vignesh
 Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal
 Mahaveer <vishalm@ti.com>,
        Kavitha Malarvizhi <k-malarvizhi@ti.com>
Subject: [PATCH v6 0/2] Add support for Texas Instruments DTHEv2 Crypto Engine
Date: Tue, 19 Aug 2025 11:42:43 +0530
Message-ID: <20250819065844.3337101-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Data Transform and Hashing Engine (DTHE) v2 is a new cryptography engine
introduced i TI AM62L SoC. DTHEv2 consists of multiple crypto IPs[1] (such
as AES Engine, hashing engine, TRNG, etc.) which can be used for
offloading cryptographic operations off of the CPU. The primary benefit
of DTHEv2 is enhanced side-channel attack resistance, with AES and PKE
engine being DPA and EMA resistant. These side-channel resistances are
the underlying requirement for various certifications like SESIP, PSA,
and IEC62443 (lvl 3+). Thus, DTHEv2 provides critical security benefits
for embedded systems that require protection against passive physical
attacks.

The AES Engine of DTHEv2 supports multiple AES modes (ECB, CBC, CTR,
CFB, f8), several protocols (GCM, CCM, XTS) and authentication modes
(CBC-MAC and f9). The hashing engine supports MD5, SHA1, and SHA2 (224,
256, 384, 512) algorithms along with HMAC. This patch series introduces
basic driver support for DTHEv2 engine, beginning with suporting AES-ECB
and AES-CBC algorithms. Other algorithms are planned to be added
gradually in phases after initial suppport is added.

The driver is tested using full kernel crypto selftests (CRYPTO_SELFTESTS)
which all pass successfully [2].

Signed-off-by: T Pratham <t-pratham@ti.com>
---
[1]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

[2]: DTHEv2 AES-ECB and AES-CBC kernel self-tests logs
Link: https://gist.github.com/Pratham-T/aaa499cf50d20310cb27266a645bfd60

Change log:
v6:
 - Reworded the cover letter and commit messages to name DTHEv2 as a
   crypto engine instead of crypto accelerator.
 - Reworded the cover letter completely to emphasise more on the utility
   of DTHEv2 as better resistance against physical attacks
 - Reworded DTHEv2 description (help text) in KConfig
 - Added dma_terminate_sync calls to ensure DMA requests are removed in
   case when completion times-out.
 - Some rearrangement of fields between dthe_tfm_ctx and dthe_aes_req_ctx
   struct, so that per tfm members are correctly placed in tfm_ctx and per
   request members are in req_ctx. Subsequently setkey, encrypt and
   decrypt functions are also changed.
 - Removed exit_tfm function which was useless and not required.
 - Removed unnecessary zeroing of tfm_ctx object in init_tfm.
 - Corrected return value in dthe_aes_run function.
 - Reduced cra_priority of DTHEv2 algorithms.
v5:
 - Simplified tfm ctx struct
 - Set cra_reqsize instead of using crypto_skcipher_set_reqsize()
 - Move setting sysconfig and irqenable registers to dthe_aes_run
v4:
 - Corrected dt-bindings example indentation
 - Simplified dt-bindings example, removing the node surrounding crypto
 - Fixed typo in dthev2-common.h header guard
 - Removed unused ctx field in dev_data struct
 - Moved per-op data into request context
v3:
 - Corrected dt-bindings reg length is too long error
 - Converted AES driver code to use crypto_engine APIs for using
   internal crypto queue instead of mutex.
 - Removed calls to skcipher_request_complete in paths not returning
   -EINPROGRESS before.
 - Added missing KConfig import, which was accidentally removed in v2.

v2:
 - Corrected dt-bindings syntax errors and other review comments in v1.
 - Completely changed driver code structure, splitting code into
   multiple files

Link to previous versions:
v5: https://lore.kernel.org/all/20250603124217.957116-1-t-pratham@ti.com/
v4: https://lore.kernel.org/all/20250508101723.846210-2-t-pratham@ti.com/
v3: https://lore.kernel.org/all/20250502121253.456974-2-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20250411091321.2925308-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20250206-dthe-v2-aes-v1-0-1e86cf683928@ti.com/
---

T Pratham (2):
  dt-bindings: crypto: Add binding for TI DTHE V2
  crypto: ti: Add driver for DTHE V2 AES Engine (ECB, CBC)

 .../bindings/crypto/ti,am62l-dthev2.yaml      |  50 +++
 MAINTAINERS                                   |   7 +
 drivers/crypto/Kconfig                        |   1 +
 drivers/crypto/Makefile                       |   1 +
 drivers/crypto/ti/Kconfig                     |  14 +
 drivers/crypto/ti/Makefile                    |   3 +
 drivers/crypto/ti/dthev2-aes.c                | 411 ++++++++++++++++++
 drivers/crypto/ti/dthev2-common.c             | 220 ++++++++++
 drivers/crypto/ti/dthev2-common.h             | 101 +++++
 9 files changed, 808 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,am62l-dthev2.yaml
 create mode 100644 drivers/crypto/ti/Kconfig
 create mode 100644 drivers/crypto/ti/Makefile
 create mode 100644 drivers/crypto/ti/dthev2-aes.c
 create mode 100644 drivers/crypto/ti/dthev2-common.c
 create mode 100644 drivers/crypto/ti/dthev2-common.h

-- 
2.43.0

