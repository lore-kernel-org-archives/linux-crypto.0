Received: from mail.nessuent.net (mail.nessuent.net [188.245.177.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF99A352001;
	Fri, 29 May 2026 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.245.177.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780069849; cv=none; b=L2HRPSDTb0ULBJJhmarHIWVxPhsDf1APJzED1ppskFdkBnIfuXhJqJcTSPT57xk4XXEIBLs8cLzmCEt67XTeWdqycXvBKyv0VLaR1/KijA1jZ74O6XAEMx2YY7rx6SB90x7twXCwXAoGcoGZrZjU7qRyz6rPYvkoOygc5N74uDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780069849; c=relaxed/simple;
	bh=wxw39qXXrGQThYUW4RzvHsc1DDdC7CKDwfIbkdm9LMw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=NCxG5TenomEpu4v0QCaIQee1o1qqBy0Jb6GViwZO4k0iEyfxCHGkakOJfEssDvV0vMDTqIMLIWyn4zNIPUO14Ox9SjtIAkRk63/5Hv1foKOg78aLoWIwZuA93eacw6zzDCzqcNYPsydyno4zqDYo1SPPOyOwcDeSCJMB0Ao4VWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pitsidianak.is; spf=pass smtp.mailfrom=pitsidianak.is; dkim=pass (4096-bit key) header.d=pitsidianak.is header.i=@pitsidianak.is header.b=x0FPMS4p; arc=none smtp.client-ip=188.245.177.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pitsidianak.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pitsidianak.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=pitsidianak.is header.i=@pitsidianak.is header.b="x0FPMS4p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=pitsidianak.is;
	s=mailSelector; t=1780069838;
	bh=wxw39qXXrGQThYUW4RzvHsc1DDdC7CKDwfIbkdm9LMw=;
	h=From:Subject:Date:To:Cc:From:Subject;
	b=x0FPMS4pJA4+1LUYQmMg65G8hN/wstx2gZRs0FezIPILSwyPQCifkHwc3txTHEXYf
	 kIgmDCgL9nJ9K9CJjhVK5BEXyoHIi5pGyKO0AV0bUEqwywco1Qx8ufrwAgkp2JjXEm
	 pm56XQobDae6Wc0ytTcg+3IOLGmYj+qtN3w2bE5mIrtCihf8jdULMAEAif/OWUt4c3
	 vgrpjQhMlQe0dEzhiti8uYxVgPUW5YWLaTCyp3BRJro0BMM/zhrQTPg4jXRuYj8vVn
	 MPrBxUZTaLAE6sxX2WqNzAJTZaUYksjaRB+eklM+sLqzSml23DbSYsbmQg+jd6u9Q9
	 xoVY1lbheE7lUxxY2WcgwdbcDYJLKVMg6RZIU3+FLPYssBBkixBYxR55kK+uiPnyBF
	 4nL0dudPtMoTZb0G/TF7shqmm1iW94zeLA0YrY5GvDh4VNhvbDrGI10wvGGWBWGkDc
	 PHMK7iutDzR7CJYmsfhQObrlswNocs5d6/WLJpMJe2/RXSGjNQKHIwP+R6U+PGaup6
	 LgOxj7S0ec2WFWC68ySqDrq9FO+uzVim0gI2PbOzyRO7NURJTOSfyoB4Pm+Mvu7BzM
	 Oofp1wsov9WsK14hNL7ISyU7g2GssRl7H0erutbvzkHXI9RpQw8t8KQ7GUnKRBSxzF
	 jgZPmCMxMTRQlTcWiVE4BPb4=
From: Manos Pitsidianakis <manos@pitsidianak.is>
Subject: [PATCH 0/2] Add hw_random Rust bindings
Date: Fri, 29 May 2026 18:50:25 +0300
Message-Id: <20260529-rust-hw_random-virtio-rng-v1-0-b3153dd90311@pitsidianak.is>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMG1GWoC/yXNTQ6DIBQE4KsY1iVBRMBepTENP09lIbQPtE2Md
 y+py2+SmTlIBgyQyb05CMIeckixor01xC0mzkCDryacccl63lPccqHL54km+rTSPWAJiWKcqfW
 6VRZaPThJav+FMIXvf/sxXkZ4b/WiXCGxJgN1aV1DuTfaOqlAeCuFMYqrjjuhhBUCjJacM8ndw
 LqJkfE8f2Ld4NO3AAAA
X-Change-ID: 20260525-rust-hw_random-virtio-rng-bd817be189c6
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, manos.pitsidianakis@linaro.org
X-Developer-Signature: v=1; a=openpgp-sha256; l=801; i=manos@pitsidianak.is;
 h=from:subject:message-id; bh=wxw39qXXrGQThYUW4RzvHsc1DDdC7CKDwfIbkdm9LMw=;
 b=LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tCgpvd0VCYlFLUy9aQU5Bd0FLQVhjcHgzQi9mZ
 25RQWNzbVlnQnFHYlhNUkF3aUlXWWNkQXVFTDQzdHVRS3hBK0E4CjRDSzZoU0dSdFBtbFlUUzJn
 K2VKQWpNRUFBRUtBQjBXSVFUTVhCdE9SS0JXODRkd0hSQjNLY2R3ZjM0SjBBVUMKYWhtMXpBQUt
 DUkIzS2Nkd2YzNEowRjRERC85aHV5VDMzZlJBQW1NL0w1UnUwQ1dKYUI3cmc4MTQ0cXZqQllmcg
 psOG9aMnpneUJxalpJWGtneWZBcSs0dTkzVG5ROGxTMy9NdWpQcVEzaXg3Yy9DbnB5cHJpSUVoL
 2F3RW5wS3c2Ckx5ZCtqV3hIRyt6ekd4dFI0V0JGQWJWb1cxdzRRc0RWSzVZdGhQblNmZDNSYTJF
 dEwrQ0h4Z2xBT0ZXclpkYjQKYlVjdnorU1ZWR0tVdnNzUlZHT1hXNURDN0hFdGdONUJmUFdLZXF
 CdDBhNXFxd2M1Zkx6RGN3OEh5V0YvV05VUApwY2U5b3BReW1adGJFVEZSVU5CUDBVR0Q1TDB0Rm
 QzbWJCbnhBbkFoUVlqdE04bjRJZElIY1RDWXk2WkdPSkxWCnBpUlo1cTRnNVdEMCs1SFF2QnMwN
 G5zRWdYNEVOL21ORmlkSDd6VzNIb0tOblJNWC92TlFBbVBKbklCbW1nZWQKNFVLelM5MjdZS0gy
 elg0TlNmeEZOSCtuUzN5ZWkrTGxyL0lrLytHYnJDTFU5VTVGWThBMDZzaXBQRTZlVHNHZgphSHE
 1NG4yYVlNTEl6Y2tSSDBwVjk2SFpkbm5oL1FwdGNLV2JnNjRtNGFOUmt0Y0JEV0pyaFZsazZuY2
 JYSWkzCmRKcTdDalNOOUJYc25UUXUzYUxOT255SHdUZE1mZVlsRFluNUVOc0VGQUZBS211VWNGQ
 nhQVmNabHNmTS8wLzYKcFdGTzRlUFByai9FVFZsR2lkL1B3ZHdzY012THNkSXhuaVhYai93azEx
 VFErM3B1SXJmZGNONWYwWHBIc3lDMwpLT2tBLzBORUJCUWppZmh6OVMyRWIvYjZrRktwem55S2V
 WV3NGLzJjcTdXM2xkdzdmeldvN1kxWVBxQkVTTDlRClREcnJkQT09Cj1PeGxrCi0tLS0tRU5EIF
 BHUCBNRVNTQUdFLS0tLS0K
X-Developer-Key: i=manos@pitsidianak.is; a=openpgp;
 fpr=7C721DF9DB3CC7182311C0BF68BC211D47B421E1

This series adds Rust abstractions for the hw_random subsystem.

A virtio-rng Rust driver that uses them will be submitted as a separate
series since it also depends on the virtio abstractions series.

Signed-off-by: Manos Pitsidianakis <manos@pitsidianak.is>
---
Manos Pitsidianakis (2):
      rust/bindings: add hw_random.h
      rust: add hw_random module

 MAINTAINERS                     |   8 +
 rust/bindings/bindings_helper.h |   1 +
 rust/kernel/hw_random.rs        | 320 ++++++++++++++++++++++++++++++++++++++++
 rust/kernel/lib.rs              |   2 +
 4 files changed, 331 insertions(+)
---
base-commit: 8bc67e4db64aa72732c474b44ea8622062c903f0
change-id: 20260525-rust-hw_random-virtio-rng-bd817be189c6

Best regards,
-- 
Manos Pitsidianakis <manos@pitsidianak.is>

