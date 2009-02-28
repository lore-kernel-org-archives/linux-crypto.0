From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: hanging modprobe aes_s390
Date: Sat, 28 Feb 2009 13:06:36 +0100
Message-ID: <20090228120636.GA26999@Chamillionaire.breakpoint.cc>
References: <20090225035137.GA31538@gondor.apana.org.au> <1235583230.17311.57.camel@localhost.localdomain> <20090226060618.GA11303@gondor.apana.org.au>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Jan Glauber <jang@linux.vnet.ibm.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38382 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035AbZB1MGk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Feb 2009 07:06:40 -0500
Content-Disposition: inline
In-Reply-To: <20090226060618.GA11303@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2009-02-26 14:06:18 [+0800]:

>As algorithms requiring fallbacks are a special case, we can fix
>this by giving them a different module alias than the rest.  Then
>it's just a matter of using the right aliases according to what
>algorithms we're trying to find.

Yup. I am not sure if we have a problem with the geode here. That one
is loaded via PCI id probing. I'm going to check on that once I figured
out where the devel board is.....

Sebastian
