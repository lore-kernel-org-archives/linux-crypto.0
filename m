Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89CBBC433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Oct 2021 12:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D19660FD8
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Oct 2021 12:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241336AbhJHMZ4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Oct 2021 08:25:56 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55916 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhJHMZz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Oct 2021 08:25:55 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mYout-0003bN-Ho; Fri, 08 Oct 2021 20:23:59 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mYouj-000868-Jl; Fri, 08 Oct 2021 20:23:49 +0800
Date:   Fri, 8 Oct 2021 20:23:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 00/12] crypto: qat - PFVF fixes and refactoring
Message-ID: <20211008122349.GC31060@gondor.apana.org.au>
References: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 28, 2021 at 12:44:28PM +0100, Giovanni Cabiddu wrote:
> This set includes few fixes and refactors in the QAT driver, mainly
> related to the PFVF communication mechanism.
> 
> Here is a summary of the changes:
> * Patches #1 and #2 fix a bug in the PFVF protocol related to collision
>   detection;
> * Patch #3 optimizes the PFVF protocol protocol by removing an unnecessary
>   timeout;
> * Patch #4 makes the VF to PF interrupt related logic device specific;
> * Patches #5 and #6 remove duplicated logic across devices and homegrown
>   logic;
> * Patches #7 to #12 are just refactoring of the PFVF code in preparation
>   for updates to the protocol.
> 
> Giovanni Cabiddu (3):
>   crypto: qat - detect PFVF collision after ACK
>   crypto: qat - disregard spurious PFVF interrupts
>   crypto: qat - use hweight for bit counting
> 
> Marco Chiappero (9):
>   crypto: qat - remove unnecessary collision prevention step in PFVF
>   crypto: qat - fix handling of VF to PF interrupts
>   crypto: qat - remove duplicated logic across GEN2 drivers
>   crypto: qat - make pfvf send message direction agnostic
>   crypto: qat - move pfvf collision detection values
>   crypto: qat - rename pfvf collision constants
>   crypto: qat - add VF and PF wrappers to common send function
>   crypto: qat - extract send and wait from adf_vf2pf_request_version()
>   crypto: qat - share adf_enable_pf2vf_comms() from adf_pf2vf_msg.c
> 
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |   4 +-
>  .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  89 +------
>  .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h  |  13 +-
>  .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  87 +------
>  .../crypto/qat/qat_c62x/adf_c62x_hw_data.h    |  12 -
>  .../crypto/qat/qat_common/adf_accel_devices.h |   5 +
>  .../crypto/qat/qat_common/adf_common_drv.h    |   9 +-
>  .../crypto/qat/qat_common/adf_gen2_hw_data.c  |  98 ++++++++
>  .../crypto/qat/qat_common/adf_gen2_hw_data.h  |  27 ++
>  drivers/crypto/qat/qat_common/adf_isr.c       |  20 +-
>  drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 238 ++++++++++--------
>  drivers/crypto/qat/qat_common/adf_pf2vf_msg.h |   9 -
>  drivers/crypto/qat/qat_common/adf_vf2pf_msg.c |   4 +-
>  drivers/crypto/qat/qat_common/adf_vf_isr.c    |   6 +
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 123 ++++-----
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h   |  14 +-
>  16 files changed, 361 insertions(+), 397 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
