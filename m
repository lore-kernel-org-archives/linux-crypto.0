From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: Re: crypto: hang in crypto_larval_lookup
Date: Fri, 24 Feb 2017 12:21:23 +0100
Message-ID: <5a74062f-0138-de29-a887-226f7b1a89a7@linux.vnet.ibm.com>
References: <02b80c39-0fd5-b7bd-39da-07e5d71abbad@linux.vnet.ibm.com>
 <20170223111957.GA14000@gondor.apana.org.au>
 <20170223113909.GA14090@gondor.apana.org.au>
 <d7cc7cd8-3632-2508-9931-a5e0875a54cd@linux.vnet.ibm.com>
 <5e3fb7fe-2229-d098-139a-7d749de8ff73@linux.vnet.ibm.com>
 <66fa483d-9961-728a-b147-46036bd6557b@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, schwidefsky@de.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46097 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751084AbdBXLVf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Feb 2017 06:21:35 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1OBJaI7103620
        for <linux-crypto@vger.kernel.org>; Fri, 24 Feb 2017 06:21:35 -0500
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28t0aw8kyb-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 24 Feb 2017 06:21:34 -0500
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.vnet.ibm.com>;
        Fri, 24 Feb 2017 11:21:32 -0000
In-Reply-To: <66fa483d-9961-728a-b147-46036bd6557b@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/24/2017 11:32 AM, Harald Freudenberger wrote:
> On 02/24/2017 09:42 AM, Harald Freudenberger wrote:
...
>> ...
>> Feb 24 09:28:10 r35lp49 kernel: ->crypto_larval_lookup(name=aes,type=0x00000405,mask=0x0000248c)
>> Feb 24 09:28:10 r35lp49 kernel:   crypto_larval_lookup calling crypto_alg_lookup(aes,0x00000405,0x0000248c)
>> Feb 24 09:28:10 r35lp49 kernel: ->__crypto_alg_lookup(name=aes)
>> Feb 24 09:28:10 r35lp49 kernel: <-__crypto_alg_lookup(name=aes) alg=          (null)
>> Feb 24 09:28:10 r35lp49 kernel:   crypto_larval_lookup calling request_module(crypto-aes)
>> Feb 24 09:28:10 r35lp49 kernel:   crypto_larval_lookup calling request_module(crypto-aes-all)
>>
>> type=0x00000405 = CRYPTO_ALG_TESTED, CRYPTO_ALG_TYPE_SKCIPHER
>> mask=0x0000248c = CRYPTO_ALG_INTERNAL, CRYPTO_ALG_TESTED, CRYPTO_ALG_ASYNC, CRYPTO_ALG_TYPE_BLKCIPHER_MASK
>>
> I catched it: Thanks Herbert for your hint. The aes algorith registers with:
>   .cra_flags = CRYPTO_ALG_TYPE_CIPHER |CRYPTO_ALG_NEED_FALLBACK
> so later at __crypto_alg_lookup(aes, 0x0405, 0x248c)
> this alg is not choosen because the check
>   if ((q->cra_flags ^ type) & mask)
> is true q->cra_flags = 0x0501 ^ 0x0405 & 0x248x => 0x0004
>
> @Martin, I'll commit a patch asap.
>
> Thanks for your help :-)
>
> regards, H.Freudenberger
>
rollback. Changing the cra_flag CRYPTO_ALG_TYPE_SKCIPHER in the crypto_alg
registration struct is not the right way.
continuing evaluation ...
