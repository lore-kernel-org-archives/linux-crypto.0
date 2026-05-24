Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29D430C145
	for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 19:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779651947; cv=none; b=Dr2JxTGHdi6eW4NTl3tolHDIxvbo4ZyJza7F0lvZohP6KckmlmzxsmNBGd9FeWKRpXbHwNskdifcHKJfsUOMU+4tT0aV0exMM3dcJ0jaJMopOk+ZKigYcR8DKZanwzcmpJiRg22OeA0FoTx7cWshQjDTcfqTMuHGD/IkSbEi0oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779651947; c=relaxed/simple;
	bh=PI5x+KLeOxar4DgYS4Ki7bcybjyhET/Yu4OLCtCXFnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QcazzHqk8b7BFvJ+ycLPxsmWQKCjH8O6U/MhHWNYcYwxMxwJSp++3brHaazdjcDQvw7npdxHWNSCGaIiumsShQmv8XkMqkGaLHZW3D+vkKHovDd2ktIalVDZDENmrZgIFkrpcRuhOqgBj9OSfxg9wpKwMEVr9gztoAXt1oTyFtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gAIYWOBj; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gAIYWOBj"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ba21d32776so65630225ad.2
        for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 12:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779651945; x=1780256745; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JA9eytA8eL8TitP57tWRyURByetoHVVveadHTWdSjN4=;
        b=gAIYWOBjYy8Lc+qk7my6IWM0K0o2R1G8gPPrxMFunqsrAquA7k8vMtCc52uMNDF1sX
         lwmMOxcnTg3ChKcSabm/WwyXRP5eniExaKxzcd5iKh4YvidQAsCmbMBawLJt8ALrsIx2
         aSO7Dsj4k2FtWALW4JodzJcyYd+Kk0QHQ4ysnRm0RvBj/RwCYa1X4uX8ShNTpVCAWf6+
         n5EuKflvnlpAINsOcYcFHbF/uBwlrZORVZ0oX3ZAMtL/iZ3jBe4q05Wz9nKYeEfcllZy
         0Qpx/khIkpHzu89ny2/7lRLRI84/VoNdM5PttpiwYLBIgZRfBpdoMb6iTFUhiwFMldoP
         oIhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779651945; x=1780256745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JA9eytA8eL8TitP57tWRyURByetoHVVveadHTWdSjN4=;
        b=h6V72YvDTWforXrm4Ch0VSTX/LJDdeS289c289NYo3BW6uxuQXyjxA5gE/VafUDhg5
         +1sSZyPL7C8IxbR6yqq0+AP/1xClNmFgIkZMr/DnNJ4RXaL32HZwM7N4GEEgDoXUiXzO
         oucMZaYi91M2DZmKo74bd4XzV5S4adyKv59j6jNuIbS8fUJKEx0ZMwklGdwWS2JU+3Aa
         cufErkTDhac4pjOhlfsTrTI6K3qIJSOcTaZdhopvBCFBWbRr4MyT6TH6DuHyiN9FBSEu
         FCsUWYeTQt439VrbxLLBhLPmlcmxPzSLrN8dx7dNtrEi788A89h+uvHM2vuZH2zJICsY
         PpTg==
X-Forwarded-Encrypted: i=1; AFNElJ9unjPJnDFDnS4xTobwnIEebmcvEJCMZAFi5/sTlTG+I2QKA940c22yNOyiPfo1zcp0hplgKUwofjcKklE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAEf+XtrrDXeKmnaFdBIecg3AlGVnPHjCd0afYjHxxeJMs4+Ed
	hJjgstPXfGRUdrvfIpUndBfWD96u7aLvfz/P0QyKTF44lGzmIY8TdOzE
X-Gm-Gg: Acq92OFD1o+1q/IrOcU6oEOzyd0KwhTgDSSHIIu+5fJ/SP+5UdRViuDuV8lLn13bAMm
	pKmf978GHoYWc0W+luyBCeop6ria4DMH/0gCE9Tl5sowTGJ9U99CKOgS5Deo0wgh5Any54Ci9CT
	YSgZi3uIeV+HmVTubrQRQSFpExm+uu5B5Xj5YhQZdQjM8S57FrKuhMF8crc4oQOznWGAjUdvhQ3
	qFVQKECkZZE3CnKI/lvUsIk8JIy1vU+iQgsqN3/KJcIS1zQ2kux9DW4SYUTevPLk834ImhFMcig
	fB7yd5r8fyklj9U/As7g0kdPCLrxLySpEEVbbV1LQY1dyvu1y0F3D/WDaoHtKw4nHXlQK5QonB1
	RPEKsPQ8SStpuDKKw6k6kcZqyxPht8oLXOTjH+VN/LZl6dolf3sTC/ME5Gv0XO9RY8y+v5us94r
	Srm2yDyJ3idcbUY54x1nDw16eM
X-Received: by 2002:a17:903:2c04:b0:2b4:61cc:37a8 with SMTP id d9443c01a7336-2beb037a5ebmr126108415ad.17.1779651944967;
        Sun, 24 May 2026 12:45:44 -0700 (PDT)
Received: from mincom1 ([125.149.177.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb590aa7esm74414485ad.78.2026.05.24.12.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 12:45:44 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-kernel@vger.kernel.org,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jihong Min <hurryman2212@gmail.com>
Subject: [PATCH 0/6] crypto: eip93: fix request lifetime and completion handling
Date: Mon, 25 May 2026 04:45:22 +0900
Message-ID: <20260524194528.3666383-1-hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series collects EIP-93 fixes which have been carried out-of-tree for a
while but have not reached upstream yet. The patches came from work by
multiple authors; I rebased the relevant parts onto current crypto.git,
split them by bug, dropped pieces that are already upstream, and adjusted the
remaining changes for the current driver.

Some of the original patch sketches were initially written with Claude Opus
4.7. The final review, split, upstream rework, and fixes were done with
assistance from OpenAI Codex GPT-5.5. The submitted commits carry the
corresponding provenance trailers where the original patch author or reporter
is known.

This series is intended as a prerequisite for the EIP-93 IPsec ESP support
series. The currently posted version of that series is broken because it
contains some overlapping fixes which are now split out here:

  https://lore.kernel.org/netdev/20260523121522.3023992-1-hurryman2212@gmail.com/

I plan to resend the IPsec ESP support series after this fix series is
resolved.

Tested on a Lumen W1700K2 wireless AP running my Linux 6.18 based OpenWrt
build, after verifying that the resulting driver changes match the
corresponding OpenWrt patch diffs, modulo upstream context differences.

Jihong Min (6):
  crypto: eip93: return IRQ request errors from probe
  crypto: eip93: guard DMA cleanup on uninitialized mappings
  crypto: eip93: reject HMAC requests before setkey
  crypto: eip93: use request-local SA records for cipher requests
  crypto: eip93: order result descriptor reads after PE_READY
  crypto: eip93: handle request ID exhaustion

 .../crypto/inside-secure/eip93/eip93-aead.c   | 34 +++++---
 .../crypto/inside-secure/eip93/eip93-cipher.c | 34 +++++---
 .../crypto/inside-secure/eip93/eip93-cipher.h |  3 +-
 .../crypto/inside-secure/eip93/eip93-common.c | 65 ++++++++++++---
 .../crypto/inside-secure/eip93/eip93-common.h |  3 +
 .../crypto/inside-secure/eip93/eip93-hash.c   | 79 +++++++++++++------
 .../crypto/inside-secure/eip93/eip93-main.c   | 21 +++--
 .../crypto/inside-secure/eip93/eip93-main.h   |  2 +
 8 files changed, 176 insertions(+), 65 deletions(-)


base-commit: 49e05bb00f2e8168695f7af4d694c39e1423e8a2
-- 
2.53.0
