From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [RESEND PATCH] crypto: Add zstd support
Date: Thu, 22 Mar 2018 13:32:30 +0900
Message-ID: <20180322043230.GD3181@jagdpanzerIV>
References: <20180321224929.3076350-1-terrelln@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Geliang Tang <geliangtang@gmail.com>
To: Nick Terrell <terrelln@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180321224929.3076350-1-terrelln@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On (03/21/18 15:49), Nick Terrell wrote:
> depends on CONFIG_CRYPTO_ZSTD, which isn't defined until this patch is in

Yikes! How come I missed that... :)

> [0] lkml.kernel.org/r/9c9416b2dff19f05fb4c35879aaa83d11ff72c92.1521626182.git.geliangtang@gmail.com

Signed-off-by: Nick Terrell <terrelln@fb.com> ?

	-ss
