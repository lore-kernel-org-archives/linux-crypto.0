Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CE7285CAA
	for <linux-crypto@vger.kernel.org>; Fri,  5 Sep 2025 09:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757063147; cv=none; b=JhIh6xtxdklW8GPy6r/ODS3UaobOYOAi1rI0NVHE1+YwCDjdBZmJ3Jd25Jq4l2x8IOKovewQgD45AvoynZtwA9WZH187nHNpDa4D1pJwrfG5YvvIdJoufTM+cXtvefAspS4rTdIo/DHpRQdAnDUy+ePF6aeMZnpHa82/JyiW75Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757063147; c=relaxed/simple;
	bh=a+YHoyzddr3M1lvAms3gbc1KC3x6fhSXZ1nfCpdsqqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbQ9P8ZNO5bLCVCVSl6ETbpLmVJzvdbePzGZXYn++CjMXcze8q9Wh2MOZVgFZZV3pupSeWND0JY4uPFFTinkl3Ge1jTtQxGSXnlSrr1V15+LU3g3T3YfKDUtbhe6s25gE2enfqIvyC1/JC6fBrq1y3BqHpyK0uipRZyghAI6/4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PMmQcKUz; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PMmQcKUz"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45b7c56a987so8036875e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2025 02:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757063143; x=1757667943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MlPw8c1buu+XznL6AI4WMMxODpf5JODmGNHWscy7PUg=;
        b=PMmQcKUzgQLwMtQ51A6AO1nwdHIE0oEh0kb0qN9+n6Pjb9xbP+o0k9jBvzZnVdeGVW
         bg72UJxYny2vBzAVaFhAWTTDxfacBd4PyzYZ5TldCrnJghg2qwXFpp+GAdltGsvNYrE5
         i5oacevqhuN4oivPpswP7PmLLRfl7G+S9twGMsLtD2Cqlwem/slStiaolXakLpoXEpcw
         yP7J6frxVdFUATq/9/9TrKq+LI2d3PsrF6+WvCUvZx6KH5i6GvowAHb/tdMO1b/PRd7k
         QT8gycR4kyNQDGSB5bOSyd3zWjuiSRC7zFkxgO0k/AKMxkA2oXzFnAdt+CIJ2vxmV6jK
         BFzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757063143; x=1757667943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MlPw8c1buu+XznL6AI4WMMxODpf5JODmGNHWscy7PUg=;
        b=cmZJSenTJaI0x/IUxqwpU1aXHDstbGrtvtXxyy9MiRdpGFnho25g+hn30DVHqXJ4A6
         YWVajyZaChHzf9WogsMIfmGp3zdZCcLjmawObebFZUerSUcBxdXOpJr01qj56HIRQ35r
         h2V9BuHuyWTxJLxhtmsZA7c5VSEP6pekrqoWMvto8HdJVDYbM/X2EmxognaAYCznA39j
         SX57nGoE5EjLvU5p90PGtUG2QtkrNBzCjScsk5FV/XYQ1B1sNDjpmrCDWDU8vpo/0f+h
         zymAl3jwIDj8j/nwfMs45ZYMRgs+z8NDwmgqChuLh6b03MU/2JHaHgNOiObL7eRwHrUe
         J3bA==
X-Forwarded-Encrypted: i=1; AJvYcCV5qszC/O9PE8qfMmPJgrzjbm+Lc4KzGsQc+tvh8WFqceB8xfpT5PyxsS2xB3Q+X+1PyhPnXbXV9Gaqj8k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT/JxzLOgPAP1oxcaG0XXQ2x060n5JXAl9GiiDPuFlo68lTpkG
	VxrtJHEmW/lved2WQsoXwz6PumFk2fubwhR87J+g2rrYmnzTQsyPp9Lngsl8SJjQiI8=
X-Gm-Gg: ASbGncvfiiE9EnwRcWBinCmZYHr03nQHTZEIU+MRPHVjbX5RljHWipQgXhj9kNF9x1U
	acukXFm7JNDjCnH3ISyexMEofulqbq1/mhFWuFc9TQyc+J11RMQsKv3bnEhhmqJbV20JundgPG6
	IIjdOHn9TZsTZJqhc8mUxSql+KI7tvO0BG0pPwCQz9uG1ydI3aO6sb0W0cuPD6/tL6XbEv60WdH
	wfVAdNv7RjBSFbet8Hu4DtbW0u9IdcPTW7U6M+NwQ6cezQyEpaRgS42FqFuK4nMVpu++R+gUIrb
	JhuHLeXMtz4rxrKdCx5ZBf1/z2uYupBDZr1+l2zH0FGmNyoJWWiG3YTwxzgMm9DeyIbpqpjKwvk
	McvIsTR0mwySTEQwDHpR2ohx9gqqvUqV66Vii/0jkGSK0Y4E=
X-Google-Smtp-Source: AGHT+IEqV2GwVMhOug5G3Y/HEmwqQ316oxFT9HdjaGn5/clCwNV5gMznP1aXnQzt3IWA8XOj0hQm0w==
X-Received: by 2002:a05:600c:46c3:b0:458:c059:7db1 with SMTP id 5b1f17b1804b1-45b8557f254mr213463215e9.30.1757063143134;
        Fri, 05 Sep 2025 02:05:43 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd0350e80sm68794625e9.22.2025.09.05.02.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:05:42 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 1/2] padata: replace use of system_unbound_wq with system_dfl_wq
Date: Fri,  5 Sep 2025 11:05:32 +0200
Message-ID: <20250905090533.105303-2-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905090533.105303-1-marco.crivellari@suse.com>
References: <20250905090533.105303-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistentcy cannot be addressed without refactoring the API.

system_unbound_wq should be the default workqueue so as not to enforce
locality constraints for random work whenever it's not required.

Adding system_dfl_wq to encourage its use when unbound work should be used.

queue_work() / queue_delayed_work() / mod_delayed_work() will now use the
new unbound wq: whether the user still use the old wq a warn will be
printed along with a wq redirect to the new one.

The old system_unbound_wq will be kept for a few release cycles.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 kernel/padata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index b3d4eacc4f5d..76b39fc8b326 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -551,9 +551,9 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
 			do {
 				nid = next_node_in(old_node, node_states[N_CPU]);
 			} while (!atomic_try_cmpxchg(&last_used_nid, &old_node, nid));
-			queue_work_node(nid, system_unbound_wq, &pw->pw_work);
+			queue_work_node(nid, system_dfl_wq, &pw->pw_work);
 		} else {
-			queue_work(system_unbound_wq, &pw->pw_work);
+			queue_work(system_dfl_wq, &pw->pw_work);
 		}
 
 	/* Use the current thread, which saves starting a workqueue worker. */
-- 
2.51.0

