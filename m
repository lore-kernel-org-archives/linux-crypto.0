Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD5BC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 02:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8EF7218A1
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 02:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552616659;
	bh=6Tu6ZXDuZstWKNqYrk1xEdRvRnFacskNZS6z3x9RlX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=aOUwkKirnyARpIaUW2xu2cLSSHHgG8a4D/KmW3N0qLpUNFzQLjdBjisYlZze2owK0
	 ZTyuoDPacS5AQ2wVcDcZRhEPjmWgJ4jBGBggC0Zfv7R+71pjFd3ww9RGJL4m1yoUVX
	 OguQuyaLAWzVn+Vf7uQyZH6KiA0Hs02ztXzJDvZY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfCOCYS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Mar 2019 22:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727331AbfCOCYS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Mar 2019 22:24:18 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26D7521872;
        Fri, 15 Mar 2019 02:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552616657;
        bh=6Tu6ZXDuZstWKNqYrk1xEdRvRnFacskNZS6z3x9RlX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WWi27k78tp3oVq0Tq4gp/SaiMjBjfWPebth9Im0zEYKOFjC/9Uzdfg7YQBLlQKWhP
         FG/o+wsTPKyNBO7yqQJKG+NunsytFo4ZVuZkkjajlo23fJqlz89ZkhS78p4aqoOipx
         9xrlO6INDNLfi9eCphPIMhsGoEe0Y6qLz9gUzio4=
Date:   Thu, 14 Mar 2019 19:24:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Daniel Axtens <dja@axtens.net>
Cc:     omosnacek@gmail.com, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, leitao@debian.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
Message-ID: <20190315022414.GA1671@sol.localdomain>
References: <20190315020901.16509-1-dja@axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190315020901.16509-1-dja@axtens.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Daniel,

On Fri, Mar 15, 2019 at 01:09:01PM +1100, Daniel Axtens wrote:
> The original assembly imported from OpenSSL has two copy-paste
> errors in handling CTR mode. When dealing with a 2 or 3 block tail,
> the code branches to the CBC decryption exit path, rather than to
> the CTR exit path.

So does this need to be fixed in OpenSSL too?

> 
> This leads to corruption of the IV, which leads to subsequent blocks
> being corrupted.
> 
> This can be detected with libkcapi test suite, which is available at
> https://github.com/smuellerDD/libkcapi
> 

Is this also detected by the kernel's crypto self-tests, and if not why not?
What about with the new option CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?

> Reported-by: Ondrej Mosnáček <omosnacek@gmail.com>
> Fixes: 5c380d623ed3 ("crypto: vmx - Add support for VMS instructions by ASM")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Axtens <dja@axtens.net>
> ---
>  drivers/crypto/vmx/aesp8-ppc.pl | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/vmx/aesp8-ppc.pl b/drivers/crypto/vmx/aesp8-ppc.pl
> index d6a9f63d65ba..de78282b8f44 100644
> --- a/drivers/crypto/vmx/aesp8-ppc.pl
> +++ b/drivers/crypto/vmx/aesp8-ppc.pl
> @@ -1854,7 +1854,7 @@ Lctr32_enc8x_three:
>  	stvx_u		$out1,$x10,$out
>  	stvx_u		$out2,$x20,$out
>  	addi		$out,$out,0x30
> -	b		Lcbc_dec8x_done
> +	b		Lctr32_enc8x_done
>  
>  .align	5
>  Lctr32_enc8x_two:
> @@ -1866,7 +1866,7 @@ Lctr32_enc8x_two:
>  	stvx_u		$out0,$x00,$out
>  	stvx_u		$out1,$x10,$out
>  	addi		$out,$out,0x20
> -	b		Lcbc_dec8x_done
> +	b		Lctr32_enc8x_done
>  
>  .align	5
>  Lctr32_enc8x_one:
> -- 
> 2.19.1
> 
