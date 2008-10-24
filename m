From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH 1/1 v7] Add Crypto API User Interface Support
Date: Sat, 25 Oct 2008 01:07:55 +0400
Message-ID: <20081024210755.GB26930@ioremap.net>
References: <1224786829-32405-1-git-send-email-spulijala@amcc.com> <DB599F406D04E34389140B7D99C71B1B064CADB6@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D6053E62E9@SDCEXCHANGE01.ad.amcc.com> <DB599F406D04E34389140B7D99C71B1B064CB159@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Loc Ho <lho@amcc.com>
To: Shasi Pulijala <spulijala@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tservice.ru ([195.178.208.66]:37896 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbYJXVRM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Oct 2008 17:17:12 -0400
Content-Disposition: inline
In-Reply-To: <DB599F406D04E34389140B7D99C71B1B064CB159@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Fri, Oct 24, 2008 at 01:54:23PM -0700, Shasi Pulijala (spulijala@amcc.com) wrote:
> This patch v7 includes a few coding style changes and benchmark comparison between for tcrypt and cryptodev. These are just a rough estimate and not the exact numbers for cbc-aes. CryptoDev interface will always be slight more as it includes crypto setup and a few other housekeeping tasks. Tcrypt is just the time for the encrypt or decrypt function calls only.
> 
> 		Tcrypt	Cryptodev
> 16 byte	47us		132us
> 32 byte	51us		141us
> 64 byte	68us		150us

Can you also run cryptodev under profiler to determine, why it is, well,
noticebly, slower than tcrypt?

> With regard to forward declaration, they are needed. 

Why? Can't you reorder functions to eliminate that?

> >> +		}
> >> +		sg_set_page(&sg[x], page, bufsize, offset);
> >> +		rop = PAGE_SIZE - sg[x].offset;
> >> +		if (bufsize > rop) {
> >> +			sg[x].length = rop;
> >> +			bufsize = bufsize - rop;
> >> +		}
> >> +		offset = 0;
> >>
> >>What if bufsize is smaller than 'rop', but there are several pages?
> >>This will initialize wrong buffers, but probably there is a check somewhere above this layer.
> 
> Yes, there is a check above for the number of pages returned. It returns an error if the number of pages returned is greater/less than requested.
> 
> With regard to "Still this is not an async crypto," it is asynchronous interface if called via AIO. For vector write, it will turn into synchronous AIO within the kernel AIO framework.

It does not mean it is async, since crypto processing itself is
synchronous. I.e. you can submit requests asynchronously, but they are
processed by the crypto code one-by-one with waiting after each request.
This actually can explain your numbers: instead of having flow of
requests, you have to do really lots of work per-request. I do not say
this is wrong (although imho it should be done differently), since it is
your code and likely it fits your needs.

Plus, you did not figure what happens when request completion is
interrupted with regard to freeing data, which may be accesed by the
crypto code in parallel.

> +	aead_request_set_crypt(req, ssg, dsg, bufsize, cop->iv);
> +	aead_request_set_assoc(req, &adata, cop->assoc_len);
> +
> +	atomic_inc(&ses_ptr->refcnt);
> +
> +	if (cop->eop == COP_ENCRYPT)
> +		ret = crypto_aead_encrypt(req);
> +	else
> +		ret = crypto_aead_decrypt(req);
> +
> +	switch (ret) {
> +	case 0:
> +		if (!iocb)
> +			atomic_dec(&result->opcnt);
> +		break;
> +	case -EINPROGRESS:
> +	case -EBUSY:
> +		if (iocb) {
> +			CDPRINTK(2, KERN_INFO,
> +				"Async Call AEAD:Returning Now\n");
> +			return -EIOCBQUEUED;
> +		}
> +		ret = wait_for_completion_interruptible(
> +					&result->crypto_completion);
> +		if (!ret)
> +			ret = result->err;
> +		if (!ret) {
> +			INIT_COMPLETION(result->crypto_completion);
> +			break;
> +		}

I.e. let's suppose it was interrupted here, while crypto driver performs
a processing on given pages.

> +		/* fall through */
> +	default:
> +		printk(KERN_ERR PFX "sid %p enc/dec failed error %d\n",
> +			ses_ptr, -ret);
> +		if (!iocb)
> +			atomic_dec(&result->opcnt);
> +		break;
> +	}
> +
> +	if (nopin && !ret) {
> +		if (copy_to_user(dst, data, enc ? bufsize + authsize :
> +						bufsize - authsize))
> +			printk(KERN_ERR PFX
> +				"failed to copy encrypted data "
> +				"to user space\n");
> +		CD_HEXDUMP(data, enc ? bufsize + authsize :
> +					bufsize - authsize);
> +	}
> +
> +	/* Check if last reference */
> +	if (atomic_dec_and_test(&ses_ptr->refcnt))
> +		cryptodev_destroy_session(ses_ptr);
> +	if (dst_flag)
> +		cryptodev_release_pages(result->dpages, nr_dpages);
> +out_spages:
> +	cryptodev_release_pages(result->spages, nr_spages);

Now you have freed pages, which are still accessible by the request
crypto processing code somewhere in the underlying driver.

-- 
	Evgeniy Polyakov
