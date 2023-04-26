Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C217CC77B60
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Apr 2023 23:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbjDZXXi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Apr 2023 19:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbjDZXXf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Apr 2023 19:23:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874433A90;
        Wed, 26 Apr 2023 16:23:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 240B96308C;
        Wed, 26 Apr 2023 23:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A4CC4339B;
        Wed, 26 Apr 2023 23:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682551413;
        bh=ljfhtZUXSaQHweOFdXEqbHy6V/WG7H3gj8DTqCSLU4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U7ysqy1cyC5qk+5uCIMUWE4azLykmQqFV/eT3GtTTFLLHrGb2LGy2Cw1aSYvgGsiU
         jC4bTHSc4HZBA12fBSlPObnA++Kr+Y0C8JZ2y0Mkc7DW2vj+pymGJRh5vh27NRt9sQ
         X3zYYFbvGBwpmqA6SV7V/vJj5f2LucE8QPlWw3M1z9rrNZX9wKyepUbxQb4YOi9OlX
         FIZDy1mFIyqkDRVUK59+RfzdjIjDJoZMBEVi+76sBwdUeYw/e+F0hjD3/4sw8vxXpU
         GiT1+6oB8BDn+qMZEBqaEBlW5vgD44v8CzHLdhVcTOIklj9ZdV/ZwjDD4oDNfDyiEZ
         i8+WC/yAE9uvQ==
Date:   Wed, 26 Apr 2023 16:23:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc:     palmer@dabbelt.com, paul.walmsley@sifive.com,
        aou@eecs.berkeley.edu, herbert@gondor.apana.org.au,
        davem@davemloft.net, conor.dooley@microchip.com,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, christoph.muellner@vrull.eu
Subject: Re: [PATCH v4 0/4] Implement GCM ghash using Zbc and Zbkb extensions
Message-ID: <20230426232331.GB65659@sol.localdomain>
References: <20230329140642.2186644-1-heiko.stuebner@vrull.eu>
 <20230426225550.GA65659@sol.localdomain>
 <7664296.GXAFRqVoOG@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7664296.GXAFRqVoOG@diego>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 27, 2023 at 01:20:31AM +0200, Heiko Stübner wrote:
> But for me, this small bit of scalar crypto is also sort of a stepping
> stone :-). Previous versions [0] already included patches using the
> vector crypto extensions too, I just split that into a separate thing,
> as _this_ series actually uses ratified extensions :-)
> 
> 
> Heiko
> 
> 
> 
> [0] https://lore.kernel.org/lkml/20230313191302.580787-12-heiko.stuebner@vrull.eu/T/

That patchset wasn't sent to linux-crypto.  Can you make sure to include
linux-crypto@vger.kernel.org on any subsequent patchsets?  Thanks!

- Eric
