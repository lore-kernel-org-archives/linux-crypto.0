From: Maurus Cuelenaere <mcuelenaere@gmail.com>
Subject: Re: [RFC 9/9] crypto: Add Samsung crypto engine driver
Date: Sun, 27 Jun 2010 13:06:03 +0200
Message-ID: <4C27309B.7010905@gmail.com>
References: <cover.1276284559.git.mcuelenaere@gmail.com>	<4C129341.2060407@gmail.com> <20100626.210728.90806559.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: David Miller <davem@davemloft.net>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <20100626.210728.90806559.davem@davemloft.net>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

 Op 27-06-10 06:07, David Miller schreef:
> From: Maurus Cuelenaere <mcuelenaere@gmail.com>
> Date: Fri, 11 Jun 2010 21:49:21 +0200
>
>> This patch adds support for the Samsung crypto engine driver available in the
>> S3C64XX and S5PC100 SoCs. Currently this supports AES and (T)DES with ECB and
>> CBC block ciphers (also CTR for AES). Support for (HMAC)-SHA1 acceleration is
>> also available in this engine, but isn't used in the driver yet.
>>
>> Support for DMA has been added in the code but is currently disabled due to
>> issues with data transfers.
>>
>> Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
> I would personally queue up new crypto requests directly when there are
> no queued up requests and ->cur_req is NULL, instead of doing all of
> that work to do the submission in the tasklet.  I would also do the
> completion and queue running directly in the hw IRQ handler.
>
> The tasklet is just pure overhead.
>
> Basically, when doing async crypto, every cycle that is consumed just
> to implement crypto job submission and completion takes away from the
> gains you get by doing it in hw at all.
>
> You can see this clearly if you do performance comparisons between the
> synchronous crypto routines and your async ones done in HW.

I'll rewrite it like you're suggesting.
I'd go with a threaded interrupt handler in that case then, or do you also consider this as too much overhead?

I'll do some performance comparisons of threaded interrupt handler vs normal and go with the fastest.

Thanks for the review!

--
Maurus Cuelenaere
