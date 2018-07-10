From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] crypto: dh - fix memory leak
Date: Tue, 10 Jul 2018 11:49:59 -0500
Message-ID: <e2747d61-3b12-40e7-b0fa-ab57064f416a@embeddedor.com>
References: <20180710142252.GA19600@embeddedor.com>
 <5010742.5FTaVXtiru@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5010742.5FTaVXtiru@positron.chronox.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Stephan,

On 07/10/2018 10:28 AM, Stephan Müller wrote:
> Am Dienstag, 10. Juli 2018, 16:22:52 CEST schrieb Gustavo A. R. Silva:
> 
> Hi Gustavo,
> 
>> In case memory resources for *base* were allocated, release them
>> before return.
> 
> Thanks a lot.
> 

Glad to help. :)

> Reviewed-by: Stephan Müller <smueller@chronox.de>
> 

Thanks
--
Gustavo
