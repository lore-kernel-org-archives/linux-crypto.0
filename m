Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B596638F9C;
	Sat, 16 Aug 2025 16:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755361836; cv=none; b=FHOK6oEo1UYcXZ684x9g35cDLALF5FhcQiO83ukDIDE5SntxFrrx7eUNCrB3vjsSb7Fi6acPgw0c5cSz35nF3qdeDY8Sx1CTjHTyYWhiaGP+lLIxI2fBwI+8l4UpqbQqjphNmO3B2eOzTHKXGjaFhKNpIH67A0j4Fy3nCRzSwuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755361836; c=relaxed/simple;
	bh=hndPGv2wdnGaAp+U8k81L2oZ/U9gw0TgClsOE/aLPCg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uqCdPMf9iXS2PoTyVu/fTFGMlGvVLdj8KZkzux/yF67cob3+DbHiUz2F5HsYFT1gvhmXZwwtrSGmhTr7Cbu6l4cvoJl2nw5vKgaWepxJR0uXFgrfBdQJTv3jbnKzBuY64mgveWbnPZ51EyATlfbdbV2k7TY6Dexixpy1/UBJplw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aTE9ObEk; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aTE9ObEk"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-32326e09f58so3251971a91.2;
        Sat, 16 Aug 2025 09:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755361834; x=1755966634; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YfDPs/ifotx8nej6O4Kf3zetz5WIEYRWWHBMLRI1GI8=;
        b=aTE9ObEkRvMtGeboRAAjnpJLESSwo4x+vVw/uqHO1xN1vXWcCNY/VxJkyc8MJnBme4
         8XWMM5R8DsyW7LyiUv5dEl2WGl5JMr+rZsBI3YN0x+tWeErvdQS+wzm6WWLKTh/OC113
         iWiarPizP4RxMomJtrYORZTBQFy1QGxUt8QfYXbyDaws9Ys7JH6nuo70rqumvRLaMpLo
         7GcycoVLDb3PJH2xCEsXX6TrnTd8BfK7pRlLevEUW56TUDuLcTTlNMqVfX0izyBpUVUC
         Rtj7Q1igOf/PBpSSNnrdIGzRrmpYPOLVzV7MndAZf07jlOw5JCIGREk2ntEfOskauw8C
         ItcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755361834; x=1755966634;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YfDPs/ifotx8nej6O4Kf3zetz5WIEYRWWHBMLRI1GI8=;
        b=W5CJzgC/hKFbQsOOejKSXT+XvcLY1dF1Et/ZOqzv3V6ld4Kel8rAEQJT4vqWyFMy7+
         Fq8OaHOncJEYj2nG2R6AGBjN47Lc8BwPX/xioQax606BoKZdrZvWRZniOzmV69QOvFBd
         cAN66UlyV9mkHUZc7qcYqIU0VzLlwa6RZXDZ+LnWZMTGS/gwee30f5x4SDBbc3tLK+Am
         vya6kmFOE9ITgjI8bDPTcoyDsdRyrPibwiiKjvw0RgiQ1y9xGb/LhX01Nec8F8YsRN0k
         4hdrZLESSXL8P2uBZYzqa0nSpKlUD69SeL77bzvg1FGYaqQl2oG/3op9w7z06tZiR6np
         2ooQ==
X-Forwarded-Encrypted: i=1; AJvYcCW39WggErK4ltA8AktJWPJvfNykic2ULUYaCZJD2babTHpEsj5NxJO3vWeTlz11X/xP7jtrcd0zdie9Of0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDR6t+1/gnAKD/+cRNTIgEmc8vDDa4I1qjROegRKPUSuv9nA8w
	XWYq+uDxUTsRUUtoXG03lutf8rdio/Jnz/jisNCsxl8HLvl8hgQIRLSe
X-Gm-Gg: ASbGncvOdKCmUJPMy5mn7tB9PQ+5BwlEcYaZV8FOPqdBMpXSi6OV84qKIUTtMkxajSs
	G0p4EAf4KcbWFzHp4ZdUzpvsoW4w92oqyGbdJfuHOD2++kmObmFMMS51H+AhwoP1HQBPe0fulJd
	EbCQX/a19AIVPBjzUQRvcGCoByVrwds/2PiCY2TE4017/Jk4mXwuB+n2lYV+BC7ATGbQSWab5eo
	tcYrR7zw89xOrFr8Wca0qtc82krYaBZtOKyJ1m7tqgJrUH+U9sBUBIRBBlLo/EayPWXX86w5ZxV
	cI5TyCs001R9DWkO/ZurI97Ne833w/slbCBLMTFBuZWiU3DEuWMAvAoeKwrI9MumWFQXz7ghezw
	UUO7kvAyDAA==
X-Google-Smtp-Source: AGHT+IExilKHuwfg07ydhMDm+4UcwYtz8LgwCY2xQg6+6o4mVcZ6auOnXR5yUfYe+WTxwta9g7WjDw==
X-Received: by 2002:a17:90b:5663:b0:320:f718:8e63 with SMTP id 98e67ed59e1d1-32341ebf894mr7086204a91.9.1755361833870;
        Sat, 16 Aug 2025 09:30:33 -0700 (PDT)
Received: from ws ([103.167.140.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3233116f46fsm6992892a91.28.2025.08.16.09.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Aug 2025 09:30:33 -0700 (PDT)
From: Xiao Liang <shaw.leon@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] padata: Reset next CPU when reorder sequence wraps around
Date: Sun, 17 Aug 2025 00:30:15 +0800
Message-ID: <20250816163017.75098-1-shaw.leon@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When seq_nr wraps around, the next reorder job with seq 0 is hashed to
the first CPU in padata_do_serial(). Correspondingly, need reset pd->cpu
to the first one when pd->processed wraps around. Otherwise, if the
number of used CPUs is not a power of 2, padata_find_next() will be
checking a wrong list, hence deadlock.

Fixes: 6fc4dbcf0276 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
---
 kernel/padata.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index f85f8bd788d0..833740d75483 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -291,8 +291,12 @@ static void padata_reorder(struct padata_priv *padata)
 		struct padata_serial_queue *squeue;
 		int cb_cpu;
 
-		cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu);
 		processed++;
+		/* When sequence wraps around, reset to the first CPU. */
+		if (unlikely(processed == 0))
+			cpu = cpumask_first(pd->cpumask.pcpu);
+		else
+			cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu);
 
 		cb_cpu = padata->cb_cpu;
 		squeue = per_cpu_ptr(pd->squeue, cb_cpu);
-- 
2.50.1

