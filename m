Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50300 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727948AbfADJ5S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jan 2019 04:57:18 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20190104041625.3259-5-ebiggers@kernel.org>
References: <20190104041625.3259-5-ebiggers@kernel.org> <20190104041625.3259-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Subject: Re: [PATCH 04/16] crypto: pcbc - remove bogus memcpy()s with src == dest
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11045.1546595833.1@warthog.procyon.org.uk>
Date: Fri, 04 Jan 2019 09:57:13 +0000
Message-ID: <11047.1546595833@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Eric Biggers <ebiggers@kernel.org> wrote:

> -	u8 *iv = walk->iv;
> +	u8 * const iv = walk->iv;

Does adding this const actually gain anything?  (this is done twice)

David
