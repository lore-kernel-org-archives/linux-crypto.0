Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01CCCC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 14:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240998AbiBJO51 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 09:57:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243290AbiBJO51 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 09:57:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326EFC4C
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 06:57:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD61BB8255A
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 14:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84B3C004E1;
        Thu, 10 Feb 2022 14:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644505045;
        bh=g5OVObHyNbVOVMOpI+RbP9Dm6TmTnDorPAxu51sTyK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HeMXFDvTS4lkAD49E/arEOU0+C2gy8ccxs7evDVnJ/h4qK/R0+z9BFHuMdjJer6Qo
         AzO6gPYEXiuyETNnSzwScIizvOIOTVKJomiCpPTGfuCo2J5FgdXmgy4gZdQyo/bFej
         RzWSIeZv7ZImGyyXobnQQmnyfKxVM1wMjipwuzNY=
Date:   Thu, 10 Feb 2022 15:57:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ted Ts'o <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] random: change usage of arch_get_random_long()
Message-ID: <YgUn0uqwJXskzEzG@kroah.com>
References: <CACXcFmkC=6DsDiTbtnu=LMSsg00Lxz7jvcWNV=yDibz8suoVgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFmkC=6DsDiTbtnu=LMSsg00Lxz7jvcWNV=yDibz8suoVgw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 10, 2022 at 10:28:26PM +0800, Sandy Harris wrote:
> This series of patches is not strictly necessary, but it is a
> significant improvement.
> 
> The current code has a sequence in several places that calls one or
> more of arch_get_random_long() or related functions, checks the return
> value(s) and on failure falls back to random_get_entropy(). These
> patches provide get_source_long(), which is intended to replace all
> such sequences.
> 
> This is better in several ways. It never wastes effort by calling
> arch_get_random_long() et al. when the relevant config variables are
> not set. If config variables for a hardware rng or the latent entropy
> plugin are set, then it uses those instead. It does not deliver raw
> output from any of these sources, but masks it by mixing with stored
> random data. In the fallback case it gives much more random output
> 
> In the cases where a good source is available, this adds a little
> overhead, but not much. It also saves some by not trying
> arch_get-random_long() unnecessarily.
> 
> If no better source is available, get_source_long() falls back to
> get_xtea_long(), an internal-use-only pseudorandom generator based on
> the xtea block cipher. In general, that is considerably more expensive
> than random_get_entropy(), but also provably much stronger.
> 
> With no good source, there is still a problem at boot; xtea cannot
> become secure until it is properly keyed. It does become safe
> eventually, and in the meanwhile it is certainly no worse than
> random_get_entropy().

This patch series is not actually threaded at all, and is totally
whitespace damaged.

How did you send it?  Try using 'git send-email' next time to correctly
thread them and not corrupt them so that they are unusable :(

thanks,

greg k-h
