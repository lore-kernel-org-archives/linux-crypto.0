From: roel kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] geode: Fix cip/blk confusion
Date: Fri, 29 Jan 2010 16:20:02 +0100
Message-ID: <25e057c01001290720k529a5ee3i6bef74c9217abbf8@mail.gmail.com>
References: <4B62E388.1070707@gmail.com> <20100129145152.GA31953@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Sergey Mironov <ierton@gmail.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61742 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0A2PUZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jan 2010 10:20:25 -0500
In-Reply-To: <20100129145152.GA31953@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 29, 2010 at 3:51 PM, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> * Roel Kluin | 2010-01-29 14:32:56 [+0100]:
>
>>This was already discussed in december/januari but I still cannot find it in
>>mainline, was it lost?
>
> Isn't this patch [0] and [1] in Herbert's tree? If so Herbert is
> probably going to merge in the next merge window because it is not
> urgend enough.
>
> [0] http://git.kernel.org/?p=linux/kernel/git/herbert/cryptodev-2.6.git;a=commit;h=faad98f29606d9d3c6bddae7c88693be37d2fb43
> [1] http://git.kernel.org/?p=linux/kernel/git/herbert/cryptodev-2.6.git;a=commit;h=d7ac769068df87ca8c7f72d99cf67ead16739f18

Yes that are the patches, however, I think my previous patch missed one
blk to cip conversion in geode_setkey_cip():

       ret = crypto_cipher_setkey(op->fallback.cip, key, len);
       if (ret) {
               tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-               tfm->crt_flags |= (op->fallback.blk->base.crt_flags &
CRYPTO_TFM_RES_MASK);
+               tfm->crt_flags |= (op->fallback.cip->base.crt_flags &
CRYPTO_TFM_RES_MASK);
       }
       return ret;
 }

Roel
