From: Zain <zain.wang@rock-chips.com>
Subject: Re: [RESEND PATCH 4/4] crypto: rk_crypto - add DT bindings
 documentation
Date: Tue, 3 Nov 2015 08:29:42 +0800
Message-ID: <5637FFF6.20202@rock-chips.com>
References: <1446193369-4453-1-git-send-email-zain.wang@rock-chips.com>
 <1446193369-4453-5-git-send-email-zain.wang@rock-chips.com>
 <20151030140334.GB31073@leverpostej> <56372942.2080900@rock-chips.com>
 <CAL_JsqLj6m2Df+LW4F++hEgxYkyqPDbeMVv8QrF7-eVCZJfj6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mark Rutland <mark.rutland@arm.com>, zhengsq@rock-chips.com,
	hl@rock-chips.com, Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	Michael Turquette <mturquette@baylibre.com>,
	=?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	"open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	eddie.cai@rock-chips.com
To: Rob Herring <robh+dt@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.134]:41475 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbbKCA3u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Nov 2015 19:29:50 -0500
In-Reply-To: <CAL_JsqLj6m2Df+LW4F++hEgxYkyqPDbeMVv8QrF7-eVCZJfj6w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Mark,

On 2015=E5=B9=B411=E6=9C=8802=E6=97=A5 23:39, Rob Herring wrote:
> On Mon, Nov 2, 2015 at 3:13 AM, Zain <zain.wang@rock-chips.com> wrote=
:
>> Hi Mark
>>
>> On 2015=E5=B9=B410=E6=9C=8830=E6=97=A5 22:03, Mark Rutland wrote:
>>> On Fri, Oct 30, 2015 at 04:22:49PM +0800, Zain Wang wrote:
>>>> Add DT bindings documentation for the rk3288 crypto drivers.
>>>>
>>>> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
>>>> ---
>>>> +Required properties:
>>>> +- compatible: should be "rockchip,crypto"
>>> Choose a more specific name. Rockchip could easily come up with ano=
ther
>>> crypto accelerator later.
>> ok! done.
>> rk3288_crypto may be better than crypto.
> Yes, but use '-' not '_'.
ok! done!
>
> Rob
>
>
>
Thanks
Zain
