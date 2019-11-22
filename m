Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C3BAC432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 03:06:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28F39206D8
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 03:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574391984;
	bh=WHOYATGBc/KhbUsY17Xhsk4+WhbvgQ0BBAtu736vu44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=lZlWG2a4qAOXQYZc8/xDwLTFpHzrAwzpOuZKghZoqNRpEQBxi47sNVuBinPTu2HVY
	 qc0bicykKx3BhTOgyiKezcKByIIu3TgxTBTd1BTo+B2JlM9r1CWluRV0GmEOp/MM5T
	 RBFEMTKzJvdwBhg7ebUx6OxG//Q6psndb8pZ00Cg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfKVDGX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 22:06:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:56002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbfKVDGX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 22:06:23 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC833206B6;
        Fri, 22 Nov 2019 03:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574391982;
        bh=WHOYATGBc/KhbUsY17Xhsk4+WhbvgQ0BBAtu736vu44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wsysb1M4c5Of6auNnd9WrnuX1d02JpYy2mPEoQ+5gjPFolt9aOvDJ6cbTtK9uowg+
         F3B/IcMPpFYJm+VI2Tz9NzrY3GG//ps0Q2UFi7UhjzC2A/93e1c3Oiee0q/7qX97qx
         1QSYrvkYUwciXyAbQHhi2Wmon4dgqLNThqpvPjsc=
Date:   Thu, 21 Nov 2019 19:06:20 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        =?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 8/8] crypto, x86/sha: Eliminate casts on asm
 implementations
Message-ID: <20191122030620.GD32523@sol.localdomain>
References: <20191122010334.12081-1-keescook@chromium.org>
 <20191122010334.12081-9-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122010334.12081-9-keescook@chromium.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 21, 2019 at 05:03:34PM -0800, Kees Cook wrote:
> -asmlinkage void sha1_transform_ssse3(u32 *digest, const char *data,
> -				     unsigned int rounds);
> +asmlinkage void sha1_transform_ssse3(struct sha1_state *digest,
> +				     const u8 *data, int rounds);

Can you please use:

asmlinkage void sha1_transform_ssse3(struct sha1_state *state,
				     const u8 *data, int blocks);

I.e., rename 'digest' => 'state' and 'rounds' => 'blocks'.

(Or alternatively 'sst' instead of 'state' would be okay since that's what
sha{1,256,512}_block_fn uses, but 'state' seems much clearer to me.)

Similarly for the other sha{1,256,512}_transform_*() functions.

'digest' is confusing because it would typically be understood to mean the final
digest, or maybe also the hash chaining state (e.g. u32[5] for SHA-1) if it's
interpreted loosely.  I don't think it would typically be understand to also
include buffered data like struct sha1_state does.

'rounds' is confusing because the parameter is actually the number of blocks,
not the number of rounds -- the latter being fixed for each SHA-* algorithm.
Since sha{1,256,512}_block_fn already call it 'blocks' and this patch has to
update the type of this parameter anyway, let's use that.

>  #ifdef CONFIG_AS_AVX
> -asmlinkage void sha1_transform_avx(u32 *digest, const char *data,
> -				   unsigned int rounds);
> +asmlinkage void sha1_transform_avx(struct sha1_state *digest,
> +				   const u8 *data, int rounds);
>  

This patch is also still missing updates to the corresponding comments in the
assembly files:

	sha1_transform_avx()
	sha1_transform_avx2()
	sha256_transform_avx()
	sha256_transform_rorx()
	sha512_transform_ssse3() [references to D, M, and L remain]
	sha512_transform_avx()
	sha512_transform_rorx()

FWIW, this patch is also independent from 1-7, so it could be sent out
separately if it makes things any easier for you.

Thanks,

- Eric
