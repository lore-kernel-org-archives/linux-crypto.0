From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [1/1 take 2] HIFN 795x driver.
Date: Mon, 8 Oct 2007 17:49:39 +0200
Message-ID: <20071008154939.GE31712@Chamillionaire.breakpoint.cc>
References: <20071002150013.GA6023@2ka.mipt.ru> <20071006215857.GB3645@Chamillionaire.breakpoint.cc> <20071008031510.GA32087@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45890 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbXJHPts (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Oct 2007 11:49:48 -0400
Content-Disposition: inline
In-Reply-To: <20071008031510.GA32087@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-10-08 11:15:10 [+0800]:

>On Sat, Oct 06, 2007 at 11:58:57PM +0200, Sebastian Siewior wrote:
>> * Evgeniy Polyakov | 2007-10-02 19:00:13 [+0400]:
>> 
>> >+MODULE_LICENSE("GPL");
>> >+MODULE_AUTHOR("Evgeniy Polyakov <johnpol@2ka.mipt.ru>");
>> >+MODULE_DESCRIPTION("Driver for HIFN 795x crypto accelerator chip.");
>> 
>> Please also add MODULE_ALIAS for algos (that was aes, des and 3des as
>> far as I remember).
>
>Actually this one should register aliases of "cbc(aes)", etc. as
>it doesn't implement plain old AES.

After thinking I realized that he does not need to provide an alias
because his driver should be auto loaded due to the PCI-IDs right?

But while you mention it: Should the alias cbc(aes), etc. also be
provided by the s390 and padlock driver which don't have PCI-IDs?
Currently they have the aes alias (what they also provide) so it might
be enough.

>Cheers,
Sebastian 
