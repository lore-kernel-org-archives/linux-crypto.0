From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: inconsistent handling of unaligned hash inputs
Date: Thu, 2 Oct 2014 15:15:32 +0800
Message-ID: <20141002071532.GA26288@gondor.apana.org.au>
References: <20141002003353.GA23780@gondor.apana.org.au>
 <20141001.180614.1843735881125772362.davem@davemloft.net>
 <CAA-+O6EDQP1x_5Wzr_K66xUBRNrFMroYEhGTKPH1ViX=5uzNRA@mail.gmail.com>
 <20141001.223557.1385169137486165396.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bob.picco@oracle.com, linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org, bpicco@meloft.net
To: David Miller <davem@davemloft.net>
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141001.223557.1385169137486165396.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 01, 2014 at 10:35:57PM -0400, David Miller wrote:
>
> Therefore, for now, it's probably best to use my patch, and use
> get_unaligned_*() consistently throughout the sha* implementations.

OK I've applied your patch to cryptodev.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
