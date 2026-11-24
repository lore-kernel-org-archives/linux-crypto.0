Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.31
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529586;
	b=E6YMAJ1+/TuviCDrUVOu6oGx9WyZIdNlry9teQzPPOnp/lns1mHWiT5HPmL0W6p5XqvV
	 o0sY3aoLZ6VpJC2/JifrMy9PQKdLVxvPRDEwOHbuvMVWy6PKC2hd4zyxfKAeWa4nsXuE4
	 h1P/2JqXNfw0X59kcCtxBAGnqZ0OPfHiWSNI3bwnGA1rwiBuuQCUS6ZHs3wtYnOeMbwsg
	 5D4syjHrhbs7w0Umi9eFav+XvvwFf1s1gNDFoqMyLALBOikApw0D64SK+lS9xfczIUB9O
	 ClJj4AWP9D1MGafKMFQLWOR47cToJ2YWH/bR9MVxYiBA7GeXkxKdMntL5fDkYPPYUNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529586;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=VOFig0ZPEj1VY6uIOp50SLMLBCwy7gZlbV7lr+z/+Rg=;
	b=MLrKjgnIIDrOMjIT7fZ+qYvx7hQkZoyXjSqE/dbvaCtnb7Zzs7OsGy6wi+gljDvnxkIa
	 YJtq1uCdYq9ALVETJlKNxPm6Oy31kzQeI2rZUMGXRJm3knL9IAgT6kGKAtKbcJnVQcdei
	 hwWEIBKp9gdIYRO2LQtZEGm89LDnuy+56FxpRZ18iRiZXRC4/1Ff6j+eHPyDO4PyxjwCI
	 p4l9MQqv0hxLm0+y3NkgXo8hG0jno+hQepoz/4gKIdtlIjKVD0/D9DiVCz7f1Qp4WYPaO
	 A+I9KufgxfpYlcKw3x7ZmYzD8xmaRIXTfr43qKc0D+HCguhwu5TC6f1t+uhxavaHlow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b="kb/s31tK";
	arc=none smtp.remote-ip=79.135.106.31
Received: from mail-10631.protonmail.ch (mail-10631.protonmail.ch [79.135.106.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DED606A321
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 14:13:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08DED606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=kb/s31tK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1795529582; x=1795788782;
	bh=VOFig0ZPEj1VY6uIOp50SLMLBCwy7gZlbV7lr+z/+Rg=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=kb/s31tKxJeaSQdHXGESVo898rj7KggR7AljpXeY550K2aAHhQZmKonGhD3H0SPp8
	 /9M2Ze6U78HmQIU5/xS9fAFA5OlUn2Y+J2RhFvO4uyyN4HXrTQnq4+3yS6EIzvKk1N
	 gu9eNtvCegxEnPn0pImwDkVLYB6LVB6zmQtRu4uvcRuCzLdt3dIusUL61k4rVsthnZ
	 VtqLb/oje+zKGy0EhLXT2qdRzaEYPZ+0NvRG/V1T24xfI/DBTpuKxUqXvq5mzkN531
	 B2hU7snytkhMfJD/Penyh+c3Vw2KS7h+vm0YZAoDpS7o40pvshJb6tBjkOq9W5rEPl
	 t71UZpq/nHT1w==
Date: Tue, 24 Nov 2026 14:12:54 +0000
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
From: Ryan Prinz <rc4d5a@protonmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, qat-linux@intel.com, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ryan Prinz <rc4d5a@protonmail.com>
Subject: [PATCH v2] crypto: qat - fix missing DH public key validation
Message-ID: <20261124141238.1743680-1-rc4d5a@protonmail.com>
Feedback-ID: 190731814:user:proton
X-Pm-Message-ID: c61cdce36e3a01742626601019e87d882d8300e9
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
v2:
 - Corrected the Fixes: tag, found by Sashiko's automated review:
   2acbb8771f6a only added the req->src_len > ctx->p_size length
   check, to fix an unrelated integer underflow; it's unrelated to
   the missing value check this patch adds. That's been missing
   since DH support was first added, in c9839143ebbf, which is now
   the correct tag.

No Intel QuickAssist hardware was available to reproduce this.
Verified by building the modified driver (along with crypto/dh.c and
crypto/kpp.c) against an unmodified kernel tree on x86_64, confirming
the module compiles and links cleanly with no new warnings; and
verifying the range-check arithmetic in a standalone test
exercising the boundary values 0, 1, 2, p-2, p-1, p and a value
larger than p, which all produced the expected accept/reject result.

AI Disclosure: An AI assistant was used to assist with the
analysis and testing. I have verified the vulnerability, the fix, and
the test results myself and take responsibility for this contribution,
per Documentation/process/coding-assistants.rst.

 drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 63 +++++++++++++++++=
+++
 1 file changed, 63 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/=
crypto/intel/qat/qat_common/qat_asym_algs.c
index 77d59e977472..78f1b949614b 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -216,6 +216,63 @@ static unsigned long qat_dh_fn_id(unsigned int len, bo=
ol g2)
 =09}
 }

+/* Returns true iff 2 <=3D y <=3D p - 2, given big-endian buffers of p_siz=
e bytes. */
+static bool qat_dh_pubkey_in_range(const u8 *y, const u8 *p_minus_1,
+=09=09=09=09   unsigned int p_size)
+{
+=09bool is_zero_or_one =3D true;
+=09unsigned int i;
+
+=09for (i =3D 0; i < p_size - 1; i++) {
+=09=09if (y[i]) {
+=09=09=09is_zero_or_one =3D false;
+=09=09=09break;
+=09=09}
+=09}
+
+=09if (is_zero_or_one && y[p_size - 1] <=3D 1)
+=09=09return false;
+
+=09return memcmp(y, p_minus_1, p_size) < 0;
+}
+
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
+=09if (!qat_dh_pubkey_in_range(y, p_minus_1, p_size))
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
@@ -241,6 +298,12 @@ static int qat_dh_compute_value(struct kpp_request *re=
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
--
2.51.2

