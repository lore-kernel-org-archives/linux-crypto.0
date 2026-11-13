Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575388;
	b=jJ1j28SraYF9SJVsmnXLPF0cxd0rnIEi0cW7fkkBXu6AljdVwn8B+mXemCTKR216CJyK
	 IfFj0yM5TyxAZti9KBYQJCLa4qRHGH+2bZqKGv9QJWHU6ZXY+eq/NpUKsmiksE3+C2xau
	 e/cdU8FC1hfcxHnAQJAHv511cm24LeIpl19S7tRD3aS+C+z7Vxf+47CrHan7vvW6DfO6o
	 s1bKbAdYl9GJSj0tBtIPerY5K1WD55UyOk4/0xMmVTRg97yX6v38rozZOkIKVhzKO/jom
	 2G92GLc42/48FTEawNdxFku6hcy6DH5foOuwpR1rigqSe6ZEZ/Pa+HwxKD2dU7tcbZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575388;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=S/eJTIJmvrNiEx5mEGDft3t/kgGJLjtcGS3SvVtRV1o=;
	b=V3lRWc6JNXCqZY//vqfDdCq6Z0mwcLLMLvCieP4luh8Us2muUgwvmx6rygUg5pSjHV+8
	 V9iqaJS6OsrRMS+2mEMOahPmpXohaE8VBVlWVDuqXVEUrSXLnMhJ/QohJWUn4B0PmhBe4
	 XrA9Uu2CFR+smlVj0dMZtA5b20kDTawul+p1ilO4Df6J6xSgGqaY6rO2jyMuohRs+fpyA
	 /5QfDcHX5zX8veSRpXMI40EBOanGIrXWiMCbU7qmAB27bMeSadTkdstGt4guxiUJWzVCO
	 VcntN/Nf7Ft7iAzmb/Yqa22vm2Jh54C854vEeOMUF4/aAbOg/5VbOwYsNsz2/du735g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=Exr1OsW8;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531DB606A327
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 13:09:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 531DB606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=Exr1OsW8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=S/eJTIJmvrNiEx5mEGDft3t/kgGJLjtcGS3SvVtRV1o=; 
	b=Exr1OsW88fxnPLPp8afPIGRwycxmcu7uFBrcRWzVsBGrpLtZdZOKKzKG3Lc/Eg5C+nbZAL8qr3o
	7yVzzdaXXHiXkDbU6iqsEu3KXlj2Zws+2FlJQlZpBYgi5alZvxR0d/GEIMY6qV62DadOf+q+85Lv8
	tsAM9+OHDpzs2Ai3CvuK/omJi1CVuRJNPif/5hzS5kgd9nonX75rFgVrNHfQOX6K/kWoUzlVdPvac
	BtCrBXDE/TYAqzJyJK2K9ThEcHcOZzDaqi4PQ0Hbp0WaQWISgYJf3+Z3DwnWNZ8EYrSdjgzgyPQME
	zfVHa7T0hLyUNiJT5Ofv5eDONKh3aNtV30zA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRr2G-0000000EfNi-2W11;
	Fri, 13 Nov 2026 21:09:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:09:44 +0800
Date: Fri, 13 Nov 2026 21:09:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - avoid double free of authentication
 descriptor
Message-ID: <avcMGHZA8PYoQvBi@gondor.apana.org.au>
References: <20261104102345.543725-1-ahsan.atta@intel.com>
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
In-Reply-To: <20261104102345.543725-1-ahsan.atta@intel.com>

On Wed, Nov 04, 2026 at 10:23:45AM +0000, Ahsan Atta wrote:
> From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
> 
> qat_uclo_wr_suof_img() reuses a single struct icp_qat_fw_auth_desc
> pointer across all signed images. At the end of every loop iteration
> qat_uclo_ummap_auth_fw() releases the DMA buffer backing the
> descriptor, but leaves the caller's pointer untouched.
> 
> If qat_uclo_map_auth_fw() then fails for a subsequent image before it
> assigns a new descriptor, for example when qat_uclo_simg_alloc()
> cannot allocate the DMA region, the error path jumps to wr_err and
> calls qat_uclo_ummap_auth_fw() again on the stale pointer. This reads
> chunk_bus_addr and chunk_size from already freed coherent memory and
> passes them to dma_free_coherent(), resulting in a use-after-free and
> a double free.
> 
> Clear the descriptor pointer in qat_uclo_ummap_auth_fw() after the
> buffer is released so that it is unmapped at most once.
> 
> Fixes: b0272276d903 ("crypto: qat - add support for new devices to FW loader")
> Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/qat_uclo.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
