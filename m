From: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 1/5] ARM: AT91SAM9G45: fix crypto peripherals irq issue
 due to sparse irq support.
Date: Fri, 16 Nov 2012 11:33:51 +0100
Message-ID: <50A6168F.90105@atmel.com>
References: <1352219463-30360-1-git-send-email-nicolas@eukrea.com> <20121107152729.GE4576@game.jcrosoft.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
To: Nicolas Royer <nicolas@eukrea.com>, <eric@eukrea.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121107152729.GE4576@game.jcrosoft.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 11/07/2012 04:27 PM, Jean-Christophe PLAGNIOL-VILLARD :
> On 17:31 Tue 06 Nov     , Nicolas Royer wrote:
>> Spare irq support introduced by commit "8fe82a5 ARM: at91: sparse ir=
q support"
>> involves to add the NR_IRQS_LEGACY offset to irq number.
>>
>> Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Acked-by: Eric B=E9nard <eric@eukrea.com>
>> Tested-by: Eric B=E9nard <eric@eukrea.com>
>> Cc: stable@vger.kernel.org # 3.6
>=20
> ok will see if we can have it for 3.7

Queued in our at91-fixes pull request for 3.7-final.

Thanks a lot, best regards,
--=20
Nicolas Ferre
