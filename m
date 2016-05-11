From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH v6 0/3] Key-agreement Protocol Primitives (KPP) API
Date: Wed, 11 May 2016 12:35:59 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D031901AFB@IRSMSX102.ger.corp.intel.com>
References: <1462951563-50042-1-git-send-email-salvatore.benedetto@intel.com>
 <2535192.8l4d6SEXNP@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28638 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092AbcEKMwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 May 2016 08:52:19 -0400
In-Reply-To: <2535192.8l4d6SEXNP@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Stephan Mueller
> Sent: Wednesday, May 11, 2016 10:05 AM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: herbert@gondor.apana.org.au; linux-crypto@vger.kernel.org
> Subject: Re: [PATCH v6 0/3] Key-agreement Protocol Primitives (KPP) API
> 
> Am Mittwoch, 11. Mai 2016, 08:26:00 schrieb Salvatore Benedetto:
> 
> Hi Salvatore,
> 
> > Changes from v5:
> > * Fix ecdh loading in fips mode.
> 
> Thanks.
> 
> As I do not readily see how you solved the issue, may I ask for a pointer to
> the code that handles that?
>

Loading kpp ecdh was indeed calling panic() before because the P192 test was run
anyway. Now when fips=1 is passed and CONFIG_CRYPTO_FIPS is set the P192 is
not run.

Regards,
Salvatore  
