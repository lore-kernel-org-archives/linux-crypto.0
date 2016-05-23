From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH v6 0/3] Key-agreement Protocol Primitives (KPP) API
Date: Mon, 23 May 2016 20:26:15 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D0319181FB@IRSMSX102.ger.corp.intel.com>
References: <1462951563-50042-1-git-send-email-salvatore.benedetto@intel.com>
 <8688641.Yei9vfB8rY@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12017 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295AbcEWU0S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 May 2016 16:26:18 -0400
In-Reply-To: <8688641.Yei9vfB8rY@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

> -----Original Message-----
> From: Stephan Mueller [mailto:smueller@chronox.de]
> Sent: Monday, May 23, 2016 7:44 PM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: herbert@gondor.apana.org.au; linux-crypto@vger.kernel.org
> Subject: Re: [PATCH v6 0/3] Key-agreement Protocol Primitives (KPP) API
> 
> Am Mittwoch, 11. Mai 2016, 08:26:00 schrieb Salvatore Benedetto:
> 
> Hi Salvatore,
> 
> > Hi Herb,
> >
> > the following patchset introduces a new API for abstracting
> > key-agreement protocols such as DH and ECDH. It provides the
> > primitives required for implementing the protocol, thus the name KPP
> > (Key-agreement Protocol Primitives).
> 
> I just saw that in Linus' tree, a DH implementation popped up at
> security/keys/dh.c
> 
> Note, the implementation is also from an Intel developer.
> 
> Would it make sense that both implementations are synced so that we only
> have one and that we need to worry about side channels only once?
> 

http://permalink.gmane.org/gmane.linux.kernel.lsm/27456

As mentioned in the cover letter of that patch, KEYCTL_DH_COMPUTE will be converted
to kpp once accepted.

Regards,
Salvatore
