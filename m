From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 3/4] crypto: s5p-sss: Minor code cleanup
Date: Mon, 17 Sep 2018 15:13:52 +0200
Message-ID: <CAJKOXPe_y7gvgAYAdewtdwhWb=bwk2ni8=_p89ps5Ge6i+pJfg@mail.gmail.com>
References: <CGME20180913075859eucas1p2bba2f5ab32fea5c4f832abaacaed6c8b@eucas1p2.samsung.com>
 <1536825522-6027-1-git-send-email-c.manszewski@samsung.com> <20180913075859eucas1p2bba2f5ab32fea5c4f832abaacaed6c8b~T5q_dx0q42420924209eucas1p2D@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org, vz@mleia.com,
        k.konieczny@partner.samsung.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        "linux-samsung-soc@vger.kernel.org"
        <linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org
To: c.manszewski@samsung.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180913075859eucas1p2bba2f5ab32fea5c4f832abaacaed6c8b~T5q_dx0q42420924209eucas1p2D@eucas1p2.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Thanks Christoph for patches!

On Thu, 13 Sep 2018 at 09:59, Christoph Manszewski
<c.manszewski@samsung.com> wrote:
>
> Modifications in s5p-sss.c:
>
> - remove unnecessary 'goto' statements,
>

No need of empty lines here.

> - change uint_8 and uint_32 to u8 and u32 types,

Please add rationale for this, e.g.: "for consistency in the driver
and making code shorter".

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
