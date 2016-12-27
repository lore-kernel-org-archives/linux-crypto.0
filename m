From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/3] Cavium ThunderX ZIP driver
Date: Tue, 27 Dec 2016 17:02:27 +0800
Message-ID: <20161227090227.GC10121@gondor.apana.org.au>
References: <20161212150439.18627-1-jglauber@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Mahipal Challa <Mahipal.Challa@cavium.com>,
        Vishnu Nair <Vishnu.Nair@cavium.com>
To: Jan Glauber <jglauber@cavium.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60623 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751583AbcL0JaC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 04:30:02 -0500
Content-Disposition: inline
In-Reply-To: <20161212150439.18627-1-jglauber@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Jan:

On Mon, Dec 12, 2016 at 04:04:36PM +0100, Jan Glauber wrote:
> 
> this series adds support for hardware accelerated compression & decompression
> as found on ThunderX (arm64) SOCs. I've been reviewing this driver internally
> for some time and would like to get feedback on the RFC to see if this goes
> into the right direction and to see if there are any concerns.
> 
> We've discussed switching to the new acomp algorithm but for the time being
> decided against acomp because our test cases are not yet supported with it.

OK.  Do you see any major problems in converting this over to acomp?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
