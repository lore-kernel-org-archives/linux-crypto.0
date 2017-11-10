From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH] crypto: s5p-sss - Remove a stray tab
Date: Fri, 10 Nov 2017 09:08:47 +0100
Message-ID: <CAJKOXPduq1n+iGEVLATa6e__SoUUFppA_-So1wrz-VaafhXdJA@mail.gmail.com>
References: <20171109212604.i3zbzlmfotz5b7rr@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750756AbdKJIIu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Nov 2017 03:08:50 -0500
In-Reply-To: <20171109212604.i3zbzlmfotz5b7rr@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 9, 2017 at 10:26 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> This code seems correct, but the goto was indented too far.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
