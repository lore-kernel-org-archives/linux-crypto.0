Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C5EC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 18:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76B0523A22
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 18:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389291AbhAUSGc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 13:06:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389189AbhAUSGS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 13:06:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 233D723A03;
        Thu, 21 Jan 2021 18:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611252336;
        bh=UGC6xbgmj6VnF4keuMb2vzAY/nDpnpUK4OYYvtZpiJw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X2Uoc8TdEKPUH9HrNNl7g/li8KBClsNfgU3TX1bHt2UzrBvw0i6KbPOghhI4ryNUL
         l2fhssGweU9g2iFYOa4a7B5+zFqtF1IJEG+gJD1a8c0cHRplHwtodhm2M2iGdgCfGS
         D4T/GrpIayh4v1EKn6XvO9CkrfZFQDOrbJvbbg3EPRhT+7NjXCiqr5CKdpc37xwAm4
         NxSkYqaJ22Vs8j3qLeoAxdJ786wTiZ6RtTKkCvU01nIAjPLx3WSPG8OSLXBAPwC/yj
         r23QG+jbs1Jdodq8Zghs0+2knOCsul6uHqJvPmjTuH5Ub7M1HqfDD2TqWie1CGnNx5
         Rzgy98dB5k//w==
Date:   Thu, 21 Jan 2021 10:05:34 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/5] crypto: remove Salsa20 stream cipher algorithm
Message-ID: <YAnCbnnFCQkyBpUA@sol.localdomain>
References: <20210121130733.1649-1-ardb@kernel.org>
 <20210121130733.1649-6-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121130733.1649-6-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 21, 2021 at 02:07:33PM +0100, Ard Biesheuvel wrote:
> Salsa20 is not used anywhere in the kernel, is not suitable for disk
> encryption, and widely considered to have been superseded by ChaCha20.
> So let's remove it.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  Documentation/admin-guide/device-mapper/dm-integrity.rst |    4 +-
>  crypto/Kconfig                                           |   12 -
>  crypto/Makefile                                          |    1 -
>  crypto/salsa20_generic.c                                 |  212 ----
>  crypto/tcrypt.c                                          |   11 +-
>  crypto/testmgr.c                                         |    6 -
>  crypto/testmgr.h                                         | 1162 --------------------
>  7 files changed, 3 insertions(+), 1405 deletions(-)
> 
> diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
> index 4e6f504474ac..d56112e2e354 100644
> --- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
> @@ -143,8 +143,8 @@ recalculate
>  journal_crypt:algorithm(:key)	(the key is optional)
>  	Encrypt the journal using given algorithm to make sure that the
>  	attacker can't read the journal. You can use a block cipher here
> -	(such as "cbc(aes)") or a stream cipher (for example "chacha20",
> -	"salsa20" or "ctr(aes)").
> +	(such as "cbc(aes)") or a stream cipher (for example "chacha20"
> +	or "ctr(aes)").

You should check with the dm-integrity maintainers how likely it is that people
are using salsa20 with dm-integrity.  It's possible that people are using it,
especially since the documentation says that dm-integrity can use a stream
cipher and specifically gives salsa20 as an example.

- Eric
