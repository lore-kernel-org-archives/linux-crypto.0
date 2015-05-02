From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v4 0/4] target: Fix several problems related to T10-PI
 support
Date: Sat, 02 May 2015 15:34:06 -0700
Message-ID: <1430606046.16112.5.camel@haakon3.risingtidesystems.com>
References: <1430461431-5936-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: target-devel@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1430461431-5936-1-git-send-email-akinobu.mita@gmail.com>
Sender: target-devel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2015-05-01 at 15:23 +0900, Akinobu Mita wrote:
> This patchset aims to fix several problems related to T10-PI support.
> 
> These patches can be applied on top of Sagi's "[v1] Simlify dif_verify
> routines and fixup fileio protection information code" patchset.
> 
> * Changes from v3:
> - Drop WRITE SAME support from this patch series, as it requires more
>   works than I expected in the first place.
> - Improve the condition in transport_generic_new_cmd() a bit
> - Reduce duplicated code between crc_t10dif_update and crc_t10dif,
>   suggested by Tim and Herbert
> - Fix inconsistent address passed to kunmap_atomic, reported by Sagi
> - Stop operation in sbc_dif_generate() and sbc_dif_verify() when
>   reaching the end of data SG elements
> 
> * Changes from v2:
> - Introduces crc_t10dif_update() to calculate CRC by multiple calls
> - Handle odd SG mapping correctly instead of giving up
> 
> * Changes from v1:
> - Reduce code duplication a bit in target_read_prot_action()
> - Fix sbc_dif_verify() for WRITE_SAME command
> - Fix inverted rw argument for fd_do_rw()
> - Perform DIF verify before write for WRITE_SAME
> 
> Akinobu Mita (4):
>   target: Fix inconsistent address passed to kunmap_atomic() in
>     sbc_dif_copy_prot()
>   target: ensure se_cmd->t_prot_sg is allocated when required
>   lib: introduce crc_t10dif_update()
>   target: handle odd SG mapping for data transfer memory
> 
>  drivers/target/target_core_sbc.c       | 127 ++++++++++++++++++++++-----------
>  drivers/target/target_core_transport.c |  27 +++----
>  include/linux/crc-t10dif.h             |   1 +
>  include/target/target_core_base.h      |   1 +
>  lib/crc-t10dif.c                       |  13 +++-
>  5 files changed, 113 insertions(+), 56 deletions(-)

Thanks Akinobu and Sagi.

Applied to target-pending/for-next as v4.2 code.

Feel free to send incremental patch to address the nit in patch #3, and
I'll apply + squash appropriately.

--nab
