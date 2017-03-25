From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v3 0/3] crypto: hw_random - Add new Exynos RNG driver
Date: Sat, 25 Mar 2017 17:32:12 +0100
Message-ID: <11209034.TNQDREpKIz@tauon.atsec.com>
References: <20170325162654.3827-1-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: linux-samsung-soc@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Arnd Bergmann <arnd@arndb.de>,
 Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
 linux-kernel@vger.kernel.org,
 Javier Martinez Canillas <javier@osg.samsung.com>,
 Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
 Matt Mackall <mpm@selenic.com>, Olof Johansson <olof@lixom.net>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170325162654.3827-1-krzk@kernel.org>
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

Am Samstag, 25. M=E4rz 2017, 17:26:51 CET schrieb Krzysztof Kozlowski:

Hi Krzysztof,

> Hi,
> =

> =

> This is a follow up of my questions around exynos-rng [1].
> =

> Changes since v2:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. Do not re-use random numbers for re-seed (neither for system resume
>    nor for periodic re-seed).  Instead the driver will just generate new
>    random numbers (suggested by Stephan M=FCller).

Thank you. Regarding the cryptographic aspects:

Reviewed-by: Stephan M=FCller <smueller@chronox.de>

Ciao
Stephan
