From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: Git bisected regression for ipsec/aead
Date: Sat, 27 Aug 2016 06:13:11 -0400
Message-ID: <20160827101311.GU28329@oracle.com>
References: <20160819192124.GF25320@oracle.com>
 <20160825084951.GA11496@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, joshua.a.hay@intel.com,
        steffen.klassert@secunet.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26837 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750825AbcH0KO0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Aug 2016 06:14:26 -0400
Content-Disposition: inline
In-Reply-To: <20160825084951.GA11496@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (08/25/16 16:49), Herbert Xu wrote:
> 
> On Fri, Aug 19, 2016 at 03:21:24PM -0400, Sowmini Varadhan wrote:
> >    7271b33cb87e80f3a416fb031ad3ca87f0bea80a is the first bad commit

> This bisection doesn't make much sense as this patch just causes
> cryptd to be used a little more more frequently.  But it does
> point the finger at cryptd.

On additional testing, I think this might be related to some
subtle race/timing issue so that git-bisect may not necessarily
be able to pin-point the correct bad-commit: if I add a few 
printks in other parts of the IPsec stack (and change the timing), 
the problem does not reproduce. Let me try to collect more data
on this. 

Meanwhile, if you can see some bug in the commit above, then
it probably makes sense to fix it upstream anyway.

--Sowmini
