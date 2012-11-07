From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 1/5] ARM: AT91SAM9G45: fix crypto peripherals irq issue
 due to sparse irq support.
Date: Wed, 7 Nov 2012 16:27:29 +0100
Message-ID: <20121107152729.GE4576@game.jcrosoft.org>
References: <1352219463-30360-1-git-send-email-nicolas@eukrea.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, eric@eukrea.com
To: Nicolas Royer <nicolas@eukrea.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1352219463-30360-1-git-send-email-nicolas@eukrea.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 17:31 Tue 06 Nov     , Nicolas Royer wrote:
> Spare irq support introduced by commit "8fe82a5 ARM: at91: sparse irq=
 support"
> involves to add the NR_IRQS_LEGACY offset to irq number.
>=20
> Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Eric B=E9nard <eric@eukrea.com>
> Tested-by: Eric B=E9nard <eric@eukrea.com>
> Cc: stable@vger.kernel.org # 3.6

ok will see if we can have it for 3.7

Best Regards,
J.
