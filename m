Return-Path: <SRS0=g5s/=PY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728499AbfAPQWl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jan 2019 11:22:41 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20190104102035.42qwwv4komjvnswh@sole.flsd.net>
References: <20190104102035.42qwwv4komjvnswh@sole.flsd.net> <20181211165938.1150-1-vt@altlinux.org> <20181213101233.6t7d5mxxkkavo46h@gondor.apana.org.au>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
        davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] akcipher: Introduce verify2 for public key algorithms
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21903.1547655757.1@warthog.procyon.org.uk>
Date: Wed, 16 Jan 2019 16:22:37 +0000
Message-ID: <21904.1547655757@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Vitaly Chikunov <vt@altlinux.org> wrote:

> This will be hard to do since there is at least tree device that use
> this interface (and who know how much out of tree):
> 
>   drivers$ git grep cra_name.*rsa
>   crypto/caam/caampkc.c:          .cra_name = "rsa",
>   crypto/ccp/ccp-crypto-rsa.c:            .cra_name = "rsa",
>   crypto/qat/qat_common/qat_asym_algs.c:          .cra_name = "rsa",
> 
> Interface seems to be designed that verify() call is interchangeable
> with encrypt().
> 
> Two verify does not seem that bad since there is common code for the old
> interface that removes code duplication and simplifies driver
> implementation (RSA drivers only need to implement encrypt).

You could move the comparison into core crypto code if it's makes more sense
than moving the comparison to the crypto algorithm ->verify() call.  It makes
more sense than the upper layers having to cover the differences between the
algo modules.

David
