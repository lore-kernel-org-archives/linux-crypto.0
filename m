From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 1/2] [XFRM] remove ifdef crypto
Date: Tue, 8 Jan 2008 17:13:50 +1100
Message-ID: <20080108061350.GC2529@gondor.apana.org.au>
References: <20080105123637.GA12561@Chamillionaire.breakpoint.cc> <E1JB8I6-0003Pk-OJ@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4416 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755308AbYAHGNx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jan 2008 01:13:53 -0500
Content-Disposition: inline
In-Reply-To: <E1JB8I6-0003Pk-OJ@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 05, 2008 at 01:36:37PM +0100, Sebastian Siewior wrote:
> and select the crypto subsystem if neccessary
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Could you please resend this patch to David Miller and cc netdev?

I'll merge the other once this one is in Linus's tree.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
