From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] padata: Remove unused but set variables
Date: Tue, 25 Oct 2016 11:38:30 +0800
Message-ID: <20161025033830.GA18666@gondor.apana.org.au>
References: <20161021090047.GO19080@gauss.secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: tklauser@distanz.ch, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34435 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756551AbcJYDin (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Oct 2016 23:38:43 -0400
Content-Disposition: inline
In-Reply-To: <20161021090047.GO19080@gauss.secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Steffen Klassert <steffen.klassert@secunet.com> wrote:
> On Mon, Oct 17, 2016 at 12:16:08PM +0200, Tobias Klauser wrote:
>> Remove the unused but set variable pinst in padata_parallel_worker to
>> fix the following warning when building with 'W=1':
>> 
>>   kernel/padata.c: In function ‘padata_parallel_worker’:
>>   kernel/padata.c:68:26: warning: variable ‘pinst’ set but not used [-Wunused-but-set-variable]
>> 
>> Also remove the now unused variable pd which is only used to set pinst.
>> 
>> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> 
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
