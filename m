From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v3] crypto: AF_ALG - remove locking in async callback
Date: Fri, 24 Nov 2017 17:37:17 +0000
Message-ID: <20171124173717.00000d3f@huawei.com>
References: <CAGkQfmNKbSwue13zPh2K1F_kLkpm1_AhsAHK4spRFA0xMvU5PA@mail.gmail.com>
 <1966139.WIlnTlQG5u@positron.chronox.de>
 <20171124073739.GB15597@gondor.apana.org.au>
 <12422115.UWn9hbrTTi@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Tudor Ambarus <tudor.ambarus@microchip.com>, Cyrille
 Pitchen <cyrille.pitchen@microchip.com>, linux-crypto@vger.kernel.org,
 Romain Izard <romain.izard.pro@gmail.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <12422115.UWn9hbrTTi@tauon.chronox.de>
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

On Fri, 24 Nov 2017 17:04:19 +0100
Stephan Mueller <smueller@chronox.de> wrote:

> Am Freitag, 24. November 2017, 08:37:39 CET schrieb Herbert Xu:
> =

> Hi Herbert,
> =

> > On Fri, Nov 10, 2017 at 01:20:55PM +0100, Stephan M=FCller wrote:  =

> > > The code paths protected by the socket-lock do not use or modify the
> > > socket in a non-atomic fashion. The actions pertaining the socket do =
not
> > > even need to be handled as an atomic operation. Thus, the socket-lock
> > > can be safely ignored.
> > > =

> > > This fixes a bug regarding scheduling in atomic as the callback funct=
ion
> > > may be invoked in interrupt context.
> > > =

> > > In addition, the sock_hold is moved before the AIO encrypt/decrypt
> > > operation to ensure that the socket is always present. This avoids a
> > > tiny race window where the socket is unprotected and yet used by the =
AIO
> > > operation.
> > > =

> > > Finally, the release of resources for a crypto operation is moved int=
o a
> > > common function of af_alg_free_resources.
> > > =

> > > Fixes: e870456d8e7c8 ("crypto: algif_skcipher - overhaul memory
> > > management") Fixes: d887c52d6ae43 ("crypto: algif_aead - overhaul mem=
ory
> > > management") Reported-by: Romain Izard <romain.izard.pro@gmail.com>
> > > Signed-off-by: Stephan Mueller <smueller@chronox.de>  =

> > =

> > Patch applied.  Thanks.  =

> =

> Thanks a lot.
> =

> Would it make sense to feed it to stable?
> =

> Ciao
> Stephan
My view would be definitely.  Ran into this precise issue whilst testing
a new driver 4.14 today...

Jonathan
