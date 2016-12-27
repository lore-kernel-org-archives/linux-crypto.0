From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [sparc64] cryptomgr_test OOPS kernel 4.9.0+
Date: Tue, 27 Dec 2016 17:52:41 +0800
Message-ID: <20161227095241.GA10547@gondor.apana.org.au>
References: <CADxRZqwxU+XjTe+jwfrDdsp7Vs47YsJHww3=bsENhrUsYgHvkg@mail.gmail.com>
 <20161226.172619.1321397093716823099.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: matorola@gmail.com, linux-crypto@vger.kernel.org,
        sparclinux@vger.kernel.org, giovanni.cabiddu@intel.com
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59061 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751083AbcL0Jxd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 04:53:33 -0500
Content-Disposition: inline
In-Reply-To: <20161226.172619.1321397093716823099.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 26, 2016 at 05:26:19PM -0500, David Miller wrote:
> From: Anatoly Pugachev <matorola@gmail.com>
> Date: Sun, 25 Dec 2016 20:56:08 +0300
> 
> > Disabling kernel config option
> > CRYPTO_MANAGER_DISABLE_TESTS
> > i.e. enable run-time self tests, makes kernel unbootable:
> > 
> > tested with git kernels v4.9-8648-g5cc60aeedf31 and v4.9-12259-g7c0f6ba682b9
> 
> I think the testing code for the new synchronous compression module is
> putting kernel image pointers into scatterlists, which in turn we
> attempt to transform to and from page structs.
> 
> That doesn't work.
> 
> It's coming from the test input buffers:
> 
> static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
> 		      struct comp_testvec *dtemplate, int ctcount, int dtcount)
> {
>  ...
> 		sg_init_one(&src, ctemplate[i].input, ilen);
> 
> These have to be copied into kmalloc() buffers or similar, just like
> the skchiper tests do.
> 
> The crash on sparc64 shows that we try to dereference a page struct at
> a bogus vmemmap address for a page that doesn't exist.
> 
> I hacked up the following and this makes the crashes go away:

Thanks Dave.  I've just applied the patch

	https://patchwork.kernel.org/patch/9483763/

which should fix this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
