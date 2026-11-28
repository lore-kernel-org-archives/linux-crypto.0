Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795859336;
	b=znCjLSjlBR5gF01hI/AL7v+ZgzhudzWeHXpJd1FNmzmtu7tgNhdk3lVxin1iSMQVDqWB
	 Ni/QQSEj9L9ryk+LfelDuo474jetwv/Bf9a3FDCjCBDGsYk6Bd564YRz9UuBTW39Vp2bh
	 A8tb4nTAQ7v1sc97aOpidmjExPShZzwv/2AQ8fi0qBvxfvfOOlghHS3ovY3cFoBOH90BB
	 wkfFkk+38cbvkoJwjepDSXXQ1D7a4cgyb6wZ1W+1+z2zLRxvI4cHNjG5vbg6gEP8boA3W
	 +FuXka50vpY6h+/x5+Qk0cb904KXcQo6ZP6ZwJHq3PjUr+vg0wDAwGUDt+1vOZjfpMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795859336;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=kwCXlj0O7wF/Vu7xBGU3ix1LJM0P2CZ8A385uhG/EHY=;
	b=4RzmSO/rXbXYbpQh++/0yCD1qOdRBK/v42/VORxazmmaqbQJREOqUEdZyyQOQif3ghh0
	 fzTuO8a9utcNsnO2olGplsJ789JIVaadBpOL6LAEey2YnH4Fw+AL00gTWGwBHfeV9DCkb
	 hRLT9rnBRHyAS8IrQq+KuyIJqqnHKWZrjpIyJzJIUcIjVk9jNOy1AxpUsUD997+Lm+Xuw
	 HxCC2+oMcsVb0zY25kl0O3FYk7PWAqeVPsb/V8hy8Xj+1JI74vq0Psx9kGI9BMfBoOsmw
	 VrUZJshpF2yFi9GHtpyVVclu7r3MGxjEhWAswGTiODPbfvx8WDN9DCeXUopHsPz1c6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SVBchSUe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABCD606A324
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 09:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SVBchSUe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2841F00897;
	Sat, 28 Nov 2026 09:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795859335;
	bh=kwCXlj0O7wF/Vu7xBGU3ix1LJM0P2CZ8A385uhG/EHY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=SVBchSUeMcq+EkD7kTgx7gchb4cp4AjT7c36fF4JKhC/rwbyPN4t2TykiXa7JAqQH
	 W5c0PKI56i2WA8+TjNgCgXLhuVPzzNlu+CJ6iHLOovAoJ0BqKSqyUdW5idVtqBrlgC
	 YihlOsl97iFFuwGyFPId5QAhaLMLspSfJFI+f1m2YkT7xyAKLkhnCwXj/etyR4BlvK
	 CCe39qYmqlr1yIBTGX54gCGRSAKAnio95sqIVnMQ19AEhGG5GxW4ZkEDhqMQg6jog3
	 S7RMVRAxF5dsWp3mTecv2I/9lIcFCi4ykp/1CRbyK7xSC9q2HGTNJP6uCMIdZEXcRo
	 n9oyaf5qKDf1A==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9437F198003A;
	Sat, 28 Nov 2026 04:48:53 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Sat, 28 Nov 2026 04:48:53 -0500
X-ME-Sender: <xms:hKMKa1TmxtwQrLZ7fIEAsh8o9rYk5DLPxg3B1D6IHV07pqpWu-6CRQ>
    <xme:hKMKa5ldnrxo4kdsqogA16575oC7Bg-v124wS8biq3OTTnNPpBTgWeeCHgirp6sy_
    YPez6lM1WKc3rNHP3UjNc7RRZEpujUgeJTOyfo7_LsRxpVYFTYv27_u>
X-ME-Proxy-Cause: dmFkZTF3ZbDitUQiVEwu86MC6N4j1CXoew+gs5gWl1+kXqRAq4zxGpFAnSI8t6ctFPqbI9
    U4oJc19uQ7Q705dNewUNsgOXCV8K9b8SwniEMuQWnjmz4/1Ak6gPU8ufCE3+PlUxT1YNrd
    aYoyGybwp+sYUW9pma+n1uOrrE/z1hkv0jqJ8B5GAUu7kV+a/+TS5HqPFRoP8FCYnWYtFW
    WJ9YZrmuhrNqaGmMzAoVfsZ5SnYlEzfgJj9SKvX9hm7ljgWvasttqSOTNL5/LaDb+0dlGe
    x5WOGmVPZoRQVnVLpDwB9s926C45HFS8fKe7wW82Nw98qtOwvOKZutgFDsz4HOmYAHNTqw
    mIj/Pv6xT/Hbo225ZSVOEgWDK7AVLb0lSyoYChB9aa70hH8C2MNuq+HVlXvSiwtty0HQ+T
    qjTVYWwPUYYDxASxOJZiOlsfvxjJq+C7uAHeWlgx8bMzBdI7Dc4SqYM9vejq7T9bPnWJYB
    undeQU4NourzlAuxukqHhAnnMGfoC6W1vIjKP3Q0e6Kj3u2Hi1GfMsm6FdCjehZVrMnFKP
    7p1s04YhRJ8/fd1PbuuzskjvYBbWqRvFJzr0UpGOD2iXkpYuQLRCPD04tOBxnZdGKY7b3Z
    PsK1QSfOOSRncymL/MJTUD1lEIr1c3EIftoY+C4wtwHk3/mfxwGEKiadwuiw
X-ME-Proxy: <xmx:haMKa77Y6yckPqMoYfB9uzAZQ1tqz1YZRX34eMGJaGCdV5q1THWu6g>
    <xmx:haMKa-sKblDIT0QvBGVO_Tr7xFoXBUHLbRVs4eREoc0vElKuB0O-GQ>
    <xmx:haMKa879jqQ67-HTbdtEh-KYpITIiW2hZ_ny8Fvcfd4EIFwAC1R3MQ>
    <xmx:haMKa5VyZ3UhvUKFZSaSvV097ErJeQY9b_owS0JxtkX-A4n5Q-eOPA>
    <xmx:haMKa--6RE3WoHDrl4FWkJqm5MxTT76Ej1UhyAATP84gOYs0L3kqn8fT>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 58EA4F80093; Sat, 28 Nov 2026 04:48:52 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Sat, 28 Nov 2026 10:48:11 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Shreesh Adiga" <16567adigashreesh@gmail.com>,
 "Eric Biggers" <ebiggers@kernel.org>, "Demian Shulhan" <demyansh@gmail.com>
Cc: linux-crypto@vger.kernel.org
Message-Id: <0a8bfbb3-f9d8-4de9-b134-ee562548aece@app.fastmail.com>
In-Reply-To: <20261127165747.512950-1-16567adigashreesh@gmail.com>
References: <20261127165747.512950-1-16567adigashreesh@gmail.com>
Subject: Re: [PATCH v3] lib/crc: arm64: Add NEON PMULL+EOR3 crc64_nvme implementation
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 27 Nov 2026, at 17:57, Shreesh Adiga wrote:
> Add a crc64_nvme implementation which benefits ARMv8.2 and
> later processors with the SHA3 extension.
>
> Usage of EOR3 from SHA3 extension improves performance by 20% compared
> to the regular PMULL without EOR3 on Cortex-X925 measured in userspace
> benchmark for 512 byte input size.
>
> Move the existing PMULL implementation into a __always_inline function
> and instantiate it twice with a boolean parameter which controls when
> EOR3 is used. This is only enabled for AArch64 since the SHA3 extension
> is not available in AArch32.
>
> Use static_branch mechanism for dispatch in arm64 and enable the EOR3
> variant when the CPU is determined to be not slower due to EOR3 and
> PMULL sharing pipeline stage. Currently Neoverse N2 is placed on the
> list to disable EOR3 based on Software Optimization Guide mentioning the
> pipeline V0 being used by both PMULL and EOR3 and V used by EOR.
>
> Tested on KUnit for correctness on both AArch32 and AArch64.
>
> Signed-off-by: Shreesh Adiga <16567adigashreesh@gmail.com>
> ---
> Changes in v3:
>  Avoid running EOR3 routine on Neoverse N2.

Ugh I don't like this at all.

Obviously, the h/w designers did not understand very well that EOR3
has much wider use beyond SHA-3.

...
> @@ -29,6 +36,21 @@ static inline u64 crc64_nvme_arch(u64 crc, const u8 
> *p, size_t len)
>  #define crc64_mod_init_arch crc64_mod_init_arch
>  static void crc64_mod_init_arch(void)
>  {
> -	if (cpu_have_named_feature(PMULL))
> +	/*
> +	 * On Neoverse N2, EOR3 can only issue on V0 pipeline, which PMULL
> +	 * also uses, so the EOR3 variant has lower throughput than plain EOR
> +	 * as per documentation in Arm Neoverse N2 Software Optimization 
> Guide.
> +	 */
> +	static const struct midr_range eor3_slow_cpus[] = {
> +		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
> +		{}
> +	};
> +
> +	if (cpu_have_named_feature(PMULL)) {
>  		static_branch_enable(&have_pmull);
> +
> +		if (cpu_have_named_feature(SHA3) &&
> +		    !is_midr_in_range_list(eor3_slow_cpus))
> +			static_branch_enable(&have_eor3);

Does this check the MIDR of the CPU that happens to be loading the module?


