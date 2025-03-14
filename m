Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10DA1FFC41;
	Fri, 14 Mar 2025 16:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741968011; cv=none; b=EWszdYHEIqlQUDTwBbdY/AKsyu+I+EDYJwRAqpvecA4wyg5uH7YNVFFMYbqP2tB0U0mU9fo6h2Xz24lXX7FtXBDMaqORO4slD9bldTb0aSFtWgpba7er29XE2kZF2SG2chLAIP3L7vKA2+cT6YVvPFw0SAPnY5Cih1cTc6pcnnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741968011; c=relaxed/simple;
	bh=HTDMJblu2yYTj5Ay9v5ypRtDQz3GYsPGANq7RB/PtJQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DaS3h25xBJj2RJU1eySYk3Cs75HPj7veVE1VmwWJDxY2ARnkf4k56Er8c9xXZRPPX7qhLfry2kmZEGBH2tTWlDoV/5bNFF6WM1AyDrynOo6Rotx4eGKyK63OUlI9M9wD/7YPXlaDXc1Asf97oPDU0syMXC01zw8vy/ogjZ0jbs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tpsXh1NQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tpsXh1NQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302BBC4CEE9;
	Fri, 14 Mar 2025 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741968011;
	bh=HTDMJblu2yYTj5Ay9v5ypRtDQz3GYsPGANq7RB/PtJQ=;
	h=From:To:Cc:Subject:Date:From;
	b=tpsXh1NQvO0N9JzLtRf95h8cohlzGsXz1A1UpYrg7/QHNZQVSATERp+wiDXQm3x4U
	 CzoHM1veuqJovXGank1l5a8r2DTH5tVf5LBNDmwOjyRqvowL9j/3A6jd0gYV8VjM37
	 pD9IQmbpSSI6ghvZoKjtfj+UGCpb56veoAzqAIu6CG5fpiUV/GuY2JRsGwjB9STlSk
	 7jXiraRvVe60bTjzk8dAqJEe8iNjelEDAAVgPHn1BwPx2KLsTgntJuWmemhVvuRE2J
	 bemih7ZlgdWQebSSfC7zwY7V6WpU1e89yiTN0tJVV/EfZnfYmYUk6dk2euEMGvtNZh
	 E15yZ/DVYLkCQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Chen Ridong <chenridong@huawei.com>,
	linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: tegra: fix size_t format string
Date: Fri, 14 Mar 2025 16:59:59 +0100
Message-Id: <20250314160006.346042-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Printing size_t as %lu causes a warning when it is defined as 'unsigned int':

drivers/crypto/tegra/tegra-se-hash.c:344:22: error: format specifies type 'unsigned long' but the argument has type 'ssize_t' (aka 'int') [-Werror,-Wformat]
  343 |         dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
      |                                                         ~~~
      |                                                         %zd

Use %zu as the proper format string.

Fixes: ff4b7df0b511 ("crypto: tegra - Fix HASH intermediate result handling")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/tegra/tegra-se-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 65a50f29bd7e..ed86235fe518 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -340,7 +340,7 @@ static int tegra_sha_prep_cmd(struct tegra_sha_ctx *ctx, u32 *cpuvaddr,
 	cpuvaddr[i++] = host1x_uclass_incr_syncpt_cond_f(1) |
 			host1x_uclass_incr_syncpt_indx_f(se->syncpt_id);
 
-	dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
+	dev_dbg(se->dev, "msg len %llu msg left %llu sz %zu cfg %#x",
 		msg_len, msg_left, rctx->datbuf.size, rctx->config);
 
 	return i;
-- 
2.39.5

