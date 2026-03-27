Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431143B27EB;
	Fri, 27 Mar 2026 10:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774606135; cv=none; b=b7rAkQqS0j3r/zywwBnAFJBJwSbo9FQoIYG79aO3iSSBDokYz1rbgbEEqbsjURFf2AwZ3rPDQFDad2JEN3+ZcYCzJDWo7uRdkN59leMzp0nphbxTMIq79NPyAW2oJ6gNqyhV6e4+6AAmwyxSSJXGBUvIU6LMvij5smBd+rspOtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774606135; c=relaxed/simple;
	bh=Gkx+ucyy+njBxZgFWeZvmGtBen55gxUZdDrB8CVHD/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tGBh60EXQtJQZYCVujSxINvazwObP449U05gm2m8coTD7UM6PTAygttQWGimrpgHITUicQGwdlT4FHMeTcoYZ6WUbjyWhMbecq2tiEbVno04rzMyeeJpjrpaUqwt5waGUY0l3s86HdRerRxxZZj4duwpjdJ2YQp3Kta66B8+JzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=mGJ6l8rQ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="mGJ6l8rQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Iyw7V4FgW1saC46e/5O6IM9EH70fsK0dWrwMtFUqqPg=; 
	b=mGJ6l8rQU+lMedql6CaLwaPSG31bhWuNsHoLS5L4u5+2gLzp8QNkFiyotYvyUPV9flz6CwqGfWi
	weAGEAtnGnn+LLgyG9I1lrNGCXKOLAR8QGn+K084DOWL0LRs7oeElfMyfuhh90VOGChT1b5q9MDPy
	G9g3lQ9UBuQraMADcjb3WGzRb/hcSLgfp7Mlh2EeyAzARnLdLZPyS7Z8FuAQK0gcaWuikDVo122O+
	up5GVxJ6FMHRUSjnckYhBXuPALPxqFyTWeRn7fJy4HECoxVd3Qzy1YKexGP0J5JPuVXrb4W2SL9mt
	BN+RTFnR2Z+XaU2ADUH7kOkIIgKhNHH6ygAA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w63i2-001boH-0H;
	Fri, 27 Mar 2026 18:08:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2026 19:08:48 +0900
Date: Fri, 27 Mar 2026 19:08:48 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S . Miller " <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>
Subject: Re: [PATCH v11 0/2] Add support for more AES modes in TI DTHEv2
Message-ID: <acZXMOVKBfg97Vq5@gondor.apana.org.au>
References: <20260320105052.3931552-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320105052.3931552-1-t-pratham@ti.com>

On Fri, Mar 20, 2026 at 04:20:50PM +0530, T Pratham wrote:
> DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
> features of DTHEv2 and details of AES modes supported were detailed in
> [1]. Additional hardware details available in SoC TRM [2].
> 
> This patch series adds support for the following AES modes:
>  - AES-GCM
>  - AES-CCM
> 
> The driver is tested using full kernel crypto selftests
> (CRYPTO_SELFTESTS_FULL) which all pass successfully [3].
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
> [1]: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto Engine
> Link: https://lore.kernel.org/all/20250820092710.3510788-1-t-pratham@ti.com/
> 
> [2]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
> Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf
> 
> [3]: DTHEv2 AES Engine kernel self-tests logs
> Link: https://gist.github.com/Pratham-T/aaa499cf50d20310cb27266a645bfd60
> 
> Change log:
> v11: 
>  - Removed AES-CTR patch merged in v10
>  - Split scatterlists into AAD and crypt scatterlists to be sent in
>    separate DMA transactions. In-place operations now have the modified
>    crypt scatterlist same for src and dst.
>  - Added correct handling of in-place operations which require
>    scatterlists to be mapped with DMA_BIDIRECTIONAL dma direction.
>  - Moved DMA callback registration to the last DMA transcriptor based on
>    conditions (cryptlen = 0 or not).
>  - Minor cleanup and added dev_err messages.
> v10:
>  - Moved dthe_copy_sg() into AES-CTR patch as it is the first user. Thus
>    maintaining bisectability.
>  - Corrected padding array size in req_ctx to avoid buffer overflow bug.
>  - Check for error in registration individually for AES and AEAD algos.
>  - Fixed return value being overridden in AEAD tag
>    calculation/verification.
>  - Changed memcmp to crypto_memneq to enhance security.
>  - Moved verifying AEAD keylen to before copying it in ctx to avoid any
>    buffer overflow bug.
> v9:
>  - Removed modifying scatterlist in AES-CTR. Replaced with allocating
>    our own scatterlist for the same purpose to handle padding.
> v8:
>  - Removed scatterlist chaining from AES-CTR, along with accompanying
>    helper functions added in v6. Replaced with sending only complete
>    blocks to hardware and handling the last partial block in software.
> v7:
>  - Moved padding buffer to inside request ctx.
>  - Removed already merged AES-XTS patch.
>  - Moved dthe_copy_sg() helper from CTR patch to GCM patch, where it is
>    being used for first time.
> v6:
>  - Removed memory alloc calls on the data path (CTR padding in aes_run),
>    replaced with scatterlist chaining for added a pad buffer. Added two
>    accompanying helpers dthe_chain_pad_sg() and
>    dthe_unchain_padded_sg(). 
>  - Replaced GFP_KERNEL to GFP_ATOMIC in AEAD src and dst scatterlist
>    prep functions to avoid deadlock in data path.
>  - Added fallback to software in AEADs on failure.
> v5:
>  - Simplified AES-XTS fallback allocation, directly using xts(aes) for
>    alg_name
>  - Changed fallback to sync and allocated on stack
> v4:
>  - Return -EINVAL in AES-XTS when cryptlen = 0
>  - Added software fallback for AES-XTS when ciphertext stealing is
>    required (cryptlen is not multiple of AES_BLOCK_SIZE)
>  - Changed DTHE_MAX_KEYSIZE definition to use AES_MAX_KEY_SIZE instead
>    of AES_KEYSIZE_256
>  - In AES-CTR, also pad dst scatterlist when padding src scatterlist
>  - Changed polling for TAG ready to use readl_relaxed_poll_timeout()
>  - Used crypto API functions to access struct members instead of
>    directly accessing them (crypto_aead_tfm and aead_request_flags)
>  - Allocated padding buffers in AEAD algos on the stack.
>  - Changed helper functions dthe_aead_prep_* to return ERR_PTR on error
>  - Changed some error labels in dthe_aead_run to improve clarity
>  - Moved iv_in[] declaration from middle of the function to the top
>  - Corrected setting CCM M value in the hardware register
>  - Added checks for CCM L value input in the algorithm from IV.
>  - Added more fallback cases for CCM where hardware has limitations
> v3:
>  - Added header files to remove implicit declaration error.
>  - Corrected assignment of src_nents and dst_nents in dthe_aead_run
>  (Ran the lkp kernel test bot script locally to ensure no more such
>  errors are present)
> v2:
>  - Corrected assignment of variable unpadded_cryptlen in dthe_aead_run.
>  - Removed some if conditions which are always false, and documented the
>    cases in comments.
>  - Moved polling of TAG ready register to a separate function and
>    returning -ETIMEDOUT on poll timeout.
>  - Corrected comments to adhere to kernel coding guidelines.
> 
> Link to previous version:
> 
> v10: https://lore.kernel.org/all/20260226125441.3559664-1-t-pratham@ti.com/ 
> v9: https://lore.kernel.org/all/20260213130207.209336-1-t-pratham@ti.com/
> v8: https://lore.kernel.org/all/20260120144408.606911-1-t-pratham@ti.com/
> v7: https://lore.kernel.org/all/20251126112207.4033971-1-t-pratham@ti.com/
> v6: https://lore.kernel.org/all/20251111112137.976121-1-t-pratham@ti.com/
> v5: https://lore.kernel.org/all/20251022180302.729728-1-t-pratham@ti.com/
> v4: https://lore.kernel.org/all/20251009111727.911738-1-t-pratham@ti.com/
> v3: https://lore.kernel.org/all/20250910100742.3747614-1-t-pratham@ti.com/
> v2: https://lore.kernel.org/all/20250908140928.2801062-1-t-pratham@ti.com/
> v1: https://lore.kernel.org/all/20250905133504.2348972-4-t-pratham@ti.com/
> ---
> 
> T Pratham (2):
>   crypto: ti - Add support for AES-GCM in DTHEv2 driver
>   crypto: ti - Add support for AES-CCM in DTHEv2 driver
> 
>  drivers/crypto/ti/Kconfig         |   3 +
>  drivers/crypto/ti/dthev2-aes.c    | 726 +++++++++++++++++++++++++++++-
>  drivers/crypto/ti/dthev2-common.h |  12 +-
>  3 files changed, 738 insertions(+), 3 deletions(-)
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
