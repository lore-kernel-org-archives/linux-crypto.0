From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 2/2] crypto: omap: convert to the new cryptoengine API
Date: Mon, 30 May 2016 15:38:45 +0200
Message-ID: <20160530133845.GA15370@Red>
References: <1463563285-11742-1-git-send-email-clabbe.montjoie@gmail.com>
 <1463563285-11742-3-git-send-email-clabbe.montjoie@gmail.com>
 <CAMz4kuJuR+UOTxA8y3em9tevubZZaFLpwCkXNsMQy1dJAPV=XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Baolin Wang <baolin.wang@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMz4kuJuR+UOTxA8y3em9tevubZZaFLpwCkXNsMQy1dJAPV=XQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, May 30, 2016 at 10:20:01AM +0800, Baolin Wang wrote:
> On 18 May 2016 at 17:21, LABBE Corentin <clabbe.montjoie@gmail.com> wrote:
> > Since the crypto engine has been converted to use crypto_async_request
> > instead of ablkcipher_request, minor changes are needed to use it.
> 
> I think you missed the conversion for omap des driver, please rebase
> your patch. Beyond that I think you did a good job for crypto engine
> if Herbert applied it.
> 

Thanks
I have just rebased it and added omap-des to the list of changes.

Regards
