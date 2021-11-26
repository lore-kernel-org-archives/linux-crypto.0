Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECC0C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 05:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358606AbhKZFgd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 00:36:33 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57148 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352124AbhKZFec (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 00:34:32 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mqTpP-0008Qx-Na; Fri, 26 Nov 2021 13:31:19 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mqTpM-0004Yg-HU; Fri, 26 Nov 2021 13:31:16 +0800
Date:   Fri, 26 Nov 2021 13:31:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com
Subject: Re: [PATCH v3 00/25] crypto: qat - PFVF refactoring
Message-ID: <20211126053116.GB17477@gondor.apana.org.au>
References: <20211117143058.211550-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117143058.211550-1-giovanni.cabiddu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 17, 2021 at 02:30:33PM +0000, Giovanni Cabiddu wrote:
> This set includes fixes to the PFVF logic but also refactoring in
> preparation for updates to the protocol and support for QAT GEN4
> devices.
> 
> The main changes introduced by this set are:
> * A fix for a bug introduced in the previous PFVF set related to an
>   undetected timeout;
> * The refactoring and rework of the PFVF message handling logic which
>   includes changes to the ACK behaviour;
> * The introduction of adf_pfvf_gen2.c which includes logic common
>   to QAT GEN 2 devices;
> * The introduction of the pfvf_ops structure to isolate PFVF related
>   code inside the adf_hw_device_data structure and facilitate the
>   introduction of PFVF for QAT GEN4;
> * The reorganization of the PFVF code structure so that message logic
>   is separated from low level communication primitives and the protocol.
> 
> Changes since v1:
> - Fixed compilation error with CONFIG_PCI_IOV=n, reported by kernel test
>   robot <lkp@intel.com>;
> 
> Changes since v2:
> - Added patch to fix a NULL pointer dereference in case of a spurious
>   interrupt with QAT GEN4 devices. This was due to a missing function;
> - Minor style changes.
> 
> Giovanni Cabiddu (7):
>   crypto: qat - do not handle PFVF sources for qat_4xxx
>   crypto: qat - fix undetected PFVF timeout in ACK loop
>   crypto: qat - move vf2pf interrupt helpers
>   crypto: qat - change PFVF ACK behaviour
>   crypto: qat - re-enable interrupts for legacy PFVF messages
>   crypto: qat - relocate PFVF disabled function
>   crypto: qat - abstract PFVF receive logic
> 
> Marco Chiappero (18):
>   crypto: qat - refactor PF top half for PFVF
>   crypto: qat - move VF message handler to adf_vf2pf_msg.c
>   crypto: qat - move interrupt code out of the PFVF handler
>   crypto: qat - split PFVF message decoding from handling
>   crypto: qat - handle retries due to collisions in adf_iov_putmsg()
>   crypto: qat - relocate PFVF PF related logic
>   crypto: qat - relocate PFVF VF related logic
>   crypto: qat - add pfvf_ops
>   crypto: qat - differentiate between pf2vf and vf2pf offset
>   crypto: qat - abstract PFVF send function
>   crypto: qat - reorganize PFVF code
>   crypto: qat - reorganize PFVF protocol definitions
>   crypto: qat - use enums for PFVF protocol codes
>   crypto: qat - pass the PF2VF responses back to the callers
>   crypto: qat - refactor pfvf version request messages
>   crypto: qat - do not rely on min version
>   crypto: qat - fix VF IDs in PFVF log messages
>   crypto: qat - improve logging of PFVF messages
> 
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |  18 +-
>  .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  11 +-
>  .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |  14 +-
>  .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h     |   1 -
>  drivers/crypto/qat/qat_c3xxxvf/adf_drv.c      |   2 +-
>  .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  11 +-
>  .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       |  14 +-
>  .../qat/qat_c62xvf/adf_c62xvf_hw_data.h       |   1 -
>  drivers/crypto/qat/qat_c62xvf/adf_drv.c       |   2 +-
>  drivers/crypto/qat/qat_common/Makefile        |   6 +-
>  .../crypto/qat/qat_common/adf_accel_devices.h |  25 +-
>  .../crypto/qat/qat_common/adf_common_drv.h    |  30 +-
>  .../crypto/qat/qat_common/adf_gen2_hw_data.c  |  48 --
>  .../crypto/qat/qat_common/adf_gen2_hw_data.h  |  13 -
>  drivers/crypto/qat/qat_common/adf_gen2_pfvf.c | 225 ++++++++++
>  drivers/crypto/qat/qat_common/adf_gen2_pfvf.h |  29 ++
>  .../crypto/qat/qat_common/adf_gen4_hw_data.c  |   7 +
>  drivers/crypto/qat/qat_common/adf_init.c      |   2 +-
>  drivers/crypto/qat/qat_common/adf_isr.c       | 123 ++++--
>  drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 416 ------------------
>  .../{adf_pf2vf_msg.h => adf_pfvf_msg.h}       |  68 +--
>  .../crypto/qat/qat_common/adf_pfvf_pf_msg.c   |  21 +
>  .../crypto/qat/qat_common/adf_pfvf_pf_msg.h   |  10 +
>  .../crypto/qat/qat_common/adf_pfvf_pf_proto.c | 148 +++++++
>  .../crypto/qat/qat_common/adf_pfvf_pf_proto.h |  13 +
>  .../crypto/qat/qat_common/adf_pfvf_vf_msg.c   |  97 ++++
>  .../crypto/qat/qat_common/adf_pfvf_vf_msg.h   |  21 +
>  .../crypto/qat/qat_common/adf_pfvf_vf_proto.c | 134 ++++++
>  .../crypto/qat/qat_common/adf_pfvf_vf_proto.h |  14 +
>  drivers/crypto/qat/qat_common/adf_sriov.c     |  20 +-
>  drivers/crypto/qat/qat_common/adf_vf2pf_msg.c |  48 --
>  drivers/crypto/qat/qat_common/adf_vf_isr.c    |  92 ++--
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |  41 +-
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h   |   2 +
>  .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |  14 +-
>  .../qat_dh895xccvf/adf_dh895xccvf_hw_data.h   |   1 -
>  drivers/crypto/qat/qat_dh895xccvf/adf_drv.c   |   2 +-
>  37 files changed, 966 insertions(+), 778 deletions(-)
>  create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
>  create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_pfvf.h
>  delete mode 100644 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
>  rename drivers/crypto/qat/qat_common/{adf_pf2vf_msg.h => adf_pfvf_msg.h} (81%)
>  create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c
>  create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.h
>  create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
>  create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.h
>  create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
>  create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.h
>  create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
>  create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.h
>  delete mode 100644 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
