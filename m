From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: IXP4xx: Simplify get_crypt_desc() and get_crypt_desc_emerg() in ixp4xx_crypto.
Date: Sun, 10 Jan 2010 18:32:53 +0100
Message-ID: <m3my0l3lx6.fsf@intrepid.localdomain>
References: <m34omu3rf7.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christian Hohnstaedt <chohnstaedt@innominate.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:53286 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab0AJRcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Jan 2010 12:32:55 -0500
In-Reply-To: <m34omu3rf7.fsf@intrepid.localdomain> (Krzysztof Halasa's message
	of "Sun, 10 Jan 2010 16:35:38 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Krzysztof Ha=C5=82asa <khc@pm.waw.pl>

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_cry=
pto.c
index 99f06e1..0c7e4f5 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -277,26 +277,25 @@ static struct crypt_ctl *get_crypt_desc(void)
 	int i;
 	static int idx =3D 0;
 	unsigned long flags;
+	struct crypt_ctl *desc =3D NULL;
=20
 	spin_lock_irqsave(&desc_lock, flags);
=20
 	if (unlikely(!crypt_virt))
 		setup_crypt_desc();
-	if (unlikely(!crypt_virt)) {
-		spin_unlock_irqrestore(&desc_lock, flags);
-		return NULL;
-	}
+	if (unlikely(!crypt_virt))
+		goto out;
+
 	i =3D idx;
 	if (crypt_virt[i].ctl_flags =3D=3D CTL_FLAG_UNUSED) {
 		if (++idx >=3D NPE_QLEN)
 			idx =3D 0;
 		crypt_virt[i].ctl_flags =3D CTL_FLAG_USED;
-		spin_unlock_irqrestore(&desc_lock, flags);
-		return crypt_virt +i;
-	} else {
-		spin_unlock_irqrestore(&desc_lock, flags);
-		return NULL;
+		desc =3D crypt_virt + i;
 	}
+out:
+	spin_unlock_irqrestore(&desc_lock, flags);
+	return desc;
 }
=20
 static spinlock_t emerg_lock;
@@ -319,12 +318,10 @@ static struct crypt_ctl *get_crypt_desc_emerg(voi=
d)
 		if (++idx >=3D NPE_QLEN_TOTAL)
 			idx =3D NPE_QLEN;
 		crypt_virt[i].ctl_flags =3D CTL_FLAG_USED;
-		spin_unlock_irqrestore(&emerg_lock, flags);
-		return crypt_virt +i;
-	} else {
-		spin_unlock_irqrestore(&emerg_lock, flags);
-		return NULL;
+		desc =3D crypt_virt +i;
 	}
+	spin_unlock_irqrestore(&emerg_lock, flags);
+	return desc;
 }
=20
 static void free_buf_chain(struct device *dev, struct buffer_desc *buf=
,u32 phys)
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
