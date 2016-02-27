From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 1/4] crypto: algif_skcipher - Require setkey before
 accept(2)
Date: Sat, 27 Feb 2016 16:40:54 -0500
Message-ID: <56D217E6.4090208@oracle.com>
References: <56D0361B.8040301@gmail.com>
 <1456487051-14652-1-git-send-email-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
To: Milan Broz <gmazyland@gmail.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40526 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbcB0VlA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2016 16:41:00 -0500
In-Reply-To: <1456487051-14652-1-git-send-email-gmazyland@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/26/2016 06:44 AM, Milan Broz wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> 
>     commit dd504589577d8e8e70f51f997ad487a4cb6c026f upstream.
> 
>     Some cipher implementations will crash if you try to use them
>     without calling setkey first.  This patch adds a check so that
>     the accept(2) call will fail with -ENOKEY if setkey hasn't been
>     done on the socket yet.
> 
>     Cc: stable@vger.kernel.org
>     Reported-by: Dmitry Vyukov <dvyukov@google.com>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>     Tested-by: Dmitry Vyukov <dvyukov@google.com>
>     [backported to 4.1 by Milan Broz <gmazyland@gmail.com>]

Thanks Milan. Can I add your Signed-off-by to this series?


Thanks,
Sasha
