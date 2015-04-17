From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3 00/17] crypto: talitos - Add support for SEC1
Date: Fri, 17 Apr 2015 16:31:47 +0200 (CEST)
Message-ID: <20150417143147.154871A242C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:42088 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934421AbbDQObt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 10:31:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The purpose of this set of patchs is to add to talitos crypto driver
the support for the SEC1 version of the security engine, which is
found in mpc885 and mpc8272 processors.

v3 is a complete rework of the patchset. Since a kernel can be built
with support for both MPC82xx and MPC83xx at the same time, talitos
driver shall support both SEC1 and SEC2+ at the same time.

Based on cryptodev-2.6 tree

Christophe Leroy (17):
  crypto: talitos - Use zero entry to init descriptors ptrs to zero
  crypto: talitos - Refactor the sg in/out chain allocation
  crypto: talitos - talitos_ptr renamed ptr for more lisibility
  crypto: talitos - Add a helper function to clear j_extent field
  crypto: talitos - remove param 'extent' in map_single_talitos_ptr()
  crypto: talitos - helper function for ptr len
  crypto: talitos - enhanced talitos_desc struct for SEC1
  crypto: talitos - add sub-choice in talitos CONFIG for SEC1
  crypto: talitos - Add a feature to tag SEC1
  crypto: talitos - fill in talitos descriptor iaw SEC1 or SEC2+
  crypto: talitos - adaptation of talitos_submit() for SEC1
  crypto: talitos - base address for Execution Units
  crypto: talitos - adapt interrupts and reset functions to SEC1
  crypto: talitos - implement scatter/gather copy for SEC1
  crypto: talitos - SEC1 bugs on 0 data hash
  crypto: talitos - Add fsl,sec1.0 compatible
  crypto: talitos - Update DT bindings with SEC1

 .../devicetree/bindings/crypto/fsl-sec2.txt        |   6 +-
 drivers/crypto/Kconfig                             |  18 +
 drivers/crypto/talitos.c                           | 727 +++++++++++++++------
 drivers/crypto/talitos.h                           | 153 +++--
 4 files changed, 644 insertions(+), 260 deletions(-)

-- 
2.1.0
