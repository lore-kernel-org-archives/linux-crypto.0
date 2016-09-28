From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Wed, 28 Sep 2016 20:33:18 +0800
Message-ID: <20160928123318.GB20839@gondor.apana.org.au>
References: <450861381.1559123.1474673197124.JavaMail.zimbra@redhat.com>
 <1655600242.1561022.1474676547316.JavaMail.zimbra@redhat.com>
 <20160926145934.GA5520@gondor.apana.org.au>
 <20160926174317.GA21317@gallifrey>
 <20160927030826.GB8579@gondor.apana.org.au>
 <346154437.225735.1474966863173.JavaMail.zimbra@redhat.com>
 <20160927120414.GC21317@gallifrey>
 <20160927194644.GB15729@gallifrey>
 <20160928024549.GB14034@gondor.apana.org.au>
 <20160928122844.GC15729@gallifrey>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Stancek <jstancek@redhat.com>,
        rui y wang <rui.y.wang@intel.com>,
        mhcerri@linux.vnet.ibm.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Marcelo Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56586 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932179AbcI1Mdt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 08:33:49 -0400
Content-Disposition: inline
In-Reply-To: <20160928122844.GC15729@gallifrey>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 28, 2016 at 09:28:44AM -0300, Marcelo Cerri wrote:
>
> The big difference between p8_ghash and padlock_sha1 is that
> padlock_sha1 defines alg->statesize as sizeof(struct sha1_state), which
> is the descsize value used by sha1_generic. This probably works but
> it's also wrong because the padlock_sha1 driver does not ensures that
> sha1_generic is always used.

It should work because all our SHA implementations use the same
export format.  This is not necessarily the case for GHASH though.

> So, one solution is to hardcode ghash-generic as the fallback algorithm
> and update the descsize direct in its shash_alg structure. There's only
> one problem with that. ghash-generic desc type (struct ghash_desc_ctx)
> is not available for vmx_crypto at compile type, the type is defined
> directly in crypto/ghash-generic.c. That's the reason I added a function
> to get the fallback desc size at runtime in the patch I wrote as a prove
> of concept.

The problem with your patch is that there is no guarantee that
you will get the same algorithm every time you allocate a fallback.
Someone may have loaded a new module for example.

So I think the safe approach is to stick with ghash-generic and
expose its state data structure in a header file.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
