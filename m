From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Update for 4.2
Date: Mon, 22 Jun 2015 21:26:51 -0700
Message-ID: <CA+55aFwK0C5BK8afhi7YhF2Omyu10quJhT_+LO2oO56ZemT4XQ@mail.gmail.com>
References: <20130907035544.GA22658@gondor.apana.org.au>
	<20131107080131.GA32307@gondor.apana.org.au>
	<20140123115319.GA20602@gondor.apana.org.au>
	<20140401100001.GA12386@gondor.apana.org.au>
	<20140605062336.GA14440@gondor.apana.org.au>
	<20140804130339.GA1178@gondor.apana.org.au>
	<20141007131826.GA29688@gondor.apana.org.au>
	<20141211125119.GA12380@gondor.apana.org.au>
	<20150214094328.GA7457@gondor.apana.org.au>
	<20150415033951.GA1406@gondor.apana.org.au>
	<20150622084457.GA7806@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:35922 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbbFWE0w (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2015 00:26:52 -0400
In-Reply-To: <20150622084457.GA7806@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 22, 2015 at 1:44 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Here is the crypto update for 4.2:

So this generates conflicts with your earlier changes (that I got
through the networking tree - they are your patches, but they went
through Steffen Klassert and then David Miller).

I resolved them, but I want you to double-check the end result.

Some of the conflicts are just trivial (but annoying) conflicts due to
whitespace changes to the vmx routines.

But the changes to net/ipv4/esp4.c and net/ipv6/esp6.c are actual real
code conflicts, even though the in the merge they look like no change
at all, because I picked your side and the changes on the other side
just went away.

I did that, because ss far as I can tell, the changes in commits
7021b2e1cddd and 000ae7b2690e (that switch esp4/6 over to the new AEAD
interface) obviate the commits I got earlier to use the high-order
sequence number bits for IV generation.

So it looks to me like those AEAD interface changes already make sure
to use the full 64 bits of the sequence number.

But if I'm wrong, please holler. You clearly know both sides of this,
since you wrote all the patches involved, so I'd like you to
double-check me.

                  Linus
