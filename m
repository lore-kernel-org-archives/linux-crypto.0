From: Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH V4 2/2] ARM: dts: imx7s: add snvs rtc clock
Date: Thu, 22 Feb 2018 13:19:41 +0800
Message-ID: <20180222051939.GH3217@dragon>
References: <1515491526-14060-1-git-send-email-Anson.Huang@nxp.com>
 <1515491526-14060-2-git-send-email-Anson.Huang@nxp.com>
 <20180202034457.GF20833@dragon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, aymen.sghaier@nxp.com,
 herbert@gondor.apana.org.au, horia.geanta@nxp.com, davem@davemloft.net,
 mturquette@baylibre.com, sboyd@codeaurora.org, linux-kernel@vger.kernel.org,
 stefan@agner.ch, linux@armlinux.org.uk, fabio.estevam@nxp.com,
 robh+dt@kernel.org, linux-crypto@vger.kernel.org, kernel@pengutronix.de,
 adriana.reus@nxp.com, linux-clk@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, dongas86@gmail.com
To: Anson Huang <Anson.Huang@nxp.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180202034457.GF20833@dragon>
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

On Fri, Feb 02, 2018 at 11:44:59AM +0800, Shawn Guo wrote:
> On Tue, Jan 09, 2018 at 05:52:06PM +0800, Anson Huang wrote:
> > Add i.MX7 SNVS RTC clock.
> > 
> > Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
> 
> Looks fine to me.  Ping me when clk driver part lands mainline.

I'm collecting i.MX clock patches and later will send them to clk
maintainers in form of pull request.  So applied both.

Shawn
