Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B6C45BE3;
	Sat, 18 Apr 2026 00:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776471854; cv=none; b=b0l0/feTY00N7dVFftWV8vg71c2PTOkpMaBQPIj9VwqpqmGNAK56xM/eF2HaIdQw2ZtfYo9/GyOo9V/vDij/rgH8D/5tIXGBZJNOMLAFVVsp1IYdtq+N4K2wAHw1PhbJd/XndrcgCMB+DQ3okR4TLKFAT/oLVc2+0j71Xv57Ufo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776471854; c=relaxed/simple;
	bh=RkRwQ8bP9KsQLuDCIhXjIUpMmiRdvgZmsmeODMmWYAc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aRXPp7oRO8Roy41PKBwFxwxtwQLrkcwgyfCkAqUkSngIsYlQ9LOFXdrpmEnIYvh/Uv/6DVJ+WiMAdmR9Pcpk2z4Eil+b+1keNY17gqR92oVtqt59gYSmEwri0LWY0eB1E90bewLNO6T9rjl1foA7HcWPB0mVAavLhkBAlucEGds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=TwCPdKUs; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="TwCPdKUs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1776471853; x=1808007853;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KVKTXmAukyORC4lyQHCe+lV38lmczCr4CInk3yMLjAk=;
  b=TwCPdKUsbf5WlZDA+q7DFvG+1KW8/4OnqSo7woN3lgsEOfJywO5IS9JK
   c9jl9oMNLuP4b1sgC3HVlTXGT3AiAIJGibdWYgv1pipTKj9qWDi95wZ30
   LY1EBSUKslYHyFZRcqDbX5mKH88MTCj5so0+tA/Pki9he/mG6dE6pjuEu
   d/8/xu+yCbJwCZy0G2SZXpmKPoHfPt4gJuQ8w/F9bKkDlrheiwJx/vYqc
   6cGkBREdq1uwTdj7ZvGfnizN3IS44/u3X723GaZRKfZzycSeXafNqlz5N
   pBxOQbWUl49Bf56O54YZ5S19Pgxo/8pz0wEbCpC1ZbiqOg7w2E51GtSlo
   w==;
X-CSE-ConnectionGUID: CLsZSSiwR6GM6/Hh42vRHw==
X-CSE-MsgGUID: VVf2Vc+KTkKVWYOXKyQ5NA==
X-IronPort-AV: E=Sophos;i="6.23,185,1770595200"; 
   d="scan'208";a="17612850"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2026 00:24:12 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:9319]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.47.173:2525] with esmtp (Farcaster)
 id 582258c8-0fd9-499f-ba9f-37b75f99c57a; Sat, 18 Apr 2026 00:24:12 +0000 (UTC)
X-Farcaster-Flow-ID: 582258c8-0fd9-499f-ba9f-37b75f99c57a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 18 Apr 2026 00:24:11 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 18 Apr 2026 00:24:11 +0000
From: Jay Wang <wanjay@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>, Masahiro Yamada
	<masahiroy@kernel.org>, <linux-kbuild@vger.kernel.org>
CC: Jay Wang <jay.wang.upstream@gmail.com>, Vegard Nossum
	<vegard.nossum@oracle.com>, Nicolai Stange <nstange@suse.de>, Ilia Okomin
	<ilya.okomin@oracle.com>, Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>,
	Bjoern Doebel <doebel@amazon.de>, Martin Pohlack <mpohlack@amazon.de>,
	Benjamin Herrenschmidt <benh@amazon.com>, Nathan Chancellor
	<nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin"
	<hpa@zytor.com>, Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu
	<petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen
	<samitolvanen@google.com>, David Howells <dhowells@redhat.com>, "David
 Woodhouse" <dwmw2@infradead.org>, Jarkko Sakkinen <jarkko@kernel.org>, "Ignat
 Korchagin" <ignat@linux.win>, Lukas Wunner <lukas@wunner.de>, "Alexei
 Starovoitov" <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
	"Andrii Nakryiko" <andrii@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <x86@kernel.org>,
	<linux-modules@vger.kernel.org>
Subject: [PATCH v2 14/19] crypto/algapi.c: skip crypto_check_module_sig() for the standalone crypto module
Date: Sat, 18 Apr 2026 00:20:22 +0000
Message-ID: <20260418002032.2877-15-wanjay@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418002032.2877-1-wanjay@amazon.com>
References: <20260418002032.2877-1-wanjay@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D040UWA003.ant.amazon.com (10.13.139.6) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Vegard Nossum <vegard.nossum@oracle.com>

The signature check in regular module verification process
`crypto_check_module_sig()` is skipped for this standalone crypto module
because its signature has already been checked during load (as described
in later patch).

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
[Revise commit message]
Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/algapi.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 37de377719aec..663698e0cd658 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -24,7 +24,19 @@ static LIST_HEAD(crypto_template_list);
 
 static inline void crypto_check_module_sig(struct module *mod)
 {
-	if (fips_enabled && mod && !module_sig_ok(mod))
+#ifdef FIPS_MODULE
+	/*
+	 * The FIPS module should ignore its own signature check, as it was
+	 * already been verified elsewhere during loading.
+	 */
+	if (mod == THIS_MODULE)
+		return;
+#else
+	if (!fips_enabled)
+		return;
+#endif
+
+	if (mod && !module_sig_ok(mod))
 		panic("Module %s signature verification failed in FIPS mode\n",
 		      module_name(mod));
 }
-- 
2.47.3

