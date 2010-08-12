From: Maurus Cuelenaere <mcuelenaere@gmail.com>
Subject: Re: [RFC 9/9] crypto: Add Samsung crypto engine driver
Date: Thu, 12 Aug 2010 13:47:24 +0200
Message-ID: <4C63DF4C.1020501@gmail.com>
References: <cover.1276284559.git.mcuelenaere@gmail.com>	<4C129341.2060407@gmail.com> <AANLkTi=FKAdC9AwPR41MUBUjBZ2Zf1qv1DSQ+EnMHu7d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net
To: Kyungmin Park <kmpark@infradead.org>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=FKAdC9AwPR41MUBUjBZ2Zf1qv1DSQ+EnMHu7d@mail.gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

 Hi,

Op 03-08-10 06:44, Kyungmin Park schreef:
> Hi,
>
> Any update on this?

Sorry for the late reply.

The current (functional) status of the driver doesn't differ much from the original one. I've reworked the crypto request handling code like David suggested and started adding support for (HMAC) SHA-1 acceleration.

The main issues still remain (DMA not working at all and FIFO not working for some (T)DES transfers). Additionally, I couldn't get tcrypt to test the s3c-sss driver for some reason, it always picked the standard AES/TDES/DES driver (even though s3c-sss has a higher priority and succeeded the self-test).

-- 
Maurus Cuelenaere
