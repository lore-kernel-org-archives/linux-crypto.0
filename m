From: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 1/3] clk: samsung: exynos4: Add SSS gate clock
Date: Mon, 19 Oct 2015 12:59:46 -0700
Message-ID: <20151019195946.GH10182@codeaurora.org>
References: <1445230834-32689-1-git-send-email-k.kozlowski@samsung.com>
 <1445230834-32689-2-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Return-path: <linux-clk-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445230834-32689-2-git-send-email-k.kozlowski@samsung.com>
Sender: linux-clk-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/19, Krzysztof Kozlowski wrote:
> Add a gate clock for controlling all clocks of Security Sub System
> (SSS).
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---

The To: list is huge, so I have no idea if you want me to apply
this patch or not, and given that it's part of a series that has
dts changes I guess that means it should go through arm-soc:

Acked-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
