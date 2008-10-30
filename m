From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Enabling Talitos kills all IPsec traffic
Date: Thu, 30 Oct 2008 12:39:33 +0800
Message-ID: <E1KvPJl-0007Vt-L3@gondolin.me.apana.org.au>
References: <20081028190257.a0d5a6d8.kim.phillips@freescale.com>
Cc: mr.scada@gmail.com, linux-crypto@vger.kernel.org
To: kim.phillips@freescale.com (Kim Phillips)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52019 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751566AbYJ3Ejl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Oct 2008 00:39:41 -0400
In-Reply-To: <20081028190257.a0d5a6d8.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kim Phillips <kim.phillips@freescale.com> wrote:
> On Thu, 23 Oct 2008 16:12:22 -0700
> "Barry G" <mr.scada@gmail.com> wrote:
> 
>> Also, is it correct that Talitos only accelerates AEAD connections, not ESP/AH
>> protocols so there will be no performance increase for me until Strongswan
>> adds rfc5282 support?

No, AEAD is just a frame-work under which all existing algorithms
and new combined-mode algorithms are now used by IPsec.  FWIW, the
fact that talitos has broken your IPsec shows you that it is being
used :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
