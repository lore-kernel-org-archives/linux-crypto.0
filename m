From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 2/4] crypto: s5p-sss - Remove unused variant field from
 state container
Date: Fri, 17 Mar 2017 18:57:40 +0100
Message-ID: <3198662.RQCJs7FP2R@amdc3058>
References: <20170317144922.27379-1-krzk@kernel.org>
 <20170317144922.27379-3-krzk@kernel.org>
 <CGME20170317175742epcas1p4de223069256de479fb9cd3b56375bd4d@epcas1p4.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Nathan Royce <nroycea+kernel@gmail.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20170317144922.27379-3-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Friday, March 17, 2017 04:49:20 PM Krzysztof Kozlowski wrote:
> The driver uses type of device (variant) only during probe so there is
> no need to store it for later.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
