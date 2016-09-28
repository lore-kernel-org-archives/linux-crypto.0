From: Jan Stancek <jstancek@redhat.com>
Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Wed, 28 Sep 2016 03:40:51 -0400 (EDT)
Message-ID: <1597189480.51836.1475048451846.JavaMail.zimbra@redhat.com>
References: <450861381.1559123.1474673197124.JavaMail.zimbra@redhat.com> <20160926145934.GA5520@gondor.apana.org.au> <20160926174317.GA21317@gallifrey> <20160927030826.GB8579@gondor.apana.org.au> <346154437.225735.1474966863173.JavaMail.zimbra@redhat.com> <20160927120414.GC21317@gallifrey> <20160927194644.GB15729@gallifrey> <20160928024549.GB14034@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Marcelo Cerri <marcelo.cerri@canonical.com>,
        rui y wang <rui.y.wang@intel.com>,
        mhcerri@linux.vnet.ibm.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:36313 "EHLO
        mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbcI1HlF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 03:41:05 -0400
In-Reply-To: <20160928024549.GB14034@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>





----- Original Message -----
> From: "Herbert Xu" <herbert@gondor.apana.org.au>
> To: "Marcelo Cerri" <marcelo.cerri@canonical.com>
> Cc: "Jan Stancek" <jstancek@redhat.com>, "rui y wang" <rui.y.wang@intel.com>, mhcerri@linux.vnet.ibm.com,
> leosilva@linux.vnet.ibm.com, pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
> linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
> Sent: Wednesday, 28 September, 2016 4:45:49 AM
> Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
> 
> On Tue, Sep 27, 2016 at 04:46:44PM -0300, Marcelo Cerri wrote:
> > 
> > Can you check if the problem occurs with this patch?
> 
> In light of the fact that padlock-sha is the correct example
> to follow, you only need to add one line to the init_tfm fucntion
> to update the descsize based on that of the fallback.

Thanks for clearing up how this works in padlock-sha, but
we are not exactly in same situation with p8_ghash.

p8_ghash_init_tfm() already updates descsize. Problem in original report
is that without custom export/import/statesize p8_ghash_alg.statesize
gets initialized by shash_prepare_alg() to alg->descsize:

crash> p p8_ghash_alg.statesize
$1 = 56

testmgr allocates space for export based on crypto_shash_statesize(),
but shash_default_export() writes based on crypto_shash_descsize():
[    8.297902] state: c0000004b873aa80, statesize: 56
[    8.297932] shash_default_export memcpy c0000004b873aa80 c0000004b8607da0, len: 76

so I think we need either:
1) make sure p8_ghash_alg.descsize is correct before we register shash,
   this is what Marcelo's last patch is doing
2) provide custom export/import/statesize for p8_ghash_alg

Regards,
Jan

> 
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
