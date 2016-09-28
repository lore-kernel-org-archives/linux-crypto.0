From: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Wed, 28 Sep 2016 10:22:51 -0300
Message-ID: <20160928132251.GB5010@dublin>
References: <1655600242.1561022.1474676547316.JavaMail.zimbra@redhat.com>
 <20160926145934.GA5520@gondor.apana.org.au>
 <20160926174317.GA21317@gallifrey>
 <20160927030826.GB8579@gondor.apana.org.au>
 <346154437.225735.1474966863173.JavaMail.zimbra@redhat.com>
 <20160927120414.GC21317@gallifrey>
 <20160927194644.GB15729@gallifrey>
 <20160928024549.GB14034@gondor.apana.org.au>
 <20160928122844.GC15729@gallifrey>
 <20160928123318.GB20839@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marcelo Cerri <marcelo.cerri@canonical.com>,
        Jan Stancek <jstancek@redhat.com>,
        rui y wang <rui.y.wang@intel.com>,
        mhcerri@linux.vnet.ibm.com, leosilva@linux.vnet.ibm.com,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38011 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932362AbcI1NXI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 09:23:08 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8SDN6vx104400
        for <linux-crypto@vger.kernel.org>; Wed, 28 Sep 2016 09:23:07 -0400
Received: from e24smtp03.br.ibm.com (e24smtp03.br.ibm.com [32.104.18.24])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25rb094hpw-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 28 Sep 2016 09:23:07 -0400
Received: from localhost
        by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <pfsmorigo@linux.vnet.ibm.com>;
        Wed, 28 Sep 2016 10:23:04 -0300
Content-Disposition: inline
In-Reply-To: <20160928123318.GB20839@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Wed, Sep 28, 2016 at 08:33:18PM +0800, Herbert Xu wrote:
> On Wed, Sep 28, 2016 at 09:28:44AM -0300, Marcelo Cerri wrote:
> >
> > The big difference between p8_ghash and padlock_sha1 is that
> > padlock_sha1 defines alg->statesize as sizeof(struct sha1_state), which
> > is the descsize value used by sha1_generic. This probably works but
> > it's also wrong because the padlock_sha1 driver does not ensures that
> > sha1_generic is always used.
> 
> It should work because all our SHA implementations use the same
> export format.  This is not necessarily the case for GHASH though.
> 
> > So, one solution is to hardcode ghash-generic as the fallback algorithm
> > and update the descsize direct in its shash_alg structure. There's only
> > one problem with that. ghash-generic desc type (struct ghash_desc_ctx)
> > is not available for vmx_crypto at compile type, the type is defined
> > directly in crypto/ghash-generic.c. That's the reason I added a function
> > to get the fallback desc size at runtime in the patch I wrote as a prove
> > of concept.
> 
> The problem with your patch is that there is no guarantee that
> you will get the same algorithm every time you allocate a fallback.
> Someone may have loaded a new module for example.
> 
> So I think the safe approach is to stick with ghash-generic and
> expose its state data structure in a header file.

Since generic is the only posible fallback for ppc, I think that's a
good solution. :)

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 

-- 
Paulo Flabiano Smorigo
IBM Linux Technology Center
