Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795817837;
	b=RSDrUqG9xj4XS7BZhF+YI1yXNldG27tHOT9PD5zCRTSBhTVrit4o9W0c60CyJ+Wu7dQf
	 OVqiZIuCEcSvYNkbmmc3w+ESyPH5d4FvpNb3MBW1oVrDJuR4afap9NOB1lVAZA2hFgLDz
	 ZzDh7RAeZ9JB3RKQTaYQ6mpDsEJ1DnE6xaAMAz//a6OvFq6W4UHXb6aIILPrvOstvuA2/
	 UyZJnubKY6gb2UE5JnQXpentAPlOWBsMXxU+PQbceTw5z/4OAXTJggPPmca/EE8euZ4aa
	 gP+nfAFhKhxO2sl+5hrZL9iR8FXSar56i6NI1zyqyqTSWSxaz9jvlBmqryT/GPQpAVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795817837;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=sMlkFUyONvrS8TXAfk+11NhJnNc1ouJQPR9RPnoNIF8=;
	b=FAlRmy2DkoJiUYsCB0v+/FuYx404Oi4nGFZbPFCoa2i0NVRmPM3IykTsMhYAPCOS7VSz
	 g+pWpkWo3FxY1YYiArxwG9+HXi4WPu6nT3T1JAWOOy8ENgc8+gwdgFVq5svV4mGOMmJcB
	 b4kCifrUJG3qNk8QI3SJ0eEk7MYQ128Fzutx6zVS/ZzVWtMhfD1DUFVqRlv/CsBNsQ5Mb
	 e2KJdb+RDT+zau2WjIfGlCm4buhATBFgCd2ibcHtba8/f14zmusF754Uuqz97tGPBTVXh
	 JWN4nen6kOKifxh9cbfRCKEOTEhmHJumBcBwaXksV8wn8cSTlqSHxtkYIG1321IKbDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=snap.com;
	spf=pass smtp.mailfrom=snapchat.com;
	dkim=pass header.d=snap.com header.i=@snap.com header.a=rsa-sha256 header.s=google header.b=dFqa1Jrq;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28533606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 22:17:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28533606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=snap.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=snapchat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=snap.com header.i=@snap.com header.a=rsa-sha256 header.s=google header.b=dFqa1Jrq
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bb69f5b161so56507965e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 14:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snap.com; s=google; t=1795817835; x=1796422635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sMlkFUyONvrS8TXAfk+11NhJnNc1ouJQPR9RPnoNIF8=;
        b=dFqa1Jrq1G31UFpVWDiJCEsjrfSt+lq+UyHFF8kELP287yiWbwusAWaTUkb4WKq/YA
         SlVx3GSpuLYEFISrn2ly2keOFn8qe09GPPRw7rM5uPaMCodRfKM5/+aC+Kh8GEsLtLOB
         paWLWfkbZ/GS0Q81G4JL5lpcoTn7BAI6/BZgs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795817835; x=1796422635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sMlkFUyONvrS8TXAfk+11NhJnNc1ouJQPR9RPnoNIF8=;
        b=KZnFQ8GqJp/uYuThw4TFLN/j2457mUYNUzLXwalVNC7xZPrqPz9XaEddTxG1JiHjrp
         VTqUEm3WpL9VzrJHXpTUJE2gBK3NVYG/pmPTpruSJcpKob1k/ixQ8OBzirW173mA1h01
         BCJI9vy5iliof79nVU9prcZWZUh2Gaovd1lr7DjINcKkWF3P8ubadyjtPHaOjCcRPYNx
         Oyx6nRspX23JOoxLbWgqKTf0gV3L1LM4gCJWdJq/4VStxeLye4Uk0pnj7o/RZJmE8/vy
         DMk4zijY5d0iC5Vlrww8ypU+TT0PEmGyfT1XsID5d93kp3OKCxSep8sJC0rfdrImpgWL
         HSTQ==
X-Gm-Message-State: APuU4Z8immGKlPp2iXOK9jAruGv+2xIyjGQtbAVuBNHYMrKu7aPQB8wV
	KFne40KyHwykZYx3mblZEcfdRmEbb+vJkGyireKU07HYDqUs0jUquMpP7HMf2dFTT3XK06msLsA
	eOvo00mQ=
X-Gm-Gg: AZFdTZd4kpOr/AJeovIGqmepMAIb+h/bHFPqrxY7SsaTZkz56o45gIbe+IupG/p1hBb
	00YUqkBC7fVnmrT8kL/xyl93GDdPb2wImtSfLMJfY1yGUslHki358r2Y1WfSPD9q7inET0dySie
	9SK2u2TdjAB2mGBoWAp2nblk/T4+fH88eTa+/otb1nOfOtGaHsZtampie+Z0UaiCiMqaUSW1a5T
	Yc4rTljDD8KVqSbCwMRvK5Y7TTBK9XQLa1nu5DYSyVOg1emC/tXledVJ6VZeEsp7Uqrp/iD9ASt
	HHW6w9zq1WDVV0iUT+LVJ4dDDSloeaffy0J2QKMkGgGz9yXBXopQTmz3md1//4kZCeQArQFEFLA
	SKDyLvViQpIwqudzMd8nClmnBmZpM7uBXZfEn6rax2/p0h++3n/bIX3rNM/RMKxFCHCFWmxg954
	0cft3pfJc+cPcv2wVlIV5N0xMWRqdiMo9UqoO6ckhm8xHy6qOuOl90gfYYos2ydXkDdhUhD3Pdo
	WJgmv/O8nTIxDIV1XxVm2V+a6gz8t5fSam7Qph2uMG5ccaQzL/wB4s5EaiRUdM80Dtr8ymGgVU0
	a5IFLIRyhNi707u5GGIMNE4KQzKD0VOrHpUCjaMvlsLGpfvT2gnifUWMR5MKw9hCtRTBMUBY6va
	ZpJoGy3WN9NP1TqjjsDYlHSrezxm3y0lfbWIs5032xCYDJgYp4LDYYQ==
X-Received: by 2002:a05:600c:8486:b0:4a6:4d6b:a840 with SMTP id 5b1f17b1804b1-4bb88819468mr535284065e9.31.1795817835414;
        Fri, 27 Nov 2026 14:17:15 -0800 (PST)
Received: from lj8k2dq3.sc-core.net ([85.237.126.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm597882215e9.0.2026.11.27.14.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 14:17:15 -0800 (PST)
From: Etienne Cordonnier <ecordonnier@snap.com>
To: ebiggers@kernel.org,
	Jason@zx2c4.com,
	ardb@kernel.org
Cc: linux-crypto@vger.kernel.org,
	Etienne Cordonnier <ecordonnier@snap.com>
Subject: [PATCH v2] lib/crypto: mpi: use a 128-bit multiply for umul_ppmm() when available
Date: Fri, 27 Nov 2026 23:17:11 +0100
Message-ID: <20261127221711.3585352-1-ecordonnier@snap.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

longlong.h only has architecture-specific umul_ppmm() implementations
for a handful of CPUs. On every other 64-bit architecture, including
arm64 and x86_64, umul_ppmm() falls back to generic C that builds each
64x64->128 product out of four 32x32 multiplications plus carry
handling. umul_ppmm() is in the inner loops of mpihelp_mul_1(),
mpihelp_addmul_1(), mpihelp_submul_1() and the division code, so this
slows down every mpi_powm(), e.g. each RSA signature verification
(module signatures, X.509).

Add a variant of umul_ppmm() based on a u128 multiplication, for 64-bit
architectures that select CONFIG_ARCH_SUPPORTS_INT128. It sits just
before the generic fallback, so architectures that provide their own
umul_ppmm() are unaffected. The compiler turns it into a widening
multiply: mul + umulh on arm64, mul on x86_64.

On an arm64 Cortex-A55 at 1.5 GHz, the time spent in mpi_powm() per
RSA-4096 module signature verification (measured with kprobes on a 6.1
kernel with the arm64 version of this change backported) goes from
1286 us to 1201 us (-6.6%). A userspace build of the same code shows
the same direction at other modulus sizes (2048/3072/4096 bits:
0.42/0.85/1.44 ms before, 0.35/0.70/1.19 ms after). Other
architectures were not benchmarked.

The new macro gives the same results as the generic C one on 200 million
random and edge-case inputs. It builds without warnings on arm64 and
x86_64. On arm64 (QEMU virt, cortex-a57), rsa-generic passes the
self-tests with CONFIG_CRYPTO_SELFTESTS_FULL. It was not run on x86_64 or
other architectures.

AI assistance: this patch and its changelog were written by Claude
Sonnet 5.5 (Anthropic), used through Claude Code, and reviewed by the
submitter.

Signed-off-by: Etienne Cordonnier <ecordonnier@snap.com>
---
Changes in v2 (suggested by Eric Biggers):
 - Drop the __aarch64__ condition and put the u128 variant right before
   the generic fallback, so it applies to every 64-bit architecture that
   selects CONFIG_ARCH_SUPPORTS_INT128 and has no umul_ppmm() of its own.
 - Retitle and reword the changelog accordingly.
 - v1 was arm64-only.

 lib/crypto/mpi/longlong.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/lib/crypto/mpi/longlong.h b/lib/crypto/mpi/longlong.h
index 6d31c3a729f1..137564e1a669 100644
--- a/lib/crypto/mpi/longlong.h
+++ b/lib/crypto/mpi/longlong.h
@@ -1266,6 +1266,17 @@ do { \
 } while (0)
 #endif
 
+/* Let the compiler use the CPU's widening multiply if it has one. */
+#if !defined(umul_ppmm) && W_TYPE_SIZE == 64 && \
+	defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
+#define umul_ppmm(w1, w0, u, v) \
+do { \
+	u128 __ll = (u128)(UWtype)(u) * (UWtype)(v); \
+	(w1) = __ll >> 64; \
+	(w0) = (UWtype)__ll; \
+} while (0)
+#endif
+
 #if !defined(umul_ppmm)
 #define umul_ppmm(w1, w0, u, v) \
 do { \
-- 
2.43.0

