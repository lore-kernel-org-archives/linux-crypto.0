Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEE13C2790
	for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2026 04:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787288178; cv=none; b=LdSbQEy+3q/VRfXJHkaaDj83X/arMXzc9P+j2jnYWcdwaz8m4pqU4IL2+zzm1EZDek8YkWnE91dZC8veEGyKMFlInCuyCbfgQ9n6RvcWZyUxB8fH4dHxw4Tij45K+k0ybk5O1Hnuq4H862tLmRZosgC/tJhbxBRD3iSptCZLGSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787288178; c=relaxed/simple;
	bh=VSUk/XzH6ZbvM3SQQlU1B4cbHRY+UaU2CBVtnm6X5E0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LliY6XOoc4zBduSTHF78gZl9FWi/JXqwka57y/cAfPYGFY0HN3NwlfbnVTQRNm951zjMsQdJ7KD2O+OpqnpNFn/D3nDbxQhPjwTjPwtAgxbWWTSZ7twS0Q/yXf4P5v8BSW6VmJW7aD7DfRHmMe90mlLvrgGMabJyjXKHP9BkZaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=JX3v//pW; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="JX3v//pW"
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 94A0044B8C
	for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2026 04:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1787288165;
	bh=38QoiOApRTAQrQETaL4SVXxpg7vYl6SG3GGtq+h/Z3M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=JX3v//pWF4ErzODVNlRTeHYZcJhQLFRcOedLLrTAXk6cf7/fRWGMyE1npcpPBvOP4
	 jrY8q/xKCx5z+OP+ORwv+hfom6RyUhNloTd2oN4wa//mJCuB27pU0Jw6jfeQBUWKcB
	 oqE++QErbwRsVEr1o67ssugJbE2Hpz4KK9LTX1jWyCHUm5lNT/0hrUD1vreqWiwSAa
	 bArw9MTRQwVwaFWCciL9RX3AeI0s6ynuQQRtHZe4B/A23ehbdZHgdDGunJCkq3YLYH
	 FJS5DCagxCdNgSJutzpcBGoN37WXapKqz7yLGBHuN5SWBPUGl9gFXa03HSdOA74a5y
	 eCAgzceoV3X4FQ1Hb1hDeduR4tf4vyQenzEl86WHdaS9AN1E3Nm4KM1FJOpa9FNLxv
	 hUSHE3GeD0teWS3QUZiYkUm6UwJuQcrG1O8F47WeuCA8Kr6bTQNBdYOuMzF2jGbRw2
	 cNAbQiybGS/OoAFoppo9oaJ/7RqQxx0Q1AphvyyFllNBywRA9H5Sd/pLoUfawxav/z
	 ZW3G64TpRFgOGBA9eP2YpmnBxy4fNAajOJR7R6gSiAlJi2433ER/WFRNa7DYR1Q469
	 r0VD31veLTmHUTEZ+cMr39BqXi7Fgv0zbv9V6im4Tw+pETN+aIVXTnxfPrx2bOEejz
	 QrLsFUsmqgIzvQYFsY0fcjdk=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbedf42f199so733918a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2026 21:56:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787288164; x=1787892964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=38QoiOApRTAQrQETaL4SVXxpg7vYl6SG3GGtq+h/Z3M=;
        b=eWJE517+jNrb6nRH+pBbfm/HB3M756pG0AEIf47VoQCn56sAd2x7UcK6HskPhmJi+D
         hZFSBy4M7ZyJuar0Bolj4/Oh+cWUR7Tz6Vc7uoUSGy7EweXhPItEewgzqHb8XkJZgoYq
         N9jiWTwSRZkuwnidUiLPp046qzqI20XBw0lNAVxr3ePVz+g/biQ/GZwA1Fis8aDSuOaX
         hnj6VAkMMpNa0aDW+nLx1gnPM8qqu5c2gLlnRsjwrttVp+M2IzNG5ChoFkGrbrqS4qbK
         J3yOXi+cuJAUcYU9maPW1CaRtfvJdpqBY8VjRXFrHfM300i4CyUERuu//xv60f1Q0sJH
         DJhA==
X-Gm-Message-State: AFuF++nzoIrDgcU/np/vcjzC9XzvV6Cg4CCJKF2FQq4iKwVSSYM6VS3T
	4lzRpw7mUPBHRYQW8kSPB1GRTTOX5MuSbHByrGQUEmLcG7v2e+0kz1plpCAMemkc/zPpxw3eP8f
	sF4C4JbPEC4taIJKmD9zwSVukCP2c1sKZRUteIWSW9O6jF0TNmQJWspD8NvB1/kz6pEQpU0Iu2s
	ddvM3FOg==
X-Gm-Gg: AR+sD1098OylcH3XtdDlHyJtp/PSlSOFCoSxDVwp61j6NPNKjaWzWTELIQrbXovdwTx
	3PW++LXMyBAs99SVqNcS39RgNNdYvZ276hSBK+9Cg91BJZyA7ckLtG6fxdbL2ZxirGlR7udSt0A
	OwdC+0Mx9ha+HMYJO4Hq0hGlZvPvUF/qP8ygwxB7oTOWQ+GH6bJ3xh4y9IQe/1D9GsSs6SHWH0I
	YbD/U49oGSwPqCJWKcQCLMM/kvLNcVT56Jlcg1GNAdiomGalwEIXqDPNFWvg3n1reYUTZZw5Lkr
	mMP78AIE4MC69PcpXyCgB2+1JDN/DC2EcxN1vIl7cpd3a0pnUZS2zdk4l2QZguHGZUEASVGzLaa
	+WYdQB5z40Xs=
X-Received: by 2002:a17:90b:57ec:b0:38e:9045:babe with SMTP id 98e67ed59e1d1-395c354e8e1mr6972688a91.7.1787288164081;
        Thu, 20 Aug 2026 21:56:04 -0700 (PDT)
X-Received: by 2002:a17:90b:57ec:b0:38e:9045:babe with SMTP id 98e67ed59e1d1-395c354e8e1mr6972655a91.7.1787288163742;
        Thu, 20 Aug 2026 21:56:03 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c4553168sm1535224a91.1.2026.08.20.21.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 21:56:03 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	changwei.zou@canonical.com
Subject: [PATCH 0/2] crypto: caam - Fix rsa-caam unmap and DMA alignment
Date: Fri, 21 Aug 2026 14:55:53 +1000
Message-ID: <20260821045555.806471-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes two issues in the rsa-caam driver.

The first patch fixes incorrect unmap operations in akcipher_do_one_req()
and akcipher_enqueue_req(), where rsa_pub_unmap() was called regardless
of the key type.

The second patch fixes an intermittent -EKEYREJECTED error observed on
i.MX8 when loading signed kernel modules. The root cause is that the
rsa-caam driver DMA-maps the destination buffer directly without checking
cacheline alignment. On non-coherent DMA systems this can corrupt
adjacent memory. A bounce buffer is introduced for destination buffers
that are not cacheline-aligned.

Changwei Zou (2):
  crypto: caam - Fix wrong unmap operations
  crypto: caam - Use bounce buffer for unaligned RSA destination buffers

 drivers/crypto/caam/caampkc.c | 120 ++++++++++++++++++++++++++++++----
 drivers/crypto/caam/caampkc.h |   6 ++
 2 files changed, 113 insertions(+), 13 deletions(-)

-- 
2.43.0

