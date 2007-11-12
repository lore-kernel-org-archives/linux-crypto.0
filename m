From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: Re: [PATCH 1/2] stream: Stream cipher wrapper
Date: Tue, 13 Nov 2007 03:44:42 +0800
Message-ID: <fd3e431c0711121144q30af79a3y577be15c1a842a8b@mail.gmail.com>
References: <fd3e431c0711061137lfa743abwa2be4d563d39e83b@mail.gmail.com>
	 <20071111121151.GA14285@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Linux Crypto" <linux-crypto@vger.kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:25496 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbXKLTon (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Nov 2007 14:44:43 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1644693wah
        for <linux-crypto@vger.kernel.org>; Mon, 12 Nov 2007 11:44:42 -0800 (PST)
In-Reply-To: <20071111121151.GA14285@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert, thanks for taking the time to review my patches. My reply is below.

On Nov 11, 2007 8:11 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> In fact, thanks the work Joy has done with CTR, the Salsa20
> stream cipher can be expressed as
>         ctr(salsa20,0,16,8)
> where salsa20 is the Salsa20 expansion function.
I agree that Salsa20 can be implemented this way as it is essentially
a hash function in counter mode. However this is not true in general
of other eSTREAM candidates. I am hoping to find a general solution
for eSTREAM ciphers, not just Salsa20.

> So could you please update your patches so that it works under
> this framework? So your salsa20 simple cipher should be OK as
> it is minus the extra bits like setiv.
I could do that. But before I do, may I propose an alternative approach?

I would like to propose using a separate crypto_type, say
crypto_estream_type, to "categorize" eSTREAM ciphers. Also separate
estream_alg and estream_tfm will be used to support the setiv() call
and to track the ivsize. A "stream" template will be used to specify
the algorithm and ivsize - so for example Salsa20 will be
"stream(salsa20,8)" to cryptomgr.

I think this is a valid approach as it allows eSTREAM ciphers to be
ported easily into the kernel without disturbing the existing block
ciphers and block modes. I also think it is feasible because I've
implemented it and tested it over the weekend. :P

Please consider the merits of such an approach. I will post my 3
patches in separate emails.

Regards,
Swee Heng
