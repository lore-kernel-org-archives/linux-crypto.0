Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD237C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 15:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243530AbiBJPUL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 10:20:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243523AbiBJPUK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 10:20:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6FDDB0
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 07:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C18F5CE22F9
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 15:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B10C004E1;
        Thu, 10 Feb 2022 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644506408;
        bh=+uzHCiisx8xRiDW6ie21pxcw6VpazLXeUNHrycehQMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FbwGjhWmsmDlvJzk/0Msm3PpliNNNMIdoaLvPe+c2HoLFwYsK07TsMcERHom53e4v
         sRTaZ8x9BlCDs4ZvC+KN4+asS4HHiEtk2b7NFxoIJ5DZjUUOO2V7NYiDoKuO1TSrvB
         2fKRCbc1SIYzQ7b/RPL6rwYnO7dx+Zuna8gKfyzU=
Date:   Thu, 10 Feb 2022 16:20:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ted Ts'o <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/4] random: Apply get_source_long() in several places
Message-ID: <YgUtJbh8yUAaKwzA@kroah.com>
References: <CACXcFmm7Bxnctksf2e96+f7UZk_HjHSJwiCakPuBfdGX5d=T9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFmm7Bxnctksf2e96+f7UZk_HjHSJwiCakPuBfdGX5d=T9A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 10, 2022 at 10:44:44PM +0800, Sandy Harris wrote:
> Replace arch_get_random_long()/random_get_entropy() sequences
> with get_source_long().

This says what you want to do, but nothing about _why_ you want to do
it.

Please read the documentation for how to write good changelog texts.
As-is, this doesn't work.

Also, the patch is whitespace corrupted :(

thanks,

greg k-h
