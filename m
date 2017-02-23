From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: hang in crypto_larval_lookup
Date: Thu, 23 Feb 2017 19:39:09 +0800
Message-ID: <20170223113909.GA14090@gondor.apana.org.au>
References: <02b80c39-0fd5-b7bd-39da-07e5d71abbad@linux.vnet.ibm.com>
 <20170223111957.GA14000@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, schwidefsky@de.ibm.com
To: Harald Freudenberger <freude@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34955 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751032AbdBWLjR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2017 06:39:17 -0500
Content-Disposition: inline
In-Reply-To: <20170223111957.GA14000@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 23, 2017 at 07:19:57PM +0800, Herbert Xu wrote:
> Harald Freudenberger <freude@linux.vnet.ibm.com> wrote:
> > 
> > Hello all
> > 
> > I am currently following a hang at modprobe aes_s390 where
> > crypto_register_alg() does not come back for the xts(aes) algorithm.
> > 
> > The registration is waiting forever in algapi.c crypto_wait_for_test() but
> > the completion never occurs. The cryptomgr is triggering a test via
> > kthread_run to invoce cryptomgr_probe and this thread is calling the
> > create() function of the xts template (file xts.c). Following this thread
> > it comes down to api.c crypto_larval_lookup(name="aes") which is first
> > requesting the module "crypto-aes" via request_module() successful and then
> > blocking forever in requesting the module "crypto-aes-all".
> > 
> > The xts(aes) has at registration CRYPTO_ALG_NEED_FALLBACK flag on.
> > 
> > This problem is seen since about 6 weeks now, first only on the linux next
> > kernel. Now it appers on the 4.10-rc kernels as well. And I still have no
> > idea on how this could be fixed or what's wrong with just the xts
> > registration (ecb, cbc, ctr work fine).
> > 
> > Any ideas or hints?
> 
> Sorry, my fault.  I should've converted all the fallback users of
> the old blkcipher interface over to skcipher before converting the
> core algorithms to skcipher.
> 
> I'll send a patch.

Hmm, actually looks like I did convert this one :)

Do you have ECB enabled in your configuration? XTS doesn't work
without it.  Currently the Kconfig is missing a select on ECB so
it could stop the generic XTS from loading.

However, you seem to be stuck on straight AES which quite strange.
The reason is that s390 crypto registers AES as the first thing so
it should already be available.

The fact that it hangs is expected because it's trying to find
an acceptable AES implementation and in doing so it's loading
s390-aes again.

So we need to get to the bottom of why there is no acceptable
"aes" registered.  Can you check /proc/crypto to see if the simple
aes cipher is correctly registered (passing the selftest) after
it hangs?

You could also print out the type/mask in crypto_larval_lookup
to see if perhaps the caller is asking for something unreasonable.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
