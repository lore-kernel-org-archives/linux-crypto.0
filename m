Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63EF0C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 18:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiDRSH4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 14:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiDRSHy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 14:07:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3367E36153
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 11:05:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEA826138B
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 18:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DA2C385A1;
        Mon, 18 Apr 2022 18:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650305114;
        bh=iTh2BkOqbHJTxvKBcPXRBs8xRFkDQ76lvXa466UhJLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aSU3BpucxT9Zzk/p5V77sXpgvetmRV+ga2HeRdb0/UF/ImvjiUK+HEFk6EU1aqXR/
         NnVVC4ShHFVeLvDbdVDSN4Ln1qxnUKQsLL4z3BA2tFrPOq8WMLh6/w0jLJzA/NcX2S
         cVQPGgpJpAb86p/ogH85UdotB+kTfDehGBqGcQD8IgoGFds+1ZwXaugI4Aeqdj1VXg
         Kf9da3B6cz5U6+qLwTS2XrDZXDFAMjPIsn0aem0N7GLq0MdqcvIWQ5OBojkAswvIy8
         anaXmVT7kSXXaTfSbGiVzTWOmxpKVzU+qTWQOjkTN4Bc+EPnMlt+O0/l1IoOonM0gH
         2qICaLnnHsTag==
Date:   Mon, 18 Apr 2022 18:05:12 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 8/8] fscrypt: Add HCTR2 support for filename encryption
Message-ID: <Yl2oWPGekEMxiaJU@gmail.com>
References: <20220412172816.917723-1-nhuck@google.com>
 <20220412172816.917723-9-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412172816.917723-9-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 12, 2022 at 05:28:16PM +0000, Nathan Huckleberry wrote:
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index eede186b04ce..ae24b581d3d7 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -53,6 +53,13 @@ struct fscrypt_mode fscrypt_modes[] = {
>  		.ivsize = 32,
>  		.blk_crypto_mode = BLK_ENCRYPTION_MODE_ADIANTUM,
>  	},
> +	[FSCRYPT_MODE_AES_256_HCTR2] = {
> +		.friendly_name = "HCTR2",

Can you use "AES-256-HCTR2" here instead of just "HCTR2"?  This would be similar
to how FSCRYPT_MODE_AES_256_XTS uses .friendly_name = "AES-256-XTS".

- Eric
