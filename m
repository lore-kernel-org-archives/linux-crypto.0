Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA55198851;
	Sat, 28 Dec 2024 18:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735411811; cv=none; b=G8HU6MsXCi4YNVdFTVbQm/q4NLQMpThYdmgYCzIZbqq3XyjCxYe+yBHzWN6c/DfWuWgDcXEe59iza6OhjW0C1CarZ46yAl1wYxb0NJrYxcksmS57v7jdO3+qGa0BnsgpAbLy2lr9MKEoyuqi5aT5F6iKK0SY4v1UirsxVrrVvNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735411811; c=relaxed/simple;
	bh=Y36qpgZuNibHp/0b/M35lfq/59snkWlET4iGJIGq+a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VO2ykMNf+HweV7g+9uaYpIirfoSU8OgwjBC2Zescqq3MkWpNAsgxmyf88dr/OkjgBNqj7M7oyJg8/vLnJ9DC3ciPdKuIpfPwiWAzSuHnbqRhX2ccwaF+f1EFGZ/HjvH8PYyRLfoGp6rx+E3Ca0n6mHcRiTKGX/DkG2SLbyJ/cpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZU8asaI8; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZU8asaI8"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e3c8ae3a3b2so8333341276.0;
        Sat, 28 Dec 2024 10:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735411809; x=1736016609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jD48FtZs8AJg9NzYr99SZEdQPts4PFMxSkqb2AKddOM=;
        b=ZU8asaI8vFw2opbeAIHQh23y4cyZhfP3/WgHAq1A//ojgKuywLqTypnVt0YQToYovH
         jQMqTtp8GjkKCOiSyNJEU9Rq/SYL8Alml17awMs7LSWNa+BJoS4MDA7GQXMcA9b0alF7
         ALKsVB0Ta3c6pzLrYqeIDDXvqvc6983jSsdrTMANynjYFctPtWrIb4uBcQ9dg17L/bG2
         pZ6vwBYXUOAuvmm0TY0rzT8V4exaupPE/3wAnfhEWagPN8g75LAQh5Abn8soCPYPddID
         DJXqi6IxpkyQ+0+qsD0eFO+LRlcmmZUaVAKZXoT26vAL3H6XjNcjcVG21JOv/weeM5/i
         tOcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735411809; x=1736016609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jD48FtZs8AJg9NzYr99SZEdQPts4PFMxSkqb2AKddOM=;
        b=tNJ6Zy/9Ig7BV1vy723aPKqPHlrctJNcPwnSbfVcddDOZmKzh/v2pXuUThksI8Ppyf
         bQoMuSMvfkDHjptbYhQ/vJgR+pluoF5njai+8es/tJJL0VVSukItUZXjwwOUBel2oPBo
         5cUrnpD3X5Q76o/O3nmDRxIt7QJcBPyRexkPmpjMHahjRCgtinAqSCV9iUCxIeo2Bxwd
         CCOCLGfcjYsLog/WUKnRUCyDwv/n1N1PVN2WNM1txKQ6MIbbIJm2GSE5vzV4x1FSGoVX
         bWtj37DHAwPF4vwnYIO/JsmRS7Jxth+idfnCfNeusyFZYtVv5A7dHAdIbQ8C6UnrYaZv
         Bbhg==
X-Forwarded-Encrypted: i=1; AJvYcCUzENHO8BF4vnu2bHzI5SCo6vvJ5fkJ5IdlP90u9wUN4rP2QbvgX0Wp+IAJPOv7uxfQjll5Iw0yHvnWHkM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvGnHnIJ9oqwSlXhyFG5jBLzdF7I5o6DOfN472Q5Qgy/9tKLSF
	EtYTzfEkHUe9tHPO+Oybd9lW4yF7FYg8Nxlor2zALftGgthJktRkYVJC80cV
X-Gm-Gg: ASbGncutOtT3+cTV3TdzJWylofhH8bMKr0Mld0xhF4IVweshxDlpfhEabzn5t/Q00QP
	wp+fn1I/UrCJ5E++UP+uNkBrnxhYSLAhvLAHQGD0Frdg4Uwv3P7h7yrjKYkfVJ5dal2YSsnjKnq
	7D+q8Up8xmBpDvRpbemH03JguB2GrxL5mwGl0pM4Vq2EePkWmnjOkuATyyjaUTAag53sfQLcgPc
	hYN7tu6krFadra5O5geClvyJ1OFnZe1APxNuwzaYJvqfbpZrryOkHDiElFqUOjky6msgRzbBQQY
	gTytL1NrMdTkmwFL
X-Google-Smtp-Source: AGHT+IGA02mULLXTgZpc9KsUxFci/4mGhqaGX1XguU/K84YbqdJFXZAgmyx9QVhduS54arIbyISz2w==
X-Received: by 2002:a05:6902:1448:b0:e4c:66ab:ed4a with SMTP id 3f1490d57ef6-e538e10a164mr18335009276.9.1735411809420;
        Sat, 28 Dec 2024 10:50:09 -0800 (PST)
Received: from localhost (c-24-129-28-254.hsd1.fl.comcast.net. [24.129.28.254])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e537cc1cee8sm5171710276.13.2024.12.28.10.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2024 10:50:09 -0800 (PST)
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 08/14] padata: switch padata_find_next() to using cpumask_next_wrap()
Date: Sat, 28 Dec 2024 10:49:40 -0800
Message-ID: <20241228184949.31582-9-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241228184949.31582-1-yury.norov@gmail.com>
References: <20241228184949.31582-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Calling cpumask_next_wrap_old() with starting CPU == -1 effectively means
the request to find next CPU, wrapping around if needed.

cpumask_next_wrap() is the proper replacement for that.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 454ff2fca40b..a886e5bf028c 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -274,7 +274,7 @@ static struct padata_priv *padata_find_next(struct parallel_data *pd,
 	if (remove_object) {
 		list_del_init(&padata->list);
 		++pd->processed;
-		pd->cpu = cpumask_next_wrap_old(cpu, pd->cpumask.pcpu, -1, false);
+		pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu);
 	}
 
 	spin_unlock(&reorder->lock);
-- 
2.43.0

