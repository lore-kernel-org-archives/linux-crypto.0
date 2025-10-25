Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEFA27AC41
	for <linux-crypto@vger.kernel.org>; Sat, 25 Oct 2025 05:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761370008; cv=none; b=U5KIqvjL4JBZyzzITqgfCtFHg/+MqBZO6JQDk+WJrmhY0ztRuptrA80UqK191ZUSs6L6DLvZCFmZx3EQr0wf9FiSYjW4Ya3phL1FiZkw3AuFyMG8ckFyQLtW57JC7l7PztIdkSX9YXE2wV/JMd7p74eLbqmdHhy3g0GyiU0/OSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761370008; c=relaxed/simple;
	bh=/zQwfhMEJhTOa5/FV1euV1Dku1nFTDlTsbnBQjlqjDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtO/NLMGHzvXqAruYTjMXfrJP/xzT2AXafzYAT4u/pVfXsiTWqIiTvt6VZJ7uebGuIiBU1ixR4ft5LCWpUIUD4upGAkaBU1Psq4i5h/UGWzCq/lfncz3Yuzmxf1k97DBtW0fQQPihuN6rTY1MzPuUVXktwjHGMD4MUuDqc4t5SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pjvfa8SE; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pjvfa8SE"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-63c31c20b64so4945458a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 24 Oct 2025 22:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761370005; x=1761974805; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mV8buuSZQP0rHOq5S4b8K+cOmbjRvDVQwA71gPDHBAE=;
        b=Pjvfa8SEZbxsM/zJR4PQ+NRDcthojbCwES9h0rerasc6DuX+QlbPq3ReB7mSmCwZzk
         G+RaYizITPByzjqWgNZCCdnHaJaARqKNOXhortmhpG6uojE+a0urH8nCO97GrZMm6zuO
         DdvtNpTMeHn5rWMFFQ7Ju4peQwzCN+8hsCog0MMBRSxOQ39Bv9ts+qL7kuXrPafx2mDp
         gsIImPcmgn6dRmfYObiegOz3nu/ZxylQPh2GOg8+npFQgjOqF89CdQqJEmYiltz2lDST
         DmfDH2jHtwgINimt1F9lgcm6fSLUUT2WEstjXw4+XuAN4I8VbQ5sjQS+kAyiVJ8caOWb
         zu7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761370005; x=1761974805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mV8buuSZQP0rHOq5S4b8K+cOmbjRvDVQwA71gPDHBAE=;
        b=FN0YeFCoLhHATLFfM5LQ+UcO+CFqV34JcXt5kBUQRu7HL8ib5sH2L3gwWHLv9xvPpp
         y+M0j/3aRSIzhv9kJ1itmOMGIXiHiNY+MqCq8x3Mz767dCi4xBoGvg4fmNqJV3OFvTiM
         r8yZW3kgUqBkbq71x89FvzuZvfZ/4GztLNyt4vHANsUb+FGxVurrwSEvTym0cx+nsRg2
         ssQ5ABPPbsMDroXffor2ZuHc3MzdKeSMJxSG7anPsMAFasEFggtCZ3hRh9SdKOjmaQ6T
         uVmXxM+M6YbZfM0hEyHaDGe/vmkx04qj2ABWcX1S1bpjmZvdSkAryult60SSQyNe3d9K
         SczA==
X-Forwarded-Encrypted: i=1; AJvYcCXL2L6/R0IHHqVN4s431AtW1rosURbsTQgTfWVgcwdce3DceBd/OqjNcWwMpPRkZyZFEeDCT5eo9/mb4kY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCO8IvpwdEPrG1RiIM3EEnSo/2AtkEQJjtzc5g38LrtGESzUAH
	2UEVQO9fV4I8kJgTD47Bf0Xn6z7ixaRlGBthqSkKp+pGnN58aqYotFxX
X-Gm-Gg: ASbGncutxKqzQ+zNeO7w+vXxLAXC4NtLioSLApk50KbmanRHyFf7ILrVQKnCcNZ+Dzs
	akiyxu+XQODszOBXS8sv6ltRumqPuBWr4jlEK39JWby4bLz6cXf9/mIKyPqxdlFC71X7pgpGnZs
	emXgRoVfOGThgTbsIrVTCMTj0F948+LP/zPWpL3EKWrorm1m+fEL6rPheQTtuG7owDfi/S8OK+T
	QdeReDrxKb10J+ql/fX2mupAoapsxRGMUDYN/trWrnayHx0QD/2QpkVulS1u0a1ZdrLyFxdRu0O
	gwZz/PBGErMEJPVP3/gnrtGbapRIYiHlnza1xt9embxyLgDCZ+ym6ZJOszBbDQ3W+n8lheTMwmx
	r9LFZGhTAlarAgfqp0sP1xzDAD0CODC8Hy2HycBUP3GVQ+EpAvWtIUsN/1v9uRNxDh6lypuAMBg
	Ta74HlbmAGm1E=
X-Google-Smtp-Source: AGHT+IHk4JGeekekahtUg2k/EhAC9kyrxVTGjCsIExfHrDtgIcN62P8FCtHZWZXypDamfyJkpyvf/Q==
X-Received: by 2002:a05:6402:40d5:b0:628:5b8c:64b7 with SMTP id 4fb4d7f45d1cf-63c1f64ec00mr33191598a12.6.1761370005212;
        Fri, 24 Oct 2025 22:26:45 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-63e7ef96105sm880960a12.19.2025.10.24.22.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 22:26:44 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: safinaskar@gmail.com
Cc: Dell.Client.Kernel@dell.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	gmazyland@gmail.com,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: dm bug: hibernate to swap located on dm-integrity doesn't work (how to get data redundancy for swap?)
Date: Sat, 25 Oct 2025 08:26:37 +0300
Message-ID: <20251025052637.422902-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024163142.376903-1-safinaskar@gmail.com>
References: <20251024163142.376903-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Askar Safin <safinaskar@gmail.com>:
> Here is output of this script on master:
> https://zerobin.net/?68ef6601ab203a11#7zBZ44AaVKmvRq161MJaOXIXY/5Hiv+hRUxWoqyZ7uE=
[...]
> Also, you will find backtrace in logs above. Disregard it. I think this
> is just some master bug, which is unrelated to our dm-integrity bug.

That WARNING in logs is unrelated bug, which happens always when I hibernate.
I reported it here: https://lore.kernel.org/regressions/20251025050812.421905-1-safinaskar@gmail.com/

-- 
Askar Safin
