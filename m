From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] crypto/async_pq: use __free_page() instead of put_page()
Date: Mon, 29 Feb 2016 10:04:38 -0800
Message-ID: <CAPcyv4jJzUieZ0i2jBqANwmYPUBVmQmhoDTPnr0KjPQXnoZqWQ@mail.gmail.com>
References: <1456738445-876239-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Linux MM <linux-mm@kvack.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Michal Nazarewicz <mina86@mina86.com>, Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>,
	NeilBrown <neilb@suse.com>, Markus Stockhausen <stockhausen@collogia.de>,
	Vinod Koul <vinod.koul@intel.com>, linux-crypto@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1456738445-876239-1-git-send-email-arnd@arndb.de>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Feb 29, 2016 at 1:33 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The addition of tracepoints to the page reference tracking had an
> unfortunate side-effect in at least one driver that calls put_page
> from its exit function, resulting in a link error:
>
> `.exit.text' referenced in section `__jump_table' of crypto/built-in.o: defined in discarded section `.exit.text' of crypto/built-in.o
>
> From a cursory look at that this driver, it seems that it may be
> doing the wrong thing here anyway, as the page gets allocated
> using 'alloc_page()', and should be freed using '__free_page()'
> rather than 'put_page()'.
>
> With this patch, I no longer get any other build errors from the
> page_ref patch, so hopefully we can assume that it's always wrong
> to call any of those functions from __exit code, and that no other
> driver does it.
>
> Fixes: 0f80830dd044 ("mm/page_ref: add tracepoint to track down page reference manipulation")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Dan Williams <dan.j.williams@intel.com>

Vinod, will you take this one?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
