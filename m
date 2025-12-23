Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D513009C7
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 06:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766471648; cv=none; b=KW0mCJMvX/RpGHjvIX6cfzB22dne1wd9vnBINyOf5uKQyO27nbzbvuNCNhEtwuQFRNKa9Et7cGZouv3aBLgaC6dA60QYWO6lLvp/i844MCuzKbvxlgKC3vwbOwa63+YAMoPhkMrMXtizicUlDL8Cn0j023W7Ya5sueyVr6vAwnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766471648; c=relaxed/simple;
	bh=zQMCxWwv+vy2hbOmutXkA1vn5ZNuVRvD6yhOueNtNZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6g6ep+BK0fh8ipUPW+MoISSwiWYI6yORU/yq1/SzChz3k4vOUUg/qgY/YhnSemWD0HpW1b1sB9v629+gVTZhb9wSfWnVWfcy6cOn+Kobz7i6pKibtMW3hMwThNpOGjZwbLzGKItic1TtbktWdt9wFm8VPVrN8sQlRYRZmDH+d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WwAmUTBH; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WwAmUTBH"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-37b95f87d4eso40780381fa.1
        for <linux-crypto@vger.kernel.org>; Mon, 22 Dec 2025 22:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766471644; x=1767076444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=048jzD37H8lsx/zZlGI/PEx4g5lnBiNM8RokzD3mdsY=;
        b=WwAmUTBH+Z8XRKtBCqY+p4vhvOZdSmb+n+f1cbt8viJVJQHBr5U0jo/4s6d7qWWbBf
         m0+yEyt1/jvRcNLPLCeivO4iEJDrI+k3zJ4jS2PQa2ZNeiL1Tlbub2tME3cf4CpV5t5x
         y2v7G9wdrigZhwrK4c7Yef+E/fzqp/cS5XJetFqG4hBREaOaTvMWzFG+nlcM12NpLnyV
         bWftFqc5KSBKZ0BFk6cyJPxHYk5+KPRoe6KeznkQ0/TJBWIgfaUW2op7B7NEb1bQFuep
         6NgElzoJ6xi+uJ6OfcZAZFe+8coZdOUBZ5vF3OSWtmJtAEFFTI3kGZUoLI04b5pvc8/0
         nauA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766471644; x=1767076444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=048jzD37H8lsx/zZlGI/PEx4g5lnBiNM8RokzD3mdsY=;
        b=JSSvHNZQyvrJDF1WZZJhZnPs7WmtBvP0nXKsdUZkLS/zG7ECPx2b6fXxDmDXPS7vss
         WtN1Vu9aAWM6La4Zq1zt0765EoG1uFnM9c2ufOU06wT8LjZ1agjN6KnSqvZJ1iZHzuZg
         CgyE3jW0uvV0WhCU4xPBVcJTw76DEEC9bBRtk36HDfN9MJfh595VsWDJjImyb7jVcf15
         ZJhTx0rsB7YcaNWFiNVyFhpk2EaG5Jw1c6yIaAeqk5/Sdip/HPgE30cxJfwP1QRgjxtZ
         K0T6i/qBDHp3kiWSrXEhqouzVHZiwD43BKr6Bf2slK695f+uRYpkmGGyc3ghtz5MwAVa
         E3VA==
X-Forwarded-Encrypted: i=1; AJvYcCVM3qPQKZw8+cC01pChN3lA8PZXnF1qgC/NYsLhi7A6wNNCwupWVHutbiqPsqO0C77g+mhsgbJ5u2gGMrE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy55zGMwssY1H0dpc9lVWGRDn6Q6RfdNaebmyT/biY2JUJqZK7b
	TYCOlSSKVPAchblpg6CMulsUryE3dagbss5eGlULO573hWGcSobMJo8YVp2hNsFu
X-Gm-Gg: AY/fxX7T8ZaJXqi16RkZvIcgSCy/R4xXJ4u5tKVo0It8jSPaSfQvl+7F7NXHgcds+IN
	bQPSNL/BoedDRwO19a/35ikSVczGdH0qo7x12adTNpL7HZxDlGwMI1513ev7KkAoeLf+/mYL6Ax
	+kWC87fc+zT9avttH1nq0mmlFdNl2+NBKtS+S605enMPAENPbq4IdqBXbPiKIyzmW9BT3ugW5kB
	7A/uH9aL14M0pYJGI+kO4uAAxxwFnHAwjtIKZIgU2jqJRekjdR+hACuKng0MfFG0xuJPTy3qk0t
	dvMvcLwuz8ekxGNOKtp3gnYdTFE8R/aCSBVXCriPvPGFDeN9/oilqC0T3O4/gq8AaV3WJTpv/md
	JXXAbPiYAer9cjQ/TPUbdbCYvIKuzaeDUgcYumgBVKVRi2WF7YK5agB6aXV6bxv5yw6CESPXyte
	nOEuDGgtWzEwxjDc5faAE=
X-Google-Smtp-Source: AGHT+IFaFE0nlDnowk+Ou3U+M9eX56ZCvZ4aEX/mIAF0sQ5oS0z9Fh1vnyWDY8DQIpJC2t19J66zfQ==
X-Received: by 2002:a05:651c:1506:b0:378:e055:3150 with SMTP id 38308e7fff4ca-38121566b66mr43783861fa.5.1766471643890;
        Mon, 22 Dec 2025 22:34:03 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-381224de6eesm33742031fa.6.2025.12.22.22.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 22:34:03 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: gmazyland@gmail.com
Cc: Dell.Client.Kernel@dell.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	mpatocka@redhat.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	safinaskar@gmail.com
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Tue, 23 Dec 2025 09:33:55 +0300
Message-ID: <20251223063355.2740782-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
References: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Milan Broz <gmazyland@gmail.com>:
> Anyway, my understanding is that all device-mapper targets use mempools,
> which should ensure that they can process even under memory pressure.

Okay, I just read some more code and docs.

dm-integrity fortunately uses bufio for checksums only.

And bufio allocates memory without __GFP_IO (thus allocation should not
lead to recursion). And bufio claims that "dm-bufio is resistant to allocation failures":
https://elixir.bootlin.com/linux/v6.19-rc2/source/drivers/md/dm-bufio.c#L1603 .

This still seems to be fragile.

So I will change mode to 'D' and hope for the best. :)

-- 
Askar Safin
