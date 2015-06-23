From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Update for 4.2
Date: Tue, 23 Jun 2015 12:32:08 +0800
Message-ID: <20150623043208.GA16725@gondor.apana.org.au>
References: <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <CA+55aFwK0C5BK8afhi7YhF2Omyu10quJhT_+LO2oO56ZemT4XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42268 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbbFWEcV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2015 00:32:21 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFwK0C5BK8afhi7YhF2Omyu10quJhT_+LO2oO56ZemT4XQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 22, 2015 at 09:26:51PM -0700, Linus Torvalds wrote:
>
> So it looks to me like those AEAD interface changes already make sure
> to use the full 64 bits of the sequence number.
> 
> But if I'm wrong, please holler. You clearly know both sides of this,
> since you wrote all the patches involved, so I'd like you to
> double-check me.

Yes the AEAD conversion does the right thing and uses the full 64
bits of the sequence number.  In fact it was during that conversion
when I noticed the bug and sent in a fix to Steffen.

Thanks for the heads up!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
