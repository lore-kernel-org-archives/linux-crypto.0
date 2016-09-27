From: Jan Stancek <jstancek@redhat.com>
Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Tue, 27 Sep 2016 05:01:03 -0400 (EDT)
Message-ID: <346154437.225735.1474966863173.JavaMail.zimbra@redhat.com>
References: <450861381.1559123.1474673197124.JavaMail.zimbra@redhat.com> <1655600242.1561022.1474676547316.JavaMail.zimbra@redhat.com> <20160926145934.GA5520@gondor.apana.org.au> <20160926174317.GA21317@gallifrey> <20160927030826.GB8579@gondor.apana.org.au>
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
Received: from mx3-phx2.redhat.com ([209.132.183.24]:58436 "EHLO
        mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753669AbcI0JB0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2016 05:01:26 -0400
In-Reply-To: <20160927030826.GB8579@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>





----- Original Message -----
> From: "Herbert Xu" <herbert@gondor.apana.org.au>
> To: "Marcelo Cerri" <marcelo.cerri@canonical.com>
> Cc: "Jan Stancek" <jstancek@redhat.com>, "rui y wang" <rui.y.wang@intel.com>, mhcerri@linux.vnet.ibm.com,
> leosilva@linux.vnet.ibm.com, pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
> linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
> Sent: Tuesday, 27 September, 2016 5:08:26 AM
> Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
> 
> On Mon, Sep 26, 2016 at 02:43:17PM -0300, Marcelo Cerri wrote:
> > 
> > Wouldn't be enough to provide a pair of import/export functions as the
> > padlock-sha driver does?
> 
> I don't think that will help as ultimately you need to call the
> export function on the fallback and that's what requires the extra
> memory.  In fact very operation involving the fallback will need
> that extra memory too.

So, if we extended p8_ghash_desc_ctx to accommodate fallback_desc's ctx
and then provided statesize/import/export, would that be acceptable?

struct p8_ghash_desc_ctx {
        ...
        struct shash_desc fallback_desc;
+       char fallback_ctx[sizeof(struct ghash_desc_ctx)];


Also, does that mean that padlock_sha has similar problem?
It does not seem to reserve any space for fallback __ctx and it calls
init()/update()/export() with padlock_sha_desc's fallback:

struct padlock_sha_desc {
        struct shash_desc fallback;
};

static struct shash_alg sha1_alg = {
        .descsize       =       sizeof(struct padlock_sha_desc),

Regards,
Jan

> 
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
