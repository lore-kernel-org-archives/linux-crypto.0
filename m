From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Testing the geode-aes driver with the tcrypt module completely freezes the machine
Date: Thu, 03 May 2007 23:49:35 +1000
Message-ID: <E1Hjbgd-000086-00@gondolin.me.apana.org.au>
References: <20070503132310.GA21082@2ka.mipt.ru>
Cc: mschiller@tdt.de, linux-crypto@vger.kernel.org,
	jordan.crouse@amd.com
To: johnpol@2ka.mipt.ru (Evgeniy Polyakov)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4391 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161899AbXECNt6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 May 2007 09:49:58 -0400
In-Reply-To: <20070503132310.GA21082@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> Hm, driver does not perform encryption in-place at all.
> Since we did not hear from AMD quite for a while, could you please
> remove src==dst check in geode_aes_crypt() and run tests again.
> If it is software protection against hardware bug, I doubt such hardware
> should be used at all...

I agree.  Jordan, could you please see if this can be fixed up?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
