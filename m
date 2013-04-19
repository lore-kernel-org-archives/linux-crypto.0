From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/9 v2] crypto: ux500/hash - Prepare clock before enabling it
Date: Fri, 19 Apr 2013 14:26:37 +0200
Message-ID: <201304191426.37408.arnd@arndb.de>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org> <1366280825-31136-2-git-send-email-lee.jones@linaro.org> <20130419122428.GC3432@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linus.walleij@stericsson.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Westin <andreas.westin@stericsson.com>,
	linux-crypto@vger.kernel.org
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130419122428.GC3432@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Friday 19 April 2013, Lee Jones wrote:
> Slight change of plan for v2.
> 
> Now we're doing a seperate clk_prepare(), as the clk_enable() in the
> previous patch turned out to be called inside a spin_lock().
> 
> Arnd, can you confirm your Ack please?
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
