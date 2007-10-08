From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] load the SHA1[1|256] module by an alias
Date: Mon, 8 Oct 2007 13:30:20 +0200
Message-ID: <20071008113020.GB31712@Chamillionaire.breakpoint.cc>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au> <20071004083512.GA11305@Chamillionaire.breakpoint.cc> <E1IdMSX-0004KV-LS@Chamillionaire.breakpoint.cc> <1191842723.7760.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Jan Glauber <jan.glauber@de.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42258 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574AbXJHLaW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Oct 2007 07:30:22 -0400
Content-Disposition: inline
In-Reply-To: <1191842723.7760.3.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Jan Glauber | 2007-10-08 13:25:23 [+0200]:

>Hi Sebastian,
Hi Jan, good to see you back :)

>what about SHA-512? Should that not also be renamed to sha512_generic.c ?

We could do it, but I haven't seen a HW implementation yet. If your new
CPU has an opcode for this, we could rename it than :)

>
>--Jan

Sebastian
