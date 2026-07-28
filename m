Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877982BEC43;
	Tue, 28 Jul 2026 03:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785207939; cv=none; b=uW2qGyyimOXnvT0LA+ayekEHBGbPYyfZ112qTMUd1uPxKQF5AOgWWwUrY27dNXDrEQ7hapBiG155SbN3FzRG0gomrluio4JkaQPLFLoq4vUUJEWhK0TQnarNfygqPjWvHNtgtKGEUrmNoDHw1Ww3EwgxIH4F5skhWsbzr3p4gdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785207939; c=relaxed/simple;
	bh=O4bUHubmAwEd5MDNybLhtW6/9jOeTADPKepVDnG6a5A=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=qj0ejqMbn0uEe1N3CVwPjryXNHJWHnXRUy0b8izCeqriQ1pZ8gFjtMRsupdueyjaFrONZtDCAkUilAuEsOXHgwBEQZSSLGfU7zJUvmfHq8J7xEimF4EsaA7yaAUc9S0c9U1vlZPc/VAHLvP3TjJkr/AomkgR0MQfbjPP3j42Gz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=CmafMry4; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="CmafMry4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1785207924; bh=YnRcQ7cU8pyEx4dSK7zQyOxb8Aouz8WcbrMEasQibXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CmafMry4/quM8POgF1S8qbIgpjsStTg+sB3Ex+JNmf1Yj5ieK768LVB1ZU3OgzUUC
	 aNN7b2jc7DDrhCFT+Ii3IvRrO9HACst/w6cR8xcWFklg4XaD1PtaBJQvXwB9dSBrSz
	 DkeGMwUPeiyXhl9gYLKrVgwOxh3Xqr7/kEDdX5JM=
Received: from LAPTOP-ALARVMHL.localdomain ([139.159.170.90])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 153874BC; Tue, 28 Jul 2026 11:05:19 +0800
X-QQ-mid: xmsmtpt1785207919tqwwl33xx
Message-ID: <tencent_381E310D1F05DE327C2607824BFCDCFA1806@qq.com>
X-QQ-XMAILINFO: Mk/FYBttBrlYNA9keDMRg3/WnxvXyxOMjRyQYpTXHGGjQFaXQUM/qqXvz/eLQ4
	 lcATL5YY9qfmmiBa7vxq30P94tTsVbk7E5sw1yWdq63BeSE28tLss4GAV9I0o1Nb+MTLPN6qx7Ka
	 aRTDsl9cQQfp45SJm3R6u6wAZFWNDQqyYZVOoExaatSphL+AubeMCj819nVS1fq6UTvWB6pL0Oc8
	 q6BXygcby7jjUVGt31nclcwZxXxIj95dPrHetnnfOVQwOpkRpus4T5Bm9Ptr8IqMKThTZBbAvf/U
	 XQYn/uHfNe2+fEyvP/78R2w0xLX82lL+ELxAqxeVx0NCBR91+OljluwaYKNLzv3ycpN1u3iyw4xx
	 W57S/jVreNkKEiun5QXt7lfJm67e3hRJOUSCe5LHeoy9eqYZ/jJ7UcfJD+vbmH9mWcU418/LIJ17
	 zmLtiu3PxR0DgELlXjou52XVIB/w1tuBmRDOtd5Bw2ngA+y8aKrE618soR5yGQ/5muBDgz3HwlwH
	 KuKehJePBRYi+hZsvuf/asF2xhK6GV4w2Cb5lM4qvuaBZb4wwDZmRGFIQCA3U7cDCnkpuG4oUThC
	 xRnCI7KvZlyiwwT9WMfMwd1qt5IItZtnOgOgYtfUgzPsCIEsS0pNQDJGm3KedQsRosmGrTFLvcyK
	 gJISHK4l/Z5sT+Be1ChGAjlEuffulCZVWJUKjgz1d8GVyXKqziWzi3Z0zXBx23ete4mMoymGGw4x
	 YY86bAbwhNWQm6U9lTq2HSDwka/7hnogvALdKeP1gskr97j7RZAGEi5uTxjD2ZuyvD/0qnIJHVTq
	 OXn6qV+aaSpYqNsvdgYF7DAI9JlGVCi76awmutNROMZUNMuJo1Czc6FUn5KxrkIXZfeySDSy+THY
	 cW41l2jaauN9E9g2676O1v3Tzicc/3WELVCwVPmrW8msodR2BxC6Gp+g4tY+s0zEBd6DAj/lI6OV
	 nwXG6TvhE1sIvmbnM8xclQz+rUDbpfz06PJJWr9CEgfYTe/AbeAJbt4G9mEo4nzuW/D+/8IsJhot
	 Et+n2o1bfcHSHh5gj7pHoa9ic71AOfpM94PVvVsyq/CdM28F5C7+kYUaoEhDs+a1pv+31XDiIzHe
	 I+cX+1za+CsCrkzBc8iLe7azYs4A6v726CIh3SNmpfAanIcEQvrI8dWhvYDPZfYAnAGsIXuM+IZr
	 6uqDA=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: He Jixin <1270243756@qq.com>
To: kanchana.p.sridhar@intel.com
Cc: 21cnbao@gmail.com,
	akpm@linux-foundation.org,
	ardb@kernel.org,
	chengming.zhou@linux.dev,
	clabbe@baylibre.com,
	davem@davemloft.net,
	ebiggers@google.com,
	giovanni.cabiddu@intel.com,
	hannes@cmpxchg.org,
	herbert@gondor.apana.org.au,
	kasong@tencent.com,
	kristen.c.accardi@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	ryan.roberts@arm.com,
	senozhatsky@chromium.org,
	sj@kernel.org,
	surenb@google.com,
	usamaarif642@gmail.com,
	vinicius.gomes@intel.com,
	wajdi.k.feghali@intel.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev
Subject: Re: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for compress batching of large folios.
Date: Tue, 28 Jul 2026 11:05:19 +0800
X-OQ-MSGID: <20260728030519.269154-1-1270243756@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 24 Jan 2026 19:35:37 -0800, Kanchana P Sridhar wrote:
> +                        if (dlen < 0) {
> +                                dlen = PAGE_SIZE;
> +                                dst = kmap_local_page(folio_page(folio,
> +                                                      folio_start + batch_iter));
> +                        }
> +
> +                        handle = zs_malloc(zs_pool, dlen, gfp, nid);
> +
> +                        if (unlikely(IS_ERR_VALUE(handle))) {
> +                                if (PTR_ERR((void *)handle) == -ENOSPC)
> +                                        zswap_reject_compress_poor++;
> +                                else
> +                                        zswap_reject_alloc_fail++;
> +
> +                                goto err_unlock;
> +                        }
> ...
> +err_unlock:
>          mutex_unlock(&acomp_ctx->mutex);
> -        return comp_ret == 0 && alloc_ret == 0;
> +        return false;

I think there might be a resource leak when both conditions below happen:

1. `dlen < 0` enters the first if block and does `kmap_local_page()` into `dst`
2. Then `zs_malloc()` fails, hitting the `IS_ERR_VALUE(handle)` path and jumping to `err_unlock`

In this path, `dst` points to a kmapped page that does not appear to get `kunmap_local()` before `err_unlock`.
The old code had a `mapped` flag and a common unlock path, so kunmap_local() was called on all exits after kmap_local_page().
After the batching rewrite, the successful path still unmaps `dst`, but the zs_malloc() failure path appears to bypass that cleanup.

If my understanding is correct, the fix could be either:

- Option A: Add `kunmap_local(dst)` right before `goto err_unlock` when `dlen < 0` was taken.
- Option B: Restructure so that `kmap_local_page()` happens after `zs_malloc()` succeeds, only for the compression-failed entries.

I'm new to the mm subsystem, so please let me know if I missed something that makes this safe.

Thanks,
He Jixin

