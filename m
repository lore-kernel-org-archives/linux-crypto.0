From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v2 1/4] crypto: s5p-sss: Fix race in error handling
Date: Mon, 17 Sep 2018 17:47:24 +0200
Message-ID: <20180917154726eucas1p18eb2e915a45177d5cd7a192278eacc48~VOpH40eWM2730527305eucas1p1o@eucas1p1.samsung.com>
References: <1537196970-5987-1-git-send-email-c.manszewski@samsung.com>
        <CGME20180917151006eucas1p2226806b94605b061bc1bc3e9b5a6c495@eucas1p2.samsung.com>
        <20180917151006eucas1p2226806b94605b061bc1bc3e9b5a6c495~VOIhXssSK0729007290eucas1p25@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Christoph Manszewski <c.manszewski@samsung.com>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917151006eucas1p2226806b94605b061bc1bc3e9b5a6c495~VOIhXssSK0729007290eucas1p25@eucas1p2.samsung.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 17.09.2018 17:09, Christoph Manszewski wrote:
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

Acked-by: Kamil Konieczny <k.konieczny@partner.samsung.com>

Thanks!
Kamil

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
