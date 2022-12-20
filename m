Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CDC1C10F1E
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Dec 2022 06:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiLTGCK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Dec 2022 01:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbiLTGCD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Dec 2022 01:02:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20C61583E;
        Mon, 19 Dec 2022 22:01:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58C7FB80952;
        Tue, 20 Dec 2022 06:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9517C433F1;
        Tue, 20 Dec 2022 06:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671516116;
        bh=bPhStfewvu4L3T4K89LnBgo5z7RAFTFq8MvZd/qxUzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FgSed6E72drB8AY87FlcerSzv3A2hJzdHcjs6egQV7+VSEJ0VKew+hdl7ewWb3F4X
         iYM4HeRBAzmQIjgOIcU0eFaYYvfci0wQ+P1NDOA6HZIrxsyEsjFjjXyptRhIaK0I+o
         U0+ZV1gnfVWcaBDQsm3OQUEX7b7cxX54JzuO4I1NOJA1wXwwVVYhRxXQFe7k6tW1hh
         Cmd8SlQzGXARlpeFEO6EHXXz3Ws9+6Xnf1loRFGHHlJv74aFdMe/9o+c4feMHvstfx
         WrQjDORNWSpU42/kJkx2HTfQD6aAb2rlQghoPXSB3QteIkHEBvy62UXUEvrfaUaBgh
         Ms+qE0yBlAXww==
Date:   Mon, 19 Dec 2022 22:01:54 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Robert Elliott <elliott@hpe.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net, corbet@lwn.net,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/8] crypto: x86/ghash - add kernel-doc comments to
 assembly
Message-ID: <Y6FP0uQpRhH+IToC@sol.localdomain>
References: <20221215063857.161665-1-elliott@hpe.com>
 <20221219185555.433233-1-elliott@hpe.com>
 <20221219185555.433233-7-elliott@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219185555.433233-7-elliott@hpe.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 19, 2022 at 12:55:53PM -0600, Robert Elliott wrote:
> +/**
> + * clmul_ghash_mul - Calculate GHASH final multiplication using x86 PCLMULQDQ instructions

Well, it does one multiplication.  It's not necessarily the final one.

> + * @dst:	address of hash value to update (%rdi)
> + * @shash:	address of hash context (%rsi)

This terminology is confusing.  I would call these the accumulator and key,
respectively.

> +/**
> + * clmul_ghash_update - Calculate GHASH using x86 PCLMULQDQ instructions
> + * @dst:	address of hash value to update (%rdi)
> + * @src:	address of data to hash (%rsi)
> + * @srclen:	number of bytes in data buffer (%rdx);
> + *		function does nothing and returns if below 16
> + * @shash:	address of hash context (%rcx)
> + *
> + * This supports 64-bit CPUs.
> + *
> + * Return:	none (but @dst is updated)
> + * Prototype:	asmlinkage clmul_ghash_update(char *dst, const char *src,
> + *					      unsigned int srclen, const u128 *shash);

"function does nothing and returns if below 16" =>
"function processes round_down(srclen, 16) bytes".

- Eric
