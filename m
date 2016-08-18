From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: XTS - remove test that will fail in FIPS mode
Date: Thu, 18 Aug 2016 10:20:00 +0200
Message-ID: <1521976.suGWaIWodL@positron.chronox.de>
References: <D3CF7065.28F3%tsarangi@trustwave.com> <1521535.SOsKusk3RD@tauon.atsec.com> <D3D9E64F.30F1%tsarangi@trustwave.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tapas Sarangi <TSarangi@trustwave.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36818 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbcHRIUE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Aug 2016 04:20:04 -0400
In-Reply-To: <D3D9E64F.30F1%tsarangi@trustwave.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 17. August 2016, 15:09:11 CEST schrieb Tapas Sarangi:

Hi Tapas,

> Is that all the authenc() ciphers, or only some of them ? In my patch

I have not yet had the chance to fully dissect the authenc issue yet.

> where I had disabled .fips_allowed are mostly authenc() ciphers with
> cbc(des3_ede) algo. Not all the authenc() ciphers were needed to be
> disabled, but some.

Can you please point me to your patch?
> 
> For your XTS related findings and patches, are they going to 4.8 or 4.9 ?

The XTS patch set is for 4.8-rc1 and should therefore go into 4.9 if accepted 
by the maintainer.


Ciao
Stephan
