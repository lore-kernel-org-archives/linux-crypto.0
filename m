From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] ansi_cprng: Fix off by one error in non-block size
 request
Date: Tue, 24 Sep 2013 06:09:32 +1000
Message-ID: <20130923200932.GE21243@gondor.apana.org.au>
References: <1379421191-13740-1-git-send-email-nhorman@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Stephan Mueller <stephan.mueller@atsec.com>,
	Petr Matousek <pmatouse@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:56732 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753538Ab3IWUJh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Sep 2013 16:09:37 -0400
Content-Disposition: inline
In-Reply-To: <1379421191-13740-1-git-send-email-nhorman@tuxdriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 17, 2013 at 08:33:11AM -0400, Neil Horman wrote:
> Stephan Mueller reported to me recently a error in random number generation in
> the ansi cprng. If several small requests are made that are less than the
> instances block size, the remainder for loop code doesn't increment
> rand_data_valid in the last iteration, meaning that the last bytes in the
> rand_data buffer gets reused on the subsequent smaller-than-a-block request for
> random data.
> 
> The fix is pretty easy, just re-code the for loop to make sure that
> rand_data_valid gets incremented appropriately
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: Stephan Mueller <stephan.mueller@atsec.com>
> CC: Stephan Mueller <stephan.mueller@atsec.com>
> CC: Petr Matousek <pmatouse@redhat.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
