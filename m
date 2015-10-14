From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 4.3
Date: Wed, 14 Oct 2015 10:38:09 +0800
Message-ID: <20151014023809.GA13213@gondor.apana.org.au>
References: <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150626102234.GA19393@gondor.apana.org.au>
 <20150908092502.GA8332@gondor.apana.org.au>
 <20150916103014.GA12315@gondor.apana.org.au>
 <20150926200133.GA19035@gondor.apana.org.au>
 <20151013121750.GA6408@gondor.apana.org.au>
 <CA+55aFz0ZdjpC_FpM6h=z_boK8HeKzgt_7Zm14TnrZYqx1SaUQ@mail.gmail.com>
 <20151014010304.GA12430@gondor.apana.org.au>
 <CA+55aFyHSme2b7i9GW_SNtqkP6F7nYQBqgApPp6pZkp3bJP3bA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35964 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbbJNCiS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Oct 2015 22:38:18 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFyHSme2b7i9GW_SNtqkP6F7nYQBqgApPp6pZkp3bJP3bA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 13, 2015 at 07:00:20PM -0700, Linus Torvalds wrote:
>
> You might try to start using signed tags for your pull requests. That
> lessens this kind of issue, because now only will you write the tag
> message and then your signing key pass phrase etc, the tag would
> specify one very particular commit at the time of the tagging rather
> than just have it be the default branch of your public repository.

Right.  I'll start using branches for the next push.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
