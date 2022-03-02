Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D11EC433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Mar 2022 00:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiCCAAz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiCCAAw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 19:00:52 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F281D532DF
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 16:00:01 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nPXwQ-0006Dh-Em; Thu, 03 Mar 2022 09:59:31 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 03 Mar 2022 10:59:30 +1200
Date:   Thu, 3 Mar 2022 10:59:30 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     linux-crypto@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        leitao@debian.org, Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v4 1/1] crypto: vmx - add missing dependencies
Message-ID: <Yh/20gN+shzCcGYC@gondor.apana.org.au>
References: <20220223151115.28536-1-pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223151115.28536-1-pvorel@suse.cz>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 23, 2022 at 04:11:15PM +0100, Petr Vorel wrote:
> vmx-crypto module depends on CRYPTO_AES, CRYPTO_CBC, CRYPTO_CTR or
> CRYPTO_XTS, thus add them.
> 
> These dependencies are likely to be enabled, but if
> CRYPTO_DEV_VMX=y && !CRYPTO_MANAGER_DISABLE_TESTS
> and either of CRYPTO_AES, CRYPTO_CBC, CRYPTO_CTR or CRYPTO_XTS is built
> as module or disabled, alg_test() from crypto/testmgr.c complains during
> boot about failing to allocate the generic fallback implementations
> (2 == ENOENT):
> 
> [    0.540953] Failed to allocate xts(aes) fallback: -2
> [    0.541014] alg: skcipher: failed to allocate transform for p8_aes_xts: -2
> [    0.541120] alg: self-tests for p8_aes_xts (xts(aes)) failed (rc=-2)
> [    0.544440] Failed to allocate ctr(aes) fallback: -2
> [    0.544497] alg: skcipher: failed to allocate transform for p8_aes_ctr: -2
> [    0.544603] alg: self-tests for p8_aes_ctr (ctr(aes)) failed (rc=-2)
> [    0.547992] Failed to allocate cbc(aes) fallback: -2
> [    0.548052] alg: skcipher: failed to allocate transform for p8_aes_cbc: -2
> [    0.548156] alg: self-tests for p8_aes_cbc (cbc(aes)) failed (rc=-2)
> [    0.550745] Failed to allocate transformation for 'aes': -2
> [    0.550801] alg: cipher: Failed to load transform for p8_aes: -2
> [    0.550892] alg: self-tests for p8_aes (aes) failed (rc=-2)
> 
> Fixes: c07f5d3da643 ("crypto: vmx - Adding support for XTS")
> Fixes: d2e3ae6f3aba ("crypto: vmx - Enabling VMX module for PPC64")
> 
> Suggested-by: Nicolai Stange <nstange@suse.de>
> Signed-off-by: Petr Vorel <pvorel@suse.cz>
> ---
> Changes v3->v4:
> * Drop commit which merged CRYPTO_DEV_VMX and CRYPTO_DEV_VMX_ENCRYPT
>   (Herbert)
> 
>  drivers/crypto/vmx/Kconfig | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
