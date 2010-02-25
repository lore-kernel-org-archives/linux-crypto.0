From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in
	sha1_update()
Date: Thu, 25 Feb 2010 18:16:59 +0200
Message-ID: <84144f021002250816o2c2cef0fke484c7e43256dba4@mail.gmail.com>
References: <4B8692E3.9030509@gmail.com>
	 <19334.40337.651079.440912@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Roel Kluin <roel.kluin@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51233 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab0BYQRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2010 11:17:04 -0500
In-Reply-To: <19334.40337.651079.440912@pilspetsen.it.uu.se>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 25, 2010 at 5:56 PM, Mikael Pettersson <mikpe@it.uu.se> wro=
te:
> I fear that the only portable (across compiler versions) and safe
> solution is to invoke an assembly-coded dummy function with prototype
>
> =A0 =A0 =A0 =A0void use(void *p);
>
> and rewrite the code above as
>
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u32 temp[...];
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0...
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memset(temp, 0, sizeof temp);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0use(temp);
> =A0 =A0 =A0 =A0}
>
> This forces the compiler to consider the buffer live after the
> memset, so the memset cannot be eliminated.

So is there some "do not optimize" GCC magic that we could use for a
memzero_secret() helper function?

                        Pekka
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
