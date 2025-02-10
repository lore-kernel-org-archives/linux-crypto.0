Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854861F463C;
	Mon, 10 Feb 2025 18:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739210479; cv=none; b=lZoGQ/TKhT//kvKTCYfZMgxpZbRZeQmmz0Y7QnsuW9ScbFV0e5BMlx/CIPyXUYUyaTsN7eKYfEWUC1F1Pc2ayXtwJ0AOQYC/lP8VfSGBTr01MMa+sm8Lw4ISCPtAwN0S+HN/c77wI4b187SJ1xf0e0r+ZFKQLWdxvNA15QI/drc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739210479; c=relaxed/simple;
	bh=KjTtyrQ6PlZ9M7KRaLHXr40wP8R/TN2mlcE3YgJ21fE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jL/R8rMQIO164y4x3BYmegavq8MdZ8r5rcHUkynaQF71q/IL4YRxj8E0xZ0zUpgxc18nvSUOuXAiXMgZsFDhfEZTbKRaGzvOvZXsJzI0JdsB2NhQIdIrqbJEJUbPUYPdZqu5rgu2AXF0wJN64FFksJSvtHqQN04GKIH519sCCK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JWOF1hrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JWOF1hrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1542C4CED1;
	Mon, 10 Feb 2025 18:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739210479;
	bh=KjTtyrQ6PlZ9M7KRaLHXr40wP8R/TN2mlcE3YgJ21fE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JWOF1hrP17DAcLqMFntcOd/4JfJqQMkcisGGgOPyewq+pNERmxh4naTI2Qy67VwCc
	 acyGELt2CoiUom/XA9mmLhgBW7UbvIEerEIglDkmlVpttieWb3SJqvofl3v4bmlHXs
	 Fg20Jav/aivQZ/HGLa9+kpaA+eOl4Vzpc0ZDDR3IR1IAIryfeG62JqXhWkpk3X5HLH
	 9HTd+R/LEe0/2IjJbRZlw5YGH3HziCNs1rfZbz5AGGNlHuJliG36IkBzdsu6QjzlLJ
	 ze9Xqo9VsELcKE7QSB77SaqEPNDbx24NN/H/Rf+UVJyOoz6IgcMcwQWexWgR67Qqpe
	 n27bO73XittnA==
Date: Mon, 10 Feb 2025 10:01:17 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-block@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 0/6] x86 CRC optimizations
Message-ID: <20250210180117.GF1264@sol.localdomain>
References: <20250210174540.161705-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210174540.161705-1-ebiggers@kernel.org>

On Mon, Feb 10, 2025 at 09:45:34AM -0800, Eric Biggers wrote:
> This patchset applies to the crc tree and is also available at:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crc-x86-v4
> 
> This series replaces the existing x86 PCLMULQDQ optimized CRC code with
> new code that is shared among the different CRC variants and also adds
> VPCLMULQDQ support, greatly improving performance on recent CPUs.  The
> last patch wires up the same optimization to crc64_be() and crc64_nvme()
> (a.k.a. the old "crc64_rocksoft") which previously were unoptimized,
> improving the performance of those CRC functions by as much as 100x.
> crc64_be is used by bcachefs, and crc64_nvme is used by blk-integrity.
> 

FYI, I've applied this to crc-next.

- Eric
