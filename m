From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 2/4] crypto: s5p-sss: Fix whitespace issues
Date: Mon, 17 Sep 2018 15:05:53 +0200
Message-ID: <CAJKOXPf8OFMY9BbjcYorbbX7_5u4MFg4fj72O3Wio5hb+n9J3Q@mail.gmail.com>
References: <CGME20180913075858eucas1p1f528fd0776c32f1c10a3e46f8f2bacd0@eucas1p1.samsung.com>
 <1536825522-6027-1-git-send-email-c.manszewski@samsung.com> <20180913075858eucas1p1f528fd0776c32f1c10a3e46f8f2bacd0~T5q9BZO-j1335913359eucas1p1w@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org, vz@mleia.com,
        k.konieczny@partner.samsung.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        "linux-samsung-soc@vger.kernel.org"
        <linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org
To: c.manszewski@samsung.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180913075858eucas1p1f528fd0776c32f1c10a3e46f8f2bacd0~T5q9BZO-j1335913359eucas1p1w@eucas1p1.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 13 Sep 2018 at 09:59, Christoph Manszewski
<c.manszewski@samsung.com> wrote:
>
> Fix two whitespace issues that occurred at line breakup.

The s5p_set_outdata_start() does not have issue - just new line is not
aligned. The other also is not a issue of whitespace (e.g. mixed
spaces and tabs) but alignment.
So how about:
"Fix misalignment of continued argument list."?

With commit and subject improvements:
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof

>
> Signed-off-by: Christoph Manszewski <c.manszewski@samsung.com>
> ---
>  drivers/crypto/s5p-sss.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 0cf3f12d8f74..ce9bd13ea166 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -491,7 +491,7 @@ static void s5p_unset_indata(struct s5p_aes_dev *dev)
>  }
>
>  static int s5p_make_sg_cpy(struct s5p_aes_dev *dev, struct scatterlist *src,
> -                           struct scatterlist **dst)
> +                          struct scatterlist **dst)
>  {
>         void *pages;
>         int len;
> @@ -1890,7 +1890,7 @@ static int s5p_set_indata_start(struct s5p_aes_dev *dev,
>  }
>
>  static int s5p_set_outdata_start(struct s5p_aes_dev *dev,
> -                               struct ablkcipher_request *req)
> +                                struct ablkcipher_request *req)
>  {
>         struct scatterlist *sg;
>         int err;
> --
> 2.7.4
>
