From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: Git bisected regression for ipsec/aead
Date: Thu, 25 Aug 2016 11:45:19 -0400
Message-ID: <20160825154519.GD10892@oracle.com>
References: <20160819192124.GF25320@oracle.com>
 <20160825084951.GA11496@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, joshua.a.hay@intel.com,
        steffen.klassert@secunet.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20123 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753525AbcHYPpj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2016 11:45:39 -0400
Content-Disposition: inline
In-Reply-To: <20160825084951.GA11496@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (08/25/16 16:49), Herbert Xu wrote:
> This bisection doesn't make much sense as this patch just causes
> cryptd to be used a little more more frequently.  But it does
> point the finger at cryptd.
    :
> So we have list corruption here, possibly caused by use-after-free.
> I did spot one bug in the AEAD cryptd path where we end up using
> the wrong tfm to track refcnt.
> 
> Does this patch help?

Unfortunately no, I still see the panic.

--Sowmini
