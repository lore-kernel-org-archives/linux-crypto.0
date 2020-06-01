Return-Path: <SRS0=veUY=7O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28656C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 07:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC77C2077D
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 07:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590995603;
	bh=IoxtWCTNv9oRM8/eqsjJ/avYBy7mPBN0qFyJgIqCcOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=lClChENAde1HPUpCpKCUw/wZkZPN01lc1tUIGP26rDcOL5TIbNIP6dUeUnfglP08x
	 Ki64WBvk33bfPDtUWoEf2QwZj5T6nuPz4kvRUt/5EgMD/kHdhO31uDw1eSjkUcyF5m
	 oOwT1Z0s779DMpXLKH+EALpxra9FxjqWuQ+mmZP4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgFAHNW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jun 2020 03:13:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbgFAHNW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jun 2020 03:13:22 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 951822074B;
        Mon,  1 Jun 2020 07:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590995601;
        bh=IoxtWCTNv9oRM8/eqsjJ/avYBy7mPBN0qFyJgIqCcOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gBdMtWLOFo8ephxI07jRpbsikFb8NfdBMEdTkDnVDeouhQ1XubhQuxZMBX6NSYbrJ
         ZA2NYyONO6X6I+U0GVGNp0d9tna0q59OHPPoy0uUpy+dmEdPM1qe6kDw6BZN2yBd3P
         AtYpuw+k/1H9UOYyH+QCgfH64fc7hpOaqxMsXrCU=
Date:   Mon, 1 Jun 2020 00:13:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     sbuisson.ddn@gmail.com
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, Sebastien Buisson <sbuisson@whamcloud.com>
Subject: Re: [PATCH] crypto: add adler32 to CryptoAPI
Message-ID: <20200601071320.GE11054@sol.localdomain>
References: <20200528170051.7361-1-sbuisson@whamcloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528170051.7361-1-sbuisson@whamcloud.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 28, 2020 at 07:00:51PM +0200, sbuisson.ddn@gmail.com wrote:
> From: Sebastien Buisson <sbuisson@whamcloud.com>
> 
> Add adler32 to CryptoAPI so that it can be used with the normal kernel
> API, and potentially accelerated if architecture-specific
> optimizations are available.
> 
> Signed-off-by: Sebastien Buisson <sbuisson@whamcloud.com>
> ---
>  crypto/Kconfig        |   7 +
>  crypto/Makefile       |   1 +
>  crypto/adler32_zlib.c | 117 ++++++++++++++++
>  crypto/testmgr.c      |   7 +
>  crypto/testmgr.h      | 362 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 494 insertions(+)
>  create mode 100644 crypto/adler32_zlib.c

Did you actually run the self-tests for this?  They fail for me.

- Eric
