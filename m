Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56888C4361B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B0C4222BB
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:40:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503405AbgLNUkP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:40:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502972AbgLNUkL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 15:40:11 -0500
Date:   Mon, 14 Dec 2020 12:39:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607978370;
        bh=BDtfqPF1hR+W8YQRbJkWf3TQLJFcZSSkZUfoVEx/WoY=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=gEsi/qr/WMdaIdTdpunN/RQs7WyiszF6Nt1oiI/Tt4cScEdUo+itlrDNMAVCHFlik
         8A7k3PH1dA2l1ZrQVhCp7XJkkgyED3svzFpdO4MqvFQ+0YKKM2iAS0HYhOUnkBbGLn
         WX2pvIIHrcUyPVk474D2hz4Zs08HAgEJA64VZi5yVm9odF+Ah92WJ+jbd0FKX0Ds5Z
         KskliVax1QQuLVUk1SznBmm+sJXwzN1125qFPebAaqgET6HV6oQ3GfrcZ7PRe5nJQD
         Hya5qX3EX/GLieUjvm38DZ+PUzQ2Z0pThjYq7Fai6KUXIYqMYjAHA6ldzlg76Z4i7G
         K6neumfbBSbWQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] crypto: arm/chacha-neon - add missing counter
 increment
Message-ID: <X9fNgQxS3jASW7C1@sol.localdomain>
References: <20201213143929.7088-1-ardb@kernel.org>
 <X9bMij4eGOXn2XJv@sol.localdomain>
 <20201214022520.GA13534@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214022520.GA13534@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 14, 2020 at 01:25:20PM +1100, Herbert Xu wrote:
> On Sun, Dec 13, 2020 at 06:23:06PM -0800, Eric Biggers wrote:
> >
> > This part doesn't seem to be true, since the chacha implementations don't
> > implement the "output IV" thing.  It's only cbc and ctr that do (or at least
> > those are the only algorithms it's tested for).
> 
> If this algorithm can be used through algif_skcipher then it will
> be making use of the output IV.
> 

That doesn't make sense, given that most algorithms don't implement it...

- Eric
