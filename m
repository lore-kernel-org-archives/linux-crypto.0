Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=65.109.113.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793597375;
	b=qUBAug29kuKmRllEBzjaYV4sYOsmjyURGie9JTVAJQ4QjzNQ2GVSPZKgwdr+sQOfO8Cu
	 8g9dCVGhYQebIolxr9EPVWD1NDUR39gulRvqItNWskiY68OetxuTxB2MxYbx8z3g0YSwF
	 9ZKZXB86t2NbAE48Uwaidms+BCwJHj4pahggfB2Pekjb0d2VKo91/WoLFnoXwDo3Sqk3/
	 TE9j97ZhDntXIBVYOMS5zgMFypwYNre6cHXzkKtoC+IyqgoNU4hWyylpesEf4SIC6/ckl
	 xzX5dtW+8xOWElNnL7hhTbAP79Rya94dGqp2RQUxKbN4X7wdcZrAYO5qIvsYCswm8Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793597375;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=062LyCwScVM8TDwVa2CHqKPohwkUdfCc0sbqgE5jNzA=;
	b=aHzpaqja082/KWQegyzgyuaIp+xWlv7uIK/R84Xp4QFenWsDX+LH0xj1TzBDZ94clhu5
	 qw0Y+hJTPVfnrRpplelBzuIwfHg08nyFzKXEYta5t/K4vsd3dNTy7SdXqN0oEuhpPHAHR
	 9D3i5oDXcwZ+61GlxmHibJRWDt20pc6ZYkpFs/B9+h8EXrM+XxtQTYvsZ+aZUooTWF4tz
	 4j+AnOVyozwRz9jfUBkPyBbP1hdU2IllqYKKT2wpGCYzZSVl7Wg7muKy2XLJK0J1vfPNz
	 uvz38xbz7awYQBOphcqPeh/qwlqiu2RXAirAHJ969OXJoTB+4aScqUtfwdESV+Sqscw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=alien8.de;
	spf=pass smtp.mailfrom=alien8.de;
	dkim=pass header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=Z6i1pCHo;
	arc=none smtp.remote-ip=65.109.113.108
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FF6606A326;
	Mon,  2 Nov 2026 05:29:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40FF6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=Z6i1pCHo
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D6C9B40E016C;
	Mon,  2 Nov 2026 05:29:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id RxgB04etsPu3; Mon,  2 Nov 2026 05:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1793597358; bh=062LyCwScVM8TDwVa2CHqKPohwkUdfCc0sbqgE5jNzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z6i1pCHoWtAn61nOtp0mn7qypuFLiIeEp5N6EODwfwZDDyy3tlHEYeuCw2DvxW3ew
	 JVieTdjlP0GGKMeT/K5nCQ0XOrmr1oeteAxOYZO4gt3VE0IfUpN7OSEjr3JvsHwUe9
	 P07qmGmwo7v4D8YQIuINOrvxPGPxdq2mphT4WRH9jk+ykAFoWpZtWNuSL9c3UtJNXQ
	 z8c0s/B6xAGeA2Bk5Y/Ej44x4mmiu9oXS6VtG8VV4I7rX0JfMMpVUfxnHr+ddaU1iV
	 1dtxKii+IP3f6fizpMpliH1ilk3GHbE6f+FxyNpC9tRdBXnwDCG2eo1pAvnyCK+geh
	 z/9rYKIk1e6WHDJK+QH6hfiyub4Ejf/JBcVJuuP09wuAsLJOt4zowB2nJhcJ1YrRin
	 JdEvWFM9FrgDCkNs31eO+2SOHE+NjCxwiHH+4kUUiqcsbKbSP2qntP4kPpw0DDW4pC
	 suHZsOsST2SdZiDjEKyWnTE/2xoLqBdBj2D3kwkR/tYgS/jxaIEzPAKYA5rnPXgQlv
	 6aiEG/A5XeS15mmm7MFQyUP5sdoOVh7U9Hf/9T+9Y/0A+qFhq003lNkm5WxWWm/+dR
	 M5jcJGH4z0E2+eTva3XGRbov0NFYXYOKzbgr6D3wk/uC3yvxvGxVBLvy5dsFvIugR4
	 76ifX0CMDDLKXElC5ob4hpxs=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DC94440E0184;
	Mon,  2 Nov 2026 05:28:44 +0000 (UTC)
Date: Sun, 1 Nov 2026 21:28:41 -0800
From: Borislav Petkov <bp@alien8.de>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	peterz@infradead.org, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
	Nathan.Fontenot@amd.com, ackerleytng@google.com, jackyli@google.com,
	pgonda@google.com, rientjes@google.com, jacobhxu@google.com,
	xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com,
	darwi@linutronix.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is
 disabled by firmware
Message-ID: <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
References: <cover.1793216372.git.ashish.kalra@amd.com>
 <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>

Ok,

pls check if this works too:

From: Ashish Kalra <ashish.kalra@amd.com>
Date: Wed, 28 Oct 2026 19:49:22 +0000
Subject: [PATCH] x86/sev: Clear RMPOPT when segmented RMP is disabled by firmware

Segmented RMP support is advertised via X86_FEATURE_SEGMENTED_RMP, and the
firmware enables it via MSR_AMD64_RMP_CFG[SEG_RMP_ENABLED]. The latter can be
cleared in platform BIOS by the user, in which case the system runs in
contiguous RMP setting.

snp_probe_rmptable_info() does not clear X86_FEATURE_RMPOPT in the
advertised-but-firmware-disabled case.

As a result, this does not prevent snp_enable_rmpopt() from trying to program
MSR_AMD64_RMPOPT_BASE, which raises a #GP on the MSR access.

Make sure X86_FEATURE_RMPOPT is cleared in all cases where segmented RMP is
not enabled.

  [ bp:
   - Put the commit message on Ozempic
   - Flip the logic in the function so that the segmented RMP disabled
     case goes first and the flow gets simpler this way. ]

Fixes: 15d974be0a3b ("x86/sev: Initialize RMPOPT configuration MSRs")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com
---
 arch/x86/virt/svm/sev.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index bd70c4d0b774..ff6d17795054 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -817,21 +817,20 @@ static bool probe_segmented_rmptable_info(void)
 
 bool snp_probe_rmptable_info(void)
 {
-	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
-		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
+	if (!cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
+		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 
-		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
-			if (probe_segmented_rmptable_info())
-				return true;
+		return probe_contiguous_rmptable_info();
+	}
 
-			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
-			return false;
-		}
-	} else {
-		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
+	rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
+	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
+		if (probe_segmented_rmptable_info())
+			return true;
 	}
 
-	return probe_contiguous_rmptable_info();
+	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
+	return false;
 }
 
 /*
-- 
2.53.0

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
