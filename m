From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v1 4/5] parisc: use seq_hex_dump() to dump buffers
Date: Wed, 9 Jul 2014 23:40:51 +0300
Message-ID: <CAHp75Ve-qhEn7emqqwf_nWSPiw-m-HJy42QapJoDhTeuBsoqZg@mail.gmail.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1404919470-26668-5-git-send-email-andriy.shevchenko@linux.intel.com>
	<1404930382.932.143.camel@joe-AO725>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Helge Deller <deller@gmx.de>,
	Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
	linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-media@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Joe Perches <joe@perches.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1404930382.932.143.camel@joe-AO725>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In one case indeed it does, in another - no, though it seems it prints
same data (by meaning) in both cases. I would like driver maintainer
to say a word what they think about it.

On Wed, Jul 9, 2014 at 9:26 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2014-07-09 at 18:24 +0300, Andy Shevchenko wrote:
>> Instead of custom approach let's use recently introduced seq_hex_dump() helper.
>
> Doesn't this also change the output from
>    1111111122222222333333334444444455555555666666667777777788888888
> to
>    11111111 22222222 33333333 44444444 55555555 66666666 77777777 88888888
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
With Best Regards,
Andy Shevchenko
