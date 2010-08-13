From: David Miller <davem@davemloft.net>
Subject: Re: [RFC 9/9] crypto: Add Samsung crypto engine driver
Date: Fri, 13 Aug 2010 14:45:37 -0700 (PDT)
Message-ID: <20100813.144537.102558594.davem@davemloft.net>
References: <4C63DF4C.1020501@gmail.com>
	<20100812.153208.48514514.davem@davemloft.net>
	<4C6529E1.8020300@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kmpark@infradead.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: mcuelenaere@gmail.com
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <4C6529E1.8020300@gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Maurus Cuelenaere <mcuelenaere@gmail.com>
Date: Fri, 13 Aug 2010 13:17:53 +0200

>  Op 13-08-10 00:32, David Miller schreef:
>> From: Maurus Cuelenaere <mcuelenaere@gmail.com>
>> Date: Thu, 12 Aug 2010 13:47:24 +0200
>>
>> tcrypt can validate async crypto algorithms, but cannot performance
>> test them just yet.  I can performance test async hash algorithms,
>> for which I added the code for a few months ago.
> Hmm ok, I suppose implementing support for performance testing async crypto
> algorithms isn't trivial?

It shouldn't be that hard, the issue is simply that nobody has put
the time in to do the work yet.
