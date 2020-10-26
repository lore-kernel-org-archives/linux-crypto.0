Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2092CC55178
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 23:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8B9A207DE
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 23:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603753421;
	bh=fdpGJaAAaOLZU97UoPeHC+CCsyWKKG1ZZPE2zHnD8tI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=HKTWe1M2A6uXI01G6rTp/KSGJB2m1aVi0QmtbiNFTvNicTacuiENwdGNjAyUabkCm
	 olhkFtRz5kapxc+VfOahMKZguW42RM9UV7uTEEbdrgdfk3SHHkHhMrzl304/B9vvy/
	 ZyBUnece8mtEdNAl0c5R/oQpz17a1ptjFIUIKCXM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395137AbgJZXD0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:03:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395130AbgJZXD0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 19:03:26 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57B5020780;
        Mon, 26 Oct 2020 23:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603753405;
        bh=fdpGJaAAaOLZU97UoPeHC+CCsyWKKG1ZZPE2zHnD8tI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mWoQTZLKlyPQGhw72cdcW5Xu881tCXFCHEQSbxJB7olU6xaU040JJISDY5j8OiUCs
         etnBM7wnQGKgxP1Be581JEm3eo0MzGjO/40eHZ05J4WEZm2h/4jZNXTclib36vCNDq
         pTcg6T9WpTuDVHMBAJQYRjci5sba+PNmSqdxrIyw=
Date:   Mon, 26 Oct 2020 16:03:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH] crypto: arm64/poly1305-neon - reorder PAC authentication
 with SP update
Message-ID: <20201026230323.GA1947033@gmail.com>
References: <20201026230027.25813-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026230027.25813-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 27, 2020 at 12:00:27AM +0100, Ard Biesheuvel wrote:
> PAC pointer authentication signs the return address against the value
> of the stack pointer, to prevent stack overrun exploits from corrupting
> the control flow. However, this requires that the AUTIASP is issued with
> SP holding the same value as it held when the PAC value was generated.
> The Poly1305 NEON code got this wrong, resulting in crashes on PAC
> capable hardware.
> 
> Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS ...")
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/poly1305-armv8.pl       | 2 +-
>  arch/arm64/crypto/poly1305-core.S_shipped | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

This needs to be fixed at https://github.com/dot-asm/cryptogams too, I assume?

- Eric
