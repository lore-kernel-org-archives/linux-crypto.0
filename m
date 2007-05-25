From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 25 May 2007 21:01:33 +1000
Message-ID: <20070525110133.GA28366@gondor.apana.org.au>
References: <20070522125828.GB8424@2ka.mipt.ru> <20070525081417.GA26691@gondor.apana.org.au> <20070525085509.GA3808@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4045 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753437AbXEYLBg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2007 07:01:36 -0400
Content-Disposition: inline
In-Reply-To: <20070525085509.GA3808@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Evgeniy:

On Fri, May 25, 2007 at 12:55:10PM +0400, Evgeniy Polyakov wrote:
> 
> Well, it is just hardware queue increase, so essentially for correct
> work it should return -EBUSY in case driver does not accept requests
> anymore (no matter if they are pushed into hardware or linked into
> backlog queue). According to sleeping with CRYPTO_TFM_REQ_MAY_BACKLOG -
> what about ipsec, where it is not allowed to sleep?
> dm-crypt as the only user of async cryptoapi is allowed to sleep, but
> I'm sure eventually ipsec will be converted (or heavily
> hacked/uglymoroned like I did in acrypto) into async mode too, but
> netowrk processing does not sleep at all. I do not think creating
> dedicated thread for ipsec processing is a good idea, but who knows...

IPsec simply wouldn't use CRYPTO_TFM_REQ_MAY_BACKLOG.  It would instead
drop the packet if the queue is full.

The CRYPTO_TFM_REQ_MAY_BACKLOG flag is used in situations where you
absolutely must queue at least one request (per tfm) and you're able
to either sleep or otherwise block further requests from being issued.
 
> I mostly worry about allocation/freeing/init code amount, memory 
> overhead is not that big, since amount of devices is limited.
> One says lazyness is a progress engine, but somtimes I do not agree :)

Perhaps I'm not understanding it correctly.  As far as I can see
you should be able to use a single function to serve all these
algorithms, no?

Anyway, let me know if it does turn out to be overly difficult and
we can always change things around.

> > > Current driver only supports AES ECB encrypt/decrypt, since I do not 
> > > know how to detect operation mode in runtime (a question).
> > 
> > For each incoming request you have an associated tfm object which has
> > a link to the algorithm object.  The algorithm object provides you
> > the info you need to know which algorithm to use and the tfm object
> > provides the session-specific information which would be the key for
> > ciphers.
> 
> That is how crypto processing is being done, but there is no information
> about how blocks are managed, i.e. were they chained into cbc or just
> one-by-one in ecb. As far as I can see, there is no such knowledge until
> algorithm was registered with new syle scheme with ecb(algo)/cbc(algo)
> strings and so on, in that case there are different strings and/or
> function pointers.

Have a look at padlock-aes/s390 where they handle pretty much the same
thing.  For HIFN I'd suggest that the entry (i.e., the encrypt/decrypt
hooks that the crypto API calls) function supply the mode and any other
algorithm-specific information before calling a generic function.

For example,

static int hifn_encrypt(int mode, struct ablkcipher_request *req)
{
	...do whatever it does now except for setting the mode...
}

static int hifn_get_key_size(struct ablkcipher_request *req)
{
	struct hifn_device *dev = ablkcipher_request_ctx(req);
	
	switch (dev->current_key_len) {
	case 128:
		return HIFN_CRYPT_CMD_KSZ_128;
	case 192:
		return HIFN_CRYPT_CMD_KSZ_192;
	case 256:
		return HIFN_CRYPT_CMD_KSZ_256;
	}

	BUG();
}

static int hifn_cbc_aes_encrypt(struct ablkcipher_request *req)
{
	return hifn_encrypt(HIFN_CRYPT_CMD_MODE_CBC | HIFN_CRYPT_CMD_ALG_AES |
			    hifn_get_key_size(req), req);
}

static int hifn_ecb_aes_encrypt(struct ablkcipher_request *req)
{
	return hifn_encrypt(HIFN_CRYPT_CMD_MODE_ECB | HIFN_CRYPT_CMD_ALG_AES |
			    hifn_get_key_size(req), req);
}

Right now the size is not specific to the algorithm.  If it were then
you could simply or the approriate bit here too.

> > Indeed users should not call setkey while there are still outstanding
> > operations.
> 
> Hmm, in that case all setkey operations must be protected against
> appropriate crypto processing ones, but I do not see if it is ever done
> in any driver. Probably they rely on higher layer not to call setkey
> simultaneously with encrypt/decrypt (this assumption correct for both
> ipsec and dm-crypt), but what if another kernel module will use them?

What I meant is that the crypto user should *never* invoke setkey while
there are outstanding requests.  So if it does happen it's OK for you
to return corrupted/unexpected output, or just BUG.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
