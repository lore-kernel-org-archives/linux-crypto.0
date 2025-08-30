Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAF322069E;
	Sat, 30 Aug 2025 08:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756543876; cv=none; b=GrvDWqI80S36VP6z07QgbrndRP6+P0rU6pe4nNe4BtwccGvovOxUlpd3axy2tShqJJZmgpbaCLPF78AjXyJza21iym7Qc/Bq8r45Gadf1sNPJAbISfu5RDNrJWMtcWdDOb2XN2nNh41wbM29+Qp5o+8rIlrg0F81+PnQW1JEhZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756543876; c=relaxed/simple;
	bh=pDQWKxeDNsOqfcHbK5MPyQN88U5Hq0VJytSBl/l9+Cg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sh7YIMBH2DYrAbLCXdC6IhRgDBd52HJAFU65RTtyK33eYFRY9wekug46jIQqAJWpSq10BAEtb5ePQZftnRNX5HcWGAtdpNlmcsnyKnDr7bbxW9JdIbDacwkE1eUobCAwSOZTpz8VfvRvBQvhmrtpqBgCK/feDCkQBVTcdE0eqGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bemiyVlw; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bemiyVlw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3exHe+b1yARcplOzn65UrVI+uZJ9/nZY/D7WY+bWVz4=; b=bemiyVlwWvKgmjELtAuYaJDXBa
	QaqBDbdD1t7f9qmchNfMLH5QyItPgMXbUD3H6N8F2JdFwYMRYbWBhgxK+4exdEj1z+BWfX4fGV2Pb
	Od2Qj2W0pMI/Zfa616tb+0kCZDM/MixOLvtxBEAJfgsvMmXqqkpbqDwptvSLaIp3TBvx1lBA36D4x
	PVD0+FZT0q8EVE+KSHAcTENJxf+ZKPnynglnmbPUQYxqewomKNlZmYhrryTw+Vm0Og/g629uKV22Z
	QmdInsHkSfyCBlSsqNqGiBwHBoeOLxplHzz7XbzzkE8FTq6UHZ/RVa7RJJocZ13ldtXB8W8rnQSbP
	HnxQbjMg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1usH3G-0017Ae-0I;
	Sat, 30 Aug 2025 16:51:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 30 Aug 2025 16:51:06 +0800
Date: Sat, 30 Aug 2025 16:51:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S . Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>
Subject: Re: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto
 Engine
Message-ID: <aLK7eiozc2F-kM_z@gondor.apana.org.au>
References: <20250820092710.3510788-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820092710.3510788-1-t-pratham@ti.com>

On Wed, Aug 20, 2025 at 02:42:25PM +0530, T Pratham wrote:
> Data Transform and Hashing Engine (DTHE) v2 is a new cryptography engine
> introduced i TI AM62L SoC. DTHEv2 consists of multiple crypto IPs[1] (such
> as AES Engine, hashing engine, TRNG, etc.) which can be used for
> offloading cryptographic operations off of the CPU. The primary benefit
> of DTHEv2 is enhanced side-channel attack resistance, with AES and PKE
> engine being DPA and EMA resistant. These side-channel resistances are
> the underlying requirement for various certifications like SESIP, PSA,
> and IEC62443 (lvl 3+). Thus, DTHEv2 provides critical security benefits
> for embedded systems that require protection against passive physical
> attacks.
> 
> The AES Engine of DTHEv2 supports multiple AES modes (ECB, CBC, CTR,
> CFB, f8), several protocols (GCM, CCM, XTS) and authentication modes
> (CBC-MAC and f9). The hashing engine supports MD5, SHA1, and SHA2 (224,
> 256, 384, 512) algorithms along with HMAC. This patch series introduces
> basic driver support for DTHEv2 engine, beginning with suporting AES-ECB
> and AES-CBC algorithms. Other algorithms are planned to be added
> gradually in phases after initial suppport is added.
> 
> The driver is tested using full kernel crypto selftests (CRYPTO_SELFTESTS)
> which all pass successfully [2].
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
> [1]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
> Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf
> 
> [2]: DTHEv2 AES-ECB and AES-CBC kernel self-tests logs
> Link: https://gist.github.com/Pratham-T/aaa499cf50d20310cb27266a645bfd60
> 
> Change log:
> v7:
>  - Dropped redundant crypto_engine_stop() calls.
>  - Corrected Reviewed-by tag.
> v6:
>  - Reworded the cover letter and commit messages to name DTHEv2 as a
>    crypto engine instead of crypto accelerator.
>  - Reworded the cover letter completely to emphasise more on the utility
>    of DTHEv2 as better resistance against physical attacks
>  - Reworded DTHEv2 description (help text) in KConfig
>  - Added dma_terminate_sync calls to ensure DMA requests are removed in
>    case when completion times-out.
>  - Some rearrangement of fields between dthe_tfm_ctx and dthe_aes_req_ctx
>    struct, so that per tfm members are correctly placed in tfm_ctx and per
>    request members are in req_ctx. Subsequently setkey, encrypt and
>    decrypt functions are also changed.
>  - Removed exit_tfm function which was useless and not required.
>  - Removed unnecessary zeroing of tfm_ctx object in init_tfm.
>  - Corrected return value in dthe_aes_run function.
>  - Reduced cra_priority of DTHEv2 algorithms.
> v5:
>  - Simplified tfm ctx struct
>  - Set cra_reqsize instead of using crypto_skcipher_set_reqsize()
>  - Move setting sysconfig and irqenable registers to dthe_aes_run
> v4:
>  - Corrected dt-bindings example indentation
>  - Simplified dt-bindings example, removing the node surrounding crypto
>  - Fixed typo in dthev2-common.h header guard
>  - Removed unused ctx field in dev_data struct
>  - Moved per-op data into request context
> v3:
>  - Corrected dt-bindings reg length is too long error
>  - Converted AES driver code to use crypto_engine APIs for using
>    internal crypto queue instead of mutex.
>  - Removed calls to skcipher_request_complete in paths not returning
>    -EINPROGRESS before.
>  - Added missing KConfig import, which was accidentally removed in v2.
> 
> v2:
>  - Corrected dt-bindings syntax errors and other review comments in v1.
>  - Completely changed driver code structure, splitting code into
>    multiple files
> 
> Link to previous versions:
> v6: https://lore.kernel.org/all/20250819065844.3337101-1-t-pratham@ti.com/
> v5: https://lore.kernel.org/all/20250603124217.957116-1-t-pratham@ti.com/
> v4: https://lore.kernel.org/all/20250508101723.846210-2-t-pratham@ti.com/
> v3: https://lore.kernel.org/all/20250502121253.456974-2-t-pratham@ti.com/
> v2: https://lore.kernel.org/all/20250411091321.2925308-1-t-pratham@ti.com/
> v1: https://lore.kernel.org/all/20250206-dthe-v2-aes-v1-0-1e86cf683928@ti.com/
> ---
> 
> T Pratham (2):
>   dt-bindings: crypto: Add binding for TI DTHE V2
>   crypto: ti: Add driver for DTHE V2 AES Engine (ECB, CBC)
> 
>  .../bindings/crypto/ti,am62l-dthev2.yaml      |  50 +++
>  MAINTAINERS                                   |   7 +
>  drivers/crypto/Kconfig                        |   1 +
>  drivers/crypto/Makefile                       |   1 +
>  drivers/crypto/ti/Kconfig                     |  14 +
>  drivers/crypto/ti/Makefile                    |   3 +
>  drivers/crypto/ti/dthev2-aes.c                | 411 ++++++++++++++++++
>  drivers/crypto/ti/dthev2-common.c             | 217 +++++++++
>  drivers/crypto/ti/dthev2-common.h             | 101 +++++
>  9 files changed, 805 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/ti,am62l-dthev2.yaml
>  create mode 100644 drivers/crypto/ti/Kconfig
>  create mode 100644 drivers/crypto/ti/Makefile
>  create mode 100644 drivers/crypto/ti/dthev2-aes.c
>  create mode 100644 drivers/crypto/ti/dthev2-common.c
>  create mode 100644 drivers/crypto/ti/dthev2-common.h
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
