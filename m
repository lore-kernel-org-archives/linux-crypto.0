From: David Howells <dhowells@redhat.com>
Subject: Re: v4.6-rc1 regression bisected, Problem loading in-kernel X.509 certificate (-2)
Date: Tue, 03 May 2016 09:54:31 +0100
Message-ID: <25450.1462265671@warthog.procyon.org.uk>
References: <20160430083248.GA20775@cucamonga.audible.transient.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jamie Heilman <jamie@audible.transient.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160430083248.GA20775@cucamonga.audible.transient.net>
Content-ID: <25449.1462265671.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Jamie Heilman <jamie@audible.transient.net> wrote:

> I usually build my kernels to require module signatures and use
> automatic signing.  As of v4.6-rc1 I'm getting this on boot:
> 
> Problem loading in-kernel X.509 certificate (-2)
> 
> I bisected that to commit d43de6c780a84def056afaf4fb3e66bdaa1efc00
> (akcipher: Move the RSA DER encoding check to the crypto layer)
> 
> For some reason after this commit my system keyring always ends up
> empty.  I use the deb-pkg make target.  My kernel config can
> be found at
> http://audible.transient.net/~jamie/k/modsign.config-4.6.0-rc5-guest

Do you have an example malfunctioning certificate that I can have a look at?

David
