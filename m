Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378FC762F7;
	Tue, 14 Jan 2025 14:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736863951; cv=none; b=C1ZcT1wtT0dGIA+DlhLR859vACjghFUD+p4Pfi9vQaoPMnupsJeI6ikkycp5EABxOgwLmgImAHmy6WPy+JaLZNBJ9IetLxO5D4SnBEyJa6uJiq8k4UMyu/OXi+iRGkv0bXIPI/JJ6hHCr325wVA6UIyLZb5bo0Qh8qIroroccec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736863951; c=relaxed/simple;
	bh=PDv4GfT9htaoo/dVnXnLNDVEfVRO2ud3WWEE+TXfR4w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IRZYVglqrU+YSbt2N7RUGZ0RqkOcOPYb7KEgmjYs7yy7/Dw1k9++GjbPi35yuD0BZesE+aG48mvsWsq8pHixFJqOcvBZpI6PdoQ8m4dS/xETqhL3CrxEezxvGdVKJsMiT0yEMWvyNsZnkrYPx1/b1jIWk3AVqq4hzAsQ8V6hZOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D5D4bwC9; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D5D4bwC9"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2f43da61ba9so7313064a91.2;
        Tue, 14 Jan 2025 06:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736863949; x=1737468749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FTG79nL8NQo8aVgerNCdWBkI5u/Jw2Lke8vYbSuDz18=;
        b=D5D4bwC9Kvkpy9ADSiSSZ+rqk7qdjouiLqHXeS34rkfF4QMCVXoXglbrt54cq8+Zjh
         A1QM3liOZwI731ee1BXyxvw2kKrEdxAmzS3jEYG5sB5QxTviyMPi6R5WsvI/R8Up9o4z
         YV+lbTIs11L9qrthlA7ZugeWAlzL2Ax912Yn4jZpu3ygrQFkrDDKUD1hcb+cqvxX2Z62
         Yeh4x4WbOzVmWzKhSN9AY6iC6TDB9NzqlukEQf/ALfjZ0K3ViZ4YOQd8YSP/gzV/Y6Hz
         yGE7UlZ45Zot4a0DqnVDmcUB08iszKg6Nm63Mm5OA+E/eyOx6BVgSCJFfsn2IJAl7OQU
         ub0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736863949; x=1737468749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FTG79nL8NQo8aVgerNCdWBkI5u/Jw2Lke8vYbSuDz18=;
        b=int53aWpR/A06zNhtX1I8VHNLYJOgEoMWcq2hapIu/CNXlRJlJVXPMDRBAdwDOVU4h
         h0k6jQECj1T3hsXJ5SF68SYjIlRgRf2xVVwJX2Y33UwGZvHeoiLYf1WCUzYpkZkV/OAS
         p7diaAYWhqaFfbm97VJIgxcT89JHH+BOJEieyXliTrrs98+LnzD8KNTMzVeF/RR2A0ax
         MnpSJUG8NUk7QcnYwfE6soIMFsWGMnTKb6TUzhkDYCmxAjU0shmz8U7XKT4cnuWPGPcd
         3dM23KCe51Q1stPajqUQXXasN6CwB4S+H1aO/JGuqd8IJF+MSIimxbWceyriKocP+yAN
         viOA==
X-Forwarded-Encrypted: i=1; AJvYcCUPTio4xm9sMKCpFLQmML/km2fOLYzqYN4niwMsQCU9878aUv8SSdQUmVyeyF6ZEqvT3zR8+v1jKTCw+J9x4Hg=@vger.kernel.org, AJvYcCUruxHyCPMxkzbhoMUC/kMFJ8BDApxPH7ZTIIWSV6D5JqAyKpOB35zygPmvJontZfFZxGNJlOAMQoItxs/B@vger.kernel.org, AJvYcCWuCAyb8X9VTr9iucsIzTEhHrytbIk+neLiCbqUA+2IIaUjqnKzmvIdt770etWAEx6W/o6S86CSvEJ72r6J@vger.kernel.org
X-Gm-Message-State: AOJu0YxJIwNWuF7D/wgywHxPXpUyyG4bjML5FYhFfuc/Ya3dsCp0okOC
	UAOwGQL35EY2pmvVaBGU3+QpJS6q3nORWeL0PEkhCdUKGfCmQ1Rb
X-Gm-Gg: ASbGncv9dXWW6j3wNQTt0iZrxVDaCCufhaRI3v8vLKuJMdb3elq2wYpGMUbhwk1/Ks7
	MJwuVMWXqxQ0JIKneMzLQRH2jZTkVD21C4TFLF0Auj4T4mxLBsBvVsoQ1eNHo45vzDg45CoNZwb
	/pdssy2y4to2wK/fYWPlJCSOGCBFNaF+V4af7lSiH30KCIokqrugYpjda5vOQ5f0p6BLLRh9DFY
	aE3YCkdiKNwlQzJGqeWJtFCeaKHR2Lz1gxOIQudV4yEpWm2vugdjdY=
X-Google-Smtp-Source: AGHT+IGsMN+DbsOzOVjwV1/Tp/QJgEFXp+tCMu+w4OtAhGEYSdhmGfR3oTFUeKGZ6DKKI+H7wNRFXQ==
X-Received: by 2002:a17:90a:d88d:b0:2ee:edae:780 with SMTP id 98e67ed59e1d1-2f548f34ebdmr38752356a91.15.1736863949310;
        Tue, 14 Jan 2025 06:12:29 -0800 (PST)
Received: from localhost.localdomain ([122.174.71.101])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2f5594512f0sm9501840a91.36.2025.01.14.06.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 06:12:28 -0800 (PST)
From: Tanya Agarwal <tanyaagarwal25699@gmail.com>
X-Google-Original-From: Tanya Agarwal <tanyaagarwal25699@gmail.com
To: haren@us.ibm.com
Cc: ddstreet@ieee.org,
	herbert@gondor.apana.org.au,
	Markus.Elfring@web.de,
	kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	anupnewsmail@gmail.com,
	linux-crypto@vger.kernel.org,
	tanyaagarwal25699@gmail.com
Subject: [RESEND PATCH V3] lib: 842: Improve error handling in sw842_compress()
Date: Tue, 14 Jan 2025 19:42:04 +0530
Message-Id: <20250114141203.1421-1-tanyaagarwal25699@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tanya Agarwal <tanyaagarwal25699@gmail.com>

The static code analysis tool "Coverity Scan" pointed the following
implementation details out for further development considerations:
CID 1309755: Unused value
In sw842_compress: A value assigned to a variable is never used. (CWE-563)
returned_value: Assigning value from add_repeat_template(p, repeat_count)
to ret here, but that stored value is overwritten before it can be used.

Conclusion:
Add error handling for the return value from an add_repeat_template()
call.

Fixes: 2da572c959dd ("lib: add software 842 compression/decompression")
Signed-off-by: Tanya Agarwal <tanyaagarwal25699@gmail.com>
---
V3: update title and reorganize commit description
V2: add Fixes tag and reword commit description

Coverity Link:
https://scan5.scan.coverity.com/#/project-view/63683/10063?selectedIssue=1309755

 lib/842/842_compress.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/842/842_compress.c b/lib/842/842_compress.c
index c02baa4168e1..055356508d97 100644
--- a/lib/842/842_compress.c
+++ b/lib/842/842_compress.c
@@ -532,6 +532,8 @@ int sw842_compress(const u8 *in, unsigned int ilen,
 		}
 		if (repeat_count) {
 			ret = add_repeat_template(p, repeat_count);
+			if (ret)
+				return ret;
 			repeat_count = 0;
 			if (next == last) /* reached max repeat bits */
 				goto repeat;
-- 
2.39.5

