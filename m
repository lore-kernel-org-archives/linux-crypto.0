Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847C118A959;
	Sun,  9 Feb 2025 10:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739096515; cv=none; b=o+rML6kvNpcWEX7fEBXOpAKDXHaCTHPAeLg4MPypJieDs8JYSh5oR8JTWyJIZ/y6DFKVOlk9rA9PrzTzymfU4D0j6tbPAQ1AAja1TbAKQs9xlXbX/mxhxrWnOkzo+AzgF49lFqy1CCcVmbfN4K31dAabs4gTCKhqtiMEDzHJ2lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739096515; c=relaxed/simple;
	bh=HFODCAK5J3CmMA8T4m3nmSUMLuYP2U76HwsFYdoujtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kx0zXIevL8dfrKI6Hx2+UG87GFXEa5ScufyzCt5XGjqJl7rDpW60Ml438Si9Q2USD+AdDUwQ2EKg5kWnGimZRHfwMT9MWPel2/6UJCjO4uhuPSBVMKoaku/ILCN74atkeBowDrf4h5HEpNrsMxGiLi1wXmqq5ufm92/GqnlTxVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qOfGhcn0; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qOfGhcn0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KJuTJH/ACV/uO7e4LopHlJMSumdRQXrjCU1mNibRGz0=; b=qOfGhcn0jnZ1fbhZ776AGCNQqu
	X9pR0LPZi9wVXCfV7wsCHZuDpgZSC/BaM1ssor2Ifpbf0L/LBQo1b3yLhp6TrK+o5amYvBHcPkmSw
	9XTcuOaVip+qLhVXEDCZZudYwe2MbbqqlKRUiBWR56IuAiVBCA3ZoLh99IZ0GAyIMhlzoqEbWzurp
	bDVRQaUqUFq5urs9uwf/N9RAVQJ2zxE/vcU01DYXURufwdH6FSI0qU4yW1L+z4wulrkKAprnHkIJn
	M274ZUvy3+NML78AZ2UOG63ov38coP38xeyee7GUhKljkhDP5p2vy6BIp9joffgAGY/uVh7gXpMxO
	NHVr0S6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1th4EU-00GIje-1C;
	Sun, 09 Feb 2025 18:21:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Feb 2025 18:21:31 +0800
Date: Sun, 9 Feb 2025 18:21:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com
Subject: Re: [PATCH v11 0/3] crypto: Add EIP-93 crypto engine support
Message-ID: <Z6iBq9kwMIie2AbL@gondor.apana.org.au>
References: <20250114123935.18346-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250114123935.18346-1-ansuelsmth@gmail.com>

On Tue, Jan 14, 2025 at 01:36:33PM +0100, Christian Marangi wrote:
> This small series add support for the Inside Secure EIP-93.
> This is a predecessor of the current supported EIP197. It doesn't
> require a firmware but instead it's embedded in the SoC.
> 
> First patch extend guard for spinlock_bh.
> 
> The other actually implement Documentation and Driver.
> 
> The Driver pass all the normal selft test for the supported
> algo and also pass the EXTRA test with fuzz_iterations set to 10000.
> 
> Changes v11:
> - Drop any mtk variable reference and use eip93 instead
> - Mute smatch warning for context unbalance by using scoped_guard instead
>   of guard cleanup API
> Changes v10:
> - Use CRYPTO_ALG_ASYNC for eip93_hmac_setkey
> Changes v9:
> - Rework hash code to alloc DMA only when needed
> - Rework hash code to only alloc needed blocks and use
>   local struct in req for everything else
> - Rework hash code to use GFP_ATOMIC
> - Simplify hash update function
> - Generalize hmac key set function
> Changes v8:
> - Rework export and update to not sleep on exporting state
>   (consume pending packet in update and return -EINPROGRESS)
> Changes v7:
> - Fix copypaste error in __eip93_hash_init
> - Rework import/export to actually export the partial hash
>   (we actually unmap DMA on export)
> - Rename no_finalize variable to better partial_hash
> - Rename 3rd commit title and drop Mediatek from title.
> - Add Cover Letter
> - Add Reviewed-by to DT commit
> (cumulative changes from old series that had changelog in each patch)
> Changes v6:
> - Add SoC specific compatible
> - Add now supported entry for compatible with no user
> Changes v5:
> - Add Ack tag to guard patch
> - Comment out compatible with no current user
> - Fix smatch warning (reported by Dan Carpenter)
> Changes v4:
> - Out of RFC
> - Add missing bitfield.h
> - Drop useless header
> Changes v3:
> - Mute warning from Clang about C23
> - Fix not inizialized err
> - Drop unused variable
> - Add SoC compatible with generic one
> Changes v2:
> - Rename all variables from mtk to eip93
> - Move to inside-secure directory
> - Check DMA map errors
> - Use guard API for spinlock
> - Minor improvements to code
> - Add guard patch
> - Change to better compatible
> - Add description for EIP93 models
> 
> Christian Marangi (3):
>   spinlock: extend guard with spinlock_bh variants
>   dt-bindings: crypto: Add Inside Secure SafeXcel EIP-93 crypto engine
>   crypto: Add Inside Secure SafeXcel EIP-93 crypto engine support
> 
>  .../crypto/inside-secure,safexcel-eip93.yaml  |  67 ++
>  MAINTAINERS                                   |   7 +
>  drivers/crypto/Kconfig                        |   1 +
>  drivers/crypto/Makefile                       |   1 +
>  drivers/crypto/inside-secure/eip93/Kconfig    |  20 +
>  drivers/crypto/inside-secure/eip93/Makefile   |   5 +
>  .../crypto/inside-secure/eip93/eip93-aead.c   | 711 ++++++++++++++
>  .../crypto/inside-secure/eip93/eip93-aead.h   |  38 +
>  .../crypto/inside-secure/eip93/eip93-aes.h    |  16 +
>  .../crypto/inside-secure/eip93/eip93-cipher.c | 413 +++++++++
>  .../crypto/inside-secure/eip93/eip93-cipher.h |  60 ++
>  .../crypto/inside-secure/eip93/eip93-common.c | 809 ++++++++++++++++
>  .../crypto/inside-secure/eip93/eip93-common.h |  24 +
>  .../crypto/inside-secure/eip93/eip93-des.h    |  16 +
>  .../crypto/inside-secure/eip93/eip93-hash.c   | 866 ++++++++++++++++++
>  .../crypto/inside-secure/eip93/eip93-hash.h   |  82 ++
>  .../crypto/inside-secure/eip93/eip93-main.c   | 501 ++++++++++
>  .../crypto/inside-secure/eip93/eip93-main.h   | 151 +++
>  .../crypto/inside-secure/eip93/eip93-regs.h   | 335 +++++++
>  include/linux/spinlock.h                      |  13 +
>  20 files changed, 4136 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
>  create mode 100644 drivers/crypto/inside-secure/eip93/Kconfig
>  create mode 100644 drivers/crypto/inside-secure/eip93/Makefile
>  create mode 100644 drivers/crypto/inside-secure/eip93/eip93-aead.c
>  create mode 100644 drivers/crypto/inside-secure/eip93/eip93-aead.h
>  create mode 100644 drivers/crypto/inside-secure/eip93/eip93-aes.h
>  create mode 100644 drivers/crypto/inside-secure/eip93/eip93-cipher.c
>  create mode 100644 drivers/crypto/inside-secure/eip93/eip93-cipher.h
>  create mode 100644 drivers/crypto/inside-secure/eip93/eip93-common.c
>  create mode 100644 drivers/crypto/inside-secure/eip93/eip93-common.h
>  create mode 100644 drivers/crypto/inside-secure/eip93/eip93-des.h
>  create mode 100644 drivers/crypto/inside-secure/eip93/eip93-hash.c
>  create mode 100644 drivers/crypto/inside-secure/eip93/eip93-hash.h
>  create mode 100644 drivers/crypto/inside-secure/eip93/eip93-main.c
>  create mode 100644 drivers/crypto/inside-secure/eip93/eip93-main.h
>  create mode 100644 drivers/crypto/inside-secure/eip93/eip93-regs.h
> 
> -- 
> 2.45.2

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
