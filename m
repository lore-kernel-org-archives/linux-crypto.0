From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH] KEYS: Use individual pages in big_key for crypto
 buffers [ver #2]
Date: Thu, 15 Feb 2018 17:56:29 -0800
Message-ID: <20180216015629.GA136603@gmail.com>
References: <151873522941.16065.2576464502758911341.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: keyrings@vger.kernel.org, Jason@zx2c4.com,
        herbert@gondor.apana.org.au, k.marinushkin@gmail.com,
        linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:43719 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757198AbeBPB4e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 20:56:34 -0500
Content-Disposition: inline
In-Reply-To: <151873522941.16065.2576464502758911341.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi David,

On Thu, Feb 15, 2018 at 10:53:49PM +0000, David Howells wrote:
>  /*
> + * Free up the buffer.
> + */
> +static void big_key_free_buffer(struct big_key_buf *buf)
> +{
> +	unsigned int i;
> +
> +	vunmap(buf->virt);
> +	for (i = 0; i < buf->nr_pages; i++)
> +		if (buf->pages[i])
> +			__free_page(buf->pages[i]);
> +
> +	memset(buf->virt, 0, buf->nr_pages * PAGE_SIZE);
> +	kfree(buf);
> +}

memset() after vunmap(), and also when buf->virt can be NULL?  I had suggested:

        if (buf->virt) {
                memset(buf->virt, 0, buf->nr_pages * PAGE_SIZE);
                vunmap(buf->virt);
        }

- Eric
