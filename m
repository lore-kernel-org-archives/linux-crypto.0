Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575047;
	b=Ptw36B0eStupV0dnpUpgmtJc9e4pj0T7hNUPacZp1W1aRg7AVACyCyK3p6ifm8LV6/gC
	 HwA3o+tn9YMFwnbqm0LYLW09fYHGDVfqiclYEySdfj5ecfwvNKAjssoGIXxNUjlKuoDTn
	 oxbOzSkOx3NS8/SsDI4/nW8334ZYNz8NGJpzo26CNChCIiRYxgBONoWM6rQUbH0cLRLGK
	 L5LaqsHpb7uknT0BGC4lJVWeeDTr/rc94xtXafyJVyOBlW+lrPH+6NoCUdiH4cT0eFLT4
	 TrZEjM+HaCM3qBYvQ1z6Nr5pRFnciwIqzM0MJpvc940NGnM4bBTmavFhb7q/EM20BAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575047;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=HqTuUMXfM22ySYhQPGjeWLFpYJZoIXrpBRITb/aVutg=;
	b=v9N709OuN1Qi78SvaAeWAbgoaPeeIpIsx60xmWHWpl/EsOnhZJfKEeAwgvedQ7W30upf
	 K9FgIU6hTzVu1lP0tkiGSC/YuV/sJcUy2ioQ0ZevnXlQ9V3yFNZQVY8uHltpmjkvq5QOo
	 j4p38i2RhFrTBfI7H/3UT6PjfHULYtet0kFWi5pICg2ksB3eBEPdRAfgKnu8wyqzXAKVx
	 sJWPVBlHfLsmc8Qn2p0qIHuA0OM8om7Lsv3gcOPlV4xMUuEA2d81XzZKq6VZ54A6bqsr4
	 0Q1HnzeEEnBG6v9Ny9VAkQxCzDEm+GisEaosfxC1UIVlo8XLA0wbh/TKUqzCR1I7TBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=oSaGoiFO;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ED8606A327;
	Fri, 13 Nov 2026 13:04:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46ED8606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=oSaGoiFO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=HqTuUMXfM22ySYhQPGjeWLFpYJZoIXrpBRITb/aVutg=; 
	b=oSaGoiFOdjh0rfYr65GZKf3juj7y7Mmj+eDclXhQ+3MngLaduAamh1ryN0xXowbAU6BkkYuPOsM
	llhb8CP/yOBB/KCpcdzSLhos9sH8thV1kTr3DMVyqyUTXA864m+Ki/KRffvtM7l1+Rlp/bMYEJmfF
	RCorlpclBc5J6Ez9CJFZOadkUTAiYkv4pebTfHnnN01VLB+6Ga9kyLeD7lsXaf9lu8m2X2hCRDmm5
	nEedynDzkXDcwrg9yFpUJ98XTvWpB2OQ0KTQu5qxZ88dQjljthv07Y1F3n6wLE0YAx69jfye+NvFE
	SDBvFndpdIucLkZfIwtKjSl5wKOhpcQf43RQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRqwf-0000000EfCh-2DZ2;
	Fri, 13 Nov 2026 21:03:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:03:57 +0800
Date: Fri, 13 Nov 2026 21:03:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gu Bowen <gubowen5@huawei.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	lujialin4@huawei.com
Subject: Re: [PATCH -next] crypto: asymmetric_keys: verify_pefile: fix
 integer underflow in pefile_strip_sig_wrapper
Message-ID: <avcKvXmCOXYwJM5D@gondor.apana.org.au>
References: <20261102074934.2925339-1-gubowen5@huawei.com>
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
In-Reply-To: <20261102074934.2925339-1-gubowen5@huawei.com>

On Mon, Nov 02, 2026 at 03:49:34PM +0800, Gu Bowen wrote:
> The pefile_strip_sig_wrapper() function validates the win_certificate
> wrapper that precedes the PKCS#7 signature in a PE binary.  It checks
> that the wrapper length does not exceed the certificate table size
> (``wrapper.length > ctx->sig_len``) but fails to verify that the
> wrapper length is at least ``sizeof(struct win_certificate)`` (8 bytes).
> 
> When a crafted PE image supplies a wrapper with ``length`` in the range
> [1, 7], the subsequent arithmetic::
> 
>     ctx->sig_len = wrapper.length;      /* e.g. 1 */
>     ctx->sig_offset += sizeof(wrapper);
>     ctx->sig_len -= sizeof(wrapper);    /* 1 - 8 = 0xFFFFFFF9 (unsigned) */
> 
> underflows the unsigned ``ctx->sig_len`` to a value near UINT_MAX.  The
> following ``sig_len < 4`` sanity check is bypassed because 0xFFFFFFF9 is
> greater than 4.
> 
> The underflowed ``sig_len`` is then passed to verify_pkcs7_signature()
> and onwards to asn1_ber_decoder().  The ASN.1 decoder's own
> ``datalen > 65535`` entry guard can be satisfied by constructing a
> PKCS#7 length field of exactly 65535 (e.g. ``30 82 ff fb``), allowing
> the decoder to proceed and attempt to read OID octets beyond the
> allocated vmalloc buffer, triggering a page fault in look_up_OID()::
> 
>   BUG: unable to handle page fault for address: ffffd1e986cb2000
>   #PF: supervisor read access in kernel mode
>   RIP: 0010:look_up_OID+0x14/0x100
>   Call Trace:
>    pkcs7_note_OID+0x33/0xa0
>    asn1_ber_decoder+0x363/0xbd0
>    pkcs7_parse_message+0xd9/0x1b0
>    verify_pkcs7_signature+0x24/0x80
>    verify_pefile_signature+0x7b/0xf0
>    kexec_kernel_verify_pe_sig+0x1b/0x40
>    kimage_file_alloc_init+0x1d8/0x3f0
>    __se_sys_kexec_file_load+0xc6/0x270
> 
> This is reachable through the kexec_file_load syscall on architectures
> that verify PE signatures (x86 bzImage with
> CONFIG_KEXEC_BZIMAGE_VERIFY_SIG, arm64 Image with
> CONFIG_KEXEC_IMAGE_VERIFY_SIG), requiring CAP_SYS_BOOT.
> 
> The oops occurs while the caller holds kexec_lock; if the faulting task
> is killed, the lock is never released, leaving all subsequent kexec and
> kdump operations permanently returning -EBUSY until reboot.
> 
> Add a lower-bound check on wrapper.length before the subtraction to
> prevent the underflow.
> 
> Fixes: 09dacbbda935 ("pefile: Strip the wrapper off of the cert data block")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gu Bowen <gubowen5@huawei.com>
> ---
>  crypto/asymmetric_keys/verify_pefile.c | 5 +++++
>  1 file changed, 5 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
