Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E72C25B67
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Oct 2023 09:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjJ0Jpz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Oct 2023 05:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjJ0Jpy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2023 05:45:54 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BE29D
        for <linux-crypto@vger.kernel.org>; Fri, 27 Oct 2023 02:45:52 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qwJPX-00Bd5p-N5; Fri, 27 Oct 2023 17:45:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Oct 2023 17:45:53 +0800
Date:   Fri, 27 Oct 2023 17:45:53 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Shashank Gupta <shashank.gupta@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Subject: Re: [PATCH] crypto: qat - add heartbeat error simulator
Message-ID: <ZTuG0eAskF6kxW4A@gondor.apana.org.au>
References: <20231020155541.240695-1-shashank.gupta@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020155541.240695-1-shashank.gupta@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 20, 2023 at 04:55:26PM +0100, Shashank Gupta wrote:
>
> +#ifdef QAT_HB_ERROR_INJECTION

Please move this into the code.

> +#ifdef QAT_HB_ERROR_INJECTION
> +	hb->dbgfs.inject_error = debugfs_create_file("inject_error", 0200,
> +						     hb->dbgfs.base_dir, accel_dev,
> +						     &adf_hb_error_inject_fops);
> +#endif

So this would look like

	if (IS_ENABLED(CONFIG_CRYPTO_DEV_QAT_ERROR_INJECTION)) {
		struct dentry *inject_error __maybe_unused;

		inject_error = debugfs_create_file("inject_error", 0200,
						   hb->dbgfs.base_dir, accel_dev,
						   &adf_hb_error_inject_fops);
#ifdef CONFIG_CRYPTO_DEV_QAT_HB_ERROR_INJECTION
		hb->dbgfs.inject_error = inject_error;
#endif
	}

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
