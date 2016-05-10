From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH v5 0/3] Key-agreement Protocol Primitives (KPP) API
Date: Tue, 10 May 2016 12:49:49 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D03190153A@IRSMSX102.ger.corp.intel.com>
References: <1462830041-7582-1-git-send-email-salvatore.benedetto@intel.com>
 <6917609.BxtCJBuMZE@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46224 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbcEJMuC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 May 2016 08:50:02 -0400
In-Reply-To: <6917609.BxtCJBuMZE@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> -----Original Message-----
> From: Stephan Mueller [mailto:smueller@chronox.de]
> Sent: Tuesday, May 10, 2016 8:03 AM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: herbert@gondor.apana.org.au; linux-crypto@vger.kernel.org
> Subject: Re: [PATCH v5 0/3] Key-agreement Protocol Primitives (KPP) API
> 
> Am Montag, 9. Mai 2016, 22:40:38 schrieb Salvatore Benedetto:
> 
> Hi Salvatore,
> 
> > Hi Herb,
> >
> > the following patchset introduces a new API for abstracting
> > key-agreement protocols such as DH and ECDH. It provides the
> > primitives required for implementing the protocol, thus the name KPP
> > (Key-agreement Protocol Primitives).
> >
> > Regards,
> > Salvatore
> >
> > Changes from v4:
> > * If fips_enabled is set allow only P256 (or higher) as Stephan
> > suggested
> 
> Thank you.
> 
> What I am wondering though is whether the kernel crashes in FIPS mode
> with this implementation as follows: there are test vectors for P192 which
> seem(?) to be called unconditionally. In FIPS mode, we do not have P192 and
> the ECC code returns an error when using this curve. Thus, wouldn't the self
> test fail for P192?

I have to admit I didn't test that small change with fips_enabled. My bad.
ECDH is indeed failing to load with fips_enabled.
I also spotted a bug in ecdh_shared_secret. Basically I was not checking the
return value of ecc_get_curve and I was dereferencing anyway. I guess I have
to resend the patch and fix that.

Thanks,
Salvatore
