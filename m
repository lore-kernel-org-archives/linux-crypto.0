From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH v2 2/4] pcrypt: Add pcrypt crypto parallelization
	engine
Date: Tue, 28 Apr 2009 08:41:57 +0200
Message-ID: <20090428064157.GB20366@secunet.com>
References: <20090424102451.GB12680@secunet.com> <20090424102720.GD12680@secunet.com> <20090427085620.GB21761@gondor.apana.org.au> <20090428062316.GA20366@secunet.com> <20090428063129.GA1776@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:36827 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbZD1Gju (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Apr 2009 02:39:50 -0400
Content-Disposition: inline
In-Reply-To: <20090428063129.GA1776@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 28, 2009 at 02:31:29PM +0800, Herbert Xu wrote:
> 
> I thought so.  The system is certainly not going to automatically
> construct a second pcrypt algorithm once one exists.  So I think
> we can just remove this bit.
> 

Ok, so I will remove it in the next version.

Steffen
