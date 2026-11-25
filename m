Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795648767;
	b=S9hT/A7mGNrbtvK/UnJdzMKAzaSB+Vg3+Nm0NoMNTSHNcrXXyUJKUU0YiftJ8G5C3zcM
	 R3RyAKfWp4fJjjIJ2aU3asM6xsSRz+LCH8vaaw4CLZM6StuacEFM3Cjanc3L6tqhR7MBi
	 7hUaqcJ3OSbSbkN93Fnwe3IqFimRDScJztehu7ZyZ5yMhdduCZFUfgu5L0j86YNPnT2hL
	 wNav23RZJ2g67W1IXmVfDRy3sS6BStSNCltzGK+Fdh4Mwax2B8D/XlrS4D/FnYeSh3doa
	 B2j8taJxv+of21Slqlf1IiNdjj3GdPYOih2cyPMukMYxqrOU7NwQH0gLSXCO7IIJthA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795648767;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=ggzgJhAcIPkA9KCxSMfYaDl9P/wTaRJZOBBqna5LcTs=;
	b=LiMcEdKbdI2dxo5jbOonI4Mps0qgGhuDu6DRCT3s4iW/id8wzMRjE+GH2i7bKAc4ABvn
	 TTtBHHq2ul7JVl1kiRz3Usk6WhBmg1KJ8ke7zM6pSNVu4WRToaa4uBSbc7HjgnMF4AIOf
	 kKr2S1OJ0KjAZxDk+p6FJKmawPnNKjox0F7CkRaI3D3EAsw+JsFoRaIfAS6DQJtq97qHK
	 eCD2DudkGJD+7sGqq0CuRIe7kBAzNdZAbDwcYDqMR/LtClozXOpKBdZcqlsB5aIBz8MT1
	 0xcz2yq6DOJzzl1+4lqEelX46YV7GuHGp4lwS71ha8aE1A8kyr5qdwX7qzvT+KNMQrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=dUaTHIaT;
	arc=none smtp.remote-ip=109.224.244.17
Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77573606A31E;
	Wed, 25 Nov 2026 23:19:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77573606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=dUaTHIaT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1795648764; x=1795907964;
	bh=ggzgJhAcIPkA9KCxSMfYaDl9P/wTaRJZOBBqna5LcTs=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=dUaTHIaTJZ9pVHFsm7SAHQDQ3/1IZMhQcPsBSl1nTy4V8cyoTLmDIE38grsx52G5E
	 /xboa3paGbbTh94iO4iiFAk7wGDS3J3RFvi1cT5hdyt6satYLONU8QxL155EKJ2rYS
	 C4ol5hkWU2E2j5PYo4JGLoQYThwFqJAS4ZH5WJBZGjTUsYzLGT34e7LYhQ15/0its/
	 4UvvvGFzeZJGOfFjJB5owyGO4Wz+LY2OEhyFn3ZRDRO/0LDb94WNsdysFns1/aO2E0
	 Xtiu6PUXSKGpVF5/J1Ea4HWPAnFoAcD4s//Prb5INMZg0BWylQ0fvhSK+3CgqDTE9A
	 OXFHThm830kSg==
Date: Wed, 25 Nov 2026 23:19:18 +0000
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
From: Ryan Prinz <rc4d5a@protonmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, qat-linux@intel.com, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ryan Prinz <rc4d5a@protonmail.com>
Subject: [PATCH v3] crypto: qat - fix missing DH public key validation
Message-ID: <20261125231859.1857450-1-rc4d5a@protonmail.com>
Feedback-ID: 190731814:user:proton
X-Pm-Message-ID: 51ca07321ea67af973bc63eb9f02dd6c4d6a6574
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

qat_dh_compute_value() passes the peer's DH public value into the
hardware queue without checking it. The only checks on req->src are
on length (req->src_len > ctx->p_size); never on the value itself.

crypto/dh.c's dh_is_pubkey_valid() is the generic software check for
this: it rejects a value outside [2, p-2], but only when FIPS mode
is enabled, and only for callers using the software implementation.
QAT's hardware path has no equivalent check in either mode.

QAT registers "dh" at cra_priority 1000, versus the generic software
implementation's 100, so any caller requesting "dh" gets this
unvalidated path whenever a QAT device is present and the requested
modulus size (1536/2048/3072/4096 bits) is one QAT supports;
qat_dh_set_secret() only falls back to software for sizes outside
that set.

drivers/nvme/common/auth.c requests "ffdheNNNN(dh)" for NVMe-oF's
in-band DH-HMAC-CHAP authentication. Three of its five supported
group sizes, 2048, 3072 and 4096 bits, match QAT's hardware sizes.
Forcing the derived session key Ks to a known value lets an
attacker who holds a handshake transcript perform an offline
brute-force attack against the pre-shared key, which is what the DH
exchange is documented to protect against on top of plain CHAP.

Fixed by validating the peer-supplied value before it reaches the
hardware queue, rejecting any value outside [2, p-2].

Fixes: c9839143ebbf ("crypto: qat - Add DH support")
Signed-off-by: Ryan Prinz <rc4d5a@protonmail.com>
---
v3:
 - Giovanni pointed out that this range check was about to exist
   twice, byte-for-byte identical, once here and once in the
   HiSilicon HPRE fix for the same bug. Moved the comparison itself
   into crypto_dh_pubkey_in_range() in crypto/dh_helper.c, exported
   via dh.h, so this and the HPRE fix (and the generic software path,
   if that's wired up too) share one implementation instead of each
   carrying a private copy. This driver's own zero-padding and (p - 1)
   computation are unchanged; only the final comparison call moved.
   Depends on the separate "crypto: dh - add shared DH public key
   range check" patch.
v2:
 - Corrected the Fixes: tag, found by Sashiko's automated review:
   2acbb8771f6a only added the req->src_len > ctx->p_size length
   check, to fix an unrelated integer underflow; it's unrelated to
   the missing value check this patch adds. That's been missing
   since DH support was first added, in c9839143ebbf, which is now
   the correct tag.

No Intel QuickAssist hardware was available to reproduce this.
Verified by building the modified driver (along with crypto/dh.c,
crypto/dh_helper.c and crypto/kpp.c) against an unmodified kernel
tree on x86_64, confirming the module compiles and links cleanly with
no new warnings; and verifying the range-check arithmetic in a
standalone test exercising the boundary values 0, 1, 2, p-2, p-1, p
and a value larger than p, which all produced the expected
accept/reject result. The comparison is now crypto_dh_pubkey_in_range()
unmodified rather than a private copy; this patch's own buffer
handling (zero-padding, p - 1 computation) is unchanged from v2.

AI Disclosure: An AI assistant was used to assist with the
analysis and testing. I have verified the vulnerability, the fix, and
the test results myself and take responsibility for this contribution,
per Documentation/process/coding-assistants.rst.

 drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 43 +++++++++++++++++=
+
 1 file changed, 43 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/=
crypto/intel/qat/qat_common/qat_asym_algs.c
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -216,6 +216,43 @@ static unsigned long qat_dh_fn_id(unsigned int len, bo=
ol g2)
 =09}
 }

+static int qat_dh_peer_pubkey_valid(struct qat_dh_ctx *ctx,
+=09=09=09=09    struct scatterlist *src,
+=09=09=09=09    unsigned int src_len, gfp_t flags)
+{
+=09unsigned int p_size =3D ctx->p_size;
+=09u8 *p_minus_1, *y;
+=09int i, ret =3D 0;
+
+=09if (!src_len || src_len > p_size)
+=09=09return -EINVAL;
+
+=09y =3D kzalloc(p_size, flags);
+=09if (!y)
+=09=09return -ENOMEM;
+
+=09scatterwalk_map_and_copy(y + (p_size - src_len), src, 0, src_len, 0);
+
+=09p_minus_1 =3D kmemdup(ctx->p, p_size, flags);
+=09if (!p_minus_1) {
+=09=09ret =3D -ENOMEM;
+=09=09goto free_y;
+=09}
+
+=09for (i =3D p_size - 1; i >=3D 0; i--) {
+=09=09if (p_minus_1[i]-- !=3D 0)
+=09=09=09break;
+=09}
+
+=09if (!crypto_dh_pubkey_in_range(y, p_minus_1, p_size))
+=09=09ret =3D -EINVAL;
+
+=09kfree_sensitive(p_minus_1);
+free_y:
+=09kfree_sensitive(y);
+=09return ret;
+}
+
 static int qat_dh_compute_value(struct kpp_request *req)
 {
 =09struct crypto_kpp *tfm =3D crypto_kpp_reqtfm(req);
@@ -241,6 +278,12 @@ static int qat_dh_compute_value(struct kpp_request *re=
q)
 =09if (req->src_len > ctx->p_size)
 =09=09return -EINVAL;

+=09if (req->src) {
+=09=09ret =3D qat_dh_peer_pubkey_valid(ctx, req->src, req->src_len, flags)=
;
+=09=09if (unlikely(ret))
+=09=09=09return ret;
+=09}
+
 =09memset(msg, '\0', sizeof(*msg));
 =09ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
 =09=09=09=09=09  ICP_QAT_FW_COMN_REQ_FLAG_SET);
--=20
2.51.2

