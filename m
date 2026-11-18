Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795011694;
	b=4a28OfBRclRyOOiv3i3959UX17LWp2sY58Ng7CHSfKGwf8n9fWQzDdZrFLAI4VGA10qy
	 R+wzwVdSp1w0pvYjH5Q4Dd3ZN6pVtAMuooDct+snk0jakLNOUGKnMY6FUUxEgjSYImfuS
	 iIAmk0xblYZQR2iZ4qz8KPomp4b9nKpArOZJpbSLT08HL4S8s2vSN0/UplFZ5eOySEH/b
	 JlZQNZA7MHar8XmeHbwPWu+WkY/BW5j1ufaaPTsz5LrNCs7vE00gvnp5GMjONltiYJEuR
	 BPoO0rP2qHHmarkTI1jajwCcIbNgZKwi9uM5Ko5PMV0wUj8ODAvN6w2qY2afMMLuxaQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795011694;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=BXbFqSDRbWCuXgSxYK5+iQpw/Ny7q6rCgUK1xrOuk60=;
	b=JhsEkjlO+/e2eJRpHe1qikSZqkK6X8LnIABg3niYUFVg6Qqa1hl7sucOsAcEcpb5XMuQ
	 srMJWiiAVnkwNHQK1eQSJVB4xCSbxzzXoXH2F7p8qR0ZAzg3CyJSmoL7wczUqCSn4/zuI
	 fa3EMxWIA4IDEWoGFN3E8A29E7F/Fq9/smBMRjqiMRbsv9O/KAkPWdl4ejyFg0YfKIQnI
	 LGI1AFcY5jSkVg8aR1jnNzIjvoMfrW/mE34Mmz2AOI5qcChQ1LrSkBT28gDxGqBeNhUMy
	 k0YQmXgATF+wh983UXOJgF7wSgVORr+iI+VPnreWxrTivwn3ahs9J4AxYj7dJyVYupQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VuLiYdbt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3482F606A31C;
	Wed, 18 Nov 2026 14:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VuLiYdbt
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795011694;
	b=p5Wsh1ohAdfLe6T0R+hqrFi0uMkFOZE8GVigS9l/NVCxKE/IxcLMF5bkOIl3dbjTUKVf
	 7dlUNM8msggsPcCKG2Syju/Fw1QVpboQGYkmgiOAGzZCsaoEM3ygbotYMTj+Gq2aY9wRa
	 mDvX+y9/xvrWpql8prDcDlKoFtHgtWakNuMNa6+W+HpKS0nNWHh384WRQV4pbfi1q2TKk
	 Y5Rc4f80zOSASnD+Mx5wvKzMb3aCC93EG4MhgGhCYcdtTrfwOeCuiWATSZQjH7CY8pFfK
	 OE0CrkJdhBSdLDtIvqWN43WZFiYpEgmnwNo/Er5ZrwrExp6p/fJ1OoDCUiTKfvan5EQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795011694;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=BXbFqSDRbWCuXgSxYK5+iQpw/Ny7q6rCgUK1xrOuk60=;
	b=w4JdfHt7Lo2DHEt2WWe5IjIiXjoeObQVuF9DT8Kju5ZiUpI8nL4XrFRQw2JRQaC7FHfU
	 yyc7THnF0mJCQ3xELkzRddKijtZo4QTGnJerOSnoZCoDuMEDawlbwUUlBc6bB5qV07Fjp
	 PRKzuAuoGHPuwxKM5HmbLDK/3RyxQRCIJXk7HTqzWmXXd00vK44zXEkRjYs9mP41q4ZkB
	 yHeCPSBKweGbuWjqi5YVDH+CYewLRlIOYPIpscmFUzkXbfiNenxv8/Htvqrx56joB8zsg
	 YqO+JR9xdYTBgrVEQuyJYOEHJmp7bzanUEr6Nr8m5D/9tZ2wp87/PM1M+4wYCQXBe6w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 829B41F000C5;
	Wed, 18 Nov 2026 14:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795011694;
	bh=BXbFqSDRbWCuXgSxYK5+iQpw/Ny7q6rCgUK1xrOuk60=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=VuLiYdbthmjQp1n/ElyLS+OVzB3xYaVasXXBL0mh/071UdL+OlXAP1r4IuNikbCdb
	 uos5T6yM0Ma8GrgNAmHEjgwZ5kr/0bBHn2Lrvfx8eQSBxfGFDBcQ8Oim+Q6T7dGK43
	 wo/2omYTrKrg0M7axMOZt5o8BFZaPPrGdFYq4SxSYspJ5PWLFaYG+AWuJG7ZiQUVHI
	 s5ho5nQ7my7nt6RNyZn6nOzcqtuqTVXiRiYWu3a55RuamVvNutgnPBLbEsu1uCOXuo
	 cG13B96ayxSvR1N4QCcNjFWfacG+W4votk28PtKxD0c57RuqgJLnZfJ3AV6GL1SoAl
	 tHDEUj8FkEEfA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D53754ADDF;
	Wed, 18 Nov 2026 14:21:32 +0000 (UTC)
From: Suyuan Wang via B4 Relay <devnull+shyckless.gmail.com@kernel.org>
Date: Wed, 18 Nov 2026 14:21:32 +0000
Subject: [PATCH] crypto: ccp: Require a writable file for SNP_COMMIT
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-ccp-sev-v1-1-76894536031f@gmail.com>
X-B4-Tracking: v=1; b=H4sIAGu0/WoC/yXMQQ5AMBCF4avIrDUxFY24ilhUOxiLkg4iEXdXL
 L/kf+8Cocgk0GQXRDpYeAkJmGfgJhtGUuyTQRfaIGKtnFuV0KG0NThUtiy99pDqNdLA5/fUdr9
 l72dy2zuH+34AflBYUGsAAAA=
X-Change-ID: 20261118-ccp-sev-2a61f5a33d2d
To: ashish.kalra@amd.com, john.allen@amd.com, thomas.lendacky@amd.com
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795011692; l=2406;
 i=shyckless@gmail.com; s=default; h=from:subject:message-id;
 bh=VKFek2Cxcwj/7D3tXDWOWVgjXPInUg0klOAhSzwecgE=;
 b=+OHDlxSfZBlZh69PJgFU3Irr+Jrmo/H7dszuT3XwQFpZqz+ny+Y4d06cUPs2uDai+BvmZSiLj
 OYdqI430KAmCmo0I7CZxSPnmgXg6/gx9VQv9Xhai42CsFqXhotWZHmn
X-Developer-Key: i=shyckless@gmail.com; a=ed25519;
 pk=pMtccVGiWES3bV+7YBFuBclkvq2n2HBHQ5azaBrK2lY=
X-Endpoint-Received: by B4 Relay for shyckless@gmail.com/default with
 auth_id=1498
X-Original-From: Suyuan Wang <shyckless@gmail.com>
Reply-To: shyckless@gmail.com

From: Suyuan Wang <stevewong@hust.edu.cn>

sev_ioctl() works out whether the file was opened for writing and passes
that down to every command that changes platform state:

	bool writable = file->f_mode & FMODE_WRITE;
	...
	case SNP_SET_CONFIG:
		ret = sev_ioctl_do_snp_set_config(&input, writable);

SNP_COMMIT is the exception. sev_ioctl_do_snp_commit() takes no writable
argument and runs SEV_CMD_SNP_COMMIT unconditionally, so a process that
opened /dev/sev read-only can still commit the SNP firmware version.
Committing the current firmware updates the committed version and the
reported TCB, and prevents rolling back to a previously committed
firmware version -- the kind of state change the FMODE_WRITE check
exists to gate.

Pass writable to sev_ioctl_do_snp_commit() and reject the command with
-EPERM on a read-only file, like the other state-changing commands
(reset, PEK/PDH gen, PEK import, SNP_SET_CONFIG, VLEK_LOAD).

Found with a static analysis tool and checked by hand.

Fixes: fad133c79afa ("crypto: ccp: Add the SNP_COMMIT command")
Cc: stable@vger.kernel.org
Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Suyuan Wang <stevewong@hust.edu.cn>
---
Compile tested only (x86_64, W=1 and sparse show no new warnings). I
don't have an SEV-SNP platform.
---
 drivers/crypto/ccp/sev-dev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 52fb208b71ab..9d1c40a371e3 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2666,11 +2666,14 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 	return ret;
 }
 
-static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
+static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_data_snp_commit buf;
 	int ret;
 
+	if (!writable)
+		return -EPERM;
+
 	buf.len = sizeof(buf);
 
 	mutex_lock(&sev_cmd_mutex);
@@ -2796,7 +2799,7 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 		ret = sev_ioctl_do_snp_platform_status(&input);
 		break;
 	case SNP_COMMIT:
-		ret = sev_ioctl_do_snp_commit(&input);
+		ret = sev_ioctl_do_snp_commit(&input, writable);
 		break;
 	case SNP_SET_CONFIG:
 		ret = sev_ioctl_do_snp_set_config(&input, writable);




