From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1 take 2] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Tue, 5 Jun 2007 17:07:31 +0400
Message-ID: <20070605130731.GA4643@2ka.mipt.ru>
References: <20070604134248.GA9645@2ka.mipt.ru> <20070605125604.GA16327@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:58656 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758213AbXFENIA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jun 2007 09:08:00 -0400
Content-Disposition: inline
In-Reply-To: <20070605125604.GA16327@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Sebastian.

On Tue, Jun 05, 2007 at 02:56:04PM +0200, Sebastian Siewior (linux-crypto@ml.breakpoint.cc) wrote:
> * Evgeniy Polyakov | 2007-06-04 17:42:48 [+0400]:
> 
> >+struct hifn_device
> >+{
> >+	struct pci_dev		*pdev;
> >+ 	spinlock_t              lock;
> >+	u8			current_key[HIFN_MAX_CRYPT_KEY_LENGTH];
> >+	int			current_key_len;
> >+	struct list_head	alg_list;
> >+};
> ...
> This struct looks to me like one per real hardware. What are you doing
> if you get two+ crypto users? Or is this struct one per crypto user?
> This is what gets allocated by crypto api for every user.

This is tricky, hifn requires to have a key per crypto setup, so this
one must be in a crypto context, but context is not used right now, so
yes, it supports only one user. I will update it to use context, since
it is smaller that hifn_device.

> >+static void hifn_work(struct work_struct *);
> >+
> >+static int hifn_start_device(struct hifn_device *dev)
> >+{
> ...
> >+	INIT_DELAYED_WORK(&dev->work, hifn_work);
> >+	schedule_delayed_work(&dev->work, HZ);
> >+	
> >+	return 0;
> >+}
> ...
> >+static irqreturn_t hifn_interrupt(int irq, void *data)
> ...
> This looks to me like you have to reset the hardware once in a while.
> The worker func and the interrupt handler are the only two functions
> (exept hifn_remove()) that know about your hardware at run time.

It is a watchdog worker, it checks if there were sessions setup, and if
they were not ready when watchdog fired, it resets hardware and
completes appropriate requests with error.

> >+static int hifn_setkey(struct crypto_ablkcipher *cipher, const u8 *key, unsigned int len)
> >+{
> >+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
> >+	struct hifn_device *dev = crypto_tfm_ctx(tfm);
> >+
> >+	if (len > HIFN_MAX_CRYPT_KEY_LENGTH)
> >+		return -1;
> >+
> >+	if (!memcmp(dev->current_key, key, len)) {
> >+		dev->flags |= HIFN_FLAG_OLD_KEY;
> >+		return 0;
> >+	}
> >+
> >+	dev->flags &= ~HIFN_FLAG_OLD_KEY;
> >+
> >+	memcpy(dev->current_key, key, len);
> >+	dev->current_key_len = len;
> >+
> >+	return 0;
> >+}
> ...
> dev is allocated by the crypto API but isn't initialized right? Nothing
> points to your real hw right?
> I (in my case) assign directly key ctx to hw ctx in set_key. This is
> crap because more than just one hw could exist. The API chooses the
> algo with the highest prio so you can't use more than one device.
> A load balancer could be the person in charge for assigning hw ctx to
> crypto user ctx. 

I should use crypto context here, it will hosts a pointer to hifn device
and key, so far key is stored in hifn_device, which is one per HIFN cpu.
Yes, I know, it is not the right way to do it.
Context should contain pointer to hardware structure and keys.

> >+static inline int hifn_encrypt_aes_ecb_16(struct ablkcipher_request *req)
> >+{
> >+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_ECB);
> >+}
> ...
> This is what I had in mind, as I said look on my skeleton, than you will
> see how you can distinguish which algo is requested. Since you have 12
> algos I understand now what you meant with "it doesn't" and your cat :)

HIFN also supports hashes, compressions and multiplication operations... 
This will look so horrible, that people will commit suicide, when are trying
to fix something in such driver.

> Sebastian

-- 
	Evgeniy Polyakov
