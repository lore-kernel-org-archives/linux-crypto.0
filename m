From: Aaron Sierra <asierra@xes-inc.com>
Subject: Re: [PATCH v2] crypto: talitos: Remove zero_entry static
 initializer
Date: Mon, 3 Aug 2015 18:47:02 -0500 (CDT)
Message-ID: <113837543.1343611.1438645622934.JavaMail.zimbra@xes-inc.com>
References: <985540634.83104.1438363661992.JavaMail.zimbra@xes-inc.com> <926902712.309275.1438618477197.JavaMail.zimbra@xes-inc.com> <20150803233120.GA26617@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Christophe Leroy <christophe.leroy@c-s.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from xes-mad.com ([216.165.139.218]:26638 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbbHCXsJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 19:48:09 -0400
In-Reply-To: <20150803233120.GA26617@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- Original Message -----
> From: "Herbert Xu" <herbert@gondor.apana.org.au>
> Sent: Monday, August 3, 2015 6:31:20 PM
> 
> On Mon, Aug 03, 2015 at 11:14:37AM -0500, Aaron Sierra wrote:
> > Compiling the talitos driver with my GCC 4.3.1 e500v2 cross-compiler
> > resulted in a failed build due to the anonymous union/structures
> > introduced in this commit:
> > 
> >   crypto: talitos - enhanced talitos_desc struct for SEC1
> > 
> > The build error was:
> > 
> >   drivers/crypto/talitos.h:56: error: unknown field 'len' specified in
> >   initializer
> >   drivers/crypto/talitos.h:56: warning: missing braces around initializer
> >   drivers/crypto/talitos.h:56: warning: (near initialization for
> >   'zero_entry.<anonymous>')
> >   drivers/crypto/talitos.h:57: error: unknown field 'j_extent' specified in
> >   initializer
> >   drivers/crypto/talitos.h:58: error: unknown field 'eptr' specified in
> >   initializer
> >   drivers/crypto/talitos.h:58: warning: excess elements in struct
> >   initializer
> >   drivers/crypto/talitos.h:58: warning: (near initialization for
> >   'zero_entry')
> >   make[2]: *** [drivers/crypto/talitos.o] Error 1
> >   make[1]: *** [drivers/crypto] Error 2
> >   make: *** [drivers] Error 2
> > 
> > This patch eliminates the errors by moving the static constant
> > zero_entry to the talitos_private structure. As a member of that
> > structure, zero_entry gets initialized for free (and compatibly) by
> > the kzalloc() during device probe.
> 
> Why? A static variable is always zeroed.  Please just get rid
> of the initialisation and it will work.

Thanks for elaborating. I'll make the change.

-Aaron
