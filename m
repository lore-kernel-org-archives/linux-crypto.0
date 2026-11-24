Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795527185;
	b=XKjLEQp3axflamOBpbnS/qmDu3FIcgyXclD2TNfofLoy53JzU3slWzOkhployhmDvDDW
	 qSWhWTigG46GNg87Qbk6hrsZtT86rMTYtyiXbkrfsSFN4Eu88vKSj3CEO7ukcX6WYtkb/
	 9mPlmDC07s0BDO9B2ndhEB3uUtfHuF1XHxIix6VG5hrAUUjmlCRsdjnI5sgimLJMlT/C3
	 X5T7dNfGfpbQ0tBMK3NtrwN1kAo4gKSpH2jYvHcQy00p6pjPknx5Sq1HQBeayfTi+RyX4
	 dLAztB88dvfq/B/ml38prmZLsFtt3/0WcUx0DK8tWHBzKDPQtCYMgh2b0kTtkp9ociA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527185;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=vbfFORKXsBUwqqx+vRWbtjSPw0l/j1sIKSEK8iegjBY=;
	b=R/WIcghRbTg3D3sxWW51RDdQSqmgNMyh+kpHlGScARQTZgTcnaHYLQpQlWCn9WyvgCeu
	 KRWhc2LqaUogCxhu0/phSSiloEhR0eKzkq6qnGvehdmFM7wbJQR/P9WGIYq0t84A8uz+M
	 ZaoJME6PT1Pu1GD+d5vwYk8+E1g2DRTCuOj70XZDPlBeEDEw+Imxeel8rIUlBCMJQVJYI
	 huQVlvS9CC03X47KXNNHcghjCa3ROe1YbuyUY1tv0FUjPrqxW1vcadXIIbMdO5buFGm6o
	 cbX00GO8EpVFYUnyo4eFrNxjlAOOIuxDAYUPSSdrG//fvF0yllCVI0Qjpus3wobshOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=ZtBF83mw;
	arc=none smtp.remote-ip=185.70.43.16
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88034606A6A5
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 13:33:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88034606A6A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=ZtBF83mw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1795527181; x=1795786381;
	bh=vbfFORKXsBUwqqx+vRWbtjSPw0l/j1sIKSEK8iegjBY=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=ZtBF83mwxwXW/52lxLjXXm32pdT9y53MDgIhJZVyx+3iE/HAb/vh5VnY5p+VgPjYE
	 Hb1ANSlodDXOF2FLsh3LegUyPwRS7KuAxllOYUNLi4p0c3Rgz/dupxIhFDuMZXj3d3
	 Vi/XOw8rqpki/APzfa6bNn81uBZ2cHEA2LofooX8ZzsY+7FI6LVJwUbpUOHblXbu0e
	 aerrb0V09j5rsicFQ4PG9ALngC+HAsdfzAIjvMTDjQC8p9WVj6uCN0VCylqCe0eidV
	 swf6s+npKi1iWELIwAwSG4R4/u4bzOtlEDaDg0A0dV2F90vr7mBHcpWw+XThJjJ9pU
	 9sFT8zAJX7fUA==
Date: Tue, 24 Nov 2026 13:32:58 +0000
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
From: Ryan Prinz <rc4d5a@protonmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, qat-linux@intel.com, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ryan Prinz <rc4d5a@protonmail.com>
Subject: [PATCH] crypto: qat - fix missing DH public key validation
Message-ID: <20261124133245.1739232-1-rc4d5a@protonmail.com>
Feedback-ID: 190731814:user:proton
X-Pm-Message-ID: 87716131018708394a98b4d7ad3b4712f9aa8542
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

Fixes: 2acbb8771f6a ("crypto: qat - add param check for DH")
Signed-off-by: Ryan Prinz <rc4d5a@protonmail.com>
---
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

