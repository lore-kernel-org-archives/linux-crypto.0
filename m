Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9773CC7EE43
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Jun 2023 03:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239282AbjFMDFA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Jun 2023 23:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239405AbjFMDEM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Jun 2023 23:04:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1BB2117;
        Mon, 12 Jun 2023 20:03:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 184E3630DF;
        Tue, 13 Jun 2023 03:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F47C433EF;
        Tue, 13 Jun 2023 03:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686625338;
        bh=QE/bJwOrqp//Jql9+14/MwBTyhw4er96hvgONGtQRQA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fmFutB7UJyIqIvyYtzg1AhRZiCqep9yi7UDUTZD+BRwy69iezaNkdsmMzjfXkNDkF
         uq1944kIbErb3We3MTv2UfHDOJhnAakKbShcn8gxn9Ek6+a93OlDiNM3W8XbAOc5Mb
         eACE/U6o9yjpFlxF02c7JlDOccZjNV8T9K/sg6ZWGR1paTU3AgwWRErDIhSBSkP7Z7
         nBO64y9c/jjjL/RVX3c3kY1uym4Lh4PP4MACduOmXaZEEJqCEPU5xfBbC60Gj7xT0c
         p5iL/yfQtr88Y2hO5W/gGWwB5jAKyTgwz9L6CUZmw6Tg78mKJQ7Aqnu89AETEYoJTZ
         IHUWlMs3YxGIA==
Date:   Mon, 12 Jun 2023 20:02:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Heiko Stuebner <heiko@sntech.de>
Cc:     palmer@dabbelt.com, paul.walmsley@sifive.com,
        aou@eecs.berkeley.edu, herbert@gondor.apana.org.au,
        davem@davemloft.net, conor.dooley@microchip.com,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, christoph.muellner@vrull.eu,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: Re: [PATCH v5 0/4] Implement GCM ghash using Zbc and Zbkb extensions
Message-ID: <20230613030216.GC883@sol.localdomain>
References: <20230612210442.1805962-1-heiko.stuebner@vrull.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612210442.1805962-1-heiko.stuebner@vrull.eu>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Heiko,

On Mon, Jun 12, 2023 at 11:04:38PM +0200, Heiko Stuebner wrote:
> From: Heiko Stuebner <heiko.stuebner@vrull.eu>
> 
> This was originally part of my vector crypto series, but was part
> of a separate openssl merge request implementing GCM ghash as using
> non-vector extensions.
> 
> As that pull-request
>     https://github.com/openssl/openssl/pull/20078
> got merged recently into openssl, we could also check if this could
> go into the kernel as well and provide a base for further accelerated
> cryptographic support.

I'm still a bit skeptical of the usefulness of a standalone "ghash"
implementation, when in practice it will only be used as part of "gcm(aes)".
Directly implementing "gcm(aes)" (instead of relying on crypto/gcm.c to compose
"ghash" and "ctr(aes)") also allows some performance optimizations.

I asked about this on v4
(https://lore.kernel.org/linux-crypto/ZCSG71bRuTzVutdm@gmail.com/),
but I didn't receive a response.

Any thoughts on this?

- Eric
