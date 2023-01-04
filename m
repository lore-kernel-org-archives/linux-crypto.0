Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9150DC5479D
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Jan 2023 13:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjADNFi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Jan 2023 08:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjADNF3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Jan 2023 08:05:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3775C1DDC2;
        Wed,  4 Jan 2023 05:05:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D16CEB8163C;
        Wed,  4 Jan 2023 13:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA8BC433EF;
        Wed,  4 Jan 2023 13:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672837524;
        bh=HgcYcbLQUuCY1Kc4OAO0bhkr3GGWCNM95MhsYtgwtFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MpEmyY0KD/wAbTx9zt1oOJuG2pGJ/yjn3463c+ljDnKtFAukM8ayLV8EQ64TEQV49
         HQiOVLtYs5gkbjT8SSwJfeCfmLJ6QrM46YiFFTHuTgyLcUvdqPcUeZeYfpHC+jzK2r
         j/mMC30uncw75IpfdAjFtq27tmAAZqtFcyFGn4NyOmXnibldHFTNAfxCIrrSHzWXhw
         waV3Q1XGW30xj6rLHB7+Z3wQJ6IwX5JobdnvDYWeB6h/mK8soAEttepQEvgKQZpktM
         BOaIo4TomDJRWFAfy5SjZ7Q/OKQJLx2s2+nNWQhMX3LJMVElRXE+MMaAQnQ8kUf4xN
         sYK36Yb0j4RCg==
Date:   Wed, 4 Jan 2023 13:05:21 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Ben Boeckel <me@benboeckel.net>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Vitaly Chikunov <vt@altlinux.org>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: certs: fix FIPS selftest depenency
Message-ID: <Y7V5kQVgK3PTWRHi@kernel.org>
References: <20221215170259.2553400-1-arnd@kernel.org>
 <Y6tF52G6/bnG+VfJ@kernel.org>
 <Y6xCYmZkggGzzzBM@farprobe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6xCYmZkggGzzzBM@farprobe>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 28, 2022 at 08:19:30AM -0500, Ben Boeckel wrote:
> On Tue, Dec 27, 2022 at 19:22:38 +0000, Jarkko Sakkinen wrote:
> > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Might want to fix this when picked:
> 
> > Subject: Re: [PATCH] crypto: certs: fix FIPS selftest depenency
>                                              dependency ^^^^^^^^^
> 
> --Ben

Thank you! I updated the patch accordingly.

It should be soon available in linux-next tree.

BR, Jarkko
