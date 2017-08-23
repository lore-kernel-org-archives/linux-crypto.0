From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v2] dt/bindings: exynos-rng: Move dt binding
 documentation to bindings/crypto
Date: Wed, 23 Aug 2017 18:54:58 +0200
Message-ID: <20170823165458.qcoes376ydeavqt6@kozik-lap>
References: <20170823150443.8399-1-prasannatsmkumar@gmail.com>
 <20170823161204.5cleer2rpgjd5vmz@kozik-lap>
 <CANc+2y4BfdAZhgfrP6NorqTPWBYsLsHKAvoeMMa=QUgB_d4Xdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: mchehab@kernel.org, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANc+2y4BfdAZhgfrP6NorqTPWBYsLsHKAvoeMMa=QUgB_d4Xdg@mail.gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 23, 2017 at 10:14:29PM +0530, PrasannaKumar Muralidharan wrote:
> Hi Krzysztof,
> 
> On 23 August 2017 at 21:42, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > On Wed, Aug 23, 2017 at 08:34:43PM +0530, PrasannaKumar Muralidharan wrote:
> >> Samsung exynos PRNG driver is using crypto framework instead of
> >> hw_random framework. So move the devicetree binding to crypto folder.
> >>
> >> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> >> ---
> >> Changes in v2:
> >> * Modify MAINTAINERS file to reflect file rename
> >>
> >>  .../devicetree/bindings/{rng => crypto}/samsung,exynos-rng4.txt         | 0
> >>  MAINTAINERS                                                             | 2 +-
> >>  2 files changed, 1 insertion(+), 1 deletion(-)
> >>  rename Documentation/devicetree/bindings/{rng => crypto}/samsung,exynos-rng4.txt (100%)
> >>
> >
> > Patch is okay but CC list is still incomplete. I do not know how you
> > could get Mauro for this patch... just use get_maintainers.pl.
> 
> I used get_maintainer.pl. Rechecked again, it says Mauro and couple of
> others who may not be interested in this. It did not give your or
> crypto mailing list. Its strange.

Hm, you're right. Aparently get_maintainer.pl does handle moved files
thus he printed only entries for MAINTAINERS.

You will get full entry with:
scripts/get_maintainer.pl -f Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt

Krzysztof Kozlowski <krzk@kernel.org> (maintainer:SAMSUNG EXYNOS PSEUDO RANDOM NUMBER GENERATOR (...)
Herbert Xu <herbert@gondor.apana.org.au> (maintainer:CRYPTO API)
"David S. Miller" <davem@davemloft.net> (maintainer:CRYPTO API)
Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
Mark Rutland <mark.rutland@arm.com> (maintainer:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
Kukjin Kim <kgene@kernel.org> (maintainer:ARM/SAMSUNG EXYNOS ARM ARCHITECTURES)
linux-crypto@vger.kernel.org (open list:SAMSUNG EXYNOS PSEUDO RANDOM NUMBER GENERATOR (...)
linux-samsung-soc@vger.kernel.org (open list:SAMSUNG EXYNOS PSEUDO RANDOM NUMBER GENERATOR (...)
devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
linux-arm-kernel@lists.infradead.org (moderated list:ARM/SAMSUNG EXYNOS ARM ARCHITECTURES)
linux-kernel@vger.kernel.org (open list)

Best regards,
Krzysztof
