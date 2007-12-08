From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] Geode: Copy the IV back in case of an
	fallback.
Date: Sat, 8 Dec 2007 13:40:02 +0100
Message-ID: <20071208124002.GA1911@Chamillionaire.breakpoint.cc>
References: <20071207182405.GA24292@Chamillionaire.breakpoint.cc> <20071208014641.GC16140@gondor.apana.org.au>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36684 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753802AbXLHMkE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Dec 2007 07:40:04 -0500
Content-Disposition: inline
In-Reply-To: <20071208014641.GC16140@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2007-12-08 09:46:41 [+0800]:

>On Fri, Dec 07, 2007 at 07:24:05PM +0100, Sebastian Siewior wrote:
>> Jan pointed this out to me and fixed it in the fallback code for s390
>> and now I remembered that this could also be fixed here :)
>> 
>> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
>
>No, the default IV is put into desc->info by the system.
>
>I see where the problem is though.  We should never call the
>functions crypto_blkcipher_encrypt/decrypt, it should always be
>crypto_blkcipher_encrypt_iv/crypto_blkcipher_decrypt_iv.
>
>Please make a patch to get the fallback to do that.
Haven't seen that function before. Patch is on the way.

>Thanks,
Sebastian
