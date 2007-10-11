From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC] consider keysize in algorithm selection
Date: Thu, 11 Oct 2007 15:28:48 +0200
Message-ID: <20071011132848.GB28993@Chamillionaire.breakpoint.cc>
References: <20071010164400.GA19471@Chamillionaire.breakpoint.cc> <20071011114700.GA17801@gondor.apana.org.au> <20071011124314.GA28993@Chamillionaire.breakpoint.cc> <20071011130140.GA20363@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, Jan Glauber <jan.glauber@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58130 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759119AbXJKN2v (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Oct 2007 09:28:51 -0400
Content-Disposition: inline
In-Reply-To: <20071011130140.GA20363@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-10-11 21:01:40 [+0800]:

>On Thu, Oct 11, 2007 at 02:43:14PM +0200, Sebastian Siewior wrote:
>> >In other words, let's make geode-aes use the padlock-sha method
>> >and just fall back to a lower-priority AES algorithm if it sees
>> >a key size that it can't handle.
>> geode and s390 :)
>
>Are you sure about s390? I can't find a key size that it can't
>handle.

Yes I am. If you take a look the comment in the driver's init functions
you will see

/* z9 109 and z9 BC/EC only support 128 bit key length */

It is possible that future machines will support 192 and 256 key sizes
as well but what do I know, I don't work there :) Anyway even if they
support all key sizes at later time you have still those who don't. On
the other hand the customers maybe don't even care / use it :)

>Cheers,

Sebastian
