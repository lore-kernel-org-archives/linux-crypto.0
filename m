From: Tomas Mraz <tmraz@redhat.com>
Subject: Re: [CRYPTO] obfuscating kernel pointers
Date: Mon, 15 Nov 2010 13:06:34 +0100
Message-ID: <1289822794.30446.424.camel@vespa.frost.loc>
References: <20101115115842.GA4007@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-2"
Content-Transfer-Encoding: 7bit
Cc: drosenberg@vsecurity.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab0KOMGl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Nov 2010 07:06:41 -0500
In-Reply-To: <20101115115842.GA4007@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2010-11-15 at 19:58 +0800, Herbert Xu wrote: 
> Tomas Mraz <tmraz@redhat.com> wrote:
> >
> > This would not be a 'hashing' algorithm but a simple block encryption
> > algorithm in the ECB mode with the random key initialized at boot. The
> > problem here is that the standard block ciphers have at least 64 bit
> > block length as smaller block length ciphers would not be secure for
> > general purpose uses. You would have to take an existing block cipher
> > algorithm and modify it to achieve the smaller block length.
> 
> If block sizes are a problem then we have stream ciphers too.
But you obviously cannot use a stream cipher as ECB cipher which is what
Dan needs here.
-- 
Tomas Mraz
No matter how far down the wrong road you've gone, turn back.
                                              Turkish proverb
