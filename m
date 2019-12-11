Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140C8C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 03:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D36ED2073B
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 03:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576035133;
	bh=gykypuSSxJcP1QgQoWY8gfMcjLeJTD9RQmw9SV6rho0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=PEDndHgdDloPkx6axqbmrRhny3F3R5HuQMPuFj9KzgwbxCCkb/FQKYHPal6NhVQZs
	 5y75nSZgBejf2afQOpE7BLJQ51uY4ZfQMW0UGObxC1chgRl35DdMA218Pia3GydoDx
	 SZO9pIDw0VwLMEbZQN5cXNirBbxL/RyJk9lwmnYE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfLKDcN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 22:32:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbfLKDcN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 22:32:13 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 930C120718;
        Wed, 11 Dec 2019 03:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576035132;
        bh=gykypuSSxJcP1QgQoWY8gfMcjLeJTD9RQmw9SV6rho0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N0buLrkG+W0v+FnCbxGUnNQr8LAk6/2lbqdUb1LpAcv7Bi69+98tr52vaT0AMjQBC
         9yYLsdrLuGXfjxQhPo4bstyLLql1AIHYqGylUu+zYH5sFgr98Gkci7VPCrxSvJg+Fb
         qYk0OwOXqPvJmHoIzuK+OBLjVfn84s/uN4CMbQBU=
Date:   Tue, 10 Dec 2019 19:32:11 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 0/3] crypto: shash - Enforce descsize limit in init_tfm
Message-ID: <20191211033211.GF732@sol.localdomain>
References: <20191206023527.k4kxngcsb7rpq2rz@gondor.apana.org.au>
 <20191208054229.h4smagmiuqhxxc6w@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191208054229.h4smagmiuqhxxc6w@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Dec 08, 2019 at 01:42:29PM +0800, Herbert Xu wrote:
> As it stands we only enforce descsize limits when an algorithm is
> registered.  However, as descsize is dynamic and may be set at
> init_tfm time this is not enough.  This is why hmac has its own
> descsize check.
> 
> This series adds descsize limit enforcement at init_tfm time so
> that the API takes over the responsibility of checking descsize
> after the algorithm's init_tfm has completed.
> 
> v2 addresses the issues raised during review, including adding
> a WARN_ON_ONCE to crypto_shash_init_tfm.
> 
> Thanks,

I left some nits on patches 1 and 2, but not too important.  Feel free to add:

Reviewed-by: Eric Biggers <ebiggers@google.com>
