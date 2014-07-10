From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v1 5/5] [S390] zcrypt: use seq_hex_dump() to dump buffers
Date: Thu, 10 Jul 2014 12:56:26 +0300
Message-ID: <1404986186.5102.98.camel@smile.fi.intel.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404919470-26668-6-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Helge Deller <deller@gmx.de>,
	Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
	linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-media@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1404919470-26668-6-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2014-07-09 at 18:24 +0300, Andy Shevchenko wrote:
> Instead of custom approach let's use recently introduced seq_hex_dump() helper.
> 
> In this case it slightly changes the output, namely the four tetrads will be
> output on one line.

The above paragraph is not true and will be removed in v2.
The output is kept the same as in original code.

> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/s390/crypto/zcrypt_api.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
> index 0e18c5d..d1f9983 100644
> --- a/drivers/s390/crypto/zcrypt_api.c
> +++ b/drivers/s390/crypto/zcrypt_api.c
> @@ -1203,16 +1203,8 @@ static void sprinthx(unsigned char *title, struct seq_file *m,
>  static void sprinthx4(unsigned char *title, struct seq_file *m,
>  		      unsigned int *array, unsigned int len)
>  {
> -	int r;
> -
>  	seq_printf(m, "\n%s\n", title);
> -	for (r = 0; r < len; r++) {
> -		if ((r % 8) == 0)
> -			seq_printf(m, "    ");
> -		seq_printf(m, "%08X ", array[r]);
> -		if ((r % 8) == 7)
> -			seq_putc(m, '\n');
> -	}
> +	seq_hex_dump(m, "    ", DUMP_PREFIX_NONE, 32, 4, array, len, false);
>  	seq_putc(m, '\n');
>  }
>  


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
