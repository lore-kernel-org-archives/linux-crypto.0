Return-Path: <SRS0=Yf/g=65=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C28F0C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 19:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 974C920728
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 19:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589570119;
	bh=UinLAu8db6y9SZEZe4qtY0YZhPXc8RUH7ydN044nJwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=CJtRYIxHvI+aUAwmT2maG8sRF7IsgNoABfU7u3HnS2tja33d0JFol7G3Ze9Qom/j0
	 wcvNgDoX2Ewdry46w86HmNNQ8d/VnLdsGjV8qYPdVQIabc+GNgT/JAyALHfDilVUlM
	 ix6SrU1YMkFFxlGAHno2/7oEuUKydHPtF0YcAAtg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgEOTPT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 May 2020 15:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgEOTPS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 May 2020 15:15:18 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 554EC20727;
        Fri, 15 May 2020 19:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589570118;
        bh=UinLAu8db6y9SZEZe4qtY0YZhPXc8RUH7ydN044nJwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ChYCB+95zjRESBMOWcH7/HCtqDwBA9bts659J/uV4emjXN6QO3sEy+ydzvPo+fA2g
         syferF1lk2pqhK8o+GaET1ZgaE2SJy9jQ36QiYn5dmI9YQdhLUZVydncXWpUVu0dzX
         UimOWObEw2zB8iHikF0e2P3+NDJSpBA3eqgET44U=
Date:   Fri, 15 May 2020 12:15:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH] lib/xxhash: make xxh{32,64}_update() return void
Message-ID: <20200515191516.GD1009@sol.localdomain>
References: <20200502063423.1052614-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502063423.1052614-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 01, 2020 at 11:34:23PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The return value of xxh64_update() is pointless and confusing, since an
> error is only returned for input==NULL.  But the callers must ignore
> this error because they might pass input=NULL, length=0.
> 
> Likewise for xxh32_update().
> 
> Just make these functions return void.
> 
> Cc: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> lib/xxhash.c doesn't actually have a maintainer, but probably it makes
> sense to take this through the crypto tree, alongside the other patch I
> sent to return void in lib/crypto/sha256.c.

Herbert, are you planning to apply this patch?

- Eric
