From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Mon, 18 Jun 2018 13:24:14 -0700
Message-ID: <152935345439.16708.16472364970375601294@swboyd.mtv.corp.google.com>
References: <20180618141259.23141-1-vkoul@kernel.org>
 <20180618141259.23141-4-vkoul@kernel.org> <20180618182123.GT14924@minitux>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Vinod Koul <vkoul@kernel.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vinod Koul <vinod.koul@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618182123.GT14924@minitux>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Quoting Bjorn Andersson (2018-06-18 11:21:23)
> On Mon 18 Jun 07:12 PDT 2018, Vinod Koul wrote:
> =

> > Qcom 8996 and later chips support prng v2 where we need to only
> > implement .read callback for hwrng.
> > =

> =

> The hardware still needs initialization, so I think you should expand
> this to mention that the initialization is moved to secure world and
> that's the reason why we only implement read.
> =

> The question is what happens in projects with other security models.

Can we still read the PRNG_CONFIG register to see if it's already been
configured or not and then bail out if it isn't configured? That would
be better as long as we the system doesn't blow up if non-secure mode
tries to read the config register.
