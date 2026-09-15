Received: from mout-b-112.mailbox.org (mout-b-112.mailbox.org [195.10.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4314A2E1B;
	Tue, 15 Sep 2026 11:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.10.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472471; cv=none; b=iVDu+X2OXIgLkoYQSPVrEEJ04dtx24FUuuccA25lbuhMM1B/xS0VfvpMaUZscuma2oVE/hOs7sE0h8cC51EyrIT7sttkRqAeuqIRPF/0N7Z7euod5R+M+U9ff3YiFmdILUVxTN7chIP2WgoDhbgvUjNZx6yF2Ayu3vSTIn1r3Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472471; c=relaxed/simple;
	bh=IjJuKqKXLxU/0JYjaYVkBnwO9uU6V1vq++HA926zpMM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LS31FL1ReS5fJPUAGCpKN8J0c4JuCcHcZqoywwrk7aJl4MbLTK5zpplTNgouDsUfy+jrBgI+qVCSAOST0V7+j83qGmPLGH3Ma22+k+UMlR9dCvy6P4PUyaWGvzAr2iGpdrwjee857DmLeiVJDWB6OC0pV0F96pucyAB0epUSxN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com; spf=pass smtp.mailfrom=mandelbit.com; dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b=x5QQo9EN; arc=none smtp.client-ip=195.10.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b="x5QQo9EN"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-112.mailbox.org (Postfix) with ESMTPS id 4hkfxw693Nz5wwK;
	Tue, 15 Sep 2026 13:32:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1789471941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5NUlqAM6Yy/s3cndoxdYdrvWqEeQ2TNloNsVjiACbWY=;
	b=x5QQo9ENm9ky01mXEXPizTWwM/E7XWiC1MmEtmLYmeP7bNSGt+uUC77cz2KGUMb+IWLoGK
	ZbWpeTe63iauypormSpsgqGe3iimXepN6MP2qHX+u8of4Jy2aMR6pwHNgVPCsmBE519YPi
	KIkDS7bMG5O8GR30SwDWKpFF0B/OEKuEwvK8P0HMZ6tfLMWXpMiyI5Q2J6oPOTq6eHvBrM
	+NiRHwv8IMI8mDvN//3GCSaYknbVaqxZyCfu1Zl3ja0rW11K4fILKkwE60DM0nf/18RJ4k
	XZ52HwyGActDyfML0czwdtIbiJg7K5g5HLGqQHWevDWDAdIBzZvAADdjy1j5og==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of ralf@mandelbit.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=ralf@mandelbit.com
From: Ralf Lici <ralf@mandelbit.com>
To: linux-crypto@vger.kernel.org
Cc: Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: [PATCH crypto 0/2] crypto: safexcel: fix AEAD DMA mapping and cleanup
Date: Tue, 15 Sep 2026 13:32:10 +0200
Message-ID: <cover.1789469436.git.ralf@mandelbit.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4hkfxw693Nz5wwK

Hi,

This series fixes a couple of bugs that affect the safexcel driver with
the first one targeting a double unmap path and the second one (more
important) mapping AEAD buffers with finer granularity.

While testing ovpn (the OpenVPN data channel offload kernel module) on
two GL.iNet GL-MT6000 routers (using the MT7986 EIP97 on a non-coherent
Cortex-A53 system), once the kernel selects the hardware AES-GCM
provider, traffic became unreliable in ways that were difficult to
explain from the ovpn side. This is not the first such report: OpenWrt
users had described tunnels that stopped passing traffic when kernel
ovpn or ipsec and safexcel were loaded together.

During the tests I noticed that the stock driver reported successful
crypto completion, yet the reproducer found damaged output. At data
offsets 0, 32 and 66 modulo 128, respectively, the first 40, 8 and 38
payload bytes were wrong. Those lengths match the part of the payload
sharing a 64-byte cache line with the small AAD mapping. Fragmented
out-of-place encryption also failed with only one request in flight.

The problem is that safexcel describes too much of an AEAD request as
device output. It maps every entry of an in-place request as
DMA_BIDIRECTIONAL and every entry of an out-of-place destination as
DMA_FROM_DEVICE, even though AAD is read-only and a decrypt tag is
input-only. On these routers, an unaligned, small entry can be bounced
by SWIOTLB. Unmapping that entry as device output copies unchanged
bounce contents back; cache maintenance on the neighboring payload
mapping can then write stale CPU bytes over ciphertext or plaintext
which the EIP97 had produced correctly. The fixed SWIOTLB pool is only 1
MiB, with 512 slots of 2 KiB each, so these tiny entries also have a
disproportionate bounce cost under network load.

Thus, the second patch in this series gives each AEAD entry the
direction its contents require: input-only entries use DMA_TO_DEVICE,
pure out-of-place output uses DMA_FROM_DEVICE, and mixed or in-place
output uses DMA_BIDIRECTIONAL.

I also checked whether other network users of the accelerator behaved
the same way. With the corrected driver, RFC 4106 AES-128-GCM ESP passed
transport-mode tests with one, two and four SA pairs, without
authentication or replay errors.

kTLS revealed a different limit. Sustained TLS 1.2 AES-128-GCM still
corrupts when multiple 16 KiB records are live concurrently, both with
stock safexcel and with the corrected prototype. Serializing records
made 256 MiB transfers pass. I think the remaining issue is of the same
class: kTLS can place neighboring records in regions of shared pages,
making concurrent cache-line-sharing DMA mappings the leading
explanation, although I have not captured an exact cache-line trace.
These patches do not claim to fix that separate kTLS failure.

Cheers!

Ralf Lici
Mandelbit Srl

---
Ralf Lici (2):
  crypto: safexcel - Avoid unmapping failed DMA mappings
  crypto: safexcel - Map AEAD buffers with accurate DMA directions

 .../crypto/inside-secure/safexcel_cipher.c    | 173 +++++++++++++++---
 1 file changed, 150 insertions(+), 23 deletions(-)


base-commit: 60892a384aa1e65d0e703e1c513417bdf0c80777
-- 
2.55.0

