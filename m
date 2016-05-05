From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH 0/3 v3] Key-agreement Protocol Primitives (KPP) API
Date: Thu, 5 May 2016 09:27:20 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D0318FFF9A@IRSMSX102.ger.corp.intel.com>
References: <1462275843-19926-1-git-send-email-salvatore.benedetto@intel.com>
 <20160505062140.GA3949@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24284 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756703AbcEEJ1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 05:27:23 -0400
In-Reply-To: <20160505062140.GA3949@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Thursday, May 5, 2016 7:22 AM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: [PATCH 0/3 v3] Key-agreement Protocol Primitives (KPP) API
> 
> On Tue, May 03, 2016 at 12:44:00PM +0100, Salvatore Benedetto wrote:
> > Hi Herb,
> >
> > the following patchset introduces a new API for abstracting
> > key-agreement protocols such as DH and ECDH. It provides the
> > primitives required for implementing the protocol, thus the name KPP
> (Key-agreement Protocol Primitives).
> >
> > Regards,
> > Salvatore
> >
> > Changes from v1:
> >  * Change check in dh_check_params_length based on Stephan review
> >
> > Changed from v2:
> >  * Add support for ECDH (curve P192 and P256). I reused the ecc module
> >    already present in net/bluetooth and extended it in order to select
> >    different curves at runtime. Code for P192 was taken from tinycrypt.
> 
> Are you going to post the patches to use this as well?
> 

I just sent v4 which contains a small change plus an illustrative patch that
converts SMP BT to KPP api. I can't test the patch as I don't have the hardware.
BT guys should be OK in converting their code properly to kpp once merged.
Is that good enough for you?

Regards,
Salvatore 
