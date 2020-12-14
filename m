Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12C8C1B0E3
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 02:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97DAB2076B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 02:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437930AbgLNCYr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Dec 2020 21:24:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:55826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437916AbgLNCYo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Dec 2020 21:24:44 -0500
Date:   Sun, 13 Dec 2020 18:23:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607912641;
        bh=3e0/RimAahnl1eUKFVMppC1yZAjcfyXtClJiM1VkL/4=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=QCiZ4KsRH3PHQDPG9kxJVTeGvQ0cZy//y76Srm/MDOMv0MMnc6J3WJg6loVrFM1Z8
         BVy1SrK5A1yFz06/oEEeMCShSF+YZig9PyZ95waJEl6psNFfBq4WWEh/aeWAJ0WQaZ
         DRLRLxzfA+uhj1oBi+uOe8vXSIR0X68yFUCIem38ZYyrJLQT0sguIP7xkzJz2vmGzj
         jql8IRN/TwB4B6jOW5Apm6nPBdFovpjqrZB/4iW69qNaikaNrlKeSGQbkr/M6sB/PJ
         fZRDB27kf5aBEtlTsGwGeas+qei5p+MCwMARljklgY0CSR8D/iO47AO8LqX4y1OdbA
         Zhj7e0xRnl0WA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH v2] crypto: arm/chacha-neon - add missing counter
 increment
Message-ID: <X9bMij4eGOXn2XJv@sol.localdomain>
References: <20201213143929.7088-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201213143929.7088-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Dec 13, 2020 at 03:39:29PM +0100, Ard Biesheuvel wrote:
> This violates the skcipher API, which requires that the output IV is suitable
> for handling more input as long as the preceding input has been presented in
> round multiples of the block size. 

This part doesn't seem to be true, since the chacha implementations don't
implement the "output IV" thing.  It's only cbc and ctr that do (or at least
those are the only algorithms it's tested for).

- Eric
