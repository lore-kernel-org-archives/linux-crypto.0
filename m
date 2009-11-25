From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] xfrm: Custom truncation lengths for authentication
	algorithms
Date: Wed, 25 Nov 2009 20:10:39 +0800
Message-ID: <20091125121038.GA28385@gondor.apana.org.au>
References: <cover.1259142145.git.martin@strongswan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39388 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758698AbZKYMKf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Nov 2009 07:10:35 -0500
Content-Disposition: inline
In-Reply-To: <cover.1259142145.git.martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 25, 2009 at 11:29:50AM +0100, Martin Willi wrote:
> The following patchset adds support for defining truncation lengths
> for authentication algorithms in userspace. The main purpose for this
> is to support SHA256 in IPsec using the standardized 128 bit
> instead of the currently used 96 bit truncation.
> 
> Martin Willi (3):
>   xfrm: Define new XFRM netlink auth attribute with specified
>     truncation bits
>   xfrm: Store aalg in xfrm_state with a user specified truncation
>     length
>   xfrm: Use the user specified truncation length in ESP and AH

Looks great to me.  Thanks Martin!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
