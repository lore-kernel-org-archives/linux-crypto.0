From: Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH] crypto: sun4i-ss: add missing statesize
Date: Thu, 5 Nov 2015 18:34:14 +0800
Message-ID: <CAGb2v65FOtbigXpmN=L3af0HOjSJU8GGPY_PDvDp+3fCUCvKQw@mail.gmail.com>
References: <1446709737-11316-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>,
	stable@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1446709737-11316-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 5, 2015 at 3:48 PM, LABBE Corentin
<clabbe.montjoie@gmail.com> wrote:
> sun4i-ss implementaton of md5/sha1 is via ahash algorithms.
> A recent change make impossible to load them without giving statesize.
> This patch specifiy statesize for sha1 and md5.
>
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> Cc: stable@vger.kernel.org

Confirmed the driver properly loads again.

Tested-by: Chen-Yu Tsai <wens@csie.org>

> ---
>  drivers/crypto/sunxi-ss/sun4i-ss-core.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> index eab6fe2..107cd2a 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> @@ -39,6 +39,7 @@ static struct sun4i_ss_alg_template ss_algs[] = {
>                 .import = sun4i_hash_import_md5,
>                 .halg = {
>                         .digestsize = MD5_DIGEST_SIZE,
> +                       .statesize = sizeof(struct md5_state),
>                         .base = {
>                                 .cra_name = "md5",
>                                 .cra_driver_name = "md5-sun4i-ss",
> @@ -66,6 +67,7 @@ static struct sun4i_ss_alg_template ss_algs[] = {
>                 .import = sun4i_hash_import_sha1,
>                 .halg = {
>                         .digestsize = SHA1_DIGEST_SIZE,
> +                       .statesize = sizeof(struct sha1_state),
>                         .base = {
>                                 .cra_name = "sha1",
>                                 .cra_driver_name = "sha1-sun4i-ss",
> --
> 2.4.10
>
