From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH v2 2/2] hwrng: msm - Add support for prng v2
Date: Thu, 21 Jun 2018 18:22:06 -0700
Message-ID: <152963052624.16708.17133633012075809772@swboyd.mtv.corp.google.com>
References: <20180619095430.26358-1-vkoul@kernel.org>
 <20180619095430.26358-3-vkoul@kernel.org>
 <152947431955.16708.15247307054260887941@swboyd.mtv.corp.google.com>
 <20180620133725.GB27187@vkoul-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
To: Vinod <vkoul@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620133725.GB27187@vkoul-mobl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Quoting Vinod (2018-06-20 06:37:25)
> On 19-06-18, 22:58, Stephen Boyd wrote:
> > Quoting Vinod Koul (2018-06-19 02:54:30)
> > > Qcom 8996 and later chips support prng v2 which requires to
> > > implement only .read callback for hwrng.
> > > =

> > > This version of chip has multiple Execution Environments (EE) and
> > > secure world is typically responsible for configuring the prng.
> > =

> > Sometimes secure world is not configuring the rng though. I prefer we
> > have a DT flag for this to indicate if secure world has configured it or
> > not and then skip the init logic when the bool property is present in
> > DT. Then the DT property can be set on firmwares that are making things
> > blow up when we try to read the 'configured' register. I'd also file a
> > bug to qcom to tell them to unlock that config register for reads so
> > that things can work simpler, but who knows how that will work out.
> =

> I dont feel that would be required. See below..
> =

> > It really sounds like the hardware isn't actually different, just the
> > firmware has decided to be more strict about making reads fail now.
> =

> So in this case base hw block seems similar but consists of multiple
> Execution Environment (EEs) and all of these contain only data
> registers. Only secure environment has configuration. Each one has its
> own register space.
> =

> In a case where we dont have secure world, we can point to secure
> environment with v1 ops, so driver shall configure and run.

Are you saying that there are multiple "frames" that each EE can read
from? And then only one of those frames is the "real" one that can also
configure the hardware to actually give us random data?

That sounds like it would work, but then the compatible string should
probably be more like qcom,prng-ee-frame or something like that to
indicate that this is a window into the real hardware, instead of
tacking on a -v2 and making everyone think it's new hardware.
