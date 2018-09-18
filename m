From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v2 1/4] crypto: s5p-sss: Fix race in error handling
Date: Tue, 18 Sep 2018 09:33:35 +0200
Message-ID: <CAJKOXPeADXdhBYiVeErjgxnGdTLJVKNtpK65mXzg6m=hL8XRJA@mail.gmail.com>
References: <CGME20180917151006eucas1p2226806b94605b061bc1bc3e9b5a6c495@eucas1p2.samsung.com>
 <1537196970-5987-1-git-send-email-c.manszewski@samsung.com> <20180917151006eucas1p2226806b94605b061bc1bc3e9b5a6c495~VOIhXssSK0729007290eucas1p25@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org, vz@mleia.com,
        k.konieczny@partner.samsung.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        "linux-samsung-soc@vger.kernel.org"
        <linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvxYJuaWVya2lld2ljeg==?=
        <b.zolnierkie@samsung.com>
To: c.manszewski@samsung.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917151006eucas1p2226806b94605b061bc1bc3e9b5a6c495~VOIhXssSK0729007290eucas1p25@eucas1p2.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 17 Sep 2018 at 17:10, Christoph Manszewski
<c.manszewski@samsung.com> wrote:
>
> Remove a race condition introduced by error path in functions:
> s5p_aes_interrupt and s5p_aes_crypt_start. Setting the busy field of
> struct s5p_aes_dev to false made it possible for s5p_tasklet_cb to
> change the req field, before s5p_aes_complete was called.
>
> Change the first parameter of s5p_aes_complete to struct
> ablkcipher_request. Before spin_unlock, make a copy of the currently
> handled request, to ensure s5p_aes_complete function call with the
> correct request.
>
> Signed-off-by: Christoph Manszewski <c.manszewski@samsung.com>
> ---
>  drivers/crypto/s5p-sss.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
