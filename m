Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D648D288536;
	Wed,  7 May 2025 12:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746621926; cv=none; b=iauq3i9VwFIGAPtIDipkMkHN/bjDmSp8yuVx3LITqD5ZdNQugTqpmilmrV9SFnE81bl4ln8JPDWHMYtbcSSN0At+4NPb1iI4f4LtoHu6SxCTeSP445mIIfAyH7UZOd8ELdRGf44HVoKabhiAtiLCjcP5Ws1/BnSqWCc3zP2WBxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746621926; c=relaxed/simple;
	bh=hWPZGZMyO9m9fh1QoW2+cS/xkUtBH3giL/aGBqo0sQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zlpcc3HadlK/3AoT6L1MbyBSJ3zjRpK5d8nr3T0yqkzgCgRApjWwhNhFVHu0CVicup1HV01yLVvxnQF2nVHKkzl2lCpM27NXrQI2lEORyLAvbnkSt/E2G1BbRKZ82fLaGvwDoEeADa+xpM4yZG6e3iN96+RM81BQ/JFvh8usAUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RydokPtq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RydokPtq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA35C4CEEB;
	Wed,  7 May 2025 12:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746621925;
	bh=hWPZGZMyO9m9fh1QoW2+cS/xkUtBH3giL/aGBqo0sQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RydokPtqw6JMBeritrP3myYZFnrzDRKicoD7SFnI4ez6VyTLq8yq93mi0/Tqb09eK
	 kI0G3iGJxANin2RCOC4rO7RLuYrXF1O3FFIJKq+Ke2hlPVBrH7mW0dBds2biLe2QQE
	 b6ZZmU5hrTpW8vbZb8AnNWk+9XdUdu/Hu5Ssgb3PA0KKlBVIlgiL8ZjRTv87JfZu7J
	 kAMB3nhY4ewgMajr00ZLKTGgIarqwvMP/iPn2OjyqV1xI5VzRNMpRt6mF4A0TV25y5
	 Zf8aS3MpZtvO1kESbFRaGp/OMhcWlWeZw12v43fE5aCqjGGFsWhZu9if099O2zvpjg
	 fVWZVsQFH0P/Q==
Date: Wed, 7 May 2025 13:45:17 +0100
From: Simon Horman <horms@kernel.org>
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
	gcherian@marvell.com, Kiran Kumar K <kirankumark@marvell.com>,
	Nithin Dabilpuram <ndabilpuram@marvell.com>
Subject: Re: [net-next PATCH v1 07/15] octeontx2-af: Add support for SPI to
 SA index translation
Message-ID: <20250507124517.GC3339421@horms.kernel.org>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-8-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502132005.611698-8-tanmay@marvell.com>

On Fri, May 02, 2025 at 06:49:48PM +0530, Tanmay Jagdale wrote:
> From: Kiran Kumar K <kirankumark@marvell.com>
> 
> In case of IPsec, the inbound SPI can be random. HW supports mapping
> SPI to an arbitrary SA index. SPI to SA index is done using a lookup
> in NPC cam entry with key as SPI, MATCH_ID, LFID. Adding Mbox API
> changes to configure the match table.
> 
> Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
> Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> index 715efcc04c9e..5cebf10a15a7 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> @@ -326,6 +326,10 @@ M(NIX_READ_INLINE_IPSEC_CFG, 0x8023, nix_read_inline_ipsec_cfg,		\
>  M(NIX_LF_INLINE_RQ_CFG, 0x8024, nix_lf_inline_rq_cfg,		\
>  				nix_rq_cpt_field_mask_cfg_req,  \
>  				msg_rsp)	\
> +M(NIX_SPI_TO_SA_ADD,    0x8026, nix_spi_to_sa_add, nix_spi_to_sa_add_req,   \
> +				nix_spi_to_sa_add_rsp)                      \
> +M(NIX_SPI_TO_SA_DELETE, 0x8027, nix_spi_to_sa_delete, nix_spi_to_sa_delete_req,   \
> +				msg_rsp)                                        \

Please keep line length to 80 columns or less in Networking code,
unless it reduces readability.

In this case perhaps:

M(NIX_SPI_TO_SA_DELETE, 0x8027, nix_spi_to_sa_delete,     \
				nix_spi_to_sa_delete_req, \
				msg_rsp)                  \

Likewise throughout this patch (set).
checkpatch.pl --max-line-length=80 is your friend.

>  M(NIX_MCAST_GRP_CREATE,	0x802b, nix_mcast_grp_create, nix_mcast_grp_create_req,	\
>  				nix_mcast_grp_create_rsp)			\
>  M(NIX_MCAST_GRP_DESTROY, 0x802c, nix_mcast_grp_destroy, nix_mcast_grp_destroy_req,	\

...
