From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Wed, 28 Sep 2016 10:44:46 +0800
Message-ID: <20160928024446.GA14034@gondor.apana.org.au>
References: <450861381.1559123.1474673197124.JavaMail.zimbra@redhat.com>
 <1655600242.1561022.1474676547316.JavaMail.zimbra@redhat.com>
 <20160926145934.GA5520@gondor.apana.org.au>
 <20160926174317.GA21317@gallifrey>
 <20160927030826.GB8579@gondor.apana.org.au>
 <346154437.225735.1474966863173.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marcelo Cerri <marcelo.cerri@canonical.com>,
        rui y wang <rui.y.wang@intel.com>,
        mhcerri@linux.vnet.ibm.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Jan Stancek <jstancek@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49604 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753937AbcI1CpM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2016 22:45:12 -0400
Content-Disposition: inline
In-Reply-To: <346154437.225735.1474966863173.JavaMail.zimbra@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 27, 2016 at 05:01:03AM -0400, Jan Stancek wrote:
> 
> Also, does that mean that padlock_sha has similar problem?
> It does not seem to reserve any space for fallback __ctx and it calls
> init()/update()/export() with padlock_sha_desc's fallback:
> 
> struct padlock_sha_desc {
>         struct shash_desc fallback;
> };
> 
> static struct shash_alg sha1_alg = {
>         .descsize       =       sizeof(struct padlock_sha_desc),

Actually I was wrong when I said that the API couldn't handle
a dynamic fallback.  It can and padlock-sha does the right thing
by updating descsize in the cra_init function.

So this is what vmx should do too.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
