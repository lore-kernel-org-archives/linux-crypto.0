From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Wed, 28 Sep 2016 20:29:35 +0800
Message-ID: <20160928122935.GA20839@gondor.apana.org.au>
References: <450861381.1559123.1474673197124.JavaMail.zimbra@redhat.com>
 <20160926145934.GA5520@gondor.apana.org.au>
 <20160926174317.GA21317@gallifrey>
 <20160927030826.GB8579@gondor.apana.org.au>
 <346154437.225735.1474966863173.JavaMail.zimbra@redhat.com>
 <20160927120414.GC21317@gallifrey>
 <20160927194644.GB15729@gallifrey>
 <20160928024549.GB14034@gondor.apana.org.au>
 <1597189480.51836.1475048451846.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marcelo Cerri <marcelo.cerri@canonical.com>,
        rui y wang <rui.y.wang@intel.com>,
        mhcerri@linux.vnet.ibm.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Jan Stancek <jstancek@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56446 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932298AbcI1MaG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 08:30:06 -0400
Content-Disposition: inline
In-Reply-To: <1597189480.51836.1475048451846.JavaMail.zimbra@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 28, 2016 at 03:40:51AM -0400, Jan Stancek wrote:
> 
> Thanks for clearing up how this works in padlock-sha, but
> we are not exactly in same situation with p8_ghash.
> 
> p8_ghash_init_tfm() already updates descsize. Problem in original report
> is that without custom export/import/statesize p8_ghash_alg.statesize
> gets initialized by shash_prepare_alg() to alg->descsize:

Right.

> so I think we need either:
> 1) make sure p8_ghash_alg.descsize is correct before we register shash,
>    this is what Marcelo's last patch is doing

This approach doesn't work because there is no guarantee that
you'll get the same fallback the next time you allocate a tfm.
So relying on the descsize being constant can only work if all
implementations of the fallback use the same desc struct.

> 2) provide custom export/import/statesize for p8_ghash_alg

This works for padlock-sha because every implementation of SHA
uses the same state data structure from sha.h.  If we can make
all implementations of ghash agree on the exported state then
we can use the same approach.

Otherwise we can go back to allocating just ghash-generic and
also move its data structure into an exported header file.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
