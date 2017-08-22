From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: rockchip: Don't dequeue the request when device
 is busy
Date: Tue, 22 Aug 2017 15:58:44 +0800
Message-ID: <20170822075844.GI6269@gondor.apana.org.au>
References: <1502783295-25621-1-git-send-email-wzz@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Heiko Stuebner <heiko@sntech.de>, jekarlson@gmail.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
To: zain wang <wzz@rock-chips.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1502783295-25621-1-git-send-email-wzz@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 15, 2017 at 03:48:15PM +0800, zain wang wrote:
> The device can only process one request at a time. So if multiple
> requests came at the same time, we can enqueue them first, and
> dequeue them one by one when the device is idle.
> 
> Signed-off-by: zain wang <wzz@rock-chips.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
