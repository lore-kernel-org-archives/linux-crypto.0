From: Joe Perches <joe@perches.com>
Subject: Re: make sure swap arguments are the same type? (was: Re: [PATCH]
 crypto: rmd320 - use swap macro in rmd320_transform)
Date: Fri, 20 Jul 2018 22:34:56 -0700
Message-ID: <085e361269db5f5f923a65a52e1000d5cd79eee4.camel@perches.com>
References: <20180718171908.GA22962@embeddedor.com>
         <4dbef38e6020d6cb78e860a9f01fcd1de9f0fb52.camel@perches.com>
         <ac6bf6b3-b739-a6b8-c9b0-8d496fb7a470@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ac6bf6b3-b739-a6b8-c9b0-8d496fb7a470@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2018-07-20 at 10:43 -0500, Gustavo A. R. Silva wrote:
> Hi Joe,
> 
> I like the idea. I'll take a look at the cases you mention and see
> if I can make them work with your version of swap.
> 
> BTW, I wonder if it would be more convenient to trigger a build warning
> instead of an error.
> 
> What do you think?

I can't think of a way to have a #pragma (or _Pragma equivalent)
emit a warning on a condition.
