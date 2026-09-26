Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C129536DA04;
	Sat, 26 Sep 2026 05:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790402373; cv=none; b=VvFAQ9K/2FxazyY2rQfCtNMsSo9S+FpsZTfYHrZ2fr5aJnQIZYxrQz5gTwIUxXGExNDPK3tCKCAsr4dPCMIkLKXJv6Sg+kieAdKZ1GF89cyxxDqZDp80f48jizXwewB8zEbWpX6jMFfHgkvWimWtGrL+/YabwakOYXazvalIoc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790402373; c=relaxed/simple;
	bh=5YLLI7osw/UGKFuIJYEyngba77vIKU9QAY2tGxqq/FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AaJeqqYOrYwkd5YPHH2XnDYG0IoSAifUHwAGyvnmSjzENf7nLA28vh7Th5edsyn5MX9OnztEkDZo4TZ2qHoBKMpsrSrCXfBxX8bhY7fmZOT589T6RBgsemt4QbN8M41PgUi3lYYI5Lp0RGkIKp0hdSw5Wr/6tK6pIFUllbEYNc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UeIsWFaD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UeIsWFaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07211F000FF;
	Sat, 26 Sep 2026 05:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790402372;
	bh=Yf7iKUmtDBEOtKZjxxS5+i5vr2t0DZvI0ceFBcfG13U=;
	h=From:To:Cc:Subject:Date;
	b=UeIsWFaDhIQgh1SfUNUmEUx4LsD7Abo9eS5znyoeIOmidXUBJ2lsMacmo9p3rhZM1
	 Hvaoa6kK5ooWb3YbZC1rKaWdK1yOOw8PoOq46nCDxVwtaAdF5GrS2Fgquf+vxLHihy
	 SN9pE1dGbkvFadmilN/7K2uLJJFG0oZ9lSBf0hUD9cnMLshDU83YcPl9f1hxMQUSer
	 R+KliAoT2W3UVJKEeR3Neqjy7qXMQGgB4WH3pOx/D3JlySDmNRvtVoM+Qb2BjSHS04
	 KK+aHIBeQ/PGmlzjPHb9rrWsVQHGSpfAqGWzbev43ZSLXLzSaHUh9gi5W5/AFJc0Y9
	 aPTUurAcoUzrA==
From: Thorsten Blum <blum@kernel.org>
To: Laurent Vivier <lvivier@redhat.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thorsten Blum <blum@kernel.org>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] hwrng: virtio - use min() in copy_data()
Date: Sat, 26 Sep 2026 07:58:54 +0200
Message-ID: <20260926055853.4868-3-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1153; i=blum@kernel.org; h=from:subject; bh=5YLLI7osw/UGKFuIJYEyngba77vIKU9QAY2tGxqq/FQ=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnb4+Uy657G1a22NRNvnsV/kENRyW71bcHoVXz1idJlz FGh4ns7SlkYxLgYZMUUWR7M+jHDt7SmcpNJxE6YOaxMIEMYuDgFYCKLrjP8z7Lh3hoobBcaWJHx PFW7cukLEec9E3O7pp1cnXcrYmXJBkaGZ5Nzirbdnbyw/kXbvYJfh8s+uJ5KPMdV45LlbqNy8pw 4MwA=
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Use the simpler min() macro since all values are unsigned and
compatible. The subtraction avail - vi->data_idx is also guaranteed to
be positive by the preceding check.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/virtio-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 5e83ffa105e4..5b1b23b5596a 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -81,13 +81,13 @@ static unsigned int copy_data(struct virtrng_info *vi, void *buf,
 	 * steered into adjacent slab memory, including under
 	 * speculation.
 	 */
-	avail = min_t(unsigned int, vi->data_avail, sizeof(vi->data));
+	avail = min(vi->data_avail, sizeof(vi->data));
 	if (vi->data_idx >= avail) {
 		vi->data_avail = 0;
 		request_entropy(vi);
 		return 0;
 	}
-	size = min_t(unsigned int, size, avail - vi->data_idx);
+	size = min(size, avail - vi->data_idx);
 	idx = array_index_nospec(vi->data_idx, sizeof(vi->data));
 	memcpy(buf, vi->data + idx, size);
 	vi->data_idx += size;
