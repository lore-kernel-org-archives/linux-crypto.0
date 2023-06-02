Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C69C7EE24
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jun 2023 10:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbjFBK2F (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jun 2023 06:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235524AbjFBK1u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2023 06:27:50 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE33B2681
        for <linux-crypto@vger.kernel.org>; Fri,  2 Jun 2023 03:25:58 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q51yT-00G368-IK; Fri, 02 Jun 2023 18:25:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Jun 2023 18:25:37 +0800
Date:   Fri, 2 Jun 2023 18:25:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>
Subject: Re: [PATCH] crypto: qat - move dbgfs init to separate file
Message-ID: <ZHnDoSBFgSVTBlz7@gondor.apana.org.au>
References: <20230526164859.49095-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526164859.49095-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 26, 2023 at 05:48:59PM +0100, Giovanni Cabiddu wrote:
> From: Damian Muszynski <damian.muszynski@intel.com>
> 
> Move initialization of debugfs entries to a separate file.
> This simplifies the exclusion of the debugfs logic in the QAT driver
> when the kernel is built with CONFIG_DEBUG_FS=n.
> In addition, it will allow to consolidate the addition of debugfs
> entries to a single location in the code.
> 
> This implementation adds infrastructure to create (and remove) debugfs
> entries at two different stages. The first, done when a device is probed,
> allows to keep debugfs entries persistent between a transition in device
> state (up to down or vice versa). The second, done after the initialization
> phase, allows to have debugfs entries that are accessible only when
> the device is up.
> 
> In addition, move the creation of debugfs entries for configuration
> to the newly created function adf_dbgfs_init() and replace symbolic
> permissions with octal permissions when creating the debugfs files.
> This is to resolve the following warning reported by checkpatch:
> 
>   WARNING: Symbolic permissions 'S_IRUSR' are not preferred. Consider using octal permissions '0400'.
> 
> Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   | 12 ++--
>  drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c  | 12 ++--
>  .../crypto/intel/qat/qat_c3xxxvf/adf_drv.c    | 12 ++--
>  drivers/crypto/intel/qat/qat_c62x/adf_drv.c   | 12 ++--
>  drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c | 12 ++--
>  drivers/crypto/intel/qat/qat_common/Makefile  |  4 +-
>  drivers/crypto/intel/qat/qat_common/adf_cfg.c | 24 +++++--
>  drivers/crypto/intel/qat/qat_common/adf_cfg.h |  2 +
>  .../crypto/intel/qat/qat_common/adf_dbgfs.c   | 69 +++++++++++++++++++
>  .../crypto/intel/qat/qat_common/adf_dbgfs.h   | 29 ++++++++
>  .../crypto/intel/qat/qat_common/adf_init.c    |  6 ++
>  .../crypto/intel/qat/qat_dh895xcc/adf_drv.c   | 12 ++--
>  .../crypto/intel/qat/qat_dh895xccvf/adf_drv.c | 12 ++--
>  13 files changed, 156 insertions(+), 62 deletions(-)
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_dbgfs.h

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
