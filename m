Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.103
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795648795;
	b=d1J1DutBYNQiQFpvKoabMFUGfBxRjefPBOzt9q3hxAkR35FQ95V7ydtcnog73FqSyMjX
	 NpRqKoE+vzx8vUBiZ/no1ciAMUoMJ4Ck3VUW37hMa5nxJTRJRljQl0ivzaXCajoL/8gil
	 b3ZfatQOb8s+hawd4G5JwEQAmTh/Z+OhDdhfH9mmOqhfDIhfoLrBYjg/JHTYaPSEt9rf8
	 bmyN+xLG/fZmaPTsJHgk9nVrD7hIas+h7Xr1zvuFlMBTYJG/S+bauBKZJP1hpdO40P/Bw
	 E5HYfeS7lIHKjNNq5Cp2AMGOLdfiV+bkcc2K2bWo1SyD/f+lFOQuBJ3MudQtBA+nUzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795648795;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=TEazLALDsobz/tolntOMr8U1plLFZVK7A/itYnyis2E=;
	b=JZ/UPBNhwlunFf93aQJ78llUgN4twVjPr0p0QsvyOLXMipLwcUcQzqjNWIJTszmzCfJr
	 JWlDpXsBIXUvRbHknioF+wbQRtcsCOpIbSGbz9WRqSqT0nw/QiK21NyTCKTVKHo8Q+LF+
	 otnZhZBRbi5QWkk8SFzYVnfmRcPfO3dssJ+UdBKwn5An7nv8TSGt847tghn8+GEOSAhJB
	 PrZLw430fMricPVSlQlZZmchVePmoQJn0txswCRXr+8/Iq0VXiZcV81FU+UImlsmUmYSW
	 jfRV6dbPrGFZ0XpAkocdygoXuI3o/J959qAXWlJiLRvRlVvT3kclham0e3CwFPilJ8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=LXKEKlfR;
	arc=none smtp.remote-ip=185.70.43.103
Received: from mail-43103.protonmail.ch (mail-43103.protonmail.ch [185.70.43.103])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DDC606A321
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 23:19:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11DDC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=LXKEKlfR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1795648792; x=1795907992;
	bh=TEazLALDsobz/tolntOMr8U1plLFZVK7A/itYnyis2E=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=LXKEKlfRrOmKXenEU+iku5083lRmnybybFQKQcH+t0wHbggpIJgJGYFF07I6fEVjK
	 +xiHHMpQaVcXdETN0UsPXrK/w+19Dz1gH86MohaIB17vJRadp4QXAjWt7/JXDov/9j
	 ZX6vfvhqSIWR8g9gSm/cpAonUtr0YUnO4r9cAGXnhkUb7VNAakdxFH04s+E7jDvHGw
	 +/4IkGV0ldhD6KqlQFR/KsjqToAhfBTh5MLaeCUCewHxHVrG/e6Pdye8CSBjEAT+/M
	 Ng9UPk1xICaKbkwxHWJhG97+HDjT5XzU1z6KBfmUF0ZOJFQkxaOe7WaVvOjqzjeycs
	 YVqSFuTKGSntg==
Date: Wed, 25 Nov 2026 23:19:46 +0000
To: Zhiqi Song <songzhiqi1@huawei.com>, Longfang Liu <liulongfang@huawei.com>
From: Ryan Prinz <rc4d5a@protonmail.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ryan Prinz <rc4d5a@protonmail.com>
Subject: [PATCH v4] crypto: hisilicon/hpre - fix missing DH/ECDH public key validation
Message-ID: <20261125231929.1857637-1-rc4d5a@protonmail.com>
Feedback-ID: 190731814:user:proton
X-Pm-Message-ID: d98190fbdf172366d2fb2d564d3b0c8692158541
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

hpre_dh_compute_value() and hpre_ecdh_compute_value() pass the peer's
DH/ECDH public value into the hardware queue without checking it
first. Neither hpre_hw_data_init() nor hpre_ecdh_src_data_init() do
any validation; they only format and DMA-map the buffer.

The generic software implementations this driver falls back to do
check it: crypto/dh.c's dh_is_pubkey_valid() rejects a DH public value
outside [2, p-2], and crypto/ecc.c's ecc_is_pubkey_valid_partial()
rejects an ECDH public point that is zero, out of range, or not on the
curve. HPRE's hardware-accelerated path is the default/primary path,
not the fallback, so the DH/ECDH value check is normally skipped
rather than normally run.

Both algorithms are registered under their generic crypto_kpp names
("dh", "ecdh-nist-p192/256/384"), so any caller requesting those names
gets this unvalidated path whenever the hardware is present.
Two in-tree callers are affected:

- drivers/nvme/common/auth.c requests "ffdheNNNN(dh)" for NVMe-oF's
  in-band DH-HMAC-CHAP authentication, used by both
  drivers/nvme/host/auth.c and drivers/nvme/target/auth.c. Forcing the
  derived session key Ks to a known value lets an attacker who holds
  a handshake transcript perform an offline brute-force attack against
  the pre-shared key, which is what the DH exchange is documented to
  protect against on top of plain CHAP. With bidirectional
  authentication enabled, an attacker can obtain a transcript by
  connecting to the target directly and requesting it without valid
  credentials, exposing the target's authentication key
  (dhchap_ctrl_secret). Cryptographic soundness then relies solely on
  the strength of the target's key.

- net/bluetooth/smp.c allocates "ecdh-nist-p256" for LE Secure
  Connections pairing and performs no validation of the remote
  device's public key before calling compute_shared_secret(); it
  relies on the crypto_kpp backend. On real HPRE hardware this call
  fails before reaching that point today, for an unrelated reason:
  hpre_ecdh_msg_request_set() requires dst_len of 2 * key_sz for
  compute_shared_secret() as well as generate_public_key(), while
  compute_ecdh_secret() only ever provides key_sz. That's a
  pre-existing bug, not something this patch depends on or fixes.
  Once it's corrected, or for any caller unaffected by it, a peer
  can send an invalid public key and force the resulting DHKey to
  one of a small number of predictable values in a single pairing
  attempt.

Fixed by validating the peer-supplied value before it reaches the
hardware queue, in both compute_value() functions: for DH, rejecting
any value outside [2, p-2]; for ECDH, reusing ecc_is_pubkey_valid_partial()
after converting the raw big-endian coordinates HPRE already works
with into the digit form that function expects.

Fixes: c8b4b477079d ("crypto: hisilicon - add HiSilicon HPRE accelerator")
Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Signed-off-by: Ryan Prinz <rc4d5a@protonmail.com>
---
v4:
 - Giovanni pointed out (reviewing the separate QAT fix for the same
   bug) that the [2, p-2] range check was about to exist twice,
   byte-for-byte identical, in two different drivers. Moved it into
   crypto_dh_pubkey_in_range() in crypto/dh_helper.c, exported via
   dh.h, so DH backends share one implementation instead of each
   reimplementing it. This patch now calls that shared function
   instead of carrying its own private copy; the QAT fix has been
   updated the same way. The ECDH check already reused a shared
   function (ecc_is_pubkey_valid_partial()) as of v1, so that part is
   unchanged. Depends on the separate "crypto: dh - add shared DH
   public key range check" patch.

v3:
 - Corrected the net/bluetooth/smp.c paragraph above: on real HPRE
   hardware, that call fails before reaching this patch's code, for
   an unrelated, pre-existing reason (a dst_len mismatch in
   hpre_ecdh_msg_request_set(), not something this patch depends on
   or fixes). No code change.

v2:
 - Fixed a bug Sashiko's automated review found: ctx->key_sz is the
   hardware slot width, not the curve's own coordinate size (HPRE
   pads P-192's 24-byte coordinates into the 32-byte P-256 slot), so
   reading ecc_swap_digits() from the start of that padded region
   shifted every P-192 coordinate and rejected every valid P-192
   public key, including testmgr's self-test.
 - Fixed a second bug Sashiko's review found: ecc_alloc_point()
   allocates with GFP_KERNEL unconditionally, which could sleep in a
   context where CRYPTO_TFM_REQ_MAY_SLEEP is clear. Switched to a
   stack-allocated ecc_point via ECC_POINT_INIT(), which removes the
   allocation (and the sleep question) entirely.
 - Fixed a third bug found during further review of the above fix:
   for P-192, the extra bytes between the caller's half-width and the
   curve's own 24-byte coordinate size were accepted without checking
   they were zero. A value with non-zero content there is wider than
   P-192's prime once it reaches the hardware at its full submitted
   width, which is the out-of-range case this patch fixes. Now
   rejected unless those extra bytes are zero.
 - Resent as a new thread rather than a reply to the v1 thread.

No HiSilicon HPRE hardware was available to reproduce this. Verified
by applying this patch to an unmodified kernel tree and building
drivers/crypto/hisilicon/hpre/hpre_crypto.o directly (along with the
crypto_dh_pubkey_in_range() change in crypto/dh_helper.c), confirming
both compile and link cleanly with no new warnings or errors. The DH
fix now reuses crypto_dh_pubkey_in_range() unmodified (same range-check
logic as before, just no longer a private copy); a standalone test of
that function exercising the boundary values 0, 1, 2, p-2, p-1 and p
produced the expected accept/reject result, same as prior to this
move. The ECDH fix reuses ecc_is_pubkey_valid_partial() unmodified; a
separate standalone test confirmed its zero-padding of a
shorter-than-full-length coordinate produces the same byte layout as
hpre_ecdh_src_data_init()'s existing shift-based padding. A third
standalone test confirmed the coordinate-extraction offset correctly
accounts for curves whose coordinate size differs from the hardware
slot width (P-192's 24-byte coordinates inside the 32-byte P-256
slot), while P-256 and P-384 (where the two sizes already match) are
unaffected. A fourth standalone test confirmed the gap-byte check
rejects a crafted P-192 value with a non-zero byte outside its real
24-byte coordinate while still accepting both a plain 24-byte encoding
and a caller zero-padded out to the full 32-byte slot.

AI Disclosure: An AI assistant was used to assist with the
analysis and testing. I have verified the vulnerability, the fix, and
the test results myself and take responsibility for this contribution,
per Documentation/process/coding-assistants.rst.

 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 124 ++++++++++++++++++++++++=
+++
 1 file changed, 124 insertions(+)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/h=
isilicon/hpre/hpre_crypto.c
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -4,6 +4,7 @@
 #include <crypto/dh.h>
 #include <crypto/ecc_curve.h>
 #include <crypto/ecdh.h>
+#include <crypto/internal/ecc.h>
 #include <crypto/rng.h>
 #include <crypto/internal/akcipher.h>
 #include <crypto/internal/kpp.h>
@@ -471,6 +472,49 @@ static int hpre_send(struct hpre_ctx *ctx, struct hpre=
_sqe *msg)
 =09return ret;
 }

+static int hpre_dh_peer_pubkey_valid(struct hpre_ctx *ctx,
+=09=09=09=09     struct scatterlist *src,
+=09=09=09=09     unsigned int src_len, gfp_t gfp)
+{
+=09unsigned int key_sz =3D ctx->key_sz;
+=09u8 *p_minus_1, *y;
+=09size_t copied;
+=09int i, ret =3D 0;
+
+=09if (!src_len || src_len > key_sz)
+=09=09return -EINVAL;
+
+=09y =3D kzalloc(key_sz, gfp);
+=09if (!y)
+=09=09return -ENOMEM;
+
+=09copied =3D sg_copy_to_buffer(src, sg_nents_for_len(src, src_len),
+=09=09=09=09   y + (key_sz - src_len), src_len);
+=09if (copied !=3D src_len) {
+=09=09ret =3D -EINVAL;
+=09=09goto free_y;
+=09}
+
+=09p_minus_1 =3D kmemdup(ctx->dh.xa_p + key_sz, key_sz, gfp);
+=09if (!p_minus_1) {
+=09=09ret =3D -ENOMEM;
+=09=09goto free_y;
+=09}
+
+=09for (i =3D key_sz - 1; i >=3D 0; i--) {
+=09=09if (p_minus_1[i]-- !=3D 0)
+=09=09=09break;
+=09}
+
+=09if (!crypto_dh_pubkey_in_range(y, p_minus_1, key_sz))
+=09=09ret =3D -EINVAL;
+
+=09kfree(p_minus_1);
+free_y:
+=09kfree(y);
+=09return ret;
+}
+
 static int hpre_dh_compute_value(struct kpp_request *req)
 {
 =09struct crypto_kpp *tfm =3D crypto_kpp_reqtfm(req);
@@ -485,6 +529,15 @@ static int hpre_dh_compute_value(struct kpp_request *r=
eq)
 =09=09return ret;

 =09if (req->src) {
+=09=09gfp_t gfp =3D hpre_req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+=09=09=09    GFP_KERNEL : GFP_ATOMIC;
+
+=09=09ret =3D hpre_dh_peer_pubkey_valid(ctx, req->src, req->src_len, gfp);
+=09=09if (unlikely(ret)) {
+=09=09=09dev_err(ctx->dev, "invalid peer public key, ret =3D %d!\n", ret);
+=09=09=09return ret;
+=09=09}
+
 =09=09ret =3D hpre_hw_data_init(hpre_req, req->src, req->src_len, 1, 1);
 =09=09if (unlikely(ret))
 =09=09=09goto clear_all;
@@ -1574,6 +1627,71 @@ static int hpre_ecdh_dst_data_init(struct hpre_asym_=
request *hpre_req,
 =09return 0;
 }

+static int hpre_ecdh_peer_pubkey_valid(struct hpre_ctx *ctx,
+=09=09=09=09       struct scatterlist *src,
+=09=09=09=09       unsigned int src_len)
+{
+=09const struct ecc_curve *curve =3D ecc_get_curve(ctx->curve_id);
+=09unsigned int nbytes =3D ctx->key_sz;
+=09unsigned int half =3D src_len >> 1;
+=09u8 coord_buf[2 * ECC_MAX_BYTES] =3D { };
+=09u64 x[ECC_MAX_DIGITS], y[ECC_MAX_DIGITS];
+=09struct ecc_point pk;
+=09unsigned int cbytes;
+=09size_t copied;
+
+=09if (!curve)
+=09=09return -EINVAL;
+
+=09/* ctx->key_sz is the hardware slot width, not the curve's own
+=09 * coordinate size: HPRE pads P-192 (24-byte coordinates) out to
+=09 * the wider 32-byte P-256 slot.
+=09 */
+=09cbytes =3D curve->g.ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
+=09if (cbytes > nbytes)
+=09=09return -EINVAL;
+
+=09/*
+=09 * Src_data is gx and gy concatenated, each zero-padded up to
+=09 * nbytes, matching the convention hpre_ecdh_src_data_init() uses
+=09 * for the hardware submission path.
+=09 */
+=09if (!half || half > nbytes || 2 * nbytes > sizeof(coord_buf))
+=09=09return -EINVAL;
+
+=09copied =3D sg_pcopy_to_buffer(src, sg_nents_for_len(src, src_len),
+=09=09=09=09    coord_buf + (nbytes - half), half, 0);
+=09if (copied !=3D half)
+=09=09return -EINVAL;
+
+=09copied =3D sg_pcopy_to_buffer(src, sg_nents_for_len(src, src_len),
+=09=09=09=09    coord_buf + nbytes + (nbytes - half),
+=09=09=09=09    half, half);
+=09if (copied !=3D half)
+=09=09return -EINVAL;
+
+=09/*
+=09 * If half is wider than the curve's own coordinate size (only
+=09 * possible for P-192 inside the wider P-256 slot), the extra
+=09 * leading bytes of each half must be zero, or this isn't a
+=09 * value this curve can represent.
+=09 */
+=09if (half > cbytes &&
+=09    (memchr_inv(coord_buf + (nbytes - half), 0, half - cbytes) ||
+=09     memchr_inv(coord_buf + nbytes + (nbytes - half), 0, half - cbytes)=
))
+=09=09return -EINVAL;
+
+=09/*
+=09 * Extract each coordinate's cbytes-wide value from the end of
+=09 * its nbytes-wide zero-padded region.
+=09 */
+=09ecc_swap_digits(coord_buf + (nbytes - cbytes), x, curve->g.ndigits);
+=09ecc_swap_digits(coord_buf + nbytes + (nbytes - cbytes), y, curve->g.ndi=
gits);
+=09pk =3D ECC_POINT_INIT(x, y, curve->g.ndigits);
+
+=09return ecc_is_pubkey_valid_partial(curve, &pk);
+}
+
 static int hpre_ecdh_compute_value(struct kpp_request *req)
 {
 =09struct crypto_kpp *tfm =3D crypto_kpp_reqtfm(req);
@@ -1591,6 +1709,12 @@ static int hpre_ecdh_compute_value(struct kpp_reques=
t *req)
 =09}

 =09if (req->src) {
+=09=09ret =3D hpre_ecdh_peer_pubkey_valid(ctx, req->src, req->src_len);
+=09=09if (unlikely(ret)) {
+=09=09=09dev_err(dev, "invalid peer public key, ret =3D %d!\n", ret);
+=09=09=09return ret;
+=09=09}
+
 =09=09ret =3D hpre_ecdh_src_data_init(hpre_req, req->src, req->src_len);
 =09=09if (unlikely(ret)) {
 =09=09=09dev_err(dev, "failed to init src data, ret =3D %d!\n", ret);
--=20
2.51.2

