From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 0/8] Conversion crypto API documentation to Sphinx
Date: Sun, 23 Oct 2016 18:46:12 +0200
Message-ID: <1645861.DSRXbPG5tl@positron.chronox.de>
References: <2053893.WjF01BJSDF@positron.chronox.de> <20161023103238.4fceddac@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20161023103238.4fceddac@lwn.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Sonntag, 23. Oktober 2016, 10:32:38 CEST schrieb Jonathan Corbet:

Hi Jonathan,

> On Fri, 21 Oct 2016 04:53:45 +0200
> 
> Stephan Mueller <smueller@chronox.de> wrote:
> > the attached patch set converts the existing crypto API documentation
> > from DocBook to Sphinx.
> 
> This looks generally good to me - thanks for doing it!
> 
> Is there any chance of running the Documentation/ parts through the docs
> tree?  Documentation/index.rst has become a bit of a conflict point
> otherwise...

Unless Herbert objects, I would not see any reason why we should not push it 
through the docs tree.

Yet we should wait for Herbert's ack as I have added also new information in 
the patch set (the KPP API documentation and the change in the AEAD 
documentation).

Ciao
Stephan
