Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61943C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 May 2022 05:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344545AbiETF5w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 May 2022 01:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244615AbiETF5u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 May 2022 01:57:50 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615FB14AA69
        for <linux-crypto@vger.kernel.org>; Thu, 19 May 2022 22:57:49 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nrvdx-00Fhys-6a; Fri, 20 May 2022 15:57:46 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 May 2022 13:57:45 +0800
Date:   Fri, 20 May 2022 13:57:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>
Subject: Re: [PATCH v3 00/10] crypto: qat - re-enable algorithms
Message-ID: <Yoct2VuN7LPNP/qT@gondor.apana.org.au>
References: <20220509133417.56043-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509133417.56043-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 09, 2022 at 02:34:07PM +0100, Giovanni Cabiddu wrote:
> This set is an extension of a previous set called `crypto: qat - fix dm-crypt
> related issues` which aims to re-enable the algorithms in the QAT driver
> after [1].
> 
> This fixes a number of issues with the implementation of the QAT algs,
> both symmetric and asymmetric.
> In particular this set enables the QAT driver to handle correctly the
> flags CRYPTO_TFM_REQ_MAY_BACKLOG and CRYPTO_TFM_REQ_MAY_SLEEP,
> fixes an hidden issue in RSA and DH which appeared after commit f5ff79fddf0e,
> related to the usage of dma_free_coherent() from a tasklet, and includes
> important fixes in the akcipher algorithms.
> 
> One item to mention is that, differently from the previous set, this
> one does not removes the flag CRYPTO_ALG_ALLOCATES_MEMORY which will
> be removed after the conversation in [2] is closed.
> 
> [1] https://lore.kernel.org/linux-crypto/YiEyGoHacN80FcOL@silpixa00400314/
> [2] https://lore.kernel.org/linux-crypto/Yl6PlqyucVLCzwF5@silpixa00400314/
> 
> Changes from v2:
>   - Removed `crypto: qat - set to zero DH parameters before free` from
>     set.
>   - Added fixes tags to patches `crypto: qat - add param check for RSA`
>     and `crypto: qat - add param check for DH`
> 
> Changes from v1:
>   - Clarified commit message in `crypto: qat - refactor submission logic`
>     to indicate why the patch should be included in stable kernels
>   - Removed `crypto: qat - use memzero_explicit() for algs` from set
>     after feedback from Greg KH
>   - Replaced memzero_explicit() with memset() in `crypto: qat - set to
>     zero DH parameters before free` after feedback from Greg KH
> 
> Giovanni Cabiddu (10):
>   crypto: qat - use pre-allocated buffers in datapath
>   crypto: qat - refactor submission logic
>   crypto: qat - add backlog mechanism
>   crypto: qat - fix memory leak in RSA
>   crypto: qat - remove dma_free_coherent() for RSA
>   crypto: qat - remove dma_free_coherent() for DH
>   crypto: qat - add param check for RSA
>   crypto: qat - add param check for DH
>   crypto: qat - honor CRYPTO_TFM_REQ_MAY_SLEEP flag
>   crypto: qat - re-enable registration of algorithms
> 
>  drivers/crypto/qat/qat_4xxx/adf_drv.c         |   7 -
>  drivers/crypto/qat/qat_common/Makefile        |   1 +
>  drivers/crypto/qat/qat_common/adf_transport.c |  11 +
>  drivers/crypto/qat/qat_common/adf_transport.h |   1 +
>  .../qat/qat_common/adf_transport_internal.h   |   1 +
>  drivers/crypto/qat/qat_common/qat_algs.c      | 153 +++++----
>  drivers/crypto/qat/qat_common/qat_algs_send.c |  86 +++++
>  drivers/crypto/qat/qat_common/qat_algs_send.h |  11 +
>  drivers/crypto/qat/qat_common/qat_asym_algs.c | 304 +++++++++---------
>  drivers/crypto/qat/qat_common/qat_crypto.c    |  10 +-
>  drivers/crypto/qat/qat_common/qat_crypto.h    |  44 +++
>  11 files changed, 392 insertions(+), 237 deletions(-)
>  create mode 100644 drivers/crypto/qat/qat_common/qat_algs_send.c
>  create mode 100644 drivers/crypto/qat/qat_common/qat_algs_send.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
