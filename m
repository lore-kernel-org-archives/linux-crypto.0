Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E5B2C027A
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 22:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757974397; cv=none; b=WY6E7DPChV2awTatMcO8kebe5618AzPDhf1ynzXeCA06roU9ZdZtu52lGRSDbI5mOkxP+CSqTOjxOrACZjsPYKE5ycZ2KvCb26knKIQyKAu1PhzOBV98BPNKu3SBS2aFy2RlGH8S3CE1a4TlTQcl02xk7immVMYapHrqfz0nQbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757974397; c=relaxed/simple;
	bh=Gt+D5JLy3ozcBhQzUhmYd8Cf6BrGurM0+4yoWKYa6/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AEVtwdg6U6Vx5HsRsNwMX3TfWFXcwkcQ7rrPNbzhTvNqKsxosax7jjHyhxuKBC6jtJ0MZXaf+IyLA3XDOoXg1zg+jYJf4MajAyNSJnoMa+PUMg4ARqYmD7okXdfGYHxzSvBHgiMdrVkGJei8ik2t25ScSRt46WCI0UEDy7cHUl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fO+1hsr8; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fO+1hsr8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757974382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=O2RzCbaONtBiLM2iRZ147oYVwmAWP9HBYzSDSYZlKkk=;
	b=fO+1hsr85eVLiPQloLb37dGetL1eUnVm19CG7cHyOjiI4bMRgM9nNhzo24OVmFFZvvTnZD
	oQN2B7+lBcnbuxmCHRhnpwnfRGY7/f22XcmK4CwvKGMXsm8LMwGwZjf/uDf2QMdR0pnSMm
	NrQM6RHtgaFtXThEsCCksq551H63Jp4=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: fips - replace simple_strtol with kstrtoint to improve fips_enable
Date: Tue, 16 Sep 2025 00:12:45 +0200
Message-ID: <20250915221244.2419149-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace simple_strtol() with the recommended kstrtoint() for parsing the
'fips=' boot parameter. Unlike simple_strtol(), which returns a long,
kstrtoint() converts the string directly to an integer and avoids
implicit casting.

Check the return value of kstrtoint() and reject invalid values. This
adds error handling while preserving existing behavior for valid values,
and removes use of the deprecated simple_strtol() helper.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/fips.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/crypto/fips.c b/crypto/fips.c
index e88a604cb42b..65d2bc070a26 100644
--- a/crypto/fips.c
+++ b/crypto/fips.c
@@ -24,7 +24,10 @@ EXPORT_SYMBOL_GPL(fips_fail_notif_chain);
 /* Process kernel command-line parameter at boot time. fips=0 or fips=1 */
 static int fips_enable(char *str)
 {
-	fips_enabled = !!simple_strtol(str, NULL, 0);
+	if (kstrtoint(str, 0, &fips_enabled))
+		return 0;
+
+	fips_enabled = !!fips_enabled;
 	pr_info("fips mode: %s\n", str_enabled_disabled(fips_enabled));
 	return 1;
 }
-- 
2.51.0

