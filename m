From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 0/9] crypto: caam - Add RTA descriptor creation library
Date: Fri, 18 Jul 2014 19:37:17 +0300
Message-ID: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "David S. Miller" <davem@davemloft.net>,
	Carmen Iorga <carmen.iorga@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Alexandru Porosanu <alexandru.porosanu@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	"Horia Geanta" <horia.geanta@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:38472
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753440AbaGRQis (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Jul 2014 12:38:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch set adds Run Time Assembler (RTA) SEC descriptor library.

The main reason of replacing incumbent "inline append" is
to have a single code base both for user space and kernel space.

Patches are based on latest cryptodev, but with the following on top:
[PATCH 00/10] CAAM - DMA API fixes
http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg11381.html
[PATCH] crypto: caam - set DK (Decrypt Key) bit only for AES accelerator
www.mail-archive.com/linux-crypto@vger.kernel.org/msg11392.html

Patches 01-04 are fixes, clean-ups.

Patch 05 adds the RTA library.

Patch 06 rewrites "inline append" descriptors using RTA.
Descriptors (hex dumps) were tested to be bit-exact,
with a few exceptions (see commit message).

Patch 07 removes "inline append".

Patch 08 refactors code that generates the descriptors,
to make code more comprehensible and maintainable.

Patch 09 adds support for generating kernel-doc for RTA.
It depends on upstream (torvalds/linux.git) commit
cbb4d3e6510b99522719c5ef0cd0482886a324c0
("scripts/kernel-doc: handle object-like macros")

Thanks,
Horia

Horia Geanta (9):
  crypto: caam - completely remove error propagation handling
  crypto: caam - desc.h fixes
  crypto: caam - code cleanup
  crypto: caam - move sec4_sg_entry to sg_sw_sec4.h
  crypto: caam - add Run Time Library (RTA)
  crypto: caam - use RTA instead of inline append
  crypto: caam - completely remove inline append
  crypto: caam - refactor descriptor creation
  crypto: caam - add Run Time Library (RTA) docbook

 Documentation/DocBook/Makefile                     |    3 +-
 Documentation/DocBook/rta-api.tmpl                 |  245 ++
 Documentation/DocBook/rta/.gitignore               |    1 +
 Documentation/DocBook/rta/Makefile                 |    5 +
 Documentation/DocBook/rta/rta_arch.svg             |  381 +++
 drivers/crypto/caam/Makefile                       |    4 +-
 drivers/crypto/caam/caamalg.c                      |  850 ++++---
 drivers/crypto/caam/caamhash.c                     |  550 ++---
 drivers/crypto/caam/caamrng.c                      |   53 +-
 drivers/crypto/caam/compat.h                       |    1 +
 drivers/crypto/caam/ctrl.c                         |   98 +-
 drivers/crypto/caam/ctrl.h                         |    2 +-
 drivers/crypto/caam/desc.h                         | 1621 -------------
 drivers/crypto/caam/desc_constr.h                  |  388 ---
 drivers/crypto/caam/error.c                        |    7 +-
 drivers/crypto/caam/flib/desc.h                    | 2541 ++++++++++++++++++++
 drivers/crypto/caam/flib/desc/common.h             |   39 +
 drivers/crypto/caam/flib/desc/jobdesc.h            |   75 +
 drivers/crypto/caam/flib/rta.h                     |  926 +++++++
 drivers/crypto/caam/flib/rta/fifo_load_store_cmd.h |  319 +++
 drivers/crypto/caam/flib/rta/header_cmd.h          |  209 ++
 drivers/crypto/caam/flib/rta/jump_cmd.h            |  181 ++
 drivers/crypto/caam/flib/rta/key_cmd.h             |  192 ++
 drivers/crypto/caam/flib/rta/load_cmd.h            |  308 +++
 drivers/crypto/caam/flib/rta/math_cmd.h            |  388 +++
 drivers/crypto/caam/flib/rta/move_cmd.h            |  408 ++++
 drivers/crypto/caam/flib/rta/nfifo_cmd.h           |  164 ++
 drivers/crypto/caam/flib/rta/operation_cmd.h       |  545 +++++
 drivers/crypto/caam/flib/rta/protocol_cmd.h        |  595 +++++
 drivers/crypto/caam/flib/rta/sec_run_time_asm.h    |  755 ++++++
 drivers/crypto/caam/flib/rta/seq_in_out_ptr_cmd.h  |  168 ++
 drivers/crypto/caam/flib/rta/signature_cmd.h       |   36 +
 drivers/crypto/caam/flib/rta/store_cmd.h           |  156 ++
 drivers/crypto/caam/jr.c                           |    6 +-
 drivers/crypto/caam/key_gen.c                      |   36 +-
 drivers/crypto/caam/key_gen.h                      |    2 +-
 drivers/crypto/caam/pdb.h                          |  402 ----
 drivers/crypto/caam/sg_sw_sec4.h                   |   12 +-
 38 files changed, 9511 insertions(+), 3161 deletions(-)
 create mode 100644 Documentation/DocBook/rta-api.tmpl
 create mode 100644 Documentation/DocBook/rta/.gitignore
 create mode 100644 Documentation/DocBook/rta/Makefile
 create mode 100644 Documentation/DocBook/rta/rta_arch.svg
 delete mode 100644 drivers/crypto/caam/desc.h
 delete mode 100644 drivers/crypto/caam/desc_constr.h
 create mode 100644 drivers/crypto/caam/flib/desc.h
 create mode 100644 drivers/crypto/caam/flib/desc/common.h
 create mode 100644 drivers/crypto/caam/flib/desc/jobdesc.h
 create mode 100644 drivers/crypto/caam/flib/rta.h
 create mode 100644 drivers/crypto/caam/flib/rta/fifo_load_store_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/header_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/jump_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/key_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/load_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/math_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/move_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/nfifo_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/operation_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/protocol_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/sec_run_time_asm.h
 create mode 100644 drivers/crypto/caam/flib/rta/seq_in_out_ptr_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/signature_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/store_cmd.h
 delete mode 100644 drivers/crypto/caam/pdb.h

-- 
1.8.3.1
