From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Fri, 24 Mar 2017 19:19:34 +0300
Message-ID: <20170324161934.kc6g36nazr3y32kp@kozik-lap>
References: <20170324142446.31129-1-krzk@kernel.org>
 <3940941.n3qdgn1RbN@amdc3058>
 <20170324154600.lavc22dbw7rtioli@kozik-lap>
 <CGME20170324161128epcas1p4b9ef08e3d7e640957d30afa84aa66a16@epcas1p4.samsung.com>
 <9265537.P6AeF50kg8@amdc3058>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-crypto@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9265537.P6AeF50kg8@amdc3058>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 24, 2017 at 05:11:25PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Friday, March 24, 2017 06:46:00 PM Krzysztof Kozlowski wrote:
> > I really do not like global or file-scope variables. I do not like
> > drivers using them. Actually I hate them.
> > 
> > From time to time I encounter a driver which was designed with that
> > approach - static fields and hidden assumption that there will be only
> > one instance. Usually that assumption is really hidden...
> > 
> > ... and then it happens that I want to use two instances which of course
> > fails.
> > 
> > This code serves as a clear documentation for this assumption - only one
> > instance is allowed. You can look at it as a self-documenting
> > requirement.
> 
> For me it looks as needless case of defensive programming and when
> I see the code like this it always raises questions about the real
> intentions of the code. I find it puzzling and not helpful.

I do not understand what might be puzzling about check for static
file-scope value. It is of course subjective, but for me that looks
pretty self-explanatory.

> 
> > And I think the probe might be called twice, for example in case of
> > mistake in DTB.
> 
> Even if this is possible resource allocation code in the driver will
> take take care of handling it just fine,

Indeed, the devm_ioremap_resource() solves the case. I can drop the
check then.

Best regards,
Krzysztof
