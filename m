Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A630A43C7C2;
	Thu, 15 Oct 2026 19:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792093880; cv=none; b=McZ8U4C33jHO+R3sIr6u0Ue7Q1FNcT0NbG/PfnyofdeSupzHDdfgkGpx5B/5hgMqkOUUFQ416ZH4HK67eCOSgBGOmNNmENFwmboDuXx8CsWa0mCMAJaXfE3xdCSA1qp/LzWR4q7uQmjXQ2Gc6cAwLkoFWVH5c4sCaxa89qehoBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792093880; c=relaxed/simple;
	bh=ga6JYYLzzscZKA6V9O1XfWF5Uf0DD39/Nn3cQ8QDo/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KkmelGwybMyiPyE0pdsJipQZQEvG21LXSoO7Zf+6c1vqgcOTeA6PX2qM/93vfUnEFaqxxuTbYLauS3OMf8ld2TWdZPbFKNYfJ1CMRGMFq1qPlwtEuTLLEjltEUmhI6adipSVWOlt8ZOiKKcTbQtwbWzIwrKZuyeMxnoOD/XNY0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FAfpDwii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FAfpDwii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBD61F000C4;
	Thu, 15 Oct 2026 19:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792093879;
	bh=jIGO386Z+1/YyIE6BOFStksGPSpSiXsQ9RgmeE/zm1Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FAfpDwiimyOYzZ5JcENHIs5Vi+2y6MQ9waCDCqjQ5+IsJfkUSeldpuMERPh/ju+9C
	 AmLFsYRx4ss/RQjY/bWbRusizOO22JZJyVNL7y9OrfXKArSLmo2eEK9R+IRfaM4DuI
	 zy/7m5tTu5LXC9BM3BCyuvZ5W7IcKf7K9Pg6mLifvUxZHSedzm26VdWYvbvixTcnuf
	 rwr/4AsRtD7ujDYGbxhGrNTq8Gp9V5d5z3AjS+c4MEV2RnQ8EhPHaqIMi6lzgKjf2l
	 mCnpem+7WCa6NI6q4/DEoE/J0Ed0EUSU/S5PHY14wTr8pGPA7si/H/ns0p1C0yzx1i
	 9bUpKICgHIs3g==
Date: Thu, 15 Oct 2026 19:51:17 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Frank.Li@oss.nxp.com
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	Anatolij Gustschin <agust@denx.de>,
	Saeed Bishara <saeed@marvell.com>,
	Rameshwar Prasad Sahu <rsahu@apm.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Anup Patel <anup.patel@broadcom.com>, Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH RFC 0/4] async_tx/md: Remove async_tx framework
Message-ID: <20261015195117.GI2170687@google.com>
References: <20261015-asycn_tx_remove-v1-0-056a7085e0a1@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-asycn_tx_remove-v1-0-056a7085e0a1@nxp.com>

On Thu, Oct 15, 2026 at 03:22:24PM -0400, Frank.Li@oss.nxp.com wrote:
> This RFC is collecting more feedbacks to device when is good time to remove
> whole async_tx framework and how to remove it safely. And is overall
> direction correction.
> 
> Little to no real hardware acceleration usage:
>   Most systems run RAID5/6 parity calculations on the CPU using optimized
>   XOR/PQ implementations, while DMAEngine-backed async_tx acceleration is
>   rarely present or exercised.
> 
> Added abstraction and maintenance cost:
>   async_tx introduces an extra layer between MD RAID and parity operations,
>   making the code harder to understand, debug, and maintain.
> 
> Modern CPUs outperform DMA offload:
>   SIMD implementations (SSE/AVX/NEON and architecture-specific RAID
>   routines) often provide better performance than DMA descriptor setup and
>   completion handling overhead.
> 
> Obsolete hardware dependencies:
>   Many async_tx acceleration backends were designed for older DMA/XOR
>   engines that are no longer common in contemporary systems.
> 
> Complex asynchronous execution model:
>   Dependency chains, callback handling, and DMA transaction management
>   increase code complexity without corresponding performance benefits on
>   typical deployments.Simplifies RAID code paths: Removing async_tx allows
>   direct use of synchronous XOR/PQ helpers, reducing indirection in raid5.c
>   source code [linux/drivers/md/raid5.c].
> 
> Reduces testing burden:
>   Eliminates rarely used code paths that are difficult to validate and more
>   likely to accumulate latent bugs.
> 
> Aligns implementation with actual usage:
>   The vast majority of MD RAID deployments already rely on software parity
>   generation rather than DMA offload.
[..]
>  17 files changed, 281 insertions(+), 2843 deletions(-)

I haven't been paying much attention to the crypto/async_tx/ directory,
but this makes sense to me.  This mirrors similar trends that we've seen
with the crypto and CRC algorithms.  For these types of algorithms, just
using the CPU is faster and much simpler than trying to offload the
operation to some external hardware engine (which rarely even exist).

- Eric
