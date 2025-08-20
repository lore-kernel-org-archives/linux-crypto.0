Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894BD275865;
	Wed, 20 Aug 2025 09:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755682676; cv=none; b=q6fkUfeBJI8DBYZ1zNKtMBPASzx5dBXMuzClTFuwMsg3biPwbF5+ve0j+kXG3r8uDLXszOgME9Z42Wf2n8FSRyJjvRL1ZXcdR4MyWJNKaTSgdObMaiI3ga+m/1xljyRbvK2qBHXJUKfi84jtedKGQ7tko4TCFgnd9TdBRza6uuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755682676; c=relaxed/simple;
	bh=CKxYqhRhl4loo1ox1nG7a5Etf7YvcbqwFYZAD9TfdcY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IE7zabzECYL8k/RvW6djOJ4ySpZiDoJc+tn/7kXkfJ2HxODAPPJACuYoSqgm02c4zBWYmGJD3ZhTvycbrZ+2V17ku/6pB5as8l/nXSsH4RPLYR5K9HAe3OPyB1y1Y7m6DYOdvH2f6d9bqPDW69H6Vy1OSD/j6Y3ohmt2EA8t65M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=lFFJzAqJ; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="lFFJzAqJ"
Received: from fllvem-sh04.itg.ti.com ([10.64.41.54])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTP id 57K9bkMC3104749;
	Wed, 20 Aug 2025 04:37:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1755682666;
	bh=v7KuCJOEXfogdf9zmemvwzD6OZ4YodlPBPiR1Btfx+o=;
	h=From:To:CC:Subject:Date;
	b=lFFJzAqJwmmYIxrMvD90JBBc4Gwe0FOSHgg6E5e2F+egwsEAP1z6T6rGq27LMllyE
	 63/DCQ6f4eUHh+eqd1wwDln/ibEhAhwqqNLWssYfKYI6TiVBvZb20N8Ef8DL/XFjzF
	 XUJ7V6vPj+hILdfoWCuAiqo1WYZqn1GOOy5Vakyk=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
	by fllvem-sh04.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 57K9bkEQ1959779
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Wed, 20 Aug 2025 04:37:46 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Wed, 20
 Aug 2025 04:37:46 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55 via
 Frontend Transport; Wed, 20 Aug 2025 04:37:46 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 57K9bi27307955;
	Wed, 20 Aug 2025 04:37:45 -0500
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
Subject: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto Engine
Date: Wed, 20 Aug 2025 14:42:25 +0530
Message-ID: <20250820092710.3510788-1-t-pratham@ti.com>
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
v7:
 - Dropped redundant crypto_engine_stop() calls.
 - Corrected Reviewed-by tag.
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
v6: https://lore.kernel.org/all/20250819065844.3337101-1-t-pratham@ti.com/
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
 drivers/crypto/ti/dthev2-common.c             | 217 +++++++++
 drivers/crypto/ti/dthev2-common.h             | 101 +++++
 9 files changed, 805 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,am62l-dthev2.yaml
 create mode 100644 drivers/crypto/ti/Kconfig
 create mode 100644 drivers/crypto/ti/Makefile
 create mode 100644 drivers/crypto/ti/dthev2-aes.c
 create mode 100644 drivers/crypto/ti/dthev2-common.c
 create mode 100644 drivers/crypto/ti/dthev2-common.h

-- 
2.43.0

