From: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Subject: Re: vmx ghash buggy on ppc64le
Date: Mon, 16 Oct 2017 21:09:53 -0200
Message-ID: <20171016230953.GA13502@dublin>
References: <20170919031845.GA28732@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54324 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932760AbdJPXKS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Oct 2017 19:10:18 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9GN9UWF113917
        for <linux-crypto@vger.kernel.org>; Mon, 16 Oct 2017 19:10:18 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2dn1nq2reh-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 16 Oct 2017 19:10:17 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <pfsmorigo@linux.vnet.ibm.com>;
        Mon, 16 Oct 2017 17:10:17 -0600
Content-Disposition: inline
In-Reply-To: <20170919031845.GA28732@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tue, Sep 19, 2017 at 11:18:45AM +0800, Herbert Xu wrote:
> Hi:
> 
> I have received a report that ghash on ppc64le does not interoperate
> with other implementations of ghash, e.g., on x86-64.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1490972
> 
> Could you guys take a look at this and see if this is a bug in
> the mainline vmx driver too?
> 
> Thanks!
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 

Hi Herbert,

It seems that this bug is affected by the fact that ctr mode is using
blkcipher for the fallback.

I just sent a patch [1] to make it use skcipher and, since then, ipsec
with  ikev2 and ghash are working fine for ppc64 and ppc64le.

Best regards,

-- 
Paulo Flabiano Smorigo
IBM Linux Technology Center

[1] https://lkml.org/lkml/2017/10/16/911
