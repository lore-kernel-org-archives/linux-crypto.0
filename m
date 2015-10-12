From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: unaligned access in pkcs7_verify
Date: Mon, 12 Oct 2015 09:46:27 -0400
Message-ID: <20151012134627.GG14646@oracle.com>
References: <20151002140014.GI18263@oracle.com>
 <20151008131519.GA24362@gondor.apana.org.au>
 <20151008144343.GE19655@oracle.com>
 <20151012133209.GA27746@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32772 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbbJLNql (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Oct 2015 09:46:41 -0400
Content-Disposition: inline
In-Reply-To: <20151012133209.GA27746@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (10/12/15 21:32), Herbert Xu wrote:
> Thanks.  We have two bugs here.  First of all pkcs7_verify definitely
> shouldn't place the structure after the digest without aligning the
> pointer.  So something like your patch is needed (but please use
> alignof instead of sizeof).  Also don't put in digest_size but
> instead align the pointer like
> 
> 	desc = PTR_ALIGN(digest + digest_size, ...)

That patch might not be rock-solid by itself though.  I was seeing
some panics/crashes when I was running with that patch, so I backed 
it off temporarily - should sinfo->sig.digest_size be set to the aligned
value?

> The sparc sha algorithms themselves need to declare the alignment
> that they require.  Currently they claim to be able to handle any
> alignment which appears to not be the case.

How would one do that correctly? I'm not a crypto expert, but I can
help test the patch..

--Sowmini
