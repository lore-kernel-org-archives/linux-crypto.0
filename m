From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Tue, 17 Apr 2007 23:42:01 +1000
Message-ID: <E1HdnwX-0005U1-00@gondolin.me.apana.org.au>
References: <20070417130431.GA8685@2ka.mipt.ru>
Cc: francis.moro@gmail.com, herbert@gondor.apana.org.au,
	helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: johnpol@2ka.mipt.ru (Evgeniy Polyakov)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1268 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754328AbXDQNmH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Apr 2007 09:42:07 -0400
In-Reply-To: <20070417130431.GA8685@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
>
>> OK, I tried to cook up something very simple. Since I don't know this
>> code, please be indulgent when reading the following patch ;)
> 
> Which means that after one has loaded ecryptfs module it can not use
> ipsec and dm-crypt if there is only one crypto algo registered...

Yep.  We don't need such a flag anyway.  All we need is a way to tweak
the priority and Bob's your uncle.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
