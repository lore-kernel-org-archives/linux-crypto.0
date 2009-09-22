From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Padlock SHA1 failed at boot time
Date: Tue, 22 Sep 2009 10:17:16 -0700
Message-ID: <20090922171716.GA2977@gondor.apana.org.au>
References: <20090922015605.GA26922@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: technique@e-teleport.net, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36478 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751230AbZIVRRO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Sep 2009 13:17:14 -0400
Content-Disposition: inline
In-Reply-To: <20090922015605.GA26922@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu <herbert@gondor.apana.org.au> wrote:
>=20
> crypto: padlock-sha - Fix stack alignment
>=20
> The PadLock hardware requires the output buffer for SHA to be
> 128-bit aligned.  We currentply place the buffer on the stack,
> and ask gcc to align it to 128 bits.  That doesn't work on i386
> because the kernel stack is only aligned to 32 bits.  This patch
> changes the code to align the buffer by hand so that the hardware
> doesn't fault on unaligned buffers.
>=20
> Reported-by: S=E9guier R=E9gis <rguier@e-teleport.net>
> Tested-by: S=E9guier R=E9gis <rguier@e-teleport.net>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

=46or the record I modified the patch slightly to ensure that
we get the minimum alignment from gcc.

diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.=
c
index fe007b6..0af8057 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -70,7 +70,8 @@ static int padlock_sha1_finup(struct shash_desc *desc=
, const u8 *in,
 	/* We can't store directly to *out as it may be unaligned. */
 	/* BTW Don't reduce the buffer size below 128 Bytes!
 	 *     PadLock microcode needs it that big. */
-	char buf[128 + PADLOCK_ALIGNMENT - STACK_ALIGN];
+	char buf[128 + PADLOCK_ALIGNMENT - STACK_ALIGN] __attribute__
+		((aligned(STACK_ALIGN)));
 	char *result =3D PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
 	struct padlock_sha_desc *dctx =3D shash_desc_ctx(desc);
 	struct sha1_state state;
@@ -135,7 +136,8 @@ static int padlock_sha256_finup(struct shash_desc *=
desc, const u8 *in,
 	/* We can't store directly to *out as it may be unaligned. */
 	/* BTW Don't reduce the buffer size below 128 Bytes!
 	 *     PadLock microcode needs it that big. */
-	char buf[128 + PADLOCK_ALIGNMENT - STACK_ALIGN];
+	char buf[128 + PADLOCK_ALIGNMENT - STACK_ALIGN] __attribute__
+		((aligned(STACK_ALIGN)));
 	char *result =3D PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
 	struct padlock_sha_desc *dctx =3D shash_desc_ctx(desc);
 	struct sha256_state state;

--=20
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
