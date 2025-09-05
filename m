Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFADA301484
	for <linux-crypto@vger.kernel.org>; Fri,  5 Sep 2025 08:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757062639; cv=none; b=B6EzChKH96OQxjgS332ngP5+gXcwItTS1NQgKrvR1wN/i8OV6ao0mtaXgPlXj3KlAaNLUk8Tt+Y33DVZkQkmza6kyL9b+SKR9yuOiD4M5rdnyRjmL+xjZLEPS5ZBwmqQjcCqqwuW2xzYEfQ8NOG16kAWRMdJQ+S7XA7XYTW76KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757062639; c=relaxed/simple;
	bh=noY2x8YkWOlIpwgqQFN144/sc7GwOOQv/UpDW+VgwuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H8UKIdDxlKtduZn/B/jjR8Jf7fZA3J8PYeCXRrDP8Yhy18cHp4KfIvgLZDbS2bOAX/SkUxWjRnUqKxaxkb+zoTaSkYcbhQnPC3uFJVi58l1taRl02vy8JsFZdYQc3/Wo67JF8YOy51YrvP3G68mvfIqir3MYRfshUdbw7xQe/7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=H/j3WqlE; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H/j3WqlE"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3da9ad0c1f4so1275168f8f.3
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2025 01:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757062636; x=1757667436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R+373k89tWwun6tYrTn7kvcTBTelhNfYslI7h6eKl8A=;
        b=H/j3WqlEoirAGQqSFsD3CLZUjCyc1QYC1HVa34czKbyWhFtO3povl6xhUcB3eC48Zo
         H3/2E7ORLPEQB9bcQo3w6BXpoRI+gG4VeZcQqIFCKqM5ViEpEkbebHZR43uDUgSmcx0r
         jH7IEhhDdovE2IGXmFIkKFaR/2bntPVxH6ffXuqCVNHEpIC9J/MIYm+PL5fntAYeMbH3
         FaJNiHO4ndKL06tc2Z6DT3y94+l8wQwWjMoAgPNW7FdLc83aMn9xmzvfZ5qJ9D0EmznK
         I7X5BMJa29iVYAqvezlNVutCC8E2KypOYY9dpFr+xewxkkBR9WP9iSDjIPYQYS6QbDE6
         tT9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757062636; x=1757667436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R+373k89tWwun6tYrTn7kvcTBTelhNfYslI7h6eKl8A=;
        b=EPK3sJ9PuMczj8a2USmQpTbukzHDhXOF7l+uC0FhJCQSj0IOvEYvo+//aqKwvmqw6I
         zwX9XTQmSB6OX4ObFmJbpdeLFuto8+bOvStPOdVd8YmWbw6TsZPsZtaEcJbnnQINaQ+1
         OKi6BxctNnygKi/3xfuSCbCXnhjY0h0wWXC9Sc7CNR5BCklk1JLF9RIoy1IXdyQ/U38j
         R+jmKkaZP+NoYy67/7njjvAkH/FR2DA1NsOPIu049zdKQm3l9y4Ni0qX0evCMXHC8nK7
         awTorSVNfnnOFinbBECG7BPIHan+QPiaStrlwF5ehFwlObvzYh4YwhDqAUNBjRtaDXp2
         EBMg==
X-Forwarded-Encrypted: i=1; AJvYcCVKVWv3TakVlV/VO7YqAqoaPGKAsLFdAdF1eUlotmuY/11iQ4Icw8W0ReJ8XT46Y992x29968ZApYv+Uac=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWPeVtX11oDRCxrMjOybR39YqYqjZluJ5RVRd/4uQc+MlyV7fT
	R0ZDWxEwe8hI/Dhn2wq24BrzUObGtEctr+3v/521k9ZUM+iNP7+qkTw8ymqOO3Aa8Uo=
X-Gm-Gg: ASbGncsR4hXnnoFVhiQHJgBHDesuik1Tbq3xpgkc3o9jI015pfZVcFT6muo3yanQyMK
	tJ3CrUlGxdpuLW6nyPl8qrbh5sLhQuE/DhqgsH2S/rWbdWVsc0+zSanorv0SG8+BT0hKSYpBNAt
	z3wZTXbTO5IR8/w27IwQI2aGxZND+bAoRnLLFTAb5H6swN6GohpWcmAPINqCR0GZqOsBIliwcTX
	EEKuefl/2G5vvhPyPZYTUXLSBpqQGoAzrYY1pcafrZDp7e/v8ScK8WyL3iVJpLN1HN99fRcaJ9K
	H3w2aGb6PPnpvz93n7KTheZl7k+5tWBpQIPOrBD0+6gIBeasqRYupFMELJTdWCldZf2tmSR9Tci
	vqBuqcKuzizSIzHPb+b0nWtPsZIU6RrOOAOVQClnoGmc7mtY=
X-Google-Smtp-Source: AGHT+IFo3nXBnIvWK8ei6IV3F8NXhA2ZlYdh4WG/HM6kH3mQu1re7CfNZmk1avxIW8asrKmx/77+IQ==
X-Received: by 2002:a05:6000:1447:b0:3df:33e9:14b9 with SMTP id ffacd0b85a97d-3df33e91a11mr8128044f8f.11.1757062636152;
        Fri, 05 Sep 2025 01:57:16 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e177488999sm5094989f8f.36.2025.09.05.01.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 01:57:15 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	"David S . Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/1] crypto: WQ_PERCPU added to alloc_workqueue users
Date: Fri,  5 Sep 2025 10:57:01 +0200
Message-ID: <20250905085701.97918-2-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905085701.97918-1-marco.crivellari@suse.com>
References: <20250905085701.97918-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.
This lack of consistentcy cannot be addressed without refactoring the API.

alloc_workqueue() treats all queues as per-CPU by default, while unbound
workqueues must opt-in via WQ_UNBOUND.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This patch adds a new WQ_PERCPU flag to explicitly request the use of
the per-CPU behavior. Both flags coexist for one release cycle to allow
callers to transition their calls.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

All existing users have been updated accordingly.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 crypto/cryptd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 31d022d47f7a..eaf970086f8d 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -1109,7 +1109,8 @@ static int __init cryptd_init(void)
 {
 	int err;
 
-	cryptd_wq = alloc_workqueue("cryptd", WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE,
+	cryptd_wq = alloc_workqueue("cryptd",
+				    WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE | WQ_PERCPU,
 				    1);
 	if (!cryptd_wq)
 		return -ENOMEM;
-- 
2.51.0

