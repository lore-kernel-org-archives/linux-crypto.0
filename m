From: Will Thomas <will.thomas@imgtec.com>
Subject: Re: [PATCH 2/6] crypto: img-hash - Fix hash request context
Date: Wed, 13 Jul 2016 15:45:15 +0100
Message-ID: <578653FB.1020809@imgtec.com>
References: <20160712074300.GA29696@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:45530 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbcGMOpX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jul 2016 10:45:23 -0400
In-Reply-To: <20160712074300.GA29696@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/07/16 08:43, Herbert Xu wrote:
> Will Thomas <will.thomas@imgtec.com> wrote:
>> Move 0 length buffer to end of structure to stop overwriting
>> fallback request data. This doesn't cause a bug itself as the
>> buffer is never used alongside the fallback but should be
>> changed.
>>
>> Signed-off-by: Will Thomas <will.thomas@imgtec.com>
>> Reviewed-by: James Hartley <james.hartley@imgtec.com>
> 
> This points out another bug, the fallback can have its own ctx
> following the request.
> 
> So the set_reqsize call needs to be adjusted to take that into
> account.

Will be an additional patch in v2 to fix this.

Thanks,
Will
