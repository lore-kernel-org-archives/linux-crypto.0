From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5 1/6] SP800-90A Deterministic Random Bit Generator
Date: Tue, 15 Apr 2014 08:08:14 +0200
Message-ID: <1520003.UOH14fpcBO@myon.chronox.de>
References: <2396177.vxvG2ljJL8@myon.chronox.de> <1635225.UnHjb6h9ND@myon.chronox.de> <1397541065.16090.11.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	aquini@redhat.com, jeremy.wayne.powell@gmail.com,
	clemens@ladisch.de, pwalten@au1.ibm.com
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397541065.16090.11.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 14. April 2014, 22:51:05 schrieb Joe Perches:

Hi Joe,

> On Tue, 2014-04-15 at 07:35 +0200, Stephan Mueller wrote:
> > diff --git a/crypto/drbg.c b/crypto/drbg.c
> 
> []
> 
> > @@ -0,0 +1,1997 @@
> 
> []
> 
> > +/***************************************************************
> > + * Backend cipher definitions available to DRBG
> > + ***************************************************************/
> > +
> > +const struct drbg_core cores[] = {
> 
> cores isn't a very good global name.
> I presume this should be static.

Agreed. static added and renamed to drbg_cores. I will wait a few days before 
releasing a new version. Maybe other comments show up.

Thanks for the review.

Ciao
Stephan
-- 
| Cui bono? |
