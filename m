Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFBA421EE8;
	Mon, 20 Apr 2026 13:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691664; cv=none; b=M8rqURt7o7pgbznykQAYj5vy4s1hUW6UOduStuzBks/9k5/8o5uXmsHQs5HzhyskEJ0wh8esqvecTI8IEtlGjoKUKbWdv9ZdrScrSaLqFAqyNjPqyIa8h4703qWwjb60r3HEkwKXQcQcfDjbXdBPz3OFNjUNhVLCmVnYd6EvjW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691664; c=relaxed/simple;
	bh=G+UgkeCMtesr88VZ4I7gQdiNarw+pmjtDEx6u+Gpxq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kn024QVVo9vZUw5iMLRJ5bMm5Snj+kqm94rrT2M5DIyGgMNSZAdzoBvUNWleD0x0OxmP/jgBNQ4zQHKwle0m970XCaggs9V1C05eSUmeixZphW5vrk1lSva25lacU1+ORDCO4oMczGPDuphwxGMpj8tSOSoFQdJY35sAQC6Aifc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NrQzf+BP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NrQzf+BP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B922CC19425;
	Mon, 20 Apr 2026 13:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691663;
	bh=G+UgkeCMtesr88VZ4I7gQdiNarw+pmjtDEx6u+Gpxq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrQzf+BPQddqBFsE/vJfvrUq/xLv0iese6Z0Fkab7C1G2pQbSVSuD5Lvgr+4u7w7I
	 PrbuSgdlvYWMSvQ0/Z/Evc53hTebcHCTqVCyPM5SMd3lD7WVaYYoM9gTjH7zlklxM2
	 ZzDzkQXDht2olenn/xIK0wUpI+biTFZfuFKPtRBLAcrl9M8wif14Zd5+Wam9npigWI
	 gKw7H+fXadi9vcqBN3i/wqePEH7pZqhMB0T+vS5YVDrcBD1OBbGgDgTlf1ea3G5lhN
	 Fg+V9tSyQXR7TrTmR8WU7aCvk/uXUjbdwwEAcc04+ZBZepYva/o1g7DgHqV9qIAuq/
	 wNYXUwnR5Bi8A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+d23888375c2737c17ba5@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	smueller@chronox.de,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] crypto: af_alg - Fix page reassignment overflow in af_alg_pull_tsgl
Date: Mon, 20 Apr 2026 09:19:14 -0400
Message-ID: <20260420132314.1023554-160-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 31d00156e50ecad37f2cb6cbf04aaa9a260505ef ]

When page reassignment was added to af_alg_pull_tsgl the original
loop wasn't updated so it may try to reassign one more page than
necessary.

Add the check to the reassignment so that this does not happen.

Also update the comment which still refers to the obsolete offset
argument.

Reported-by: syzbot+d23888375c2737c17ba5@syzkaller.appspotmail.com
Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 crypto/af_alg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 6867d177f2a2d..b61c3ba126ed1 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -705,8 +705,8 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst)
 			 * Assumption: caller created af_alg_count_tsgl(len)
 			 * SG entries in dst.
 			 */
-			if (dst) {
-				/* reassign page to dst after offset */
+			if (dst && plen) {
+				/* reassign page to dst */
 				get_page(page);
 				sg_set_page(dst + j, page, plen, sg[i].offset);
 				j++;
-- 
2.53.0

