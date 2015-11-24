From: Zain <zain.wang@rock-chips.com>
Subject: Re: [PATCH v4 2/4] clk: rockchip: set an ID for crypto clk
Date: Tue, 24 Nov 2015 08:49:39 +0800
Message-ID: <5653B423.5000406@rock-chips.com>
References: <1447732847-30514-1-git-send-email-zain.wang@rock-chips.com>
 <1447732847-30514-3-git-send-email-zain.wang@rock-chips.com>
 <3324035.fFJ7jKO18L@diego>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	eddie.cai@rock-chips.com, linux-crypto@vger.kernel.org
To: =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>,
	linux-rockchip@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.138]:53500 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbbKXAto (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Nov 2015 19:49:44 -0500
In-Reply-To: <3324035.fFJ7jKO18L@diego>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 2015=E5=B9=B411=E6=9C=8824=E6=97=A5 07:24, Heiko St=C3=BCbner wrote:
> Hi Zain,
>
> Am Dienstag, 17. November 2015, 12:00:45 schrieb Zain Wang:
>> Set an ID for crypto clk, so that it can be called in other part.
>>
>> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
>> Acked-by: Michael Turquette <mturquette@baylibre.com>
>> Tested-by: Heiko Stuebner <heiko@sntech.de>
> I've split this into the header and clk-rk3288.c changes and applied =
it to my=20
> clk-ids and clock branch for 4.5
Thanks for your responding.

Thanks
Zain
>
> Thanks
> Heiko
>
>
>
