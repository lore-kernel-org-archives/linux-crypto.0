From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH 1/1] Crypto: [xp ]cbc: use 64bit regs on 64bit machines
Date: Thu, 14 Jun 2007 13:47:19 +0200
Message-ID: <20070614114719.GA7112@Chamillionaire.breakpoint.cc>
References: <20070613222006.GA4585@Chamillionaire.breakpoint.cc> <20070614105744.GB24814@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35956 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952AbXFNLrW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Jun 2007 07:47:22 -0400
Received: id: bigeasy by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1HynnL-0001sU-HJ
	for linux-crypto@vger.kernel.org; Thu, 14 Jun 2007 13:47:19 +0200
Content-Disposition: inline
In-Reply-To: <20070614105744.GB24814@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Evgeniy Polyakov | 2007-06-14 14:57:45 [+0400]:

>On Thu, Jun 14, 2007 at 12:20:06AM +0200, Sebastian Siewior (linux-crypto@ml.breakpoint.cc) wrote:
>>  static void xor_64(u8 *a, const u8 *b, unsigned int bs)
>>  {
>> +#if BITS_PER_LONG == 64
>> +	((u64 *)a)[0] ^= ((u64 *)b)[0];
>> +#else
>>  	((u32 *)a)[0] ^= ((u32 *)b)[0];
>>  	((u32 *)a)[1] ^= ((u32 *)b)[1];
>> +#endif
>>  }
>
>What about endianess?

It doesn't effect the xor operation. Either I load both LE, xor, store
LE or load both BE, xor, store BE. The result is always the same. An
additional endian convert would make thinks just slower.
Since you confused me a little, I tested it on ppc and amd64 :)

>
>-- 
>	Evgeniy Polyakov

Sebastian
