From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH v5 1/3] crypto: Key-agreement Protocol Primitives API
 (KPP)
Date: Thu, 2 Jun 2016 12:06:48 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D031930814@IRSMSX102.ger.corp.intel.com>
References: <1462830041-7582-1-git-send-email-salvatore.benedetto@intel.com>
 <1462830041-7582-2-git-send-email-salvatore.benedetto@intel.com>
 <20160531064210.GA13948@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32429 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbcFBMGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 08:06:52 -0400
In-Reply-To: <20160531064210.GA13948@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

apologies, I missed this email.

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Herbert Xu
> Sent: Tuesday, May 31, 2016 7:42 AM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: [PATCH v5 1/3] crypto: Key-agreement Protocol Primitives API
> (KPP)
> 
> On Mon, May 09, 2016 at 10:40:39PM +0100, Salvatore Benedetto wrote:
> > Add key-agreement protocol primitives (kpp) API which allows to
> > implement primitives required by protocols such as DH and ECDH.
> > The API is composed mainly by the following functions
> >  * set_params() - It allows the user to set the parameters known to
> >    both parties involved in the key-agreement session
> >  * set_secret() - It allows the user to set his secret, also
> >    referred to as his private key
> 
> Why can't we just have one function, set_secret or better yet setkey?
>

Off the top of my head, with ECDH when the user gets a EGAIN, he wants
to reset the secret key only, not the params.

> >  * generate_public_key() - It generates the public key to be sent to
> >    the other counterpart involved in the key-agreement session. The
> >    function has to be called after set_params() and set_secret()
> >  * generate_secret() - It generates the shared secret for the session
> 
> Ditto, we only need one operation and that is multiplication by the secret.

Sorry, but I don't understand your point.
We do always need one math operation with different params.

> I'm OK with you keeping them separate for kpp users so that they don't have
> to explicitly provide G but please ensure that drivers only have to implement
> one of them.

The implementation still has to know which params to use for the operation
and somehow we need to pass that information on.

Can you please help understand what your main concern is? :-)

Thanks,
Salvatore
