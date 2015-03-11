From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: amcc: remove incorrect __init/__exit markups
Date: Thu, 12 Mar 2015 01:13:22 +1100
Message-ID: <20150311141322.GD5713@gondor.apana.org.au>
References: <20150309203539.GA11240@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150309203539.GA11240@dtor-ws>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Mar 09, 2015 at 01:35:39PM -0700, Dmitry Torokhov wrote:
> Even if bus is not hot-pluggable, the devices can be bound and unbound
> from the driver via sysfs, so we should not be using __init/__exit
> annotations on probe() and remove() methods. The only exception is
> drivers registered with platform_driver_probe() which specifically
> disables sysfs bind/unbind attributes.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
