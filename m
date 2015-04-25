From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 0/5] target: Fix several problems related to T10-PI support
Date: Sat, 25 Apr 2015 23:33:25 +0900
Message-ID: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Sagi Grimberg <sagig@mellanox.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: target-devel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33498 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbbDYOdu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 25 Apr 2015 10:33:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset aims to fix several problems related to T10-PI support.

These patches can be applied on top of Sagi's "[v1] Simlify dif_verify
routines and fixup fileio protection information code" patchset.

* Changes from v2:
- Introduces crc_t10dif_update() to calculate CRC by mutiple calls
- Handle odd SG mapping correctly instead of giving up

* Changes from v1:
- Reduce code duplication a bit in target_read_prot_action()
- Fix sbc_dif_verify() for WRITE_SAME command
- Fix inverted rw argument for fd_do_rw()
- Perform DIF verify before write for WRITE_SAME

Akinobu Mita (5):
  target: ensure se_cmd->t_prot_sg is allocated when required
  lib: introduce crc_t10dif_update()
  target: handle odd SG mapping for data transfer memory
  target: Fix sbc_dif_generate() and sbc_dif_verify() for WRITE SAME
  target/file: enable WRITE SAME when protection info is enabled

 drivers/target/target_core_file.c      |  18 +++--
 drivers/target/target_core_sbc.c       | 136 +++++++++++++++++++++++----------
 drivers/target/target_core_transport.c |  30 +++++---
 include/linux/crc-t10dif.h             |   1 +
 include/target/target_core_base.h      |   1 +
 lib/crc-t10dif.c                       |  23 ++++++
 6 files changed, 153 insertions(+), 56 deletions(-)

Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: target-devel@vger.kernel.org
-- 
1.9.1
