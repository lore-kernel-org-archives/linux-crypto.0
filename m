Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 341F1CA9EAE
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 04:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0313221872
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 04:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571805661;
	bh=Gi+QwAYSnRq+qc3fWMJPJigkCQq5YPHxeww/sCsCE8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=RuzF4/FYjMB1iy/mSzy74rij7tfCSu8+RxY2oVAU2Sb/l3EArnvME4ooAQpcuvTBl
	 0dGgiS5ta2EM4JbWULn6Wt2SkWG7moLa3IeB6gqxCVMNq22e6TysfXa5E6CCcfZwYA
	 2hWKFPUCFQmRN1MIGx2Hgo0jqxKqFVAM296WtYI8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731534AbfJWEk7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 00:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731487AbfJWEk7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 00:40:59 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B9732086D;
        Wed, 23 Oct 2019 04:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571805658;
        bh=Gi+QwAYSnRq+qc3fWMJPJigkCQq5YPHxeww/sCsCE8Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2IJkMdhbHtZrT8kRTcM7QDaeofg+r3E7zSGeJQhA+yyv7HW1ZUfR/9b4AeURzUXID
         IjtctC3h/i8KIf3bNsVR5PtwUqwt3pY+H9NzDttbR2efb2yi+0eio9QfhnJ0er4jbS
         xlb5M8z3gF0/e6sPba+JdMFWsYaex2RcPmq91ZU4=
Date:   Tue, 22 Oct 2019 21:40:57 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v4 04/35] crypto: x86/chacha - expose SIMD ChaCha routine
 as library function
Message-ID: <20191023044057.GA361298@sol.localdomain>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
 <20191017190932.1947-5-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017190932.1947-5-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 17, 2019 at 09:09:01PM +0200, Ard Biesheuvel wrote:
> +void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
> +		       int nrounds)
> +{
> +	state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
> +
> +	if (!static_branch_likely(&chacha_use_simd) || !crypto_simd_usable() ||
> +	    bytes <= CHACHA_BLOCK_SIZE)
> +		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
> +
> +	kernel_fpu_begin();
> +	chacha_dosimd(state, dst, src, bytes, nrounds);
> +	kernel_fpu_end();
> +}
> +EXPORT_SYMBOL(chacha_crypt_arch);

This can process an arbitrary amount of data with preemption disabled.
Shouldn't the library functions limit the amount of data processed per
fpu_begin/fpu_end region?  I see that some of them do...

- Eric
