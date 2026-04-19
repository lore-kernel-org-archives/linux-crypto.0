Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC6A40DFCD;
	Sun, 19 Apr 2026 15:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776612823; cv=none; b=X2BpnqfJPz6pTICcliUQQhvFpFvEFLkmVzlHqZE6wwZUYFXIpnQSLQ8qDOwv7z275PPOCndSu6pseyoFPcWDCvHXDat3tu4zbM9r6jsjb/XtOWkCZ9gmSG0qzNjq8F0CaMPBUtzygaqOB0DXKobvqkH9i44BaMgkxfx5WSy6lZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776612823; c=relaxed/simple;
	bh=FYV6dcCGF4tINKzJvzQW04nH7vShjcheyrL6DKTDC4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qAGTCd3uDNYNZceq88l57PoxjSiBGe0VNvg4JDhsBFLBWGz7+VY9e1XqRDaosqPRz0k6hG3LcZPZ29NdiZiGzGCU/z0W3PlhrvGrYLELnDNbAy17lxPlEOErQNFSd2/eViiL1K5SccOIlIKi+aYDgRcXyJkq/CzlJOnS3XtjWtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SYN6DD6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SYN6DD6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B9BC2BCAF;
	Sun, 19 Apr 2026 15:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776612823;
	bh=FYV6dcCGF4tINKzJvzQW04nH7vShjcheyrL6DKTDC4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SYN6DD6L7U7mUnOeAZRT+dmiVKwbGPcVG1Hd7A6uuiimRgyNZvburq+DNEMgZvKj5
	 BGcWKVrKrWA1x0evbxAMR4R3dlorUlVzGdvt/gn8f/zPLk3iMpz2GHk1U5p/gGOmj5
	 esUrsXci/wTdyeo9OeesaIOx4ybfGmvblZwdWU3XAyttQQfqcmESKzrZPYYx3or+nl
	 pg5mHhjRpn1r40/WWuCkQdMkHylVYO+WNOMylB00RKC8smxN1buxEwB3Nb5uKB1Gj+
	 h1KRCMrtsZgfu/sypVeCmBD+J8TmMkYmUEQmP+cQkRQjyUQTlVHAFYuLxRBTWQVb0d
	 6wL8Yc5xeUchg==
Date: Sun, 19 Apr 2026 05:33:41 -1000
From: Tejun Heo <tj@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thomas Graf <tgraf@suug.ch>, David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	linux-crypto@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	netdev@vger.kernel.org, NeilBrown <neil@brown.name>
Subject: [PATCH v2 sched_ext/for-7.1-fixes] sched_ext: Mark scx_sched_hash
 insecure_elasticity
Message-ID: <aeT11WIF6kzvifm7@slm.duckdns.org>
References: <aeGElQ-TcCclEHwo@slm.duckdns.org>
 <aeGIsGi9fBqu9EZT@gondor.apana.org.au>
 <aeHjjGEhlikSsxCX@slm.duckdns.org>
 <aeHmeAz-Z-Rx2MqX@gondor.apana.org.au>
 <aeJe8oIyYUi-NtCQ@slm.duckdns.org>
 <aeLT8eB_xfzLxqbI@gondor.apana.org.au>
 <aeLV6aDhM0-S4oQ1@slm.duckdns.org>
 <aeLWH_HgSHF4buiJ@gondor.apana.org.au>
 <aeLgjAeJuidWNy3N@gondor.apana.org.au>
 <aeLhQRFPEY24ySIq@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeLhQRFPEY24ySIq@gondor.apana.org.au>

scx_sched_hash is inserted into under scx_sched_lock (raw_spinlock_irq)
in scx_link_sched(). rhashtable's sync grow path calls get_random_u32()
and does a GFP_ATOMIC allocation; both acquire regular spinlocks, which
is unsafe under raw_spinlock_t. Set insecure_elasticity to skip the
sync grow.

v2:
- Dropped dsq_hash changes. Insertion is not under raw_spin_lock.

- Switched from no_sync_grow flag to insecure_elasticity.

Fixes: 25037af712eb ("sched_ext: Add rhashtable lookup for sub-schedulers")
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/ext.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -32,6 +32,7 @@ static const struct rhashtable_params sc
 	.key_len		= sizeof_field(struct scx_sched, ops.sub_cgroup_id),
 	.key_offset		= offsetof(struct scx_sched, ops.sub_cgroup_id),
 	.head_offset		= offsetof(struct scx_sched, hash_node),
+	.insecure_elasticity	= true,	/* inserted under scx_sched_lock */
 };
 
 static struct rhashtable scx_sched_hash;
