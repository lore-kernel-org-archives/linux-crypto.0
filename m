From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/8] Conversion crypto API documentation to Sphinx
Date: Tue, 25 Oct 2016 10:35:49 +0800
Message-ID: <20161025023549.GA17875@gondor.apana.org.au>
References: <2053893.WjF01BJSDF@positron.chronox.de>
 <20161023103238.4fceddac@lwn.net>
 <1645861.DSRXbPG5tl@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1645861.DSRXbPG5tl@positron.chronox.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Oct 23, 2016 at 06:46:12PM +0200, Stephan Mueller wrote:
> Am Sonntag, 23. Oktober 2016, 10:32:38 CEST schrieb Jonathan Corbet:
> 
> Hi Jonathan,
> 
> > On Fri, 21 Oct 2016 04:53:45 +0200
> > 
> > Stephan Mueller <smueller@chronox.de> wrote:
> > > the attached patch set converts the existing crypto API documentation
> > > from DocBook to Sphinx.
> > 
> > This looks generally good to me - thanks for doing it!
> > 
> > Is there any chance of running the Documentation/ parts through the docs
> > tree?  Documentation/index.rst has become a bit of a conflict point
> > otherwise...
> 
> Unless Herbert objects, I would not see any reason why we should not push it 
> through the docs tree.

No objections from me.

> Yet we should wait for Herbert's ack as I have added also new information in 
> the patch set (the KPP API documentation and the change in the AEAD 
> documentation).

Looks good to me.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
