From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Suspect bug in the authenc module
Date: Fri, 5 Mar 2010 15:26:49 +0800
Message-ID: <20100305072649.GA3706@gondor.apana.org.au>
References: <201003041154.05369.myrobmail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: steffen.klassert@secunet.com, linux-crypto@vger.kernel.org
To: Roberto Sassu <myrobmail@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57224 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754038Ab0CEH06 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Mar 2010 02:26:58 -0500
Content-Disposition: inline
In-Reply-To: <201003041154.05369.myrobmail@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Roberto Sassu <myrobmail@gmail.com> wrote:
>
> when dumping the data placed pointed by the scatterlist array i noted that the 
> assoc is always zero'ed. I investigated further and it seems that the problem 
> is the static allocation of the assoc string in my test module. When using the 
> kmalloc the dump is correct.   

Right, static allocation in general is incompatible with any
interface that uses scatterlists.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
