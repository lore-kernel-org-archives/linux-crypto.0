From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] wusbcore: Fix one more crypto-on-the-stack bug
Date: Mon, 12 Dec 2016 22:44:47 +0100
Message-ID: <20161212214447.GA12142@kroah.com>
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
To: Andy Lutomirski <luto@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 12, 2016 at 12:52:45PM -0800, Andy Lutomirski wrote:
> The driver put a constant buffer of all zeros on the stack and
> pointed a scatterlist entry at it.  This doesn't work with virtual
> stacks.  Make the buffer static to fix it.
> 
> Cc: stable@vger.kernel.org # 4.9 only
> Reported-by: Eric Biggers <ebiggers3@gmail.com>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  drivers/usb/wusbcore/crypto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/wusbcore/crypto.c b/drivers/usb/wusbcore/crypto.c
> index 79451f7ef1b7..a7e007a0cd49 100644
> --- a/drivers/usb/wusbcore/crypto.c
> +++ b/drivers/usb/wusbcore/crypto.c
> @@ -216,7 +216,7 @@ static int wusb_ccm_mac(struct crypto_skcipher *tfm_cbc,
>  	struct scatterlist sg[4], sg_dst;
>  	void *dst_buf;
>  	size_t dst_size;
> -	const u8 bzero[16] = { 0 };
> +	static const u8 bzero[16] = { 0 };

Hm, can static memory handle DMA?  That's a requirement of the USB
stack, does this data later end up being sent down to a USB host
controller?

thanks,

greg k-h
