Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBBF2E762C
	for <linux-crypto@vger.kernel.org>; Sat, 26 Sep 2026 04:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790395585; cv=none; b=CFXuiBWDRshxA8/dSC3LqrKnAv5jQEH/Mk45DDXnNqXIxNLR+wFWtxlMOvV7tjkvfRU3VqybWmmXwQkYi7lYM9BSI8nzlcJ92RIKRX/h26gcxCirHFtRwvPGir7HN0E7SCLi8UzDuWa2dulBfWEqaijAUku9xJgFMerx5zYTJJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790395585; c=relaxed/simple;
	bh=OMJF5iJ2bBNlvNvOH1A4lr3DOw0VhjkbaLchCaWNF/0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iGNRpZnPxxwMP34E2Qc+/mKlfgy+JvomAFgSkT6WjT2JIKAlMfvkEFelH8f1byGfU3O3tffa4PcuzXH2cKOsjI41Z8qtexQsbn2sdck5UIjGo8EdE6wMAIDupxfLyhONoFRqPUtD/CXZdXLjs6xNBTRahLpOtMlCp7317phJBgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jeTQjQtQ; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jeTQjQtQ"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-13fc403e373so2448764c88.1
        for <linux-crypto@vger.kernel.org>; Fri, 25 Sep 2026 21:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790395583; x=1791000383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yYWtV/7WN26wpAQGg7Cw6b1+YKQD3NCUU23kC8EEZdE=;
        b=jeTQjQtQTQsmab2bkO5CDwPnUrgrsk0oHJ1C8e3x9R3+Ob2slaG3nc9I/tLyQ3MwYV
         GciSScbcV+0xi8xuQJvLXgAs+IXBO4NsrSMZRmQuTdMhenAZY6TyInPD5oVPvC7Vh29n
         Mwtvr+cH90jWZXzpxZUlo45OwxeI+sPngs0e/2I3/8HlYttMi0M6/csRjW/hpDtpFRg4
         KCitigwKFnDO6K/qITfm5/1b21t8VQT85VRgcs24zLts0NZ3j6gV/YKiNfjGjSC9GKTY
         hozKG8J+8PeRAWgYJSI++dN7HSq/TmyIpHMKg+Be+5S1fcHAeVScRWXhQbQWA+6xTs9q
         8uMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790395583; x=1791000383;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yYWtV/7WN26wpAQGg7Cw6b1+YKQD3NCUU23kC8EEZdE=;
        b=xOAPuzcycmZXpaVEjPZ8LmPXwbkOpjriOwJ38so/PKT0hMEwJr5xM0DyCGkUL7zBXL
         el7LK+TTeD+tu814YJJ/RW0t0ifeH9JTh+OGqHbaqakYUW3JAjqMVQeqhESU2qvRXMKF
         xLKNwfNGFbbRSScVCvC/M4uKLcWxYMCka8BFm0vobyQWsNXMpZNAvBhwwRXsoIv7h4I+
         AO0i87tEj8TT4fXmyUp5VhpzLV1RN+tnEf/gMVyGe2CTSLpbuYvVX4jJ0QMOuWkl1HXa
         SX1j2jM8UowCBE6x5qXaTBnKmOfajAGAhmPwItVXa+HQyaN0REO4f4mFGQghki4n5AE0
         2OUA==
X-Forwarded-Encrypted: i=1; AKwUvBxAmH5YpAi/uQXb4ivgCO+js1g0PT2iq0BN/Y3rAW7uLTWesGvM99edIiwCWAEJH1UMaoF9K9YUt5iHPy8=@vger.kernel.org
X-Gm-Message-State: AFuF++mKaakBzs6XPW0w32uTN58xkwAj9YLQoILai8ARQXdOY4wUQR3f
	E39qxDEQVLj2iAyVEbKqkSZRjQcqhfiIz93QtVLOSXBEKQ18PixJwwTX
X-Gm-Gg: AYBFou3dGrYcDePdioHipnRiXzIT7uqDyacJxItF2jXZRhA5F/xrHVyavs2FLaydRcR
	qhAj6YI4d6Lg5wfzUdJp0ZUNuTCrVlEmjkt96YYN3X1onk+BxE3LrLt+XXlYD8KFEZUC5vvSuaE
	Ouff4yUnRK9IvUfY7rnXXWhdb2UlQqOCCQRvhx2qiLNWNPzPWZYZfmlfPSo+2DvKotQSNsV1u1D
	jynjpC2nbMg26zxv9fZICUkSEzHz7AxHyl9+JNbjMzGZX+M50Bv+q2q839dEIpmR49DcHK7rJI4
	rYF8eaQUHdRjSRVG2gAI/qvfAb/uXTZUv/WI+ASC+7C7bYurjPGK1vPNfyuLUMaO/CwY9uZNXR2
	mD2ElzH7/Mu9Zqwf2ag3Pas+varIwJnG+oyBm1msO9zf0JAWPEUkBLWiW00S/Puuj5sYRUTV6Lb
	PDKnknOzxkAMJHgWCKrjrqc2/tqsLz+3lUGvcJKM6nCdPl+XupWTDr2jr22vbq4vYrUuiV2N+xD
	i3KRtzVsbANljrBmw==
X-Received: by 2002:a05:7022:f417:b0:13c:f65c:d5b5 with SMTP id a92af1059eb24-146ce4925a9mr1755896c88.3.1790395582978;
        Fri, 25 Sep 2026 21:06:22 -0700 (PDT)
Received: from kernel ([103.219.206.17])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34145c166cfsm9368197eec.28.2026.09.25.21.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 21:06:22 -0700 (PDT)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: ebiggers@kernel.org,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Subject: [PATCH] crypto: x86/aes-gcm - fix always true check for last AAD segment
Date: Sat, 26 Sep 2026 09:36:14 +0530
Message-ID: <20260926040614.8683-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In gcm_process_assoc(), a segment that is not the last one must have its
length rounded down to a multiple of 16 bytes, as required by the
assembly. The check intended to detect a non-last segment,
`if (unlikely(assoclen)) /* Not the last segment yet? */` is always
true, since the loop only runs while assoclen is nonzero.

As a result the last segment was rounded down as well, leading to some
avoidable extra work: an additional memcpy into the temporary buffer and
an additional call into the assembly after the loop. The GCM
authentication tag is unaffected either way, so the self-tests pass and
this went unnoticed, its purely an efficiency issue rather than
correctness one.

Fix this by comparing the length of the current step against the amount
of AAD that remains, so that only a step which cannot consume all of the
remaining bytes is treated as a non-last segment.

Fixes: b06affb1cb580 ("crypto: x86/aes-gcm - add VAES and AVX512 / AVX10 optimized AES-GCM")
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index f522fff9231e..f4aae889635a 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1305,7 +1305,7 @@ static void gcm_process_assoc(const struct aes_gcm_key *key, u8 ghash_acc[16],
 			pos = 0;
 		}
 		len = len_this_step;
-		if (unlikely(assoclen)) /* Not the last segment yet? */
+		if (unlikely(len < assoclen)) /* Not the last segment yet? */
 			len = round_down(len, 16);
 		aes_gcm_aad_update(key, ghash_acc, src, len, flags);
 		src += len;
-- 
2.53.0

