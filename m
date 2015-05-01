From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 0/4] target: Fix several problems related to T10-PI support
Date: Fri,  1 May 2015 15:23:47 +0900
Message-ID: <1430461431-5936-1-git-send-email-akinobu.mita@gmail.com>
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
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patchset aims to fix several problems related to T10-PI support.

These patches can be applied on top of Sagi's "[v1] Simlify dif_verify
routines and fixup fileio protection information code" patchset.

* Changes from v3:
- Drop WRITE SAME support from this patch series, as it requires more
  works than I expected in the first place.
- Improve the condition in transport_generic_new_cmd() a bit
- Reduce duplicated code between crc_t10dif_update and crc_t10dif,
  suggested by Tim and Herbert
- Fix inconsistent address passed to kunmap_atomic, reported by Sagi
- Stop operation in sbc_dif_generate() and sbc_dif_verify() when
  reaching the end of data SG elements

* Changes from v2:
- Introduces crc_t10dif_update() to calculate CRC by multiple calls
- Handle odd SG mapping correctly instead of giving up

* Changes from v1:
- Reduce code duplication a bit in target_read_prot_action()
- Fix sbc_dif_verify() for WRITE_SAME command
- Fix inverted rw argument for fd_do_rw()
- Perform DIF verify before write for WRITE_SAME

Akinobu Mita (4):
  target: Fix inconsistent address passed to kunmap_atomic() in
    sbc_dif_copy_prot()
  target: ensure se_cmd->t_prot_sg is allocated when required
  lib: introduce crc_t10dif_update()
  target: handle odd SG mapping for data transfer memory

 drivers/target/target_core_sbc.c       | 127 ++++++++++++++++++++++-----------
 drivers/target/target_core_transport.c |  27 +++----
 include/linux/crc-t10dif.h             |   1 +
 include/target/target_core_base.h      |   1 +
 lib/crc-t10dif.c                       |  13 +++-
 5 files changed, 113 insertions(+), 56 deletions(-)

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
