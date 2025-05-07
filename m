Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEAF72635;
	Wed,  7 May 2025 12:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746622593; cv=none; b=E0eoJXu+p8SwnOEJKCQ37K03cuEKhhS1H7QHfZNSpbjvg7cDekXRlPrENTQp/3xxvMt3H1n2HqSJ0jtBJsZk5WfUbbKNqSOwnZcOdAOv8Ppsz4o3FJgGhXtEZC7HsbTiXVPzQ7RAW0SJkbhYPBev0pIWNrg/3K/CPfeLHEBI5Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746622593; c=relaxed/simple;
	bh=ETKPy7cscEkxT1hCjZsF04t03LagtJT/ZxD8Xi5As1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZf88/se1D/T3eRp1uEc7pNOStduOEu7TeX71ONGZD2wm5ZI9V/cE0yxdk0diTCbNB0SnTbjlohaaoLC9rMS/mcweo9wvL7Jtw7DkEuIhSGtVFSCiJVpSDgACOnOd3cllTnl6JP7Iipvii7Qjo70eceOQDHJ3CRVS2yo2ZRvD1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+xQIuO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+xQIuO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9560DC4CEF0;
	Wed,  7 May 2025 12:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746622592;
	bh=ETKPy7cscEkxT1hCjZsF04t03LagtJT/ZxD8Xi5As1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y+xQIuO2q5l0LtuVPuQY0qcRWd4Ed6207mKUG5AmU2olxGhuHQoH48tfjDGyburUA
	 OZNTdVowOXuPl9fuQVujjYoDH8jc1XbLOrRkYZRY6HCS59qOY4rss7AQ+8SebZ/7an
	 8wjstxtgfO4JwtgnyYOnUiiO4gXw/PqzIKG2YmsYoQla4t2dcQV8MEnuWD2Z7hLeCX
	 hhH8bLqWMTpNhyxtmbd8DnZJmRvke6iyku3t3b2VOaYIMiOdjxIBdxkbegAcjWuON9
	 0+3yI3SyW/gTX/dtpjReRUe73WF246qEbmX4mzVXbqKIKaXQvXwfQV3ga3+H8ymoOp
	 zl3pupL0oH5Pg==
Date: Wed, 7 May 2025 13:56:25 +0100
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
	gcherian@marvell.com
Subject: Re: [net-next PATCH v1 09/15] octeontx2-pf: ipsec: Allocate Ingress
 SA table
Message-ID: <20250507125625.GD3339421@horms.kernel.org>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-10-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502132005.611698-10-tanmay@marvell.com>

On Fri, May 02, 2025 at 06:49:50PM +0530, Tanmay Jagdale wrote:
> Every NIX LF has the facility to maintain a contiguous SA table that
> is used by NIX RX to find the exact SA context pointer associated with
> a particular flow. Allocate a 128-entry SA table where each entry is of
> 2048 bytes which is enough to hold the complete inbound SA context.
> 
> Add the structure definitions for SA context (cn10k_rx_sa_s) and
> SA bookkeeping information (ctx_inb_ctx_info).
> 
> Also, initialize the inb_sw_ctx_list to track all the SA's and their
> associated NPC rules and hash table related data.
> 
> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h

...

> @@ -146,6 +169,76 @@ struct cn10k_tx_sa_s {
>  	u64 hw_ctx[6];		/* W31 - W36 */
>  };
>  
> +struct cn10k_rx_sa_s {
> +	u64 inb_ar_win_sz	: 3; /* W0 */
> +	u64 hard_life_dec	: 1;
> +	u64 soft_life_dec	: 1;
> +	u64 count_glb_octets	: 1;
> +	u64 count_glb_pkts	: 1;
> +	u64 count_mib_bytes	: 1;
> +	u64 count_mib_pkts	: 1;
> +	u64 hw_ctx_off		: 7;
> +	u64 ctx_id		: 16;
> +	u64 orig_pkt_fabs	: 1;
> +	u64 orig_pkt_free	: 1;
> +	u64 pkind		: 6;
> +	u64 rsvd_w0_40		: 1;
> +	u64 eth_ovrwr		: 1;
> +	u64 pkt_output		: 2;
> +	u64 pkt_format		: 1;
> +	u64 defrag_opt		: 2;
> +	u64 x2p_dst		: 1;
> +	u64 ctx_push_size	: 7;
> +	u64 rsvd_w0_55		: 1;
> +	u64 ctx_hdr_size	: 2;
> +	u64 aop_valid		: 1;
> +	u64 rsvd_w0_59		: 1;
> +	u64 ctx_size		: 4;
> +
> +	u64 rsvd_w1_31_0	: 32; /* W1 */
> +	u64 cookie		: 32;
> +
> +	u64 sa_valid		: 1; /* W2 Control Word */
> +	u64 sa_dir		: 1;
> +	u64 rsvd_w2_2_3		: 2;
> +	u64 ipsec_mode		: 1;
> +	u64 ipsec_protocol	: 1;
> +	u64 aes_key_len		: 2;
> +	u64 enc_type		: 3;
> +	u64 life_unit		: 1;
> +	u64 auth_type		: 4;
> +	u64 encap_type		: 2;
> +	u64 et_ovrwr_ddr_en	: 1;
> +	u64 esn_en		: 1;
> +	u64 tport_l4_incr_csum	: 1;
> +	u64 iphdr_verify	: 2;
> +	u64 udp_ports_verify	: 1;
> +	u64 l2_l3_hdr_on_error	: 1;
> +	u64 rsvd_w25_31		: 7;
> +	u64 spi			: 32;

As I understand it, this driver is only intended to run on arm64 systems.
While it is also possible, with COMPILE_TEST test, to compile the driver
on for 64-bit systems.

So, given the first point above, this may be moot. But the above
assumes that the byte order of the host is the same as the device.
Or perhaps more to the point, it has been written for a little-endian
host and the device is expecting the data in that byte order.

But u64 is supposed to represent host byte order.  And, in my understanding
of things, this is the kind of problem that FIELD_PREP and FIELD_GET are
intended to avoid, when combined on endian-specific integer types (in this
case __le64 seems appropriate).

I do hesitate in bringing this up, as the above very likely works on
all systems on which this code is intended to run. But I do so
because it is not correct on all systems for which this code can be
compiled. And thus seems somehow misleading.

> +
> +	u64 w3;			/* W3 */
> +
> +	u8 cipher_key[32];	/* W4 - W7 */
> +	u32 rsvd_w8_0_31;	/* W8 : IV */
> +	u32 iv_gcm_salt;
> +	u64 rsvd_w9;		/* W9 */
> +	u64 rsvd_w10;		/* W10 : UDP Encap */
> +	u32 dest_ipaddr;	/* W11 - Tunnel mode: outer src and dest ipaddr */
> +	u32 src_ipaddr;
> +	u64 rsvd_w12_w30[19];	/* W12 - W30 */
> +
> +	u64 ar_base;		/* W31 */
> +	u64 ar_valid_mask;	/* W32 */
> +	u64 hard_sa_life;	/* W33 */
> +	u64 soft_sa_life;	/* W34 */
> +	u64 mib_octs;		/* W35 */
> +	u64 mib_pkts;		/* W36 */
> +	u64 ar_winbits;		/* W37 */
> +
> +	u64 rsvd_w38_w100[63];
> +};
> +
>  /* CPT instruction parameter-1 */
>  #define CN10K_IPSEC_INST_PARAM1_DIS_L4_CSUM		0x1
>  #define CN10K_IPSEC_INST_PARAM1_DIS_L3_CSUM		0x2
