From: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/6] crypto: engine - Permit to enqueue
 all async requests
Date: Fri, 16 Feb 2018 16:36:56 +0100
Message-ID: <20180216153656.GA22492@Red>
References: <20180126191534.17569-1-clabbe.montjoie@gmail.com>
 <20180215155100.GJ7352@gondor.apana.org.au>
Reply-To: clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: alexandre.torgue-qxv4g6HH51o@public.gmane.org, arei.gonglei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org,
	davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, fabien.dessenne-qxv4g6HH51o@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org,
	linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-sunxi+bncBD7YLCN32UNBBHPVTPKAKGQE5WOXQMA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <20180215155100.GJ7352-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

On Thu, Feb 15, 2018 at 11:51:00PM +0800, Herbert Xu wrote:
> On Fri, Jan 26, 2018 at 08:15:28PM +0100, Corentin Labbe wrote:
> > Hello
> > 
> > The current crypto_engine support only ahash and ablkcipher request.
> > My first patch which try to add skcipher was Nacked, it will add too many functions
> > and adding other algs(aead, asymetric_key) will make the situation worst.
> > 
> > This patchset remove all algs specific stuff and now only process generic crypto_async_request.
> > 
> > The requests handler function pointer are now moved out of struct engine and
> > are now stored directly in a crypto_engine_reqctx.
> > 
> > The original proposal of Herbert [1] cannot be done completly since the crypto_engine
> > could only dequeue crypto_async_request and it is impossible to access any request_ctx
> > without knowing the underlying request type.
> > 
> > So I do something near that was requested: adding crypto_engine_reqctx in TFM context.
> > Note that the current implementation expect that crypto_engine_reqctx
> > is the first member of the context.
> > 
> > The first patch is a try to document the crypto engine API.
> > The second patch convert the crypto engine with the new way,
> > while the following patchs convert the 4 existing users of crypto_engine.
> > Note that this split break bisection, so probably the final commit will be all merged.
> > 
> > Appart from virtio, all 4 latest patch were compile tested only.
> > But the crypto engine is tested with my new sun8i-ce driver.
> > 
> > Regards
> > 
> > [1] https://www.mail-archive.com/linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg1474434.html
> > 
> > Changes since V1:
> > - renamed crypto_engine_reqctx to crypto_engine_ctx
> > - indentation fix in function parameter
> > - do not export crypto_transfer_request
> > - Add aead support
> > - crypto_finalize_request is now static
> > 
> > Changes since RFC:
> > - Added a documentation patch
> > - Added patch for stm32-cryp
> > - Changed parameter of all crypto_engine_op functions from
> > 	crypto_async_request to void*
> > - Reintroduced crypto_transfer_xxx_request_to_engine functions
> > 
> > Corentin Labbe (6):
> >   Documentation: crypto: document crypto engine API
> >   crypto: engine - Permit to enqueue all async requests
> >   crypto: omap: convert to new crypto engine API
> >   crypto: virtio: convert to new crypto engine API
> >   crypto: stm32-hash: convert to the new crypto engine API
> >   crypto: stm32-cryp: convert to the new crypto engine API
> 
> All applied.  Thanks.

Hello

As mentionned in the cover letter, all patchs (except documentation one) should be squashed.
A kbuild robot reported a build error on cryptodev due to this.

Regards
