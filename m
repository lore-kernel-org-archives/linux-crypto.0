From: Javier Martinez Canillas <javier@dowhile0.org>
Subject: Re: [PATCH v7 00/14] crypto: add a new driver for Marvell's CESA
Date: Thu, 25 Jun 2015 02:33:43 +0200
Message-ID: <CABxcv=m4juAMHaMYSB+8O8cEX+YZCJ0cArS2wN-YGpTBgWe-CA@mail.gmail.com>
References: <1434635190-27733-1-git-send-email-boris.brezillon@free-electrons.com>
 <20150619142444.GA15234@gondor.apana.org.au>
 <CAP=VYLqQynCNRTpm4JnOxeO6DH_739fO2QNcDMxaXqCKCHiTtQ@mail.gmail.com>
 <CAP=VYLpSrTvXRovWo4G7AXWv1OKFQRpQR255hS5z+=h4+XOLhg@mail.gmail.com>
 <20150621102418.2ea74910@bbrezillon>
 <20150621082717.GA29128@gondor.apana.org.au>
 <20150622092336.5949e258@bbrezillon>
 <20150622075910.GA7659@gondor.apana.org.au>
 <20150625000037.GK31584@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
 Nadav Haklai <nadavh@marvell.com>, Mark Rutland <mark.rutland@arm.com>,
 Boris Brezillon <boris.brezillon@free-electrons.com>,
 Russell King - ARM Linux <linux@arm.linux.org.uk>,
 Herbert Xu <herbert@gondor.apana.org.au>, Tawfik Bayouk <tawfik@marvell.com>,
 Eran Ben-Avi <benavi@marvell.com>,
 Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
 "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
 Ian Campbell <ijc+devicetree@hellion.org.uk>,
 Arnaud Ebalard <arno@natisbad.org>, Rob Herring <robh+dt@kernel.org>,
 Gregory CLEMENT <gregory.clement@free-electrons.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20150625000037.GK31584@windriver.com>
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

Hello Paul,

On Thu, Jun 25, 2015 at 2:00 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> [Re: [PATCH v7 00/14] crypto: add a new driver for Marvell's CESA] On 22/06/2015 (Mon 15:59) Herbert Xu wrote:
>
>> On Mon, Jun 22, 2015 at 09:23:36AM +0200, Boris Brezillon wrote:
>> > Hi Herbert,
>> >
>> > On Sun, 21 Jun 2015 16:27:17 +0800
>> > Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> >
>> > > On Sun, Jun 21, 2015 at 10:24:18AM +0200, Boris Brezillon wrote:
>> > > >
>> > > > Indeed. Here is a patch fixing that.
>> > >
>> > > I think you should just kill COMPILE_TEST instead of adding ARM.
>> >
>> > The following patch is killing the COMPILE_TEST dependency.
>>
>> Patch applied.
>
> Just a heads up, this driver is still killing a couple of linux-next
> builds today and for the past few days.
>
> drivers/crypto/mv_cesa.c:1037:2: error: implicit declaration of function
> 'of_get_named_gen_pool' [-Werror=implicit-function-declaration]
>
> http://kisskb.ellerman.id.au/kisskb/buildresult/12448851/
> http://kisskb.ellerman.id.au/kisskb/buildresult/12448776/
>
> Missing dependency on CONFIG_OF_<blah> presumably.
>

I haven't looked at the series but <linux/genalloc.h> has a stub
of_get_named_gen_pool() function if CONFIG_OF is not enabled [0].

So it seems that the problem is rather that the header is not being
included in some file.

> Paul.
> --
>

Best regards,
Javier

[0]: http://lxr.free-electrons.com/source/include/linux/genalloc.h#L131
