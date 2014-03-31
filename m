From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: Does talitos driver support mpc8272 ?
Date: Mon, 31 Mar 2014 17:50:11 -0500
Message-ID: <20140331175011.a199ed5e6d06067ac06b034e@freescale.com>
References: <CAKwbz4wM3U3AW7LewUEOurSwRAt99h-Z6jeZKQhJ+UK_amE0cg@mail.gmail.com>
	<CAKwbz4zGyd7xAYEVKRnbZLzF+eQjF-AYf1PCk-FoUaywJaRaUQ@mail.gmail.com>
	<CAKwbz4yoMH3WVuoLBy09YwmSsqgjATNaUnbtRt25ZDQhm98xmA@mail.gmail.com>
	<CAKwbz4ztGYPkwU5DGKKz3UTFuwDwsPatdT7fJaYiWR7Fqg+TbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: christophe leroy <chleroy2@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:32112 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbaCaWzM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 31 Mar 2014 18:55:12 -0400
In-Reply-To: <CAKwbz4ztGYPkwU5DGKKz3UTFuwDwsPatdT7fJaYiWR7Fqg+TbQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 29 Mar 2014 17:07:43 +0000
christophe leroy <chleroy2@gmail.com> wrote:

> Hi
> Does the talitos driver support mpc 8272 or does any other driver do ?

none upstream that I know of.

> i see that CONFIG_CRYPTO_DEV_TALITOS is not set in mpc8272ads config, and
> mpc8272ads dts does includeba compatible for fsl,sec1.0 while talitos
> driver match is fsl,sec2.0

my (dated) understanding was that talitos would need to be ported to
the SEC1, that e.g., uses a different ring buffer mechanism vs.
SEC2's Fetch FIFOs.

drivers/crypto/mxs-dcp.c and esp. the later drivers/crypto/sahara.c
share some bits; although since they're in i.MX parts, it's likely
the number of differences from a networking part like the 8272 is
higher than that of talitos.

Kim
