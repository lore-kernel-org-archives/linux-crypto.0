Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D29B640
	for <linux-crypto@vger.kernel.org>; Sat, 14 Jun 2025 00:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749859725; cv=none; b=Z1ztcGE54SmV8DHjJud/LUimt/KiglygQaXlAIiHQiPanKuJrPM235szhsctq7HXkH8pa8l+sIXhEJkDogzvnJyqSHUfNUEUkc1ytWmQ5N6W2Oi6acdNDh+P+GQPz1y+AaYRQvGefm44r+jPOLPocPKFvJlKeYKE9UmrOQByKNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749859725; c=relaxed/simple;
	bh=vuCp+799+GA2TdD3womsE4plTUsz+mVthrFC6jCIhdw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ch6rl0FNGY5+41nY7EQR87kQITAaAb3O3GMmLEjMXLyT4W8JmvSvoqN1rX17QJ1OURdF82/ItXJmBr7Dmtvf6DEUkw2BqyZHVheDIxn1Dqz7GPh04VlSdQVaqRCStXI7k5MkkVHp6qZzG6pl6uhoTEXhq9PQgBd50PiFVxnT6vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--yuzhuo.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2nu2eXsv; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--yuzhuo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2nu2eXsv"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313c3915345so2956275a91.3
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 17:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749859723; x=1750464523; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8gRBKiUS/LqVw91mdG4BB51Db6Wh9r5ixmp7H76fvHU=;
        b=2nu2eXsvEsSCFdHixF1YPnpPXIXtmXWQGtto3WpgQoaxhZrwqHMa4F7vR8TZK7MUCL
         aSucvRFt1fEWsW6C6xp49/xOqtBe4z9DcVMJCqK8rSpbqOg+TcogkoZ4caSmPoWPIWd/
         vR9ArBk9MM6I1cK1518f8xb0Hp/nEQyuP09+PYOAuwZ3Vzj/uHXfNFHYn0kyV9AWM9Ph
         tx7ADrmV+5K7suFvGeMLiKO53WJpds/q6xrnypgTf4yoRkxNbUX6rNToJkf1y7Nm8O/l
         2973k19vi9VspB2BsEGRfcvMXyifYUhGOOCNbcIbM3Vr8XU0uTt4gmMld4bSpZaP7uuL
         nKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749859723; x=1750464523;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8gRBKiUS/LqVw91mdG4BB51Db6Wh9r5ixmp7H76fvHU=;
        b=cPZCm8IZKb3OA/W9Cbs9peP+lhbY43GB5+K9fTnWb+vDBwEyHYa+WLm+L01AoNDP61
         jyfYQV3OOUh/4pAaCv7z5xjo7NTHplS/CUSeZag4b7QRq0Hreo485xnG1iBalw27+Lxg
         VKeWkV2t+9lWm2s1wn542Jk/ksmHz56o9UpThWJ42ihyDF9MFvWYuyoiDB8n87j2Kpo6
         weiYrIIo8WOmKY2rKQWlPIUiQfOjZGxIXRzurIItMGlOOqwGEAwQICFAShOT80T/6cU0
         8eScLhCsOVrF4XzLRNJhGPYPoyyg5XBuieYt0AsxIs0gP3equIsOAxH8BM+MJIM2O/Bb
         zY2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXstLbaaSfS1iavfEt1BlWByjO1aKqZgoW6mCwCaqPhD49I9wLoFr/3Ph9SquR0s/3MBfT5mAdv5dApuDU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEYIMcOFsIyp37h4QEMnRb/pCnZKldfOi6AW+LAp4PzfsxLpdT
	dmQafII+zF/eV+7tKvlLdE1HgjA6uai+CHV6pM9eXLmC1m3LdkBM5sIV/JvyQjPs5LV8svlMFgQ
	JEpwvmw==
X-Google-Smtp-Source: AGHT+IE6o+GDxvYYDKjM66M41eSWNOGyDPF0TERhOYuWw3vwrpms5wYhLmIqj8aM36fhlBScuEhdO5teB2c=
X-Received: from pjzz7.prod.google.com ([2002:a17:90b:58e7:b0:2ff:84e6:b2bd])
 (user=yuzhuo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c8d:b0:312:959:dc3c
 with SMTP id 98e67ed59e1d1-313f1c0c004mr2437852a91.10.1749859723377; Fri, 13
 Jun 2025 17:08:43 -0700 (PDT)
Date: Fri, 13 Jun 2025 17:08:26 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250614000828.311722-1-yuzhuo@google.com>
Subject: [PATCH v1 0/2] crypto: Fix sha1 compile error
From: Yuzhuo Jing <yuzhuo@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Ian Rogers <irogers@google.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Yuzhuo Jing <yuzhuo@google.com>
Content-Type: text/plain; charset="UTF-8"

This is a followup patch series for an ongoing patch series to reuse
kernel tree sha1 utils in perf tools and remove libcrypto dependency.
This mirrors the fixes made in perf back to the kernel tree so we can
use tools/perf/check-headers.sh to monitor future changes.
Link: https://lore.kernel.org/lkml/aC9lXhPFcs5fkHWH@x1/t/#u

This series contains two patches: one fixing signed and unsigned integer
comparisons and another fixing function type mismatches.

Yuzhuo Jing (2):
  crypto: Fix sha1 signed integer comparison compile error
  crypto: Fix sha1 signed pointer comparison compile error

 crypto/sha1_generic.c      | 2 +-
 include/crypto/sha1_base.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.50.0.rc1.591.g9c95f17f64-goog

