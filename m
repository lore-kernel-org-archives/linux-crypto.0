From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Fri, 24 Mar 2017 20:01:48 +0300
Message-ID: <20170324170148.ew7ozpt5jfwdx5yn@kozik-lap>
References: <20170324142446.31129-1-krzk@kernel.org>
 <9265537.P6AeF50kg8@amdc3058>
 <20170324161934.kc6g36nazr3y32kp@kozik-lap>
 <CGME20170324164544epcas1p353b2eba5ecb6d5f7a69049c5ba9d667e@epcas1p3.samsung.com>
 <87677624.EBdhaJY1KM@amdc3058>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-samsung-soc@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
 Javier Martinez Canillas <javier@osg.samsung.com>,
 Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
 Matt Mackall <mpm@selenic.com>, Olof Johansson <olof@lixom.net>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org,
 Marek Szyprowski <m.szyprowski@samsung.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <87677624.EBdhaJY1KM@amdc3058>
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

On Fri, Mar 24, 2017 at 05:45:41PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > > And I think the probe might be called twice, for example in case of
> > > > mistake in DTB.
> > > 
> > > Even if this is possible resource allocation code in the driver will
> > > take take care of handling it just fine,
> > 
> > Indeed, the devm_ioremap_resource() solves the case. I can drop the
> > check then.
> 
> Looking on this a bit more it seems that devm_ioremap_resource() will
> not cover all mistakes (using compatible by mistake in some other DTB
> node).
> 
> Leave the check, I take my objection back.

Great! Thanks for feedback.

Best regards,
Krzysztof
