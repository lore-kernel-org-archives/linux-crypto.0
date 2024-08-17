Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF2683CC8;
	Sat, 17 Aug 2024 07:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723878515; cv=none; b=RtMyjWP/vkQUsKCmHbj+1Kwy/1CI7iIx6bsoJLGA6xwlCEOA9vRurHG7anafNY0c4F3A6rTSqR3QUxKpHGyoUEo0+cY2eC1E/69sdxsJvCyN4fjx/zKujYy02G+9iYm+CjPMQk+0VZO7cPGLPDuWzetlnhHyMdHFpDkY5jKj8+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723878515; c=relaxed/simple;
	bh=p1TrJqnF6zBrjyF5BTD0cSL0hEmAVbn1rmjfhlXSPb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fo3npFC4P02rxDnZl2vTn8blnOxc6ESvQxMchda9DuPwlIoFMHYnUymbfV2p+ElumhhibpXxqI3Iod7o+L55Xow9EaIPK51UQsrzb1gDfKB3/MS0TlOZF1Fm8rbAY5RMixT7gJPOI8JtCYQ5er/lkIo9Z34o02Dv+pm1vLSJi8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sfDPZ-005IK4-0R;
	Sat, 17 Aug 2024 15:08:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Aug 2024 15:08:26 +0800
Date: Sat, 17 Aug 2024 15:08:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] crypto: qat - Use static_assert() to check struct
 sizes
Message-ID: <ZsBMajBTjPKy__9S@gondor.apana.org.au>
References: <ZrVBJqdL1q3X3Dg/@cute>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrVBJqdL1q3X3Dg/@cute>

On Thu, Aug 08, 2024 at 04:05:26PM -0600, Gustavo A. R. Silva wrote:
> Commit 140e4c85d540 ("crypto: qat - Avoid -Wflex-array-member-not-at-end
> warnings") introduced tagged `struct qat_alg_buf_list_hdr`. We want to
> ensure that when new members need to be added to the flexible structure,
> they are always included within this tagged struct.
> 
> So, we use `static_assert()` to ensure that the memory layout for
> both the flexible structure and the tagged struct is the same after
> any changes.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/crypto/intel/qat/qat_common/qat_bl.h | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
