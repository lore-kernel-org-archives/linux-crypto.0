Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24D1344D92;
	Fri, 17 Jul 2026 17:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784308749; cv=none; b=UOGtGvVFGk5bGZAhzNPH5Ib19ffM51pdy5d9l5d7jodxgduWehZihvggUoIQrKSgir4xUqHKkScGRfkiSqUqoaHHb5FeWnJMfwzmGw50As9rWbzyrTAknsZuqCkHjym/WeXrFBW5XlMeRwEbUorSSBntvaBCOn5QLiuMcOyaf58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784308749; c=relaxed/simple;
	bh=mXPn6s7C8Yhd1oSMkIbEUnvqqM3b1cHQpmNzRefZ1KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKYWf7c1yLsOkcFZjvGD1xLjV9WcybA9r9aMFI3daJI4lyUPjkfk6EaWNM4zCwtUTfDcze/ZrKy5LlTe1cpIaqzwZ38jibdzx6posgsNEhEJmhMcWLhmrTcKzfG83u5vfTfrDXICA/EQDR3jcYkZvDwZdm9JRYtzo6J6NIm7ucw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M99CA3MG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M99CA3MG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1EA1F00A3E;
	Fri, 17 Jul 2026 17:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784308748;
	bh=aCaoliOTEjCXok/Twq0CGRKlTzYFk428lNaVQzhxRRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M99CA3MGC/ybAH7nrwoURHGzWuL86s2FIEeLeA/wCwlwiVqgTFMau0euDZnbXvcqN
	 6CZ/2401Iezvf7keRvpjDojW5cIMurIghZxOfQYUmU5RlAB7lQ4/bd2sGm/jAibjOv
	 Th5Mk+VqRHT2/ZREtuoJ80LFz4CGwqRvImzOD+Bgb84XHcciAHBTWW7DO7UEYWbC8d
	 wQP/x3rH4rUrJcUiEl5b1jrGMLBxSP+qY3DUES5cVby39/3vxs2mVSrJs9JvpzhWWO
	 PLkDpJrEp4JLUKEV4MI2RfZxzxVskupkhKYHdJKKyGXF0ukXIfP25EcB3qF27oeO1n
	 V7NJdLI2yWrlQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/2] padata: Free the padata_works when they're no longer needed
Date: Fri, 17 Jul 2026 10:18:31 -0700
Message-ID: <20260717171831.27994-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260717171831.27994-1-ebiggers@kernel.org>
References: <20260717171831.27994-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The memory pointed to by 'padata_works' is never freed.

Originally this was necessary because it was used to support the
serialized job APIs used by pcrypt, which can be used long after boot.

However, now that's been removed, and the remaining code in padata.c is
used only at boot time.  The pointer 'padata_works' is now __initdata.

The result is that this essentially turned into a memory leak.  Fix it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 kernel/padata.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/padata.c b/kernel/padata.c
index e7f89e3e44e9..a28fe0c4f66b 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -230,3 +230,12 @@ void __init padata_init(void)
 	for (i = 0; i < possible_cpus; ++i)
 		list_add(&padata_works[i].pw_list, &padata_free_works);
 }
+
+static int __init padata_exit(void)
+{
+	kfree(padata_works);
+	padata_works = NULL;
+	INIT_LIST_HEAD(&padata_free_works);
+	return 0;
+}
+late_initcall_sync(padata_exit);
-- 
2.55.0

