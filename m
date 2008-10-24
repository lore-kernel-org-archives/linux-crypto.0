From: "Loc Ho" <lho@amcc.com>
Subject: RE: [PATCH 1/1 v7] Add Crypto API User Interface Support
Date: Fri, 24 Oct 2008 15:16:52 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D6053E6363@SDCEXCHANGE01.ad.amcc.com>
References: <1224786829-32405-1-git-send-email-spulijala@amcc.com> <DB599F406D04E34389140B7D99C71B1B064CADB6@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D6053E62E9@SDCEXCHANGE01.ad.amcc.com> <DB599F406D04E34389140B7D99C71B1B064CB159@SDCEXCHANGE01.ad.amcc.com> <20081024210755.GB26930@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
To: "Evgeniy Polyakov" <zbr@ioremap.net>,
	"Shasi Pulijala" <spulijala@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.73]:26917 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbYJXWRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Oct 2008 18:17:08 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20081024210755.GB26930@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Evgenly,

See inline...

-----Original Message-----
From: Evgeniy Polyakov [mailto:zbr@ioremap.net] 
Sent: Friday, October 24, 2008 2:08 PM
To: Shasi Pulijala
Cc: Herbert Xu; linux-crypto@vger.kernel.org; Loc Ho
Subject: Re: [PATCH 1/1 v7] Add Crypto API User Interface Support

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

[Loc Ho]
We will look at profiling but in either case cryptodev will always takes longer as tcrypto only measure the encrypt/decrypt function. Cryptodev has to setup the operation as well as other house cleaning.

> With regard to forward declaration, they are needed. 

Why? Can't you reorder functions to eliminate that?
[Loc Ho]
We will look again.

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

[Loc Ho]
I don't understand what you are referring to here. Let's assume that operation is submitted synchronously to cryptodev, cryptodev in turn will submit to the underlying driver. If the underlying driver is software based, it will completed synchronous and return without calling wait_for_completion. If the underlying driver is hardware based or asynchronous, it will wait for completion via the callback function signaling the event wait object. Now, let's assume that operation is submitted asynchronously to cryptodev, crypto in turn will submit to the underlying driver. If the underlying driver is software based and completed, it just return. If the underlying driver is asynchronous such as hardware, it will return immediately without waiting. CryptoDev will call the AIO callback function when
  the crypto driver call cryptodev callback function. Therefore, what is the issue?

As regard to performance, asynchronous only help performance if there are a large number request (which implement hardware support).


Plus, you did not figure what happens when request completion is
interrupted with regard to freeing data, which may be accesed by the
crypto code in parallel.

[Loc Ho]
We looked at this. There is reference count that will prevent delete of the request context. Apparently, we missed this. We will fix this.


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
