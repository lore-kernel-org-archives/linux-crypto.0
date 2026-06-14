Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8320913B7AE
	for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2026 13:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781442392; cv=none; b=oFRqFZmy3gIXmqPDpF5Tg5jlDFkZEhU+PBMi/kleZOyBuZKQIGh00JHAHpMZfmJhw0cKnlvdUgN+Uq0va0mCY7VA8uGgbT9uw7V60HOJckEK2yCmnLJeEAlVJY5hEG3aqGm5rmWUnW4TkzLZEIMWqN8U4DP9KByAuETtVLM4mg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781442392; c=relaxed/simple;
	bh=F8nefapGpq1hkNr3dR953PbBEi8lHQKnLkLvosnH5/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCLnUgIX2fjP2508cV2PZBIkqqAOUoAIhOzP9V5psNg4ruccYrK4qyrR7mSJtFczfHy5rD9EwI8PCdFvPTrg9Jd7aHoidjAXATKcqf2sAhd4BwOySavS2yamq1gSwMR1e5GIDqn/B9y2yiGZtdcBY7Cc+e1/CsUv2CNaopYFaKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HHQLSkWM; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HHQLSkWM"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8ce65629acaso29912696d6.3
        for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2026 06:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781442389; x=1782047189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LaU8/SkUlaCNRKpR7Ka7OTF4Zk+4rJg57uFLh3oSqoI=;
        b=HHQLSkWMJmNQDNEckbs6WiS9bLNmOImbTP4hPpd1VnjAAsuN+wsRCpAocV2Sm4yaZc
         5x/YnbV7TOcz4YzKagJabG3MEV/jRkxCYTa/jnx8EUoxH8PuzzunECU51kJx/pXlHBbV
         b+vAtxB5z8tUAUjhM6/YNNtTJXcvNJePduoWBjw/CCeHNeOHGdpbawGrTdalZs3rf+qM
         KPcfbuqxSHuqHUN8Li5a+4gsVOD34kzwQ4J3BS1UAs8Bl2AYgjJ95gxFjK56ELGQroxP
         DsaNM5oIXP31DwU5RSloTe+i5w3ty6c5RkqnmV87v08NdGCQWFpAdQnZQlim3gBB1iBi
         OKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781442389; x=1782047189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LaU8/SkUlaCNRKpR7Ka7OTF4Zk+4rJg57uFLh3oSqoI=;
        b=FpAymYojI0bFL7E1fusAo9nnT41H+5GBqUxQwVTSOPQMoGjUdk1IljCS+J745tArNA
         eBFZlb7j19SG9l+fk5gdn+Do1FEZ6v4XsCg8FL3HpaIHvL4nHxii7CLKmMMWg4et46WQ
         yS4kzKYYI5e/LMxgjq1SMI7oUTg3Ce6RJVRPr7R+TN98Ekfv7wlGnuYe7W8ZSS2gDvab
         GRgbiaxftTkQwVHAf1pTloY985LkOsk9WEUpxEPx7AyClZ/Yuo0RoqNS6jCWLZGQ+lOe
         BkAe9au32jMzVt7mRsFUPmugz1fTLucq2Z+9bHm8BUJgdv9D9/Jtd4owhtzGoYTrgsav
         qGDA==
X-Forwarded-Encrypted: i=1; AFNElJ+N1iaZ49r/Zb90PpZeXhSSd7zKbCptfVnyPUO7DVgveaBUgO5jZZIKTZC7IDxVpGH2fPcQK0mLcd7qwPE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyClAUjDpkO3RSlmc7pkH7HAzvtEJ7J90hgcJi0ZaaE1WcCc0kw
	DFZ4C26ctt7RtHfMYHpAOwIR7885bU1lySEBuuNYdn+rMj02Ex5i/Yyk
X-Gm-Gg: Acq92OF0ijth2xv4U5Mm2fRtZ/LVNemWC1I4pZM3QKl7T/smEnXdnYyZp58pKxZuvNq
	cfUHUqc8woKNgr0Zu4i4lJmO3BsVYrK10qLvREk3kvwgW9HoN9p8aSIrKI129lgU90aJ/4+wUKC
	ymmYe8s5upLVuTZMrKPkqHpahcO9zKvVFay+h3ZR0IQAlQJmbaL72uBH+M5kx8Ff0l1uGj8Lj1T
	hJe/bMYH3ggP1+rDByzCmCeSIch8LVM13bHQdeONot9A1rFnaPTNPHNWvQGUvJDKx1T4aWaduAO
	88ONFC96oZmEKeYkRV7dsb7kq8Pwu06JKjfNIMzJfyIi/mOnrWyfltuDRD/orAyFLhoTc/MqWap
	NGfK0GdyzyudkI6cHBJC0TEXA3jGdQyXkembAEqtn0uDqc61eQe5hucxbTVwq/m7kGM5RAdxAbD
	pqs4uLXlGx9HolrzqFMsX/4d7193PkPKqMXY0pKMMSIjJ0IEwmndAqzOfI/7iG3s1DTTFmD2coP
	3rGNTUfhcLZeHsAqOAN1/9KBNfQKMtbsBC3ExqbkPY=
X-Received: by 2002:a05:6214:1d07:b0:8ce:cfb3:2800 with SMTP id 6a1803df08f44-8d32b47adcamr190019316d6.2.1781442389443;
        Sun, 14 Jun 2026 06:06:29 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8d301a32d5csm77937106d6.12.2026.06.14.06.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2026 06:06:28 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S . Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: qat - validate migration section header is in bounds
Date: Sun, 14 Jun 2026 09:06:18 -0400
Message-ID: <20260614130619.2519534-2-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260614130619.2519534-1-michael.bommarito@gmail.com>
References: <20260614130619.2519534-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

adf_mstate_mgr_init_from_remote() sets the section-walk cursor to
mgr->buf + preh_len from the remote migration preamble. The default
preamble checker only rejects preh_len > mgr->size, so preh_len ==
mgr->size (the 4096-byte QAT VF state buffer) puts mgr->state one
region past the allocation while n_sects is still honoured.
adf_mstate_sect_validate() then reads sect->size from that cursor
before proving the section header is in the buffer. The remote stream
reaches this parser from the destination-host VFIO migration path
(qat_vf_resume_write), so a malformed import reads out of bounds.

Reject section headers not fully contained in the state buffer before
dereferencing any of their fields.

Reproduced under KASAN on QEMU via the KUnit case in patch 2; the
slab-out-of-bounds read is gone after this change.

Fixes: f0bbfc391aa7 ("crypto: qat - implement interface for live migration")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
The patch 2 KUnit case drives the real parser on a kmalloc(4096) buffer
under KASAN on QEMU x86_64. Trigger {preh_len=4096, n_sects=1}: stock
tree reports

  BUG: KASAN: slab-out-of-bounds in qat_mstate_remote_run

reading sect->size 8 bytes past the allocation; patched it returns
-EINVAL and KASAN is silent. Two benign controls (empty preamble,
in-bounds section header) drive the same path with no OOB and pass on
both trees. No in-tree selftest exercises adf_mstate_mgr.c; patch 2 is
the coverage offered. KASAN build of the touched object is warning clean.

 .../crypto/intel/qat/qat_common/adf_mstate_mgr.c   | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
index f9017e03ec0f2..7370b87f72a2f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
@@ -231,8 +231,18 @@ static int adf_mstate_sect_validate(struct adf_mstate_mgr *mgr)
 
 	end = (uintptr_t)mgr->buf + mgr->size;
 	for (i = 0; i < mgr->n_sects; i++) {
-		uintptr_t s_start = (uintptr_t)sect->state;
-		uintptr_t s_end = s_start + sect->size;
+		uintptr_t s_start, s_end;
+
+		/* The section header must be in the buffer before it is read. */
+		if ((uintptr_t)sect < (uintptr_t)mgr->buf ||
+		    (uintptr_t)sect > end - sizeof(*sect)) {
+			pr_debug("QAT: LM - Section header out of bounds (index=%u) in state_mgr (size=%u, secs=%u)\n",
+				 i, mgr->size, mgr->n_sects);
+			return -EINVAL;
+		}
+
+		s_start = (uintptr_t)sect->state;
+		s_end = s_start + sect->size;
 
 		if (s_end < s_start || s_end > end) {
 			pr_debug("QAT: LM - Corrupted state section (index=%u, size=%u) in state_mgr (size=%u, secs=%u)\n",
-- 
2.53.0

