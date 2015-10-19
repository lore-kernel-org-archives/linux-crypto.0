From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH 1/3] clk: samsung: exynos4: Add SSS gate clock
Date: Tue, 20 Oct 2015 08:51:31 +0900
Message-ID: <56258203.8030500@samsung.com>
References: <1445230834-32689-1-git-send-email-k.kozlowski@samsung.com>
 <1445230834-32689-2-git-send-email-k.kozlowski@samsung.com>
 <20151019195946.GH10182@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Kukjin Kim <kgene@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	Michael Turquette <mturquette@baylibre.com>,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	Heiner Kallweit <hkallweit1@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:28421 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbbJSXvp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Oct 2015 19:51:45 -0400
In-reply-to: <20151019195946.GH10182@codeaurora.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 20.10.2015 04:59, Stephen Boyd wrote:
> On 10/19, Krzysztof Kozlowski wrote:
>> Add a gate clock for controlling all clocks of Security Sub System
>> (SSS).
>>
>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> ---
> 
> The To: list is huge, so I have no idea if you want me to apply
> this patch or not, and given that it's part of a series that has
> dts changes I guess that means it should go through arm-soc:
> 
> Acked-by: Stephen Boyd <sboyd@codeaurora.org>

If you are OK with that I would like to push it through arm-soc. Thanks
for the ack!

Best regards,
Krzysztof
