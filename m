From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH v2 2/4] pcrypt: Add pcrypt crypto parallelization
	engine
Date: Tue, 28 Apr 2009 14:31:29 +0800
Message-ID: <20090428063129.GA1776@gondor.apana.org.au>
References: <20090424102451.GB12680@secunet.com> <20090424102720.GD12680@secunet.com> <20090427085620.GB21761@gondor.apana.org.au> <20090428062316.GA20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52118 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755195AbZD1Gbf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Apr 2009 02:31:35 -0400
Content-Disposition: inline
In-Reply-To: <20090428062316.GA20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 28, 2009 at 08:23:16AM +0200, Steffen Klassert wrote:
>
> I don't need to exclude it. I just wanted to avoid another layer
> of pcrypt here because it does not make too much sense to parallelize
> a second time. If the aead algorithm is already parallel it would just
> add overhead if we parallelize an underlying algorithm too.
> Anyway, I would not mind to allow more than one pcrypt layer.

I thought so.  The system is certainly not going to automatically
construct a second pcrypt algorithm once one exists.  So I think
we can just remove this bit.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
