Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95866C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 676EA208CB
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561744168;
	bh=ylC+7sFJxaB6Cj5A/cOO9045bcE5QhDv/k/YY8QEgk8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=VCLoy5BmYebrWh27C0nNlE65h3tVQiqRncqM6PrF4+MoHiQiuPhVYWyGk3WmoPIqP
	 tPBtDhYqh4UHIf9o5Y02Yc52+gqJk5iB7ZOJQa2b9pTUcEdtXBfQ0yQD9+89PpXJVC
	 XozXler895YbAiHF4yHs7iG+pYsIW3G+DAzTXIFs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfF1Rt2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 13:49:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfF1Rt1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 13:49:27 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA7FF208C4;
        Fri, 28 Jun 2019 17:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561744166;
        bh=ylC+7sFJxaB6Cj5A/cOO9045bcE5QhDv/k/YY8QEgk8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qBsq+AbRiZZPZ3Hh9bpgGCN7bX93oEbWP0TpF+qy7L1qIR5G1Q6wXve2qHxs0Dmth
         TF19zv1ism3kr9sqfdDBCdZFzn95NPuXlV2ztni7DsFjg3F8DgieKzKWHcAaKzoyBA
         brWGXeTaOuwABx77YO09pZJZ3pjF/BNRejv9onNA=
Date:   Fri, 28 Jun 2019 10:49:25 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v2 2/7] crypto: aegis128l/aegis256 - remove x86 and
 generic implementations
Message-ID: <20190628174924.GB103946@gmail.com>
References: <20190628170746.28768-1-ard.biesheuvel@linaro.org>
 <20190628170746.28768-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628170746.28768-3-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 28, 2019 at 07:07:41PM +0200, Ard Biesheuvel wrote:
> Three variants of AEGIS were proposed for the CAESAR competition, and
> only one was selected for the final portfolio: AEGIS128.
> 
> The other variants, AEGIS128L and AEGIS256, are not likely to ever turn
> up in networking protocols or other places where interoperability
> between Linux and other systems is a concern, nor are they likely to
> be subjected to further cryptanalysis. However, uninformed users may
> think that AEGIS128L (which is faster) is equally fit for use.
> 
> So let's remove them now, before anyone starts using them and we are
> forced to support them forever.
> 
> Note that there are no known flaws in the algorithms or in any of these
> implementations, but they have simply outlived their usefulness.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/x86/crypto/Makefile               |   4 -
>  arch/x86/crypto/aegis128l-aesni-asm.S  | 826 ----------------
>  arch/x86/crypto/aegis128l-aesni-glue.c | 297 ------
>  arch/x86/crypto/aegis256-aesni-asm.S   | 703 --------------
>  arch/x86/crypto/aegis256-aesni-glue.c  | 297 ------
>  crypto/Makefile                        |   2 -
>  crypto/aegis128l.c                     | 522 -----------
>  crypto/aegis256.c                      | 473 ----------
>  crypto/testmgr.c                       |  12 -
>  crypto/testmgr.h                       | 984 --------------------
>  10 files changed, 4120 deletions(-)
> 

Need to remove the options from crypto/Kconfig too.

- Eric
