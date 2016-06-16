From: Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [PATCH 2/7] crypto: marvell: Check engine is not already running
 when enabling a req
Date: Thu, 16 Jun 2016 10:18:45 +0200
Message-ID: <576260E5.2000402@free-electrons.com>
References: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
 <1466018134-10779-3-git-send-email-romain.perier@free-electrons.com>
 <20160615213709.3a060ff4@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:38098 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751246AbcFPIS6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jun 2016 04:18:58 -0400
In-Reply-To: <20160615213709.3a060ff4@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

Le 15/06/2016 21:37, Boris Brezillon a =E9crit :
>
> "
> Add a BUG_ON() call when the driver tries to launch a crypto request
> while the engine is still processing the previous one. This replaces
> a silent system hang by a verbose kernel panic with the associated
> backtrace to let the user know that something went wrong in the CESA
> driver.
> "

thanks

>
>> ---
>>   drivers/crypto/marvell/cipher.c | 2 ++
>>   drivers/crypto/marvell/hash.c   | 2 ++
>>   drivers/crypto/marvell/tdma.c   | 2 ++
>>   3 files changed, 6 insertions(+)
>>
>> diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvel=
l/cipher.c
>> index dcf1fce..8d0fabb 100644
>> --- a/drivers/crypto/marvell/cipher.c
>> +++ b/drivers/crypto/marvell/cipher.c
>> @@ -106,6 +106,8 @@ static void mv_cesa_ablkcipher_std_step(struct a=
blkcipher_request *req)
>>
>>   	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
>>   	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
>> +	BUG_ON(readl(engine->regs + CESA_SA_CMD)
>> +				  & CESA_SA_CMD_EN_CESA_SA_ACCL0);
>
> Nit: please put the '&' operator at the end of the first line and
> align CESA_SA_CMD_EN_CESA_SA_ACCL0 on the open parenthesis.

Arf, ok I will fix this.

>
> 	BUG_ON(readl(engine->regs + CESA_SA_CMD) &
> 	       CESA_SA_CMD_EN_CESA_SA_ACCL0);
>
>>   	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
>>   }
>>
>> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/=
hash.c
>> index 7ca2e0f..0fae351 100644
>> --- a/drivers/crypto/marvell/hash.c
>> +++ b/drivers/crypto/marvell/hash.c
>> @@ -237,6 +237,8 @@ static void mv_cesa_ahash_std_step(struct ahash_=
request *req)
>>
>>   	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
>>   	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
>> +	BUG_ON(readl(engine->regs + CESA_SA_CMD)
>> +				  & CESA_SA_CMD_EN_CESA_SA_ACCL0);
>
> Ditto.

ack

>
>>   	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
>>   }
>>
>> diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/=
tdma.c
>> index 7642798..d493714 100644
>> --- a/drivers/crypto/marvell/tdma.c
>> +++ b/drivers/crypto/marvell/tdma.c
>> @@ -53,6 +53,8 @@ void mv_cesa_dma_step(struct mv_cesa_tdma_req *dre=
q)
>>   		       engine->regs + CESA_SA_CFG);
>>   	writel_relaxed(dreq->chain.first->cur_dma,
>>   		       engine->regs + CESA_TDMA_NEXT_ADDR);
>> +	BUG_ON(readl(engine->regs + CESA_SA_CMD)
>> +				  & CESA_SA_CMD_EN_CESA_SA_ACCL0);
>
> Ditto.
ack

Regards,
Romain
--=20
Romain Perier, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
