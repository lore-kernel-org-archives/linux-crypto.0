From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 0/3] crypto: marvell - Remove the old CESA driver
Date: Wed, 11 Oct 2017 13:56:24 +0000
Message-ID: <20171011135624.GL31762@io.lakedaemon.net>
References: <20171011131619.30196-1-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
 Andrew Lunn <andrew@lunn.ch>, Herbert Xu <herbert@gondor.apana.org.au>,
 Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@kernel.org>,
 Arnaud Ebalard <arno@natisbad.org>, Russell King <linux@armlinux.org.uk>,
 Gregory CLEMENT <gregory.clement@free-electrons.com>,
 linux-crypto@vger.kernel.org, Olof Johansson <olof@lixom.net>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org,
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20171011131619.30196-1-boris.brezillon@free-electrons.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Hey Boris,

On Wed, Oct 11, 2017 at 03:16:16PM +0200, Boris Brezillon wrote:
> Hello,
> 
> It's been several releases since we added a new driver to support the
> CESA IP (the new driver was introduced in 4.2). It seems most major
> bugs have been discovered and fixed and now is probably a good time to
> kill the old driver and force remaining users to switch to the new one.
> 
> This series first add a platform_device_id table to the marvell CESA
> driver so that it can work on non-DT platforms. Then we patch all
> defconfigs to select the new driver instead of the old. And finally we
> remove the old driver.
> These patches have to be applied in this order to make things
> bisectable, so, if this series is accepted it will have to go through
> a single tree (either ARM or crypto).

Thanks for keeping this on your radar.  As I was the one who originally
requested this transitioning time,

Acked-by: Jason Cooper <jason@lakedaemon.net>

For the series.

thx,

Jason.
