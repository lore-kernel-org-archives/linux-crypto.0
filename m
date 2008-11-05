From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: extend ansi_cprng to allow resetting of DT
	value
Date: Wed, 5 Nov 2008 12:13:53 +0800
Message-ID: <20081105041353.GA19366@gondor.apana.org.au>
References: <20081103212240.GB24888@hmsreliant.think-freely.org> <200811041604.24895.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37583 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752811AbYKEEOF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Nov 2008 23:14:05 -0500
Content-Disposition: inline
In-Reply-To: <200811041604.24895.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 04, 2008 at 04:04:24PM -0500, Jarod Wilson wrote:
> 
> Even better than my original version, since it lets providing a DT value be 
> optional. Go ahead and slap this on there too:
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Applied to cryptodev.  Thanks everyone!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
