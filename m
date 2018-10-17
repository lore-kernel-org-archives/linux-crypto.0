Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37428 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbeJQOC5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 10:02:57 -0400
Date: Wed, 17 Oct 2018 14:08:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] crypto: streebog - add Streebog hash function
Message-ID: <20181017060851.r5mxvpq3l2ycvpio@gondor.apana.org.au>
References: <20181010121254.12220-1-vt@altlinux.org>
 <20181012061659.mextetc3v7urqkzx@gondor.apana.org.au>
 <20181012064105.bchujbwoaszrcu3l@sole.flsd.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012064105.bchujbwoaszrcu3l@sole.flsd.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 12, 2018 at 09:41:05AM +0300, Vitaly Chikunov wrote:
>
> It is the first part of attempts to add to the Integrity subsystem
> ability of verifying file and module signatures by Russian GOST
> algorithms.

It would be better if these patches are posted together.  That
way we don't end up with a situation where the algorithm goes into
the kernel but the ultimate user is rejected.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
