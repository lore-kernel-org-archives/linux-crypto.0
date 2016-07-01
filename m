From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto: sha256-mb - cleanup a || vs | typo
Date: Fri, 1 Jul 2016 17:28:06 +0800
Message-ID: <20160701092806.GA13424@gondor.apana.org.au>
References: <20160629144242.GE22818@mwanda>
 <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
 <1467319339.22178.256.camel@linux.intel.com>
 <20160701075559.GA11902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Megha Dey <megha.dey@intel.com>,
	"Wang, Rui Y" <rui.y.wang@intel.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Xiaodong Liu <xiaodong.liu@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56114 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbcGAJ3R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Jul 2016 05:29:17 -0400
Content-Disposition: inline
In-Reply-To: <20160701075559.GA11902@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 01, 2016 at 09:55:59AM +0200, Ingo Molnar wrote:
>
> Plus:
>=20
> > > > =A0		/* Compute how many bytes to copy from user buffer into
> > > > =A0		=A0* extra block
> > > > =A0		=A0*/
>=20
> please use the customary (multi-line) comment style:

This is the customary comment style of the networking stack and
the crypto API.  So please don't change it.

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
