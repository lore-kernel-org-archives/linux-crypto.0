From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Fixes for 4.2
Date: Fri, 26 Jun 2015 13:07:02 -0700
Message-ID: <CA+55aFwvyJkQXxTLzgtwv4wMmvwVtKdPMsNa05CgaKop9vQ1NQ@mail.gmail.com>
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
	<20150626102234.GA19393@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36841 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbbFZUHD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Jun 2015 16:07:03 -0400
In-Reply-To: <20150626102234.GA19393@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 26, 2015 at 3:22 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> * Kill testmgr warning for gcm-aes-aesni.

Hmm. You killed one of the warnings, but the setkey one remains.

    alg: aead: setkey failed on test 1 for rfc4106-gcm-aesni: flags=0

Expected?

               Linus
