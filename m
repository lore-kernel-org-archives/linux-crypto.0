From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v2 3/4] crypto: s5p-sss: Minor code cleanup
Date: Mon, 17 Sep 2018 17:49:13 +0200
Message-ID: <20180917154915eucas1p138e4193dc80c976f356e94589f6e4a40~VOqtgu4ye0974509745eucas1p1R@eucas1p1.samsung.com>
References: <1537196970-5987-1-git-send-email-c.manszewski@samsung.com>
        <CGME20180917151009eucas1p145fdde4a56241418a49a1da14c5bdb02@eucas1p1.samsung.com>
        <20180917151009eucas1p145fdde4a56241418a49a1da14c5bdb02~VOIkhD_S60202502025eucas1p1F@eucas1p1.samsung.com>
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
In-Reply-To: <20180917151009eucas1p145fdde4a56241418a49a1da14c5bdb02~VOIkhD_S60202502025eucas1p1F@eucas1p1.samsung.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 17.09.2018 17:09, Christoph Manszewski wrote:
> Modifications in s5p-sss.c:
> - remove unnecessary 'goto' statements (making code shorter),
> - change uint_8 and uint_32 to u8 and u32 types (for consistency in the
> driver and making code shorter),
> 
> Signed-off-by: Christoph Manszewski <c.manszewski@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Acked-by: Kamil Konieczny <k.konieczny@partner.samsung.com>

Thanks!
Kamil
