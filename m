From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 11/14] treewide: Prepare to remove VLA
	usage for AHASH_REQUEST_ON_STACK
Date: Mon, 16 Jul 2018 09:24:06 +0200
Message-ID: <CAK8P3a0Y82-zxiC4L1v3B20fTgP=AwfFT7sogZZBH5+v0uToHw@mail.gmail.com>
References: <20180711203619.1020-1-keescook@chromium.org>
	<20180711203619.1020-12-keescook@chromium.org>
	<CAK8P3a3356dbruUfS_+fj9f+X-0jbNE8WMe5sWhJmuRY9Nvcbg@mail.gmail.com>
	<20180713004038.lwibdesz7ohhoind@gondor.apana.org.au>
	<CAGXu5jJOZ3u1BTf8U20wErphfjKzaGK+m1sdhA89LqVP3MDYZA@mail.gmail.com>
	<20180713062204.2o7gz5xri374nii6@gondor.apana.org.au>
	<CAGXu5jJp3Y4RZD+ZUYsWqf+sTbGJwdN3M=KOiPBn9VecYE4OgQ@mail.gmail.com>
	<20180715024430.n6bcnb4k7cm3ugtj@gondor.apana.org.au>
	<CAGXu5jLkhC8Jb0zVXuVZnbJM6tmMpyGkaoCvw=jACLA3fnoChw@mail.gmail.com>
	<20180716000118.nna5jkgcjxofbsup@gondor.apana.org.au>
	<CAGXu5jKQV+qiLjbDoS=8QYfG_hdiYeRqeDdov_of5wn5Sek0KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>, qat-linux@intel.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>, dm-devel@redhat.com,
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
	<linux-crypto@vger.kernel.org>, Lars Persson <larper@axis.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>, Alasdair Kergon <agk@redhat.com>,
	Rabin Vincent <rabinv@axis.com>
To: Kees Cook <keescook@chromium.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAGXu5jKQV+qiLjbDoS=8QYfG_hdiYeRqeDdov_of5wn5Sek0KA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 16, 2018 at 5:39 AM, Kees Cook <keescook@chromium.org> wrote:
> On Sun, Jul 15, 2018 at 5:01 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Sat, Jul 14, 2018 at 07:59:09PM -0700, Kees Cook wrote:
>>> On Sat, Jul 14, 2018 at 7:44 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>> > On Fri, Jul 13, 2018 at 08:07:10PM -0700, Kees Cook wrote:
>>> >>
>>> >> On a plane today I started converting all these to shash. IIUC, it
>>> >> just looks like this (apologies for whitespace damage):
>>> >
>>> > Yes if it doesn't actually make use of SGs then shash would be
>>> > the way to go.  However, for SG users ahash is the best interface.
>>>
>>> Nearly all of them artificially build an sg explicitly to use the
>>> ahash interface. :P
>>>
>>> So, I'll take that as a "yes, do these conversions." :) Thanks!
>>
>> Yeah anything that's doing a single-element SG list should just
>> be converted.
>
> There are a few that are multiple element SG list, but it's a locally
> allocated array of SGs, and filled with data. All easily replaced with
> just calls to ..._update() instead of sg helpers. For example
> net/wireless/lib80211_crypt_tkip.c:
>
> -       sg_init_table(sg, 2);
> -       sg_set_buf(&sg[0], hdr, 16);
> -       sg_set_buf(&sg[1], data, data_len);
> ...
> -       ahash_request_set_tfm(req, tfm_michael);
> -       ahash_request_set_callback(req, 0, NULL, NULL);
> -       ahash_request_set_crypt(req, sg, mic, data_len + 16);
> -       err = crypto_ahash_digest(req);
> -       ahash_request_zero(req);
> +       err = crypto_shash_init(desc);
> +       if (err)
> +               goto out;
> +       err = crypto_shash_update(desc, hdr, 16);
> +       if (err)
> +               goto out;
> +       err = crypto_shash_update(desc, data, data_len);
> +       if (err)
> +               goto out;
> +       err = crypto_shash_final(desc, mic);
> +
> +out:
> +       shash_desc_zero(desc);
>         return err;

There may be a little overhead in calling crypto_shash_update()/
crypto_shash_final() repeatedly compared to calling
crypto_ahash_digest() once. It's probably no worse (or maybe
better) in this case, since we call only three times and there
is less indirection, but if there are any cases with a long sglist,
it would be good to measure the performance difference.

       Arnd
