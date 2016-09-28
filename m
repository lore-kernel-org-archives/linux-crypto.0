From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Wed, 28 Sep 2016 20:44:52 +0800
Message-ID: <20160928124452.GA21011@gondor.apana.org.au>
References: <20160926145934.GA5520@gondor.apana.org.au>
 <20160926174317.GA21317@gallifrey>
 <20160927030826.GB8579@gondor.apana.org.au>
 <346154437.225735.1474966863173.JavaMail.zimbra@redhat.com>
 <20160927120414.GC21317@gallifrey>
 <20160927194644.GB15729@gallifrey>
 <20160928024549.GB14034@gondor.apana.org.au>
 <1597189480.51836.1475048451846.JavaMail.zimbra@redhat.com>
 <20160928122935.GA20839@gondor.apana.org.au>
 <20160928123841.GD15729@gallifrey>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Stancek <jstancek@redhat.com>,
        rui y wang <rui.y.wang@intel.com>,
        mhcerri@linux.vnet.ibm.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Marcelo Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44642 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752339AbcI1MpZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 08:45:25 -0400
Content-Disposition: inline
In-Reply-To: <20160928123841.GD15729@gallifrey>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 28, 2016 at 09:38:41AM -0300, Marcelo Cerri wrote:
> 
> The patch forces ghash-generic as the fallback. And I don't think that
> is a big problem if we decide to go by this path.

Right it should work but could break for example if we ever decide
to change the exported state structure for ghash and someone unloads
the ghash-generic module and reloads a new one.

> That would be nice because it would allow p8_ghash to keep using a
> dynamic fallback, but I'm not that is viable. What do you think?

We did it for SHA because it was desirable to have multiple
fallbacks, i.e., a generic C version plus an assembly-optimised
version.

Not sure whether the same motiviation exists for GHASH.

> > Otherwise we can go back to allocating just ghash-generic and
> > also move its data structure into an exported header file.
> > 
> 
> That would make the fix much more simple and it wouldn't require to get
> the fallback descsize at runtime.

This is the easiest fix so let's go with this now.  If we ever
care enough to have multiple fallbacks for GHASH we can always
revisit this.  The exported format is not exposed to user-space
so it can always be changed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
