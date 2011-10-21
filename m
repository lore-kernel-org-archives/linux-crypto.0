From: David Rientjes <rientjes@google.com>
Subject: Re: Crypto Fixes for 3.1
Date: Fri, 21 Oct 2011 02:41:54 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1110210240290.12963@chino.kir.corp.google.com>
References: <20100427135547.GA4008@gondor.apana.org.au> <20100603100550.GA30681@gondor.apana.org.au> <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au> <20100903060055.GA28915@gondor.apana.org.au>
 <20100903110722.GA31826@gondor.apana.org.au> <20101215115035.GA25248@gondor.apana.org.au> <20110216053911.GA10999@gondor.apana.org.au> <20110328071322.GA6569@gondor.apana.org.au> <20110629235153.GA16559@gondor.apana.org.au>
 <20111021082259.GA13530@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:30349 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab1JUJl7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Oct 2011 05:41:59 -0400
Received: from hpaq12.eem.corp.google.com (hpaq12.eem.corp.google.com [172.25.149.12])
	by smtp-out.google.com with ESMTP id p9L9fw89016601
	for <linux-crypto@vger.kernel.org>; Fri, 21 Oct 2011 02:41:58 -0700
Received: from pzk1 (pzk1.prod.google.com [10.243.19.129])
	by hpaq12.eem.corp.google.com with ESMTP id p9L9dTKm032400
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 21 Oct 2011 02:41:56 -0700
Received: by pzk1 with SMTP id 1so12078626pzk.5
        for <linux-crypto@vger.kernel.org>; Fri, 21 Oct 2011 02:41:56 -0700 (PDT)
In-Reply-To: <20111021082259.GA13530@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 21 Oct 2011, Herbert Xu wrote:

> Hi Linus:
> 
> This push fixes a NULL-pointer dereference that can be triggered
> from user-space.
> 
> Please pull from
> 
> git://github.com/herbertx/crypto.git
> 

Hi Herbert,

When I pull from this, I also get 

commit 9c129165af0225c63c37d1896ac9b0d34e48b69f
Author: Jamie Iles <jamie@jamieiles.com>
Date:   Mon Jun 6 12:31:17 2011 +0100

    crypto: picoxcell - fix possible invalid pointer dereference

which looks unrelated?
