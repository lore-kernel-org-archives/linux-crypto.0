From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [RESEND] crypto test: use print_hex_dump from kernel.h
 instead
Date: Tue, 27 Nov 2007 01:26:22 -0800
Message-ID: <20071127012622.3e3a6bd1.akpm@linux-foundation.org>
References: <20071126143939.GB28022@gondor.apana.org.au>
	<1196098095-8995-1-git-send-email-crquan@gmail.com>
	<1196100104.31590.11.camel@localhost>
	<20071127013540.GA793@gondor.apana.org.au>
	<1196131632-7285-1-git-send-email-crquan@gmail.com>
	<474B87F1.2060109@student.ltu.se>
	<91b13c310711262103w781b3047k6338acda56837c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Richard Knutsson" <ricknu-0@student.ltu.se>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dengxw@163.com, "Randy Dunlap" <randy.dunlap@oracle.com>,
	"Joe Perches" <joe@perches.com>
To: "rae l" <crquan@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758328AbXK0J2o@vger.kernel.org>
In-Reply-To: <91b13c310711262103w781b3047k6338acda56837c0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 27 Nov 2007 13:03:29 +0800 "rae l" <crquan@gmail.com> wrote:

> -static void hexdump(unsigned char *buf, unsigned int len)
> +static inline void hexdump(unsigned char *buf, unsigned int len)
>  {
> -	while (len--)
> -		printk("%02x", *buf++);
> -
> -	printk("\n");
> +	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
> +			16, 1,
> +			buf, len, false);
>  }

uninlining this function shrinks crypto/tcrypt.o's .text from 20,009 bytes
down to 19,701.

inlining is almost always wrong.
