From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH v2 2/2] hwrng: msm - Add support for prng v2
Date: Tue, 19 Jun 2018 22:58:39 -0700
Message-ID: <152947431955.16708.15247307054260887941@swboyd.mtv.corp.google.com>
References: <20180619095430.26358-1-vkoul@kernel.org>
 <20180619095430.26358-3-vkoul@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, vinod.koul@linaro.org,
        Vinod Koul <vkoul@kernel.org>
To: Vinod Koul <vinod.koul@linaro.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180619095430.26358-3-vkoul@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Quoting Vinod Koul (2018-06-19 02:54:30)
> Qcom 8996 and later chips support prng v2 which requires to
> implement only .read callback for hwrng.
> =

> This version of chip has multiple Execution Environments (EE) and
> secure world is typically responsible for configuring the prng.

Sometimes secure world is not configuring the rng though. I prefer we
have a DT flag for this to indicate if secure world has configured it or
not and then skip the init logic when the bool property is present in
DT. Then the DT property can be set on firmwares that are making things
blow up when we try to read the 'configured' register. I'd also file a
bug to qcom to tell them to unlock that config register for reads so
that things can work simpler, but who knows how that will work out.

It really sounds like the hardware isn't actually different, just the
firmware has decided to be more strict about making reads fail now.
