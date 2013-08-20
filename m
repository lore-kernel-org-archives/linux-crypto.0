From: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Subject: Re: [patch] crypto: tegra-aes - bitwise vs logical and
Date: Tue, 20 Aug 2013 10:31:41 -0600
Message-ID: <521399ED.9030701@wwwdotorg.org>
References: <20130820085447.GA20170@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Rob Herring <rob.herring-bsGFqQB8/DxBDgjK7y7TUQ@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130820085447.GA20170-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 08/20/2013 02:54 AM, Dan Carpenter wrote:
> The bug here is that:
> 
> 	while (eng_busy & (!icq_empty) & dma_busy)
> 
> is never true because it's using bitwise instead of logical ANDs.  The
> other bitwise AND conditions work as intended but I changed them as well
> for consistency.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> Static checker stuff.  I don't have the hardware.

Varun, can you please test the driver with this change applied and make
sure it works correctly.

If you could also update our internal testing wiki with the steps you
use for this testing, that'd be great too.

Thanks.
