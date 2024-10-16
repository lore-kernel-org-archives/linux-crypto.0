Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13052144D2
	for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 18:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729105053; cv=none; b=PgGUcqhpsgP2yZy5OpnjFzT6ajxONl7fUHnQQ2dN6JqP62G84F8o2t8GZ6GYdyJPacNiX/alfrICnJQaBEnO3PCXzToGNKrKSekyWBmHbnUQ2/RiJATmvE4LpdVJQnpVHZWn49eG4sTYcYbs/x9lKck5q+ZdYii1eBApgDnfRgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729105053; c=relaxed/simple;
	bh=Au5PfJ5mtIqIAMIRGBDNZcO3+cIA/AhC5G7zhKbGSKk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=n0mVOBkAtmAUeP1azp4ZjhbS6I2qnGomONNhwVdr2Boq7X/2Piy83M76eVQJkt9f47gxCFdhdQsxs45W6dxYuOl/pCNwrWuU5pL96ia8f++L3LUC6Nos6wNpEX3bUBg4J9QnwKZVd+88dfRRaPmAXVoYAn+yoQydt21EeZP0q3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TewajsOP; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TewajsOP"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e2904d0cad0so203707276.1
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 11:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729105051; x=1729709851; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w+45YWEyOmYkoR5G+dQrMLiOQJzCVmLWXqFQemZoOQQ=;
        b=TewajsOPZxECYffBSQ0PWJWuihbH/6TXHpX/RAL6GhkxFBTuRAnFmrBiZnFotw3utD
         BhM8AQFyPE33fpf2F5+dnQTPDKEGCNMc4EQVvEuxK330qNWOWBROesHG/4gsfkdfT23C
         vOvbHPsHNzMrSKfd0WYjoQkvN8hvaLMhLjVYbJ3EvXJ1AWhwgHBb6bEZm3zUeCkkWfLU
         sz6qiFBbZNHX2Y/RtzbZSD4Nb8OaUov9oQBy/m+QdfrR+zkP4BK28OBAqFs6ntbocgPw
         ztHh+kqd38C3rdThj6IV1dVsHOL8T45VRZkbfOedkHcr27UGy8OnlexwfXy6k/nYb6az
         wV2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729105051; x=1729709851;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w+45YWEyOmYkoR5G+dQrMLiOQJzCVmLWXqFQemZoOQQ=;
        b=Cu7neFyGPHu58XUxph/vkOlFbmuI/FD9jXx5az0CT+5kFobtifKphOHG/fNulF942y
         CsjC9mYXL3dGdlSd/OoE9AucJQ02jFgQr/Ey6n2KP7bSjUZTNMGb+TZ52frSbVpXfcAv
         /pjM3CTC5uC9G8sHGrn4uNS1z45D85X4uOiQrCB9fVeKvL5s94AC+PEqL6eg/pnfb8/G
         wV+HtWAOfjHoQTU5my/gJruadWByh0FKtSJ6/ueLPbRoMsScH7LBHw9Dn/vt7M2IQq4R
         WlzZFKTUE/y25U1QAbM1YxEl9vXTV2oP4nK4nMm/lcNSezOW2mlF/FMPcGN/IOs/r5rY
         YTFQ==
X-Gm-Message-State: AOJu0Yx2Lo27ZnawKljEBvYti/Gtqa6aNkSA1KlqfPg6AZzuSy3R6ovk
	rX3y6YKHVSGthp+HW4IERFuz2LFwYcjw4HlWN9ALjfiyODFXkgy3MPFuRer9mzH2zOW8EMS3AVg
	+FZklsSZFfeLUOFYFF+Ch/qhZqOYNQrexiKU5TJsBKS8YsFX7e2d2PUoOJUsdTfCmwKP2izuwV9
	Nk2tqR7L+BWDgCn5yci2Uo9tKacZiSLA==
X-Google-Smtp-Source: AGHT+IHG6bQctoVPjev5IG3rYTgLxvIR8EDnh59SKCBDqq1vlzBZqaMYv5wIelR3lsDHdLYiKLApXais
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a25:8682:0:b0:e29:6e61:3db4 with SMTP id
 3f1490d57ef6-e29782cc524mr5191276.2.1729105049939; Wed, 16 Oct 2024 11:57:29
 -0700 (PDT)
Date: Wed, 16 Oct 2024 20:57:23 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1041; i=ardb@kernel.org;
 h=from:subject; bh=Wy584VG+6vu6v+P6T1WoWy8qCF1pWkPd73hXskK7/40=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV2AZ/LhrzLPfGz0zl7wblWTeF3Dup9vwq5clxVHtVacn
 PP4eGRSRykLgxgHg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZhIKi/Dfx+db8taJcIfTevZ
 nq4fEWxhd09ePpp90f8elr2zH24QXMnIcFHtn4LOsaW3nLZHRByZ8vBneP1ejufWJx+0aaibbw/ kZgAA
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241016185722.400643-4-ardb+git@google.com>
Subject: [PATCH v2 0/2] crypto: Enable fuzz testing for arch code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Follow-up to [0].

crc32-generic and crc32c-generic are built around the architecture
library code for CRC-32, and the lack of distinct drivers for this arch
code means they are lacking test coverage.

Fix this by exposing the arch library code as a separate driver (with a
higher priority) if it is different from the generic C code. Update the
crc32-generic drivers to always use the generic C code.

Changes since [0]:
- make generic drivers truly generic, and expose the arch code as a
  separate driver

[0] https://lore.kernel.org/all/20241015141514.3000757-4-ardb+git@google.com/T/#u

Ard Biesheuvel (2):
  crypto/crc32: Provide crc32-arch driver for accelerated library code
  crypto/crc32c: Provide crc32c-arch driver for accelerated library code

 crypto/Makefile         |  2 +
 crypto/crc32_generic.c  | 94 +++++++++++++++-----
 crypto/crc32c_generic.c | 94 +++++++++++++++-----
 lib/crc32.c             |  4 +
 4 files changed, 148 insertions(+), 46 deletions(-)

-- 
2.47.0.rc1.288.g06298d1525-goog

