Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3709C43613
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 22:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77B49215EA
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 22:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560984354;
	bh=3qUrUVlZN3408V1zM+36w2+cVHhWM0gqh7CfNIECHj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=uq/nn7p5HTy51bH4Gf2IoN1QiIVQacBK+grILT6OpKnxRZnd6kSa/FG45NdmNYIK4
	 AiZS5q0AejFTUbiR6d/GM3KxSQG+axPoInvq2vp3BXMGWLaMv/sUgeI18Mrr3v9ufG
	 cbPlVo+dJ+Bncu7gNxCh6PBO0ugmVmXOixGIoNkQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfFSWpx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 18:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfFSWpx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 18:45:53 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6012A2085A;
        Wed, 19 Jun 2019 22:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560984352;
        bh=3qUrUVlZN3408V1zM+36w2+cVHhWM0gqh7CfNIECHj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tjy3ZTw2p83PAsbpLWyyaSKRrO7J8UvuBAO+MPoMfhGqDUVMroleoXoMb9gpwrwza
         8T/fWiWXDKLTObrrazTge+m2tBb8WfQikRSAK72mCzw42oWz1HhgXJRwFGHvk4M0H8
         ibiN/arbEjCVQQqwYGQSxc6jGgAlP20gaFASLXHg=
Date:   Wed, 19 Jun 2019 15:45:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v3 2/6] fs: crypto: invoke crypto API for ESSIV handling
Message-ID: <20190619224550.GD33328@gmail.com>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619162921.12509-3-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 19, 2019 at 06:29:17PM +0200, Ard Biesheuvel wrote:
> Instead of open coding the calculations for ESSIV handling, use a
> ESSIV skcipher which does all of this under the hood.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  fs/crypto/Kconfig           |  1 +
>  fs/crypto/crypto.c          |  5 --
>  fs/crypto/fscrypt_private.h |  9 --
>  fs/crypto/keyinfo.c         | 88 +-------------------
>  4 files changed, 3 insertions(+), 100 deletions(-)
> 
> diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> index 24ed99e2eca0..b0292da8613c 100644
> --- a/fs/crypto/Kconfig
> +++ b/fs/crypto/Kconfig
> @@ -5,6 +5,7 @@ config FS_ENCRYPTION
>  	select CRYPTO_AES
>  	select CRYPTO_CBC
>  	select CRYPTO_ECB
> +	select CRYPTO_ESSIV
>  	select CRYPTO_XTS
>  	select CRYPTO_CTS
>  	select CRYPTO_SHA256

Selecting CRYPTO_ESSIV is fine for now, but I'd really like to de-bloat the
dependencies of FS_ENCRYPTION (probably in a separate patch) by removing
CRYPTO_ESSIV and CRYPTO_SHA256 and documenting in the encryption modes section
of Documentation/filesystems/fscrypt.rst that people need to select them
themselves if they want to use AES-128-CBC.  I already took that approach when I
added Adiantum support, so we don't force all fscrypt users to build Adiantum,
ChaCha, Poly1305, etc. into their kernels.

- Eric
