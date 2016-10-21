From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/6] chcr: Remove malloc/free
Date: Fri, 21 Oct 2016 10:20:38 +0800
Message-ID: <20161021022038.GB22485@gondor.apana.org.au>
References: <cover.1476263960.git.harsh@chelsio.com>
 <67f49fab047b0b97bac20493dc4414e27c637ab0.1476263960.git.harsh@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dan.carpenter@oracle.com, linux-crypto@vger.kernel.org,
        jlulla@chelsio.com, atul.gupta@chelsio.com, yeshaswi@chelsio.com,
        hariprasad@chelsio.com
To: Harsh Jain <harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47383 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbcJUCUn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2016 22:20:43 -0400
Content-Disposition: inline
In-Reply-To: <67f49fab047b0b97bac20493dc4414e27c637ab0.1476263960.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 13, 2016 at 04:39:35PM +0530, Harsh Jain wrote:
> Remove malloc/free in crypto operation and allocate memory via cra_ctxsize.
> Added new structure chcr_wr to populate Work Request Header.
> Fixes: 324429d74127 (chcr: Support for Chelsio's Crypto Hardware)

Do you mean the reqsize as opposed to ctxsize since the latter is
shared by all tfm users?

In any case, your patch doesn't seem to change the size setting?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
