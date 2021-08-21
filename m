Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9660DC4338F
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Aug 2021 07:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B63C611C9
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Aug 2021 07:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhHUHub (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 21 Aug 2021 03:50:31 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53808 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232469AbhHUHub (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Aug 2021 03:50:31 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mHLlH-0006Ef-Iq; Sat, 21 Aug 2021 15:49:51 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mHLlH-0000u0-Ft; Sat, 21 Aug 2021 15:49:51 +0800
Date:   Sat, 21 Aug 2021 15:49:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 00/20] crypto: qat - cumulative fixes
Message-ID: <20210821074951.GC3392@gondor.apana.org.au>
References: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 12, 2021 at 09:21:09PM +0100, Giovanni Cabiddu wrote:
> This is a collection of various fixes and improvements, mostly related
> to PFVF, from various authors.
> A previous version of this set was already sent to this list a few weeks
> ago. I didn't call this V2 since a number of patches were
> added/removed to the set and the order of the patches changed.
> 
> Ahsan Atta (1):
>   crypto: qat - flush vf workqueue at driver removal
> 
> Giovanni Cabiddu (7):
>   crypto: qat - use proper type for vf_mask
>   crypto: qat - do not ignore errors from enable_vf2pf_comms()
>   crypto: qat - handle both source of interrupt in VF ISR
>   crypto: qat - prevent spurious MSI interrupt in VF
>   crypto: qat - move IO virtualization functions
>   crypto: qat - do not export adf_iov_putmsg()
>   crypto: qat - store vf.compatible flag
> 
> Kanchana Velusamy (1):
>   crypto: qat - protect interrupt mask CSRs with a spinlock
> 
> Marco Chiappero (10):
>   crypto: qat - remove empty sriov_configure()
>   crypto: qat - enable interrupts only after ISR allocation
>   crypto: qat - prevent spurious MSI interrupt in PF
>   crypto: qat - rename compatibility version definition
>   crypto: qat - fix reuse of completion variable
>   crypto: qat - move pf2vf interrupt [en|dis]able to adf_vf_isr.c
>   crypto: qat - fix naming for init/shutdown VF to PF notifications
>   crypto: qat - complete all the init steps before service notification
>   crypto: qat - fix naming of PF/VF enable functions
>   crypto: qat - remove the unnecessary get_vintmsk_offset()
> 
> Svyatoslav Pankratov (1):
>   crypto: qat - remove intermediate tasklet for vf2pf
> 
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |  8 +-
>  .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  | 19 ++---
>  .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h  |  1 -
>  .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     | 14 +---
>  .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h     |  1 -
>  drivers/crypto/qat/qat_c3xxxvf/adf_drv.c      |  1 +
>  .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    | 19 ++---
>  .../crypto/qat/qat_c62x/adf_c62x_hw_data.h    |  1 -
>  .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       | 14 +---
>  .../qat/qat_c62xvf/adf_c62xvf_hw_data.h       |  1 -
>  drivers/crypto/qat/qat_c62xvf/adf_drv.c       |  1 +
>  .../crypto/qat/qat_common/adf_accel_devices.h |  8 +-
>  .../crypto/qat/qat_common/adf_common_drv.h    | 21 +++--
>  drivers/crypto/qat/qat_common/adf_init.c      | 13 ++--
>  drivers/crypto/qat/qat_common/adf_isr.c       | 42 ++++++----
>  drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 78 +++++++++++--------
>  drivers/crypto/qat/qat_common/adf_pf2vf_msg.h |  2 +-
>  drivers/crypto/qat/qat_common/adf_sriov.c     |  8 +-
>  drivers/crypto/qat/qat_common/adf_vf2pf_msg.c | 12 +--
>  drivers/crypto/qat/qat_common/adf_vf_isr.c    | 64 ++++++++++++++-
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 19 ++---
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h   |  1 -
>  .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   | 14 +---
>  .../qat_dh895xccvf/adf_dh895xccvf_hw_data.h   |  1 -
>  drivers/crypto/qat/qat_dh895xccvf/adf_drv.c   |  1 +
>  25 files changed, 207 insertions(+), 157 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
