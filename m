From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] trivial: report backend_cra_name when allocation fails
Date: Thu, 11 Jun 2015 08:28:53 +0800
Message-ID: <20150611002853.GA8904@gondor.apana.org.au>
References: <1433942868-16447-1-git-send-email-sergey.senozhatsky@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	sergey.senozhatsky.work@gmail.com
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47951 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbbFKA26 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 20:28:58 -0400
Content-Disposition: inline
In-Reply-To: <1433942868-16447-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 10, 2015 at 10:27:47PM +0900, Sergey Senozhatsky wrote:
> Hello,
> 
> A trivial patch.
> 
> My wifi stopped working recently, and the error message was not too
> informative (at least to me):
> 
> kernel: wlp2s0: authenticate with 64:e5:99:74:dc:44
> kernel: wlp2s0: send auth to 64:e5:99:74:dc:44 (try 1/3)
> kernel: wlp2s0: authenticated
> kernel: wlp2s0: associate with 64:e5:99:74:dc:44 (try 1/3)
> kernel: wlp2s0: RX AssocResp from 64:e5:99:74:dc:44 (capab=0x411 status=0 aid=1)
> kernel: wlp2s0: associated
> kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
> dhclient[355]: DHCPREQUEST on wlp2s0 to 255.255.255.255 port 67
> kernel: DRBG: could not allocate digest TFM handle
> kernel: wlp2s0: deauthenticating from 64:e5:99:74:dc:44 by local choice (Reason: 1=UNSPECIFIED)
> kernel: cfg80211: Calling CRDA to update world regulatory domain
> 
> 
> an update error message
>   DRBG: could not allocate digest TFM handle: hmac(sha256)
> 
> is slightly more helpful (didn't have sha256 config enabled).

Thanks.  And I'll make sure drbg select sha256 so that this doesn't
happen.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
