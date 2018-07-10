From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: dh - fix memory leak
Date: Tue, 10 Jul 2018 17:28:34 +0200
Message-ID: <5010742.5FTaVXtiru@positron.chronox.de>
References: <20180710142252.GA19600@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180710142252.GA19600@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 10. Juli 2018, 16:22:52 CEST schrieb Gustavo A. R. Silva:

Hi Gustavo,

> In case memory resources for *base* were allocated, release them
> before return.

Thanks a lot.

Reviewed-by: Stephan M=FCller <smueller@chronox.de>

Ciao
Stephan
