Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101CA31A053
	for <linux-crypto@vger.kernel.org>; Thu, 12 Mar 2026 21:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773351303; cv=pass; b=NkUKeD5miTMOdvBg2sH86D8KQkg4Ke2VwTYtErneP7xlX8XKBBly0YU2gwpfWb0fuQo/hGligj3LIxTDCmQH5cswkFMcAo/stZ8IMRHs69khq0hvCusv9Di3mQhbnAqmt4TBfAitk1gSjuFfF5Xq2PaaA271Turgq2DewoW977s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773351303; c=relaxed/simple;
	bh=gIjUIJ1qavPnJ09f8IJAA3QTQeJp8aH9yAtz2EQNkXQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=h5WIQbz5xjyNK9MMuOaZHw9v1Jk8Y67a01uJk8LeGtsT8x1l+nb3j5dtiO7PGytMEq/H3ayRzps9AaltpORdWuhAQZ/ZpXplRM+vDe053HlQKPqU2ydKxdCGjeAkWG933TGxOivyDHxk8mOQdQvZsjnbRWfcoybeigi5wn/+BNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BmXuZY58; arc=pass smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BmXuZY58"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d4be94eeacso1747424a34.2
        for <linux-crypto@vger.kernel.org>; Thu, 12 Mar 2026 14:35:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773351301; cv=none;
        d=google.com; s=arc-20240605;
        b=hKL5w+x93F44x45uovgIHZ1I71ieUVXRk+ZqEvPexEzZzVJjifuBlh+t1OqBUkpF7/
         O6qkkX13Q9E4+TyNRUbYCN6D/1UaW/JMsPhInro/RCqA8PQv+EJPCLo7Aiag86IGbX/R
         x021765g38/+Wu8xuTKkhAsZSNEjaZ2IdRCo/plGuQep1I6HhTF0l69jRhHask9SOqn+
         54+SKwtAITZHOtUBV29NOkspAz609Jd2aRfqmHnVU6hT0Ajg0lae6YvJ3fQaV6y4piom
         hQdJos5VdQFZQh15Bmx4lURrKLfFeg84d3u+9qwYk9JJwUA22btL1TTh5ENEgMFqoZq4
         7gyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=tdgabxvgrR3NH9n6dRdF+gCtINqaBantNHEPEnk5z6I=;
        fh=mYukIsWbcql1crXa3qAu+y4z81B13a12BT+UnGNeqws=;
        b=HPKH/0oxuYCe58opOFmKwQDwC/ykppo72RK7GbQduRpdFDAgmV3S7kKsuw7JOXI6Oy
         eRAZxAXabA8t4vElnAvWyts6lQj4Y7HKNG+rp0Khm8bw327ikI5PM0GqRnmDsDnbTtkA
         1ZJ9JjAEC6/oIDyN4paTjD6qkhV2nnHzgU35y9xNVhwMfFz+0KNs7Kz5WKoRJH4C0WLf
         AJy+CEguPfQWOJDe2jGjKgBFf/l60eJyBnPBV3nEg5cEysu0k3C9zvc9hy6WF0DEGt2M
         llDTKKXBRDaU3UUAbQVzjPHHLwJWea//VGQyeY9CjZb/PYCI1k/idO74xBrnuTiMoE2i
         9frw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773351301; x=1773956101; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tdgabxvgrR3NH9n6dRdF+gCtINqaBantNHEPEnk5z6I=;
        b=BmXuZY58sbCTlclLwTDEIdk3zWUzmRerA2+xA/8xhoajn+RuPUQ7Zf+V/0zcEIqvAq
         qzN7ai5nt79apoYz6uJGPsCiW7uMWc1H6dZYoeNn6HlXP1paOgK+L+qD5SQmG9uGHdu5
         HtP0Zckz2RZq4uwUOYQ4bvGPshtM3ymh8j8q93Cp4UguTrcrcUnXCt2X//jDue8hLXRB
         fCHuB0gq+c3qb0W20OSfbLmHb3C6oFeRDykio8znFsRGeSQslYvhEuKvaRm3LHIQ5I45
         VZJ2rzOo7EULsK1kPSWMxArS3sVhVejha3+s27ikFniZB8x6luNm38lsDl6xcS0C4S67
         u88w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773351301; x=1773956101;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tdgabxvgrR3NH9n6dRdF+gCtINqaBantNHEPEnk5z6I=;
        b=SNmb9AwjvfROqGV+M+W8KmFHUPrEvvhsS3s2XHb+ctlHh/7dDB3t1HCHCP6/raNOKT
         bO7ZGwhqnJj8Mr0B3/S2f5HHkBQe0qSYKVWA3S2eahV9m0WcSnXMG0ZDepQxfITENdKs
         6e5HKx7u+rhDMfbsB9VRW1a8X7hAnCmFE8SuJhT0oB8DxhR1rLNZjlj101rx1JTiOMTE
         89qjr5KEpy4myiLjzd1PcprFCRl80M0vtlo4xZ86pcGol3NevhoMkqAlYswF7xy5XmoC
         781ws0RZdprV1V6PUwnmSs6+PvtQTClouL+NXA8t1i+Kj+dBW+3kQRCPkvueYJCknori
         PpDw==
X-Gm-Message-State: AOJu0YxZ712xK26iX82tWXpveA3ml9JiI+HEu+deJZ8DS4FHmUHsFRVz
	IqFJafu566fT44KJRoFM47+57hFAwLdaQPHW+O0aNl3p3POWtu3UnjoI7k05whu9MpySKipwo9c
	GLc8OzjTYgtgo3liLhXVc4oFXmL84Ic6hhF6A
X-Gm-Gg: ATEYQzy6O6LHkRTgc3H3urhKILJTYLfvKBzZYAkyHoYpKhlaC+5VrCJyxozWsTeFXVN
	b+LPkr5OA+1rWZjdFBqROvfToYeV3hfC3b463mpRDg5g8XYaVIUOwZMjb4idzaKV1z/+Ca5uxsg
	luqgt+Y71iCDTebynY60img5sH/sJNvxTEplVuwkJYmbntW86IpdK/vd5SbtTzJVwPBgh/OVy3W
	uXUBmzenP0mAaWC23SLOlFAGwXqHACPBGev0i7p0xOsXNH2DOxHy99RJyJMlam59SXsjqNijDgg
	q+iFjiKPl3SLjDJIZ90jKucNPU+49e6ep1/KPT6pRAelTg4QBHGm018KaUk7f3FzfNOO8K2/6Oe
	FNN4i
X-Received: by 2002:a05:6870:6589:b0:404:15e7:b86c with SMTP id
 586e51a60fabf-417b906d0femr494861fac.3.1773351300889; Thu, 12 Mar 2026
 14:35:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: John S <xaum.io@gmail.com>
Date: Thu, 12 Mar 2026 22:34:48 +0100
X-Gm-Features: AaiRm519wtUg4oD9zNSZ11uUpzstseJGm2kD5X_fr26rbOp17N0s2he-FTifDv8
Message-ID: <CAAZVx98ALZkDnDcGacJLAPag=tFDtScVmR1pMCPnXZpeRzwOQQ@mail.gmail.com>
Subject: [PATCH] crypto: add missing kernel-doc for anonymous union members
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Document the anonymous SKCIPHER_ALG_COMMON and COMP_ALG_COMMON struct
members in skcipher_alg, scomp_alg, and acomp_alg, following the
existing pattern used by HASH_ALG_COMMON in shash_alg.

This fixes the following kernel-doc warnings:

  include/crypto/skcipher.h:166: struct member 'SKCIPHER_ALG_COMMON'
not described in 'skcipher_alg'
  include/crypto/internal/scompress.h:39: struct member
'COMP_ALG_COMMON' not described in 'scomp_alg'
  include/crypto/internal/acompress.h:55: struct member
'COMP_ALG_COMMON' not described in 'acomp_alg'

Signed-off-by: Kit Dallege <xaum.io@gmail.com>
---
 include/crypto/internal/acompress.h | 1 +
 include/crypto/internal/scompress.h | 1 +
 include/crypto/skcipher.h           | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/crypto/internal/acompress.h
b/include/crypto/internal/acompress.h
index 9a3f28baa804..9cd37df32dc4 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -42,6 +42,7 @@
  *
  * @base:      Common crypto API algorithm data structure
  * @calg:      Cmonn algorithm data structure shared with scomp
+ * @COMP_ALG_COMMON: see struct comp_alg_common
  */
 struct acomp_alg {
        int (*compress)(struct acomp_req *req);
diff --git a/include/crypto/internal/scompress.h
b/include/crypto/internal/scompress.h
index 6a2c5f2e90f9..13a0851a995b 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -22,6 +22,7 @@ struct crypto_scomp {
  * @decompress:        Function performs a de-compress operation
  * @streams:   Per-cpu memory for algorithm
  * @calg:      Cmonn algorithm data structure shared with acomp
+ * @COMP_ALG_COMMON: see struct comp_alg_common
  */
 struct scomp_alg {
        int (*compress)(struct crypto_scomp *tfm, const u8 *src,
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 9e5853464345..4efe2ca8c4d1 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -145,6 +145,7 @@ struct skcipher_alg_common SKCIPHER_ALG_COMMON;
  *           considerably more efficient if it can operate on multiple chunks
  *           in parallel. Should be a multiple of chunksize.
  * @co: see struct skcipher_alg_common
+ * @SKCIPHER_ALG_COMMON: see struct skcipher_alg_common
  *
  * All fields except @ivsize are mandatory and must be filled.
  */
--
2.53.0
