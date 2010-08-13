From: Maurus Cuelenaere <mcuelenaere@gmail.com>
Subject: Re: [RFC 9/9] crypto: Add Samsung crypto engine driver
Date: Fri, 13 Aug 2010 13:17:53 +0200
Message-ID: <4C6529E1.8020300@gmail.com>
References: <4C129341.2060407@gmail.com>	<AANLkTi=FKAdC9AwPR41MUBUjBZ2Zf1qv1DSQ+EnMHu7d@mail.gmail.com>	<4C63DF4C.1020501@gmail.com> <20100812.153208.48514514.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kmpark@infradead.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35646 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab0HMLSA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Aug 2010 07:18:00 -0400
In-Reply-To: <20100812.153208.48514514.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 Op 13-08-10 00:32, David Miller schreef:
> From: Maurus Cuelenaere <mcuelenaere@gmail.com>
> Date: Thu, 12 Aug 2010 13:47:24 +0200
>
>> The main issues still remain (DMA not working at all and FIFO not
>> working for some (T)DES transfers). Additionally, I couldn't get
>> tcrypt to test the s3c-sss driver for some reason, it always picked
>> the standard AES/TDES/DES driver (even though s3c-sss has a higher
>> priority and succeeded the self-test).
> I forget the details of your driver, but were your encryption algorithms
> implemented async?

Yes, all are async (also the not-yet-working hash algorithms).

> tcrypt can validate async crypto algorithms, but cannot performance
> test them just yet.  I can performance test async hash algorithms,
> for which I added the code for a few months ago.
Hmm ok, I suppose implementing support for performance testing async crypto
algorithms isn't trivial?

-- 
Maurus Cuelenaere
