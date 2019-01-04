Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43970 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbfADRYZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jan 2019 12:24:25 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20190104170748.GA67931@gmail.com>
References: <20190104170748.GA67931@gmail.com> <20190104041625.3259-5-ebiggers@kernel.org> <20190104041625.3259-1-ebiggers@kernel.org> <11047.1546595833@warthog.procyon.org.uk>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Subject: Re: [PATCH 04/16] crypto: pcbc - remove bogus memcpy()s with src == dest
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17297.1546622663.1@warthog.procyon.org.uk>
Date: Fri, 04 Jan 2019 17:24:23 +0000
Message-ID: <17298.1546622663@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Eric Biggers <ebiggers@kernel.org> wrote:

> It makes it clearer what's going on, especially since some modes update the
> 'iv' pointer after each block (delaying the copy to 'walk.iv' until the end)
> but others can't do that.  The 'const' is helpful to further distinguish
> these two cases, which were confused in both the pcbc and cfb
> implementations.

I'm not sure I agree that it makes it clearer, but:

Reviewed-and-tested-by: David Howells <dhowells@redhat.com>
