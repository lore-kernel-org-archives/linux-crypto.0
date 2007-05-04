From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH 2/5] jffs2: Add LZO compression support to jffs2
Date: Fri, 4 May 2007 14:36:16 +0530
Message-ID: <a781481a0705040206jee1c4a7s9822960a7a18d56f@mail.gmail.com>
References: <1178030823.5883.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	"David Woodhouse" <dwmw2@infradead.org>,
	herbert@gondor.apana.org.au,
	linux-mtd <linux-mtd@lists.infradead.org>,
	linux-crypto@vger.kernel.org
To: "Richard Purdie" <rpurdie@openedhand.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.235]:40105 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767744AbXEDJGS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 May 2007 05:06:18 -0400
Received: by wr-out-0506.google.com with SMTP id 76so829243wra
        for <linux-crypto@vger.kernel.org>; Fri, 04 May 2007 02:06:17 -0700 (PDT)
In-Reply-To: <1178030823.5883.54.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Richard,

On 5/1/07, Richard Purdie <rpurdie@openedhand.com> wrote:
> Add LZO1X compression/decompression support to jffs2.
>
> LZO's interface doesn't entirely match that required by jffs2 so a
> buffer and memcpy is unavoidable.
>
> Signed-off-by: Richard Purdie <rpurdie@openedhand.com>
> ---
> [...]
> +++ b/fs/jffs2/compr_lzo.c
> [...]
> +static void *lzo_mem;
> +static void *lzo_compress_buf;
> +static DEFINE_MUTEX(deflate_mutex);
> +
> +static void free_workspace(void)
> +{
> +       vfree(lzo_mem);
> +       vfree(lzo_compress_buf);
> +}
> +
> +static int __init alloc_workspace(void)
> +{
> +       lzo_mem = vmalloc(LZO1X_MEM_COMPRESS);
> +       lzo_compress_buf = vmalloc(lzo1x_worst_compress(PAGE_SIZE));
> +
> +       if (!lzo_mem || !lzo_compress_buf) {
> +               printk(KERN_WARNING "Failed to allocate lzo deflate workspace\n");
> +               free_workspace();
> +               return -ENOMEM;
> +       }
> +
> +       return 0;
> +}
> +
> +static int jffs2_lzo_compress(unsigned char *data_in, unsigned char *cpage_out,
> +                             uint32_t *sourcelen, uint32_t *dstlen, void *model)
> +{
> +       unsigned long compress_size;
> +       int ret;
> +
> +       mutex_lock(&deflate_mutex);
> +       ret = lzo1x_1_compress(data_in, *sourcelen, lzo_compress_buf, &compress_size, lzo_mem);
> +       mutex_unlock(&deflate_mutex);

Considering we do have to memcpy() the entire compressed result to the
destination output buffer later anyway (note that
fs/jffs2/compr_zlib.c doesn't need to do that), do we really gain much
by avoiding vmalloc() and vfree() in jffs2_lzo_compress() itself and
keeping the workspace buffers pre-allocated? I ask because I always
found these global static workspace buffers ugly, and all the
associated code + mutex could go away if we make them local to
jffs2_lzo_compress() -- as long as it doesn't hurt performance
terribly, of course.

Thanks,
Satyam
