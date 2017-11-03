From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [PATCH] crypto: qat: qat_common: qat_uclo - mark expected
 switch fall-throughs
Date: Fri, 03 Nov 2017 09:35:37 -0500
Message-ID: <20171103093537.Horde.bktOWsgySfzGMEaxPEBpORe@gator4166.hostgator.com>
References: <20171012225529.GA25176@embeddedor.com>
 <20171103142338.GH9011@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        "David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171103142338.GH9011@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Quoting Herbert Xu <herbert@gondor.apana.org.au>:

> On Thu, Oct 12, 2017 at 05:55:29PM -0500, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>>
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>
> Patch applied.  Thanks.

Thank you, Herbert.
--
Gustavo A. R. Silva
