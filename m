From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] crypto: Use zeroing memory allocator instead of
 allocator/memset
Date: Sun, 31 Dec 2017 07:46:09 -0800
Message-ID: <1514735169.1967.13.camel@perches.com>
References: <1514723063-5614-1-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514723063-5614-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, 2017-12-31 at 17:54 +0530, Himanshu Jha wrote:
> Use dma_zalloc_coherent for allocating zeroed
> memory and remove unnecessary memset function.
> 
> Done using Coccinelle.
> Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci

I thought you were going to change this tag to
not use the "-by:" form and use something else
like "generated-using:" or "created-with:".
