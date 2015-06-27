From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Fixes for 4.2
Date: Sat, 27 Jun 2015 09:40:24 -0700
Message-ID: <CA+55aFzLESDmcCEO+N93y8=eF5t7Y0xA0+JnCPvpctXm4hvgGQ@mail.gmail.com>
References: <20131107080131.GA32307@gondor.apana.org.au>
	<20140123115319.GA20602@gondor.apana.org.au>
	<20140401100001.GA12386@gondor.apana.org.au>
	<20140605062336.GA14440@gondor.apana.org.au>
	<20140804130339.GA1178@gondor.apana.org.au>
	<20141007131826.GA29688@gondor.apana.org.au>
	<20141211125119.GA12380@gondor.apana.org.au>
	<20150214094328.GA7457@gondor.apana.org.au>
	<20150626102234.GA19393@gondor.apana.org.au>
	<CA+55aFwvyJkQXxTLzgtwv4wMmvwVtKdPMsNa05CgaKop9vQ1NQ@mail.gmail.com>
	<20150627065638.GA29497@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34461 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbbF0QkZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Jun 2015 12:40:25 -0400
In-Reply-To: <20150627065638.GA29497@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 26, 2015 at 11:56 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
>
> So I think Tadeusz's patch is the simplest fix for 4.2.  Could you
> please test it to see if it makes your warning go away?

Seems to silence it here.

I get the feeling that the patch is still wrong - why are not the
*tests* run at late time when everything is properly set up, rather
than forcing ordering at the code init level - but at least I don't
see the annoying error, so it's certainly better than it was before.

                Linus
