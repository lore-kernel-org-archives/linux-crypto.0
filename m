From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH 2/2] crypto: kpp - Add DH software implementation
Date: Tue, 12 Apr 2016 13:18:42 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D0318E7DEE@IRSMSX102.ger.corp.intel.com>
References: <1460457556-3117-1-git-send-email-salvatore.benedetto@intel.com>
 <1460457556-3117-3-git-send-email-salvatore.benedetto@intel.com>
 <1607852.1Sj4nuRRVd@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Stephan Mueller <sm@eperm.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:19012 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583AbcDLNTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Apr 2016 09:19:05 -0400
In-Reply-To: <1607852.1Sj4nuRRVd@tauon.atsec.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

> -----Original Message-----
> From: Stephan Mueller [mailto:sm@eperm.de]
> Sent: Tuesday, April 12, 2016 2:01 PM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: herbert@gondor.apana.org.au; linux-crypto@vger.kernel.org
> Subject: Re: [PATCH 2/2] crypto: kpp - Add DH software implementation
> 
> Am Dienstag, 12. April 2016, 11:39:16 schrieb Salvatore Benedetto:
> 
> Hi Salvatore,
> 
> >  * Implement MPI based Diffie-Hellman under kpp API
> >  * Add test with data generad by OpenSSL
> >
> > Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
> > ---
> >  crypto/Kconfig      |   8 ++
> >  crypto/Makefile     |   2 +
> >  crypto/dh.c         | 233
> > ++++++++++++++++++++++++++++++++++++++++++++++++++++
> crypto/testmgr.c    |
> > 157 +++++++++++++++++++++++++++++++++++
> >  crypto/testmgr.h    | 208
> ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/crypto/dh.h |  23 ++++++
> >  6 files changed, 631 insertions(+)
> >  create mode 100644 crypto/dh.c
> >  create mode 100644 include/crypto/dh.h
> >
> > +
> > +static int dh_check_params_length(unsigned int p_len)
> > +{
> > +	switch (p_len) {
> > +	case 1536:
> > +	case 2048:
> > +	case 3072:
> > +	case 4096:
> > +	case 6144:
> > +	case 8192:
> > +		return 0;
> 
> Does the math require this check?
> 
> Wouldn't it be better to implement limits to the low side (i.e. p_len < 1536)
> and then add a real limit due to the implementation (e.g. it must be multiple
> of full bytes)?
> 

The math itself does not require any check that I'm aware of.
As for the real limit, I think we have to add that as an hardware
that is only capable of handling up to 4096 bytes, should fall back
to the software implementation if a bigger param is used.

Thanks,
Salvatore
