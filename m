Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490840;
	b=j8NOmX9YfS5THrjqhvVUkqRZ67Rypb4NsrkmzzZGP2Q2fync4UusDHh8ZU7fNGxEVPZ/
	 FzOOat05Q+dXF70ilr4wCpjTZY+UeHsCpEUcsmnTH8e9wKQUM4txIy/BmaVJb2LtDr6PV
	 zoWT4ZMsIdcAmIV73PCkVH5+4k17HQjbnuufvv7oIX3WLrLuJEvaKrY5mQ5NvQbzELyt1
	 ZWyepE8yaho+tUQKCR011PYcb6pFWZ+iuq9dz0vxDKV+y9UZaPei9jn7PjMgHAHAOvgSs
	 8MQnN5nKCkhdOumXxA61APsCXFzmidYBObXS+U6Q0gfgnxBGxfCU1C7RU83IaGrGqPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490840;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=cG6WrmDsAfWc3D53X0L0967DMbbo3VT/YtZuqmz5IhQ=;
	b=LnKjKw8miR5sfU7YPn8oGT4JCCKpsE04m3AwGmLP/j3SgIS4gdyY4TfnuTzmWavrqQ7f
	 5LfN9W4d7VW77JAJtxIc71+fCIM2YrqWF93fAHq3YvL6/XQz/TQOxkY5XQTvOJUCCdP61
	 DP7IQG6/so6d224X+WiQi6i561Xtwhxc8Zz9ZKSYplp4hx1ds2a0ZWH2/JjAJRqpk8v04
	 mLsOa4rH5AA42Fi//heuYHLWk0VTwPst/aIGKEswR5jLCmKaUI9CV91tCnuKdvUJdEb0O
	 wmYIMsFk8rJe41LPy/0fzT5GSt0hCu9nFNvqxb9diDyp1WrOXCYDO7kMMcd506Wy1MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18594606A31C;
	Thu, 12 Nov 2026 13:40:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18594606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BF9356732A; Thu, 12 Nov 2026 14:40:36 +0100 (CET)
Date: Thu, 12 Nov 2026 14:40:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: akpm@linux-foundation.org, linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	Christoph Hellwig <hch@lst.de>, Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/3] lib/raid: opt out of initializing MXCSR and 387
 state
Message-ID: <20261112134036.GA23216@lst.de>
References: <20261111205604.47547-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111205604.47547-1-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 11, 2026 at 12:56:01PM -0800, Eric Biggers wrote:
> This series slightly reduces the overhead of the x86 kernel-mode "FPU"
> sections in the RAID code by using kernel_fpu_begin_mask(0) instead of
> kernel_fpu_begin(), thus opting out of the 'ldmxcsr' (and on 32-bit
> kernels, also 'fninit').  MXCSR is irrelevant for integer code.

Maybe we really want a kernel_avx_{begin,end} after all :)

I'd still prefer that, but in the meantime the change looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

