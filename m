From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH] KEYS: Use individual pages in big_key for crypto
 buffers
Date: Thu, 15 Feb 2018 12:45:28 -0800
Message-ID: <20180215204528.GA49445@gmail.com>
References: <151871006638.2759.15708879200455370908.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: keyrings@vger.kernel.org, Jason@zx2c4.com,
        herbert@gondor.apana.org.au, k.marinushkin@gmail.com,
        linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:38279 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033689AbeBOUpd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 15:45:33 -0500
Content-Disposition: inline
In-Reply-To: <151871006638.2759.15708879200455370908.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi David,

On Thu, Feb 15, 2018 at 03:54:26PM +0000, David Howells wrote:
> kmalloc() can't always allocate large enough buffers for big_key to use for
> crypto (1MB + some metadata) so we cannot use that to allocate the buffer.
> Further, vmalloc'd pages can't be passed to sg_init_one() and the aead
> crypto accessors cannot be called progressively and must be passed all the
> data in one go (which means we can't pass the data in one block at a time).
> 
> Fix this by allocating the buffer pages individually and passing them
> through a multientry scatterlist to the crypto layer.  This has the bonus
> advantage that we don't have to allocate a contiguous series of pages.

Thanks for fixing this.  The proposed solution is ugly but I don't have a better
one in mind.  Someday the crypto API might support virtual addresses itself, in
which case vmalloc (or kvmalloc()) could just be used.  But it's tough since
some crypto drivers really do need pages, so there would still have to be a
translation from virtual addresses to pages somewhere.

> +struct big_key_buf {
> +	int			nr_pages;
> +	void			*virt;
> +	struct scatterlist	*sg;
> +	struct page		*pages[];
> +};

nr_pages should be an 'unsigned int' to be consistent with the rest of the code.

> + * Free up the buffer.
> + */
> +static void big_key_free_buffer(struct big_key_buf *buf)
> +{
> +	unsigned int i;
> +
> +	vunmap(buf->virt);
> +	for (i = 0; i < buf->nr_pages; i++)
> +		__free_page(buf->pages[i]);
> +
> +	kfree(buf);
> +}

If big_key_alloc_buffer() fails to allocate one of the pages then some of the
pages may still be NULL here, causing __free_page() to crash.  You need to check
for NULL first.

Also how about doing the memset to 0 in here so that the callers don't thave to
remember it:

	if (buf->virt) {
		memset(buf->virt, 0, buf->nr_pages * PAGE_SIZE);
		vunmap(buf->virt);
	}

- Eric
