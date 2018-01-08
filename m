From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] hwrng: Clean up RNG list when last hwrng is
 unregistered
Date: Mon, 8 Jan 2018 16:05:20 +1100
Message-ID: <20180108050520.GA1775@gondor.apana.org.au>
References: <151336772989.60446.16322941485803241258.stgit@sosxen2.amd.com>
 <d2f7189e-8a25-0352-0e33-a3df26f18c37@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net, prasannatsmkumar@gmail.com
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:53426 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750710AbeAHFFd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jan 2018 00:05:33 -0500
Content-Disposition: inline
In-Reply-To: <d2f7189e-8a25-0352-0e33-a3df26f18c37@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 05, 2018 at 11:28:23AM -0600, Gary R Hook wrote:
> 
> It may not have been obvious from the title but this fixes a bug
> which will impact the use of any HW RNG that is the only RNG
> registered. The breakage of rmmod/modprobe -r that this fix obviates
> suggests that it needs to make the 4.15 kernel, please. Just want to
> ensure this gets the proper attention. Thank you.

I don't think breaking rmmod is sufficiently serious to warrant
immediate inclusion at this point.  We can always send it via
stable after the release.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
