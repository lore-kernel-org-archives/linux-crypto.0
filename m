Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08651A3056;
	Mon,  5 May 2025 17:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746467557; cv=none; b=sY5v+zf6it7Dof8DUYAovO3GlmhPTxwdsxqop06kvdR/KqA2+U0IYPbFeYa/sPuZDeDcsmg3iUKKBnSZooKvlHWXiZWZMUjfo6cmYT7IE26GkqmMeDsssOQdEiVKa2VPhClU3jriUoJ8eddfx2bho0wz4OPi/pTconme5M2es/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746467557; c=relaxed/simple;
	bh=bRdbB5nwoXceqJLAgXR8XsFvGMcB++yq5xBurBYsHF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mxILYlid0zvVeHiRz0EdvB/IYdVrW6pxHk6mBezFWnaPRmOyMMOnJDuIqa5ckCifCFl6pWtTKVgvNSQiztF2XPX4xuaRuHttLB0IcPfaQTrBbGhLd+elPW44rwlqlNr6uAjDf1xCsRsI12dwzS+CH1ZdNAvYjcmyp0hpAUyrN/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GrFsSaO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GrFsSaO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A49C4CEE4;
	Mon,  5 May 2025 17:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746467556;
	bh=bRdbB5nwoXceqJLAgXR8XsFvGMcB++yq5xBurBYsHF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GrFsSaO/rc5NtMJpnqe/lDFOwhuNGiijkItvt4S7Dl6WQdwK53uxHqqI6jUNG+qlK
	 Y3o0WbevDK7KU+DAXO4j2Ko/caQ1qSb1JQAZJC3L7wPgy0lz/kNCaMSQ1lZ4/5hTdx
	 JSMpqE21g9ySrJ+Bv8hq7ZUhLTotzRxchKiIsJDjPvVNB4V43i9ajouo2lmF8BA4vb
	 c4lGkGcmZUbbIrCXsBS4Oc/V6+M9MArYDDC920EnMDebr0u8hq9ye+R1itIWb20P/x
	 YNQ+mFyBUP3wHNnCJsa5xuyaHHCJng795ZBLx9n/30ErfOdsbia+f3TVfDm+ddH3CT
	 RtD2/5dWf9DTw==
Date: Mon, 5 May 2025 20:52:32 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Tanmay Jagdale <tanmay@marvell.com>
Cc: bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
	jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
	andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, bbhushan2@marvell.com, bhelgaas@google.com,
	pstanner@redhat.com, gregkh@linuxfoundation.org,
	peterz@infradead.org, linux@treblig.org,
	krzysztof.kozlowski@linaro.org, giovanni.cabiddu@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, rkannoth@marvell.com, sumang@marvell.com,
	gcherian@marvell.com
Subject: Re: [net-next PATCH v1 00/15] Enable Inbound IPsec offload on
 Marvell CN10K SoC
Message-ID: <20250505175232.GN5848@unreal>
References: <20250502132005.611698-1-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502132005.611698-1-tanmay@marvell.com>

On Fri, May 02, 2025 at 06:49:41PM +0530, Tanmay Jagdale wrote:
> This patch series adds support for inbound inline IPsec flows for the
> Marvell CN10K SoC.

It will be much easier if in commit messages and comments you
will use kernel naming, e.g. "IPsec packet offload" and not "inline IPsec", e.t.c.

Also, I'm wonder, do you have performance numbers for this code?

Thanks

> 
> The packet flow
> ---------------
> An encrypted IPSec packet goes through two passes in the RVU hardware
> before reaching the CPU.
> First Pass:
>   The first pass involves identifying the packet as IPSec, assigning an RQ,
>   allocating a buffer from the Aura pool and then send it to CPT for decryption.
> 
> Second Pass:
>   After CPT decrypts the packet, it sends a metapacket to NIXRX via the X2P
>   bus. The metapacket contains CPT_PARSE_HDR_S structure and some initial
>   bytes of the decrypted packet which would help NIXRX in classification.
>   CPT also sets BIT(11) of channel number to further help in identifcation.
>   NIXRX allocates a new buffer for this packet and submits it to the CPU.
> 
> Once the decrypted metapacket packet is delivered to the CPU, get the WQE
> pointer from CPT_PARSE_HDR_S in the packet buffer. This WQE points to the
> complete decrypted packet. We create an skb using this, set the relevant
> XFRM packet mode flags to indicate successful decryption, and submit it
> to the network stack.
> 
> 
> Patches are grouped as follows:
> -------------------------------
> 1) CPT LF movement from crypto driver to RVU AF
>     0001-crypto-octeontx2-Share-engine-group-info-with-AF-dri.patch
>     0002-octeontx2-af-Configure-crypto-hardware-for-inline-ip.patch
>     0003-octeontx2-af-Setup-Large-Memory-Transaction-for-cryp.patch
>     0004-octeontx2-af-Handle-inbound-inline-ipsec-config-in-A.patch
>     0005-crypto-octeontx2-Remove-inbound-inline-ipsec-config.patch
> 
> 2) RVU AF Mailbox changes for CPT 2nd pass RQ mask, SPI-to-SA table,
>    NIX-CPT BPID configuration
>     0006-octeontx2-af-Add-support-for-CPT-second-pass.patch
>     0007-octeontx2-af-Add-support-for-SPI-to-SA-index-transla.patch
>     0008-octeontx2-af-Add-mbox-to-alloc-free-BPIDs.patch
> 
> 3) Inbound Inline IPsec support patches
>     0009-octeontx2-pf-ipsec-Allocate-Ingress-SA-table.patch
>     0010-octeontx2-pf-ipsec-Setup-NIX-HW-resources-for-inboun.patch
>     0011-octeontx2-pf-ipsec-Handle-NPA-threshhold-interrupt.patch
>     0012-octeontx2-pf-ipsec-Initialize-ingress-IPsec.patch
>     0013-octeontx2-pf-ipsec-Manage-NPC-rules-and-SPI-to-SA-ta.patch
>     0014-octeontx2-pf-ipsec-Process-CPT-metapackets.patch
>     0015-octeontx2-pf-ipsec-Add-XFRM-state-and-policy-hooks-f.patch
> 
> 
> Bharat Bhushan (5):
>   crypto: octeontx2: Share engine group info with AF driver
>   octeontx2-af: Configure crypto hardware for inline ipsec
>   octeontx2-af: Setup Large Memory Transaction for crypto
>   octeontx2-af: Handle inbound inline ipsec config in AF
>   crypto: octeontx2: Remove inbound inline ipsec config
> 
> Geetha sowjanya (1):
>   octeontx2-af: Add mbox to alloc/free BPIDs
> 
> Kiran Kumar K (1):
>   octeontx2-af: Add support for SPI to SA index translation
> 
> Rakesh Kudurumalla (1):
>   octeontx2-af: Add support for CPT second pass
> 
> Tanmay Jagdale (7):
>   octeontx2-pf: ipsec: Allocate Ingress SA table
>   octeontx2-pf: ipsec: Setup NIX HW resources for inbound flows
>   octeontx2-pf: ipsec: Handle NPA threshold interrupt
>   octeontx2-pf: ipsec: Initialize ingress IPsec
>   octeontx2-pf: ipsec: Manage NPC rules and SPI-to-SA table entries
>   octeontx2-pf: ipsec: Process CPT metapackets
>   octeontx2-pf: ipsec: Add XFRM state and policy hooks for inbound flows
> 
>  .../marvell/octeontx2/otx2_cpt_common.h       |    8 -
>  drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   10 -
>  .../marvell/octeontx2/otx2_cptpf_main.c       |   50 +-
>  .../marvell/octeontx2/otx2_cptpf_mbox.c       |  286 +---
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      |  116 +-
>  .../marvell/octeontx2/otx2_cptpf_ucode.h      |    3 +-
>  .../ethernet/marvell/octeontx2/af/Makefile    |    2 +-
>  .../ethernet/marvell/octeontx2/af/common.h    |    1 +
>  .../net/ethernet/marvell/octeontx2/af/mbox.h  |  119 +-
>  .../net/ethernet/marvell/octeontx2/af/rvu.c   |    9 +-
>  .../net/ethernet/marvell/octeontx2/af/rvu.h   |   71 +
>  .../ethernet/marvell/octeontx2/af/rvu_cn10k.c |   11 +
>  .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  706 +++++++++-
>  .../ethernet/marvell/octeontx2/af/rvu_cpt.h   |   71 +
>  .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  230 +++-
>  .../marvell/octeontx2/af/rvu_nix_spi.c        |  220 +++
>  .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   16 +
>  .../marvell/octeontx2/af/rvu_struct.h         |    4 +-
>  .../marvell/octeontx2/nic/cn10k_ipsec.c       | 1191 ++++++++++++++++-
>  .../marvell/octeontx2/nic/cn10k_ipsec.h       |  152 +++
>  .../marvell/octeontx2/nic/otx2_common.c       |   23 +-
>  .../marvell/octeontx2/nic/otx2_common.h       |   16 +
>  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   17 +
>  .../marvell/octeontx2/nic/otx2_struct.h       |   16 +
>  .../marvell/octeontx2/nic/otx2_txrx.c         |   25 +-
>  .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |    4 +
>  26 files changed, 2915 insertions(+), 462 deletions(-)
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c
> 
> -- 
> 2.43.0
> 
> 
