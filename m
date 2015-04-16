From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Update for 4.1
Date: Wed, 15 Apr 2015 18:58:32 -0700
Message-ID: <CA+55aFyynQ75NfQy7Lp6t9Tp8+bp=LKG9Xw9q8KQqNoS+gGLmA@mail.gmail.com>
References: <20130223023331.GA11002@gondor.apana.org.au>
	<20130907035544.GA22658@gondor.apana.org.au>
	<20131107080131.GA32307@gondor.apana.org.au>
	<20140123115319.GA20602@gondor.apana.org.au>
	<20140401100001.GA12386@gondor.apana.org.au>
	<20140605062336.GA14440@gondor.apana.org.au>
	<20140804130339.GA1178@gondor.apana.org.au>
	<20141007131826.GA29688@gondor.apana.org.au>
	<20141211125119.GA12380@gondor.apana.org.au>
	<20150214094328.GA7457@gondor.apana.org.au>
	<20150415033951.GA1406@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:32769 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbbDPB6d (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Apr 2015 21:58:33 -0400
In-Reply-To: <20150415033951.GA1406@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 14, 2015 at 8:39 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Here is the crypto update for 4.1:

Just a heads-up: this breaks iwlwifi for me after suspend.

I'm bisecting right now. But because this laptop is what I expect to
travel with tomorrow, I will ruthlessly revert anything I find,
because I need it to work.

             Linus
