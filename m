From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v2] crypto: doc - clarify hash callbacks state machine
Date: Tue, 20 Mar 2018 09:50:17 +0100
Message-ID: <d036a7ef-d900-4858-b821-05c50b2b739e@partner.samsung.com>
References: <20180305103945.3517-1-horia.geanta@nxp.com>
        <CGME20180320075741epcas5p3a7c026ba8644e54478955afcb6091023@epcas5p3.samsung.com>
        <20180320075612.22719-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20180320075612.22719-1-horia.geanta@nxp.com>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 20.03.2018 08:56, Horia Geantă wrote:
> Add a note that it is perfectly legal to "abandon" a request object:
> - call .init() and then (as many times) .update()
> - _not_ call any of .final(), .finup() or .export() at any point in
>   future
> 
> Link: https://lkml.kernel.org/r/20180222114741.GA27631@gondor.apana.org.au
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>  Documentation/crypto/devel-algos.rst | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/crypto/devel-algos.rst b/Documentation/crypto/devel-algos.rst
> index 66f50d32dcec..c45c6f400dbd 100644
> --- a/Documentation/crypto/devel-algos.rst
> +++ b/Documentation/crypto/devel-algos.rst
> @@ -236,6 +236,14 @@ when used from another part of the kernel.
>                                 |
>                                 '---------------> HASH2
>  
> +Note that it is perfectly legal to "abandon" a request object:
> +- call .init() and then (as many times) .update()
> +- _not_ call any of .final(), .finup() or .export() at any point in future
> +
> +In other words implementations should mind the resource allocation and clean-up.
> +No resources related to request objects should remain allocated after a call
-- ^^^^^^^^^^^^
> +to .init() or .update(), since there might be no chance to free them.

is it for crypto api  users or for drivers ?

the creator of request context is responsible for alloc and destroy,
so why there are no chance of free ?

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
