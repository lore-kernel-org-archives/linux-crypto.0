From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH v2 00/12] crypto: caam - Add RTA descriptor creation library
Date: Thu, 14 Aug 2014 15:54:22 +0300
Message-ID: <1408020874-2211-1-git-send-email-horia.geanta@freescale.com>
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
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:10505
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752368AbaHNMzl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Aug 2014 08:55:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This patch set adds Run Time Assembler (RTA) SEC descriptor library.
RTA is a replacement for incumbent "inline append".

The library is intended to be a single code base for SEC descriptors creation
for all Freescale products. This comes with a series of advantages, such as
library being maintained / kept up-to-date with latest platforms, i.e. SEC
functionalities (for e.g. SEC incarnations present in Layerscape LS1 and LS2).

RTA detects options in SEC descriptors that are not supported
by a SEC HW revision ("Era") and reports this back.
Say a descriptor uses Sequence Out Pointer (SOP) option for the SEQINPTR
command, which is supported starting from SEC Era 5. If the descriptor would
be built on a P4080R3 platform (which has SEC Era 4), RTA would report
"SEQ IN PTR: Flag(s) not supported by SEC Era 4".
This is extremely useful and saves a lot of time wasted on debugging.
SEC HW detects only *some* of these problems, leaving user wonder what causes
a "DECO Watchdog Timeout". And when it prints something more useful, sometimes
it does not point to the exact opcode.

Below is a summary of the patch set.

Patches 01-04 are fixes, clean-ups.

Patches 05-07 add the RTA library in 3 steps, to overcome
patch size limitations.
Patch 07 replaces desc.h with a new version from RTA. However, at this stage,
RTA is still not being used.

Patch 08 rewrites "inline append" descriptors using RTA.
Descriptors (hex dumps) were tested to be bit-exact,
with a few exceptions (see commit message).

Patch 09 removes "inline append" files.

Patch 10 refactors code that generates the descriptors,
in order to:
-make code more comprehensible and maintainable
-prepare for changes in patch 11

Patch 11 moves some of the descriptors that could be used
in other places from caamalg.c into RTA library files.

Patch 12 adds support for generating kernel-doc for RTA.
It depends on upstream (torvalds/linux.git) commit
cbb4d3e6510b99522719c5ef0cd0482886a324c0
("scripts/kernel-doc: handle object-like macros")

Thanks,
Horia

Horia Geanta (12):
  crypto: caam - completely remove error propagation handling
  crypto: caam - desc.h fixes
  crypto: caam - code cleanup
  crypto: caam - move sec4_sg_entry to sg_sw_sec4.h
  crypto: caam - add Run Time Library (RTA) - part 1
  crypto: caam - add Run Time Library (RTA) - part 2
  crypto: caam - add Run Time Library (RTA) - part 3
  crypto: caam - use RTA instead of inline append
  crypto: caam - completely remove inline append
  crypto: caam - refactor descriptor creation
  crypto: caam - move caamalg shared descs in RTA library
  crypto: caam - add Run Time Library (RTA) docbook

 Documentation/DocBook/Makefile                     |    3 +-
 Documentation/DocBook/rta-api.tmpl                 |  271 ++++
 Documentation/DocBook/rta/.gitignore               |    1 +
 Documentation/DocBook/rta/Makefile                 |    5 +
 Documentation/DocBook/rta/rta_arch.svg             |  381 ++++++
 drivers/crypto/caam/Makefile                       |    4 +-
 drivers/crypto/caam/caamalg.c                      |  799 ++++--------
 drivers/crypto/caam/caamhash.c                     |  536 ++++----
 drivers/crypto/caam/caamrng.c                      |   48 +-
 drivers/crypto/caam/compat.h                       |    1 +
 drivers/crypto/caam/ctrl.c                         |   91 +-
 drivers/crypto/caam/ctrl.h                         |    2 +-
 drivers/crypto/caam/desc_constr.h                  |  388 ------
 drivers/crypto/caam/error.c                        |    7 +-
 drivers/crypto/caam/{ => flib}/desc.h              | 1335 +++++++++++++++++---
 drivers/crypto/caam/flib/desc/algo.h               |   88 ++
 drivers/crypto/caam/flib/desc/common.h             |  151 +++
 drivers/crypto/caam/flib/desc/ipsec.h              |  550 ++++++++
 drivers/crypto/caam/flib/desc/jobdesc.h            |   57 +
 drivers/crypto/caam/flib/rta.h                     |  980 ++++++++++++++
 drivers/crypto/caam/flib/rta/fifo_load_store_cmd.h |  303 +++++
 drivers/crypto/caam/flib/rta/header_cmd.h          |  209 +++
 drivers/crypto/caam/flib/rta/jump_cmd.h            |  168 +++
 drivers/crypto/caam/flib/rta/key_cmd.h             |  183 +++
 drivers/crypto/caam/flib/rta/load_cmd.h            |  297 +++++
 drivers/crypto/caam/flib/rta/math_cmd.h            |  362 ++++++
 drivers/crypto/caam/flib/rta/move_cmd.h            |  401 ++++++
 drivers/crypto/caam/flib/rta/nfifo_cmd.h           |  157 +++
 drivers/crypto/caam/flib/rta/operation_cmd.h       |  545 ++++++++
 drivers/crypto/caam/flib/rta/protocol_cmd.h        |  595 +++++++++
 drivers/crypto/caam/flib/rta/sec_run_time_asm.h    |  672 ++++++++++
 drivers/crypto/caam/flib/rta/seq_in_out_ptr_cmd.h  |  168 +++
 drivers/crypto/caam/flib/rta/signature_cmd.h       |   36 +
 drivers/crypto/caam/flib/rta/store_cmd.h           |  145 +++
 drivers/crypto/caam/jr.c                           |    6 +-
 drivers/crypto/caam/key_gen.c                      |   35 +-
 drivers/crypto/caam/key_gen.h                      |    5 +-
 drivers/crypto/caam/pdb.h                          |  402 ------
 drivers/crypto/caam/sg_sw_sec4.h                   |   12 +-
 39 files changed, 8438 insertions(+), 1961 deletions(-)
 create mode 100644 Documentation/DocBook/rta-api.tmpl
 create mode 100644 Documentation/DocBook/rta/.gitignore
 create mode 100644 Documentation/DocBook/rta/Makefile
 create mode 100644 Documentation/DocBook/rta/rta_arch.svg
 delete mode 100644 drivers/crypto/caam/desc_constr.h
 rename drivers/crypto/caam/{ => flib}/desc.h (54%)
 create mode 100644 drivers/crypto/caam/flib/desc/algo.h
 create mode 100644 drivers/crypto/caam/flib/desc/common.h
 create mode 100644 drivers/crypto/caam/flib/desc/ipsec.h
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
