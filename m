From: Sebastian Siewior <bigeasy@breakpoint.cc>
Subject: Re: [patch 1/1] spufs: SPU-AES support (kspu+ablkcipher user)
Date: Wed, 29 Aug 2007 11:28:25 +0200
Message-ID: <20070829092825.GB24782@Chamillionaire.breakpoint.cc>
References: <20070816200105.735608000@ml.breakpoint.cc> <20070816200137.867399000@ml.breakpoint.cc> <20070828154637.GA21007@Chamillionaire.breakpoint.cc> <20070829071507.GA5108@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, arnd@arndb.de, jk@ozlabs.org,
	cbe-oss-dev@ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54367 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753473AbXH2J21 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Aug 2007 05:28:27 -0400
Content-Disposition: inline
In-Reply-To: <20070829071507.GA5108@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-08-29 15:15:07 [+0800]:

>Do you plan to use this for anything beyond AES? If so it
I probably don't, others maybe.

>would be good to come up a way to share some of the crypto
>code between the main kernel and what runs on the SPUs.
Yes. You could share almost everything except the setkey() function on
the kernel side.

>Cheers,

Sebastian
