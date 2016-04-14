From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 2/3] crypto: rsa_helper - add raw integer parser actions
Date: Thu, 14 Apr 2016 17:38:08 +0200
Message-ID: <1694759.CAoKSHjcSd@tauon.atsec.com>
References: <1459949826-11840-1-git-send-email-tudor-dan.ambarus@nxp.com> <50351949.oWvfu4SbDk@tauon.atsec.com> <AM3PR04MB1300D3E01F404CA61D833C3DB8970@AM3PR04MB1300.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"tadeusz.struk@intel.com" <tadeusz.struk@intel.com>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34570 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449AbcDNPiM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Apr 2016 11:38:12 -0400
In-Reply-To: <AM3PR04MB1300D3E01F404CA61D833C3DB8970@AM3PR04MB1300.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 14. April 2016, 15:25:17 schrieb Tudor-Dan Ambarus:

Hi Tudor,

> > 
> > > +{
> > > +	if (key->d) {
> > > +		memset(key->d, '\0', key->n_sz);
> > 
> > memzero_explicit, please
> 
> I don't think this is really needed. memzero_explicit is used only on stack
> variables that get cleared just before they go out of scope.

Are you so sure that a compiler is not getting smart on seeing a memset 
followed by a free without marking the pointer as volatile? You free the 
pointer immediately after memset(). I would not want to bet anything that a 
compiler would leave the memset for non-volatile pointers.

Besides, memzero_expicit does not cost anything -- it does not add any 
instruction but convinces the compiler to not optimize it away.

Ciao
Stephan
