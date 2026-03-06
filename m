Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A02D34A3B4
	for <linux-crypto@vger.kernel.org>; Fri,  6 Mar 2026 09:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772790323; cv=none; b=QFardU+wyQTxIyMEEfgXYO4buxuBVjVtRnZmfLAyHQjgjFXU6wLVfXu3AkFXngGuxnfgl5AYRkwxBkjTQGHnODSCKYnv02TUFJvs7OLV7Qgwzo3EcUbGUQphzWaeBQZHjBH45HC3bVjP5G1ypo+HvBXp6z98T/wzE+C+R9aqxWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772790323; c=relaxed/simple;
	bh=wS1qxKCchhjtDwRNXR6jv/SqzMa5hcVlBO3c/OsKvrQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kSRFBXsvXplFsQSpNEqn7D5olUqb8eTv6ya/iqz5jKPG4dS54NWCcGzifwHovDWJO4RF8cqGmoc6Ulg4uTi4IosmqiZL+lbb1yJ8Afc0WemPyvkr/WviKWVj8gRfIlkP13g3wTuvEVrc6OHy2fZSw/ocNADbkPMBJlv5WifSAHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eRpLJ8GR; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eRpLJ8GR"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82976220e97so1585902b3a.3
        for <linux-crypto@vger.kernel.org>; Fri, 06 Mar 2026 01:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772790322; x=1773395122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wS1qxKCchhjtDwRNXR6jv/SqzMa5hcVlBO3c/OsKvrQ=;
        b=eRpLJ8GR3N/DESL1Zv2QogEs2UkUOSCFQySNIutUPimJ6BuCFg+d8LcFAc1zaWJl68
         w84DxURWOHMBvLfoK/0I3VjtGxaVA/yBwTv+RQryVwD+jvgD7b8EJX79LXNFxpr1jJrU
         H8NXJNuekFZiK0TTYwb+KSf0/eWK9/didy3Ndrf/DM2GN4QqqNtUpF5SM1nTmeX2q8r4
         b8OyN53uQL2ArEO/HCIYkQHQSx7mUGj8pvhdrOToFns/Z+DaDTIPwmj5UzzOuOjlhPJZ
         g5hWC9BGMBRQWrhPrEIirzpL1dHMGiN4wBdrPCkVP9xiOtLcicrv8VeojXOk9014f6TF
         Q2EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772790322; x=1773395122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wS1qxKCchhjtDwRNXR6jv/SqzMa5hcVlBO3c/OsKvrQ=;
        b=Sjfnixm7zjWTCgvG18fNApIv19iUId9mgaos6SBEQY1k4sdUvScsC6OqGB7iUQU3kV
         +2Gx+cpUBtrbsko20U8FGwUVsYA0GMkxbrOfbaWjU8GHbzu3HkUD/wsLXTdnZ0B86yoV
         RxIc/nm0ctM4eGZdDYPf/Pvc97BfckzHtt+NXrpDgPwLa7695kqgKNQu28cJnAdwEkvm
         +iQcTCKtBRGalNrNFQf2UIuk+8Npm0QlqjjSltPlcsk+rZtf2UNaWPX46u9yF8/MuA0E
         nrMzhvUPChjCYsCO7RMbsVNg/S/aXdb/rUAlk7wX3XAz2lvLkINxybqEj/2cjY1oKkNc
         QDkg==
X-Forwarded-Encrypted: i=1; AJvYcCV6WZid4BFJpV78E4bF3sCpuouUS5JmAiWlAhNb1v0uf3+qpvHveYRx9S3X5WDvObjm63kSpfWjOiY3CXg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2KG9jdYHzkaQ0L3RdrVz3J+A++YKzULzELEj7A/AUdQB4uBit
	cKucmtTS8RZx5KG0OfcTFHcITd0DY1XwI6QSrEr5McheqpHaksMgw1cy
X-Gm-Gg: ATEYQzyW5aFe0cFrz9uzLmuX0llKGW8ck3CdlB99UaPRokdGlfiAA2zosPv0CtK7xQT
	2e4tJl76agTKF9zswv0ld/gNB5TfAkT24s3HnP/ZOfJp/rkaQ+Wsqhw5NXPb9eiwaHnhnRUt+yn
	nFuaTfR0BGCup328QvxLJHe9Ipj3zjiF5NZDE2eRe3Zs6N1v7gy31myCU0tyHiZYOzWF9pr0D00
	lL048WOf+4Dve0eqQJXFHLU6ZdEPItczlkaPx5BDPxnpRKxZu5Xg6eqpuVYt2vyUXpD2xH8CTFW
	cfZEKR5NMmBLBNTczhsCiqcKUspTtC1ShZdirfwYT+ko5hBfb0Xwt15knuYVe+yaPFWMgs8WjiR
	qrXxbOyHGpNyRAM7VYyeTonCNISo/9XD6dotKs/jbMdNzAQcCgv3gPfj4zFoJFoP1RyLc0XeOon
	A41YPsZmZBZWLhYYuzQdgbxCaFJHF0Smzy6ihi19zq6PNH
X-Received: by 2002:a05:6a21:a43:b0:393:c4d:be50 with SMTP id adf61e73a8af0-39858fda4a6mr1885603637.16.1772790321826;
        Fri, 06 Mar 2026 01:45:21 -0800 (PST)
Received: from localhost.localdomain ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e0cb598sm1080738a12.13.2026.03.06.01.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 01:45:21 -0800 (PST)
From: Jiakai Xu <jiakaipeanut@gmail.com>
X-Google-Original-From: Jiakai Xu <jiakaiPeanut@gmail.com>
To: ethan.w.s.graham@gmail.com
Cc: akpm@linux-foundation.org,
	andreyknvl@gmail.com,
	andy.shevchenko@gmail.com,
	andy@kernel.org,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	ebiggers@kernel.org,
	elver@google.com,
	glider@google.com,
	gregkh@linuxfoundation.org,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	mcgrof@kernel.org,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	skhan@linuxfoundation.org,
	tarasmadan@google.com,
	wentaoz5@illinois.edu
Subject: Question about "stateless or low-state functions" in KFuzzTest doc
Date: Fri,  6 Mar 2026 17:44:58 +0800
Message-Id: <20260306094459.973-1-jiakaiPeanut@gmail.com>
X-Mailer: git-send-email 2.35.1.windows.2
In-Reply-To: <20260112192827.25989-4-ethan.w.s.graham@gmail.com>
References: <20260112192827.25989-4-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Ethan and all,=0D
=0D
I've been reading the KFuzzTest documentation patch (v4 3/6) with great =0D
interest. I have some questions about the scope and applicability of this =
=0D
framework that I'd like to discuss with the community.=0D
=0D
The documentation states:=0D
> It is intended for testing stateless or low-state functions that are =0D
> difficult to reach from the system call interface, such as routines =0D
> involved in file format parsing or complex data transformations.=0D
=0D
I'm trying to better understand what qualifies as a "stateless or =0D
low-state function" in the kernel context. How do we define or identify =0D
whether a kernel function is stateless or low-state?=0D
=0D
Also, I'm curious - what proportion of kernel functions would we =0D
estimate falls into this category?=0D
=0D
Any insights would be greatly appreciated!=0D
=0D
Thanks,=0D
Jiakai=
