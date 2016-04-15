From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [PATCH v3 1/3] crypto: rsa - generalize ASN.1 sequences
Date: Fri, 15 Apr 2016 15:03:07 +0000
Message-ID: <VI1PR04MB1311589CC8A871EF1543B4ECB8680@VI1PR04MB1311.eurprd04.prod.outlook.com>
References: <1459949826-11840-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1459949826-11840-2-git-send-email-tudor-dan.ambarus@nxp.com>
 <20160415135245.GA334@gondor.apana.org.au>
 <VI1PR04MB13110F6720DB1578EC6AF0B2B8680@VI1PR04MB1311.eurprd04.prod.outlook.com>
 <20160415143851.GK733@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"tadeusz.struk@intel.com" <tadeusz.struk@intel.com>,
	"smueller@chronox.de" <smueller@chronox.de>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	"Horia Ioan Geanta Neag" <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3on0089.outbound.protection.outlook.com ([157.55.234.89]:63425
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751304AbcDOPRn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2016 11:17:43 -0400
In-Reply-To: <20160415143851.GK733@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> On Fri, Apr 15, 2016 at 02:32:42PM +0000, Tudor-Dan Ambarus wrote:
> > > On Wed, Apr 06, 2016 at 04:37:04PM +0300, Tudor Ambarus wrote:
> > > > This approach has the advantage that users can select specific
> > > > parser actions by using a general parser with function pointers
> > > > to specific actions.
> > >
> > > I don't understand why we need different parsing functions in the
> > > first place.  Can't they just return raw integers always?
> > >
> > > You can then trivially convert the raw integers to MPI, no?
> >
> > We need different parsing functions so that we don't allocate duplicate
> buffers for the same data.
> >
> > You need to allocate buffers when getting the raw integers and you need
> to allocate other (duplicate) buffers when converting the raw integers to
> MPI.
> >
> > Using the proposed API each user can select the format of data he wants,
> eliminating the need of a double conversion (with its drawbacks: duplicate
> buffers, unnecessary cycles).
> 
> The double allocation only happens with software RSA, right? I
> don't really think that is going to matter considering how slow
> it is, no?

The double allocation happens only with software RSA. I can't estimate the performance hit for the double conversion. Naturally is to parse the data only once. Plus, my suggestion is simple, faster and doesn't waste resources.

Thanks,
ta
