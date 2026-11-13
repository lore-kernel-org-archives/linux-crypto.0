Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573020;
	b=QvluYA/reCG2hXDfaF3Z13JldvJTDsgw9gUX81AW5K7MiQiDHw58nLgSxHU3hEBJGKK7
	 lLLdabg4dmzUgs6H3PPBPcv351JS0NXk+bsfL7j3L8YS4TQAmexvKKDjD/Iolw6F4bhV0
	 cOw6fJyjigc5sQz42TV95hN+bGy17Le+qiVian8lX1Sjr69GAWYy/TTToBJoWFJ+slDaH
	 crheNYIgzCVYENJRsCm6BpQC4zMli1TymPmS/SM58Abxl8nCVieLaMEkRkGBMaL01SMnM
	 s2u7hr6CKV24LmBuNR1HNWVhmTfpByiQtgPiirXHlxj/gqGcHKrYRG6J6iHHP0VjQUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573020;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=sN6f0kB6Dy66AvYIMnvswgiK6xBy/AvPZ/ZPqib1vDM=;
	b=LH17vzHgWpVq54XBhqPj/8HF38LvWQzewriBhb5WBm9iP47vnpglhKdt+UPffd4ZZ9z1
	 KCX+NOkJGjiedbixNy1JXTGM4qbM3ChsQTlSNABqUWtHr7ZTbJNnK0cr0gVhqZZsBInke
	 RZrwJGbVIa14huCN/nnz0zWLHOT5ssw5bwLVSJ7VfAV5gvLlPdGTNMGOj1n8Bn+J3mhzE
	 BDlc753oWE0eNZXp//985Tv4zGEoA4Yc3VAp3ZZBAz06HwAJGVp0RfGDkTILlX1VRa7vT
	 wz+mxOt/+/Aedsk+9KybdWys2sQ1PHPsfXdtrId5vAXEDkk+db3o70p5Q0o1JDh8JJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=NDyPvxL+;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9918606A323
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 12:30:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9918606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=NDyPvxL+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=sN6f0kB6Dy66AvYIMnvswgiK6xBy/AvPZ/ZPqib1vDM=; 
	b=NDyPvxL+gZtuKYOzvgF4yuvnCxWU5ZNixaSvwTPonSUV1bPvSTt3N0FHG8GXCL5zBLzYFUOvBfG
	R/n9ggh1ZBqgJXVARkNbvAjmos9A+BnR/A3P4R9XVxhXFDryzn4my1YvbP09RE8XFljgamDdxoaDy
	2pPle4SB04wFlibcGXXkk5GPQIR/NzSXAI8OLfkuKSGDe18dgdfHoLdiP9kiAim++pAbFv5uKdeXG
	xuJMpAvgnLrYa3dOiVKCgYv804FSWcVvN9WVcu4nOoLdTDfzqdzAGv0RLGuk0PKdqyHGg/jJ1/kCW
	mwK8PJYzhjgItOjNjpbudECgsbm/5fIhDX0g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRqPx-0000000EeTS-2GWT;
	Fri, 13 Nov 2026 20:30:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 20:30:09 +0800
Date: Fri, 13 Nov 2026 20:30:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - clear fw_loader pointer on adf_ae_init()
 failure
Message-ID: <avcC0bQVidfygn0B@gondor.apana.org.au>
References: <20261103100126.534424-1-ahsan.atta@intel.com>
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
In-Reply-To: <20261103100126.534424-1-ahsan.atta@intel.com>

On Tue, Nov 03, 2026 at 10:01:26AM +0000, Ahsan Atta wrote:
> adf_ae_init() stores the newly allocated loader data in
> accel_dev->fw_loader before calling qat_hal_init(), as the latter
> publishes the HAL handle through that pointer. If either
> qat_hal_init() or adf_ae_reset() fails, the error paths free the
> allocation but leave accel_dev->fw_loader pointing at freed memory,
> so the device is left holding a dangling pointer.
> 
> No code path dereferences that stale pointer today. This is therefore
> a robustness improvement with no observable failure behind it, hence
> no Fixes tag.
> 
> Clear accel_dev->fw_loader when the allocation is released, and fold
> the duplicated error handling into a cascading goto chain. Report the
> error returned by the callee rather than a generic -EFAULT;
> adf_dev_init() still maps any failure to -EFAULT, so this is a
> readability improvement and not a functional change.
> 
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  .../intel/qat/qat_common/adf_accel_engine.c   | 21 ++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)

This patch failed to apply for Sashiko, please rebase and
resubmit:

https://sashiko.dev/#/patchset/20261103100126.534424-1-ahsan.atta%40intel.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
