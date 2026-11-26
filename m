Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795684810;
	b=G6yz/yi4TyVszW3Bp5QDY8C3DIlN1Xwodb18I0bmI2/p/vaCcdse8RkEb7y5LnW8SBhn
	 pbJfS+nrjw90pDJ7STiva6sWaxHvN0IOvp8uEPoBzdK2GYQMTNEcOjZ12UHvyX1tz/e4Z
	 16+cvM+8v5AVx+zvzdcrMgV8YLHKOezdvPVIAFQ5HQlVZUW65Ha6YIIejj2UUzhEea/W9
	 ZSSkCxy52MVoQOnArkt2fPo/PEEvb0shxkmYwm6fJ5joYglHblBB0w11w51uOlJ6ozJEB
	 XVOaGFIczhX7SGtmXoSYfXmFl/03EYcqbT4DYLXcvROlrN5hIRVG8eyc8by65Z9JPUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795684810;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YSWGbZPwr9sJMOQLpiVypNb+LSdgPlTuQnvpKc7sF1o=;
	b=G5h7dbg1ntMNTBZVM7N/uWBzMEwNiU7LVYE/Hpj8vVdx37BgLm8xlqJRT6EDJesn4p9s
	 lOiFc5HdH3f8/SYwO0iGiD8LLHdCywpD/yx/lbncDQTfjEq44llLgEQecGDMJsJcwUaVc
	 rwwb0VPR4AFMt4tdchgBgPrVQ3TkIqpXrK9SeDed0s9HOKth6cbPevnH9o3Ngdk0cKQm5
	 Qga8Q5KaakYzrkV8AarR22BQkN8rSt/12JDPv4qFsCkbd35bjQv9iHhAanC7dmk8LavB5
	 NMT0UP8rEF7oO8dhacuADlJitgIyyb2Yv5fwJPqDcz9O1F+i35c/Kivfv/khdv9IkSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nvW+SgGa;
	arc=none smtp.remote-ip=74.125.82.49
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7BB606A31E
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 09:20:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC7BB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nvW+SgGa
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1b244fb7fffso7180643c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 01:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795684809; x=1796289609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YSWGbZPwr9sJMOQLpiVypNb+LSdgPlTuQnvpKc7sF1o=;
        b=nvW+SgGa/kN9lh0cXnSBONwhpUuHro3RapFfFTgEK5nkueJVMH0McdaAgipK6MeIY9
         DieSNzouwUOmaXXMl5e30MzunC20JhacZfOhv5RAQSKiBqwUXNRLXHeV828QdnpFXn98
         2wobAqFydRzYo35fJ6J8KWWNS0CeT22PXCn3AeU017OOuKrmgPKEiGycFW4HXvXtfOX1
         1wIwSrTOkCuhDYaORtONgnBF2udiwSTBUWN42lVIfOzB6TuNdtwLMPffwVy7mpPh0aPy
         mUkJVWmZ/bl3/4Hb+k1FtM/zlpbJEUi18XH5KsuuBumdX9eG7h57MHRKeqSWdNlM3v32
         GINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795684809; x=1796289609;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YSWGbZPwr9sJMOQLpiVypNb+LSdgPlTuQnvpKc7sF1o=;
        b=mJJ6wGdjyRabo4hzCB7gQeG+iI/9qONzoeYmcWb7lNsR0A/IsvLLQp/PdgonP8nWMT
         5qjsBx6hYb7vvzuHujEjaQZm5JRHBF2JAfSBY0GIU9TKC7b8M496+C+CCGvemEindtUY
         jv8hjSMWzWJpHtyHKAXMhB1oB8Ie0VENs7YXBhtYPdcg10qs0m26GBb2uSsoNLj/AAEg
         Ze/xISSTjrRfQ6ED+GOCuR0ViQFyBlCH33HJTZbl7kuR7sF+W6NbF5N0+mvURDhtm7PP
         MfLx29V+bEsA4D3HLVcCo0aqLDO8GSYbUNT2Durd0UMGLbbbDXxEiiK4dHfkUNG7cmbt
         k38A==
X-Forwarded-Encrypted: i=1; AL+hErFX6QGxP1U5H2hdA4y+tJgxjWyKT2irXVkKKDQW6900ZOegoLEQnNGYf98+U/F21hxsZBmntjbODC9P0XE=@vger.kernel.org
X-Gm-Message-State: APuU4Z8/WR7MJ9Y+lPb2KZ2SuageQLmVKTUD4p3ia8x2phm5ugpIozKB
	LODsW4mBejSi9BTVoOzWgwvdtc+xfgsyVNPATY70pqUkEOf5wYqqbHZ5
X-Gm-Gg: AZFdTZdjmkktMJ7FMd4bdpmKogXRzv8DgyDAVLiB+HXXHsu0sS/OtX7zloSxrXexHpg
	VdOYtcn2H1QJF+ewUCm/y6d4eSar6DqiW1QRuzxUXj2EbJ4fPPczz6Mhw7A+BtzfwSE59LovI8F
	kiUfYid3DMoaOjDzA8diulfP2bi9XxEaB3h2c4Dm3t6gBsHysg9p7rRUbLb5ovQQ7AmUVsS0oZj
	/ddawh1GQ9SrstmiJD9mjlbEGOGC5KJYKiOVOA1yYmz2xyf3zDrUDiGWTGjWbI4C86cGXM+doSW
	Bct8OYsrxRKYhJ5h+A/FYNdU7FYoHbXsc2flyIajjhYZVnYfvSgfzrq4LVRoDKux+P03q9mUIIz
	f0OLstLttZfjG0mKzRCMy5+BuSHFopd840KP5Yyo05zwL5nwuCuAhcBVN4h63b1GS5XPsEMAXMy
	VBxC4p2zJChVfkPgNOVWLyi+RYtRcfKR/ddtC9q2db9gtEm8+1r4A0RfvnUue5xc4rmjb68s799
	dd2qny8aomUlJj9+jT/LQzd6dprGzxti05NyaOy7j7ghCnJt73X7ro0jfvbNGaHX+EJtDFOgxEz
	05ehMcr9wsxlpSQvj2zow7YR7kOrDyUbbUW08Nw7kQ==
X-Received: by 2002:a05:7022:3a8b:b0:15a:4155:3d9d with SMTP id a92af1059eb24-1b5568d6db3mr25122033c88.31.1795684808698;
        Thu, 26 Nov 2026 01:20:08 -0800 (PST)
Received: from 10-86-27-207.ban-spse ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b55682d301sm48711524c88.10.2026.11.26.01.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 01:20:08 -0800 (PST)
From: Gokul K <gokul02k@gmail.com>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	David Rientjes <rientjes@google.com>,
	Peter Gonda <pgonda@google.com>,
	Atish Patra <atishp@meta.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccp - Do not hand a short INIT_EX file to the firmware
Date: Thu, 26 Nov 2026 14:50:01 +0530
Message-ID: <20261126092001.2099312-1-gokul02k@gmail.com>
X-Mailer: git-send-email 2.54.0
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

sev_read_init_ex_file() reads the INIT_EX non-volatile state from
init_ex_path into sev_init_ex_buffer. When the read returns anything other
than NV_LENGTH it logs the fact and then returns 0, so the caller carries
on and __sev_init_ex_locked() passes the buffer to the PSP as the
platform's saved state.

For a truncated file that buffer holds a prefix of the old contents
followed by the zeroes the page was allocated with, which is not a state
the firmware ever wrote. A negative return from kernel_read() is treated
the same way, and then the buffer holds nothing but zeroes while the code
still reports success.

This is not what the interface promises. Documentation/virt/kvm/x86/
amd-memory-encryption.rst says of init_ex_path:

  If the file specified by ``init_ex_path`` does not exist or is invalid,
  the OS will create or override the file with PSP non-volatile storage.

A file that cannot be read in full is invalid, so discard what was read
and let INIT_EX run from a zeroed buffer, exactly as it does when the file
does not exist yet. The firmware then repopulates the buffer and
sev_write_init_ex_file_if_required() writes it back, which is the
"override" half of the documented behavior.

Doing this for a negative kernel_read() return means a transient read
error costs the platform its persisted state rather than failing the
init. That is the deliberate trade: the documented contract allows the
file to be overridden, and feeding the firmware a buffer it did not write
is worse than starting over.

This was found while looking at the INIT_EX failure reported by Sean
Christopherson, where an interrupted writeback leaves the platform
unusable. It addresses only the case of a file that is short or unreadable
on the next init. An interrupted write leaves a full-length file holding a
mix of old and new bytes, which a length check cannot detect, so the
reported failure is not fully fixed by this patch.

Fixes: 3d725965f836 ("crypto: ccp - Add SEV_INIT_EX support")
Reported-by: Sean Christopherson <seanjc@google.com>
Closes: https://lore.kernel.org/all/abSWm4wyY91I4zf8@google.com/
Signed-off-by: Gokul K <gokul02k@gmail.com>
---
Compile-tested only.  I have AMD hardware but not a working SEV INIT_EX
setup, so the path this touches has not been exercised on a machine.  Built
at W=1 with CONFIG_CRYPTO_DEV_SP_PSP=y, and confirmed sev-dev.o is not built
with it =n.

What this does not cover, and I would rather say so up front than have it
found in review: the failure in the report starts with an interrupted
kernel_write() in sev_write_init_ex_file().  That file is opened without
O_TRUNC, so a partial overwrite leaves a full-length file whose head is new
and whose tail is stale.  Such a file passes the length check this patch
adds and still reaches the firmware.  Making the write side leave either
nothing or something detectably invalid behind is a separate change, and I
did not want to bundle an untested design decision with this one.

I also have no explanation yet for the widespread memory corruption in the
report.  A zeroed or stale NV buffer should not produce corrupted page
tables, so I assume something else is going on there and this patch does
not claim to address it.

If anyone with an INIT_EX setup is willing to run the reproducer from the
report against this, I would appreciate it, and I am happy to follow up on
the write side.

 drivers/crypto/ccp/sev-dev.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f833cb7e4da3..6d7ea028d24f 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -302,14 +302,23 @@ static int sev_read_init_ex_file(void)
 	}
 
 	nread = kernel_read(fp, sev_init_ex_buffer, NV_LENGTH, NULL);
+	filp_close(fp, NULL);
+
 	if (nread != NV_LENGTH) {
 		dev_info(sev->dev,
 			"SEV: could not read %u bytes to non volatile memory area, ret %ld\n",
 			NV_LENGTH, nread);
+		/*
+		 * Whatever was read is not what the firmware last wrote, so
+		 * none of it can be handed back to the firmware. Discard it
+		 * and let INIT_EX start from a zeroed buffer, which is what
+		 * happens when the file does not exist yet.
+		 */
+		memset(sev_init_ex_buffer, 0, NV_LENGTH);
+		return 0;
 	}
 
 	dev_dbg(sev->dev, "SEV: read %ld bytes from NV file\n", nread);
-	filp_close(fp, NULL);
 
 	return 0;
 }
-- 
2.54.0


