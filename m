Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09785277819;
	Sat, 12 Jul 2025 13:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752327594; cv=none; b=p5R6W7J8ORoa6TEn4nPq1mH8fURKr5eTksLpB+RqoWcb1gHoRgoD/OKMQgFNw9TR4W7tEpX3qcyFAlO3UZwMsPYtAOHSDDW3ygRb9qcegP4uSYevHCq8AmD4JKI1WcnG4UAJioQhhgTPdXxX1mNd40tq/sRKXya7OQKMgjFPloI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752327594; c=relaxed/simple;
	bh=CXzJr7msdAQUmDr0XGJbVsBEEBDwQdHtltso1pwaJL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V/2B/Qq9MqjA/rUM6GZj+Ff1jnHeQSdBer/XYCGEGYLmdlagX0KA5xkV3L4GkTKR9mEhbD5bJ+ow483tBixaTqXmQ0y4IpS/6IC1JKLgarKy6gTWq4RXhFdMbSKjBuIOf+QpSpIURekIA/xX+v2NINXaYsOGxNrsYBqUduvAR88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GFo4TSoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GFo4TSoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B75C4CEEF;
	Sat, 12 Jul 2025 13:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752327593;
	bh=CXzJr7msdAQUmDr0XGJbVsBEEBDwQdHtltso1pwaJL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GFo4TSoM+m/M/yCN0itseD3d3pnFF1ZnBNdhFtmb5KYIF0IVMBagHuwkitKLh0kcQ
	 UIAhYUq1PhEWUZVuupQYKfymPP5qJAoqyIx4xihXV7t2tAibsZKOSRs1qDSyuKFXj/
	 yO46Y/R+G9YarC+f53PV/f+Yk/YOhUHT2+yL7pSAbK6odlv+WResBsB5NsUY+8nugl
	 EStfsFyg+Q253lvEw9NJ0gWZJWfR35hZoQktYa7NSFx3WjSn7MXQfwLbi1BsHPGHP9
	 ZU8dLl8IXpvUhtKe+i0DnoaiigxHvjwFmztA+1F1Oy8mXwDMKZdJM9j89uAMgmDmkt
	 cO07QiT8QZw8A==
Date: Sat, 12 Jul 2025 14:39:50 +0100
From: Simon Horman <horms@kernel.org>
To: Tanmay Jagdale <tanmay@marvell.com>
Cc: davem@davemloft.net, leon@kernel.org, herbert@gondor.apana.org.au,
	sgoutham@marvell.com, bbhushan2@marvell.com,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 12/14] octeontx2-pf: ipsec: Process CPT
 metapackets
Message-ID: <20250712133950.GB721198@horms.kernel.org>
References: <20250711121317.340326-1-tanmay@marvell.com>
 <20250711121317.340326-13-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250711121317.340326-13-tanmay@marvell.com>

On Fri, Jul 11, 2025 at 05:43:05PM +0530, Tanmay Jagdale wrote:
> CPT hardware forwards decrypted IPsec packets to NIX via the X2P bus
> as metapackets which are of 256 bytes in length. Each metapacket
> contains CPT_PARSE_HDR_S and initial bytes of the decrypted packet
> that helps NIX RX in classifying and submitting to CPU. Additionally,
> CPT also sets BIT(11) of the channel number to indicate that it's a
> 2nd pass packet from CPT.
> 
> Since the metapackets are not complete packets, they don't have to go
> through L3/L4 layer length and checksum verification so these are
> disabled via the NIX_LF_INLINE_RQ_CFG mailbox during IPsec initialization.
> 
> The CPT_PARSE_HDR_S contains a WQE pointer to the complete decrypted
> packet. Add code in the rx NAPI handler to parse the header and extract
> WQE pointer. Later, use this WQE pointer to construct the skb, set the
> XFRM packet mode flags to indicate successful decryption before submitting
> it to the network stack.
> 
> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
> ---
> Changes in V3:
> - Updated cpt_parse_hdr_s structure to use __be64 type

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h

...

> @@ -302,6 +303,41 @@ struct cpt_sg_s {
>  	u64 rsvd_63_50	: 14;
>  };
>  
> +/* CPT Parse Header Structure for Inbound packets */
> +struct cpt_parse_hdr_s {
> +	/* Word 0 */
> +	__be64 pkt_out     : 2;
> +	__be64 num_frags   : 3;
> +	__be64 pad_len     : 3;
> +	__be64 pkt_fmt     : 1;
> +	__be64 et_owr      : 1;
> +	__be64 reserved_53 : 1;
> +	__be64 reas_sts    : 4;
> +	__be64 err_sum     : 1;
> +	__be64 match_id    : 16;
> +	__be64 cookie      : 32;
> +
> +	/* Word 1 */
> +	__be64 wqe_ptr;
> +
> +	/* Word 2 */
> +	__be64 fi_offset   : 5;
> +	__be64 fi_pad      : 3;
> +	__be64 il3_off     : 8;
> +	__be64 pf_func     : 16;
> +	__be64 res_32_16   : 16;
> +	__be64 frag_age    : 16;
> +
> +	/* Word 3 */
> +	__be64 spi         : 32;
> +	__be64 res3_32_16  : 16;
> +	__be64 uc_ccode    : 8;
> +	__be64 hw_ccode    : 8;

Sparse complains about this and I'm not at all sure
how __be64 bitfields function on little endian systems.

I'd suggest using u64 members (not bitfields) and a combination of
FIELD_GET/FIELD_PREP, BITULL/GENMASK_ULL, and cpu_from_be64/be64_from_cpu.

> +
> +	/* Word 4 */
> +	__be64 misc;
> +};
> +

...

-- 
pw-bot: changes-requested
