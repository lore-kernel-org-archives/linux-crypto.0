From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] crypto: cavium: zip: Remove unnecessary parentheses
Date: Wed, 28 Mar 2018 11:11:16 -0700
Message-ID: <1522260676.12357.121.camel@perches.com>
References: <20180328175736.17360-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: cocci <cocci@systeme.lip6.fr>
To: Varsha Rao <rvarsha016@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180328175736.17360-1-rvarsha016@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2018-03-28 at 23:27 +0530, Varsha Rao wrote:
> This patch fixes the clang warning of extraneous parentheses, with the
> following coccinelle script.
> 
> @@
> identifier i;
> constant c;
> @@
> (
> -((i == c))
> +i == c
> > 
> 
> -((i <= c))
> +i <= c

Why just the "==" and "<=" cases?
Why not "<", ">" and ">=" too?

Why not expression instead of constant?
