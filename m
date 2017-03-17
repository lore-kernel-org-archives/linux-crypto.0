From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 0/7] crypto: caam - add Queue Interface (QI) support
Date: Fri, 17 Mar 2017 12:05:55 +0200
Message-ID: <20170317100602.2837-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Cristian Stoica <cristian.stoica@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Wood <oss@buserror.net>, Roy Pledge <roy.pledge@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0082.outbound.protection.outlook.com ([104.47.37.82]:13225
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750885AbdCQKGb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Mar 2017 06:06:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

RFC -> v1:
-rebased on latest cryptodev-2.6 tree
open-code tsk_cpus_allowed() - sync with commit
0c98d344fe5c "sched/core: Remove the tsk_cpus_allowed() wrapper"
-addressed Scott's feedback - removed most of the accessors
added in soc/qman (patch 4) and instead open-coded them in caam/qi


The patchset adds support for CAAM Queue Interface (QI), the additional
interface (besides job ring) available for submitting jobs to the engine
on platforms having DPAA (Datapath Acceleration Architecture).

Patches 1-4 are QMan dependencies.
During RFC stage, we agreed to go with them through the crypto tree:
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg24105.html

Patch 5 adds a missing double inclusion guard in desc_constr.h.

Patch 6 adds the caam/qi job submission backend.

Patch 7 adds algorithms (ablkcipher and authenc) that run on top
of caam/qi. For now, their priority is set lower than caam/jr.

Thanks,
Horia

Horia Geantă (7):
  soc/qman: export volatile dequeue related structs
  soc/qman: add dedicated channel ID for CAAM
  soc/qman: export non-programmable FQD fields query
  soc/qman: add macros needed by caam/qi driver
  crypto: caam - avoid double inclusion in desc_constr.h
  crypto: caam - add Queue Interface (QI) backend support
  crypto: caam/qi - add ablkcipher and authenc algorithms

 drivers/crypto/caam/Kconfig        |   20 +-
 drivers/crypto/caam/Makefile       |    5 +
 drivers/crypto/caam/caamalg.c      |    9 +-
 drivers/crypto/caam/caamalg_desc.c |   77 +-
 drivers/crypto/caam/caamalg_desc.h |   15 +-
 drivers/crypto/caam/caamalg_qi.c   | 2387 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/ctrl.c         |   58 +-
 drivers/crypto/caam/desc_constr.h  |    5 +
 drivers/crypto/caam/intern.h       |   24 +
 drivers/crypto/caam/qi.c           |  805 ++++++++++++
 drivers/crypto/caam/qi.h           |  201 +++
 drivers/crypto/caam/sg_sw_qm.h     |  108 ++
 drivers/soc/fsl/qbman/qman.c       |    4 +-
 drivers/soc/fsl/qbman/qman_ccsr.c  |    6 +-
 drivers/soc/fsl/qbman/qman_priv.h  |   97 --
 include/soc/fsl/qman.h             |  109 ++
 16 files changed, 3786 insertions(+), 144 deletions(-)
 create mode 100644 drivers/crypto/caam/caamalg_qi.c
 create mode 100644 drivers/crypto/caam/qi.c
 create mode 100644 drivers/crypto/caam/qi.h
 create mode 100644 drivers/crypto/caam/sg_sw_qm.h

-- 
2.12.0.264.gd6db3f216544
