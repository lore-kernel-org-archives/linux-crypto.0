From: Harsh Jain <Harsh@chelsio.com>
Subject: Re: [PATCH 2/6] chcr: Remove malloc/free
Date: Wed, 26 Oct 2016 16:59:51 +0530
Message-ID: <365cdce2-9195-474d-1114-60772f3fc6b5@chelsio.com>
References: <cover.1476263960.git.harsh@chelsio.com>
 <67f49fab047b0b97bac20493dc4414e27c637ab0.1476263960.git.harsh@chelsio.com>
 <20161021022038.GB22485@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: dan.carpenter@oracle.com, linux-crypto@vger.kernel.org,
        jlulla@chelsio.com, atul.gupta@chelsio.com, yeshaswi@chelsio.com,
        hariprasad@chelsio.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:63550 "EHLO l.chelsio.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754802AbcJZLaN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2016 07:30:13 -0400
In-Reply-To: <20161021022038.GB22485@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 21-10-2016 07:50, Herbert Xu wrote:
> On Thu, Oct 13, 2016 at 04:39:35PM +0530, Harsh Jain wrote:
>> Remove malloc/free in crypto operation and allocate memory via cra_ctxsize.
>> Added new structure chcr_wr to populate Work Request Header.
>> Fixes: 324429d74127 (chcr: Support for Chelsio's Crypto Hardware)
> Do you mean the reqsize as opposed to ctxsize since the latter is
> shared by all tfm users?
It's reqsize for hash algos (chcr_ahash_req_ctx struct ) and ctxsize for Cipher algos(ablk_ctx struct),As rrkey(reverse round key) is also same for all tfm.
>
> In any case, your patch doesn't seem to change the size setting?
Added new variables in old structure. Size setting related code is unchanged.
In v2  will break the patch to smaller one.
>
> Cheers,
