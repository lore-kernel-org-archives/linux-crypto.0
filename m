Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792694007;
	b=nXL+JpOQO/21k3FWQD7FcwxNL/W9dCB42XVinYO2lpVslwm685cCQlYBgq3SXsNgJr2v
	 3uRWNxfpDYseRIP9Y7r7NHUKxquXlvM0wiBPEejneURkKoKcTX5x/Ml8f0SRfvaDzDkI+
	 s6SE1wKJNzv+/69v2otP0y+NFKg8wehxYuyQlSRhBBXzoqt+S+W9f/p/sIwEaVGd/Lxg6
	 CflI6J9IxjjtzNJ/dUf8gRzBnCbeaxs0IK16eEmhMpWL6pBxtIOZ5rLEjHghGtZujHkjj
	 cB1upwxE0sRm3Jbwf1oi2bqTQTqnVNXUMpyWbJyLJcuIzAzjETEdQG8JJUiG04Fd5rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792694007;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=kMc2eNn/OrrFKUYMVyLnIB+VtX1ihRJBTMeBnYRefLE=;
	b=jknzUplIsxR+SSJT3LJu3lrXZ7GXutLAjM3ox8mC850f7MLtK8Jg0WrLdpzmLJyD69cM
	 eiTUYN1UpuZjQNlArkE2pNI0zndqazIbQ5opZ8mbM/6NIK9nET3JJjMEWHnazNx2pqdx3
	 xtVNn7M5Rz/RKKFVXvWKKbjr6tMF6W04u/+i412AhUVB5ZFEY04/2Iv6fAQVhYjcK+Uz+
	 zX7xUSLjcnaiLjipoWoi1ib6urus4xWPxG5c6xLHAI9KaFhmso1/rlpmhi3W9rWDrWuak
	 iQvzwRIBhZDE7yMDEEkwff7c6BQxeqxZk8RlilGSBmlH7pccIGVsqZ8BDpoi65vzX9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--suseendranb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b="Eug/YSgE";
	arc=none smtp.remote-ip=209.85.210.199
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C1060A262F
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 18:33:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3C1060A262F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suseendranb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Eug/YSgE
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a0522cdaf3so148824b3a.0
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 11:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792694006; x=1793298806; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kMc2eNn/OrrFKUYMVyLnIB+VtX1ihRJBTMeBnYRefLE=;
        b=Eug/YSgEIQnYwSVtyRNMhnyB45nYUyzLnZ3BgbnyHX1QFDPFX3RcBM/RGQwCH8vRwv
         bz7Z145Joh0s6NanCfDRFKgpkjeiLGoqIgyjQig1YQIQnnoUzD00vkPO9J55x/PAFZg9
         kTEmREnsVedJpcap1gMH0iH/5CdS6g2hk4O2GgjNtlT3BE14/Yo/5jCE1vvoZvfSsEvm
         +GYmd//fVmMKcbuNtc9JAwsn40hUjji65QLUohBLh9FlzrtDbytYk2/5O6PalS/TDp9S
         5co3pPBaVUYHZAW7Au7JkgQTAePmb6kl9bSV7tG2DhdkMYvKx60vMlcWLp+SQqAPnJO2
         mQVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792694006; x=1793298806;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kMc2eNn/OrrFKUYMVyLnIB+VtX1ihRJBTMeBnYRefLE=;
        b=Ptmty5TXEZjJ0Bc1JQQnjXE07ulQW5UWoxG24QMDX6pdiMS2Lci/17raPRZ7PrsnkI
         89o/GHlnxO0YiiPWowuV9IXvGZKeNvIC7CAVdaglcjOqryL1jZz8T1wi1N26pyIlH+FM
         eIJZSGDr0qgI0dazRvUPdx0jeelwDX29q08It/ICfP500w4UXc7BZfmuIN9eLtECAxvI
         KBEH0LyQABnFFq3stk2JB5/rGOIv00XvnmblbUqtt0Bq/Off9jIlVBUGz9+e5VQGVaLm
         k1DOhCVPmNImNmeS1gbaB6bg9dSE1sSLRshZtdDfYtuFhnR3TfLNT9UAUZJj6U68g1vl
         ss5A==
X-Forwarded-Encrypted: i=1; AKwUvBwEVuBVkmTC/wWnMPCs3ok0aFEyQAk3BJu32VIOC26Fif/K6r3YCGPUX2yuTZGtAFExq67T1koOW+eOPIU=@vger.kernel.org
X-Gm-Message-State: AFq9FYLpVgZVKwP+FHwQi0/VpdG6Q1ZXGqnwIDlotA/dNMiUPZnkqVeT
	XXTJ/KehgZa+1s04WvgKyNJqGft+n0EhYj4Nb2HPiz+8geMbqLMf6WUwjR4x6idh610EzZXnsmA
	UdYD96A9DhU+KKgRJm11XBSuYsA==
X-Received: from pfdc25.prod.google.com ([2002:aa7:8c19:0:b0:89d:3267:4348])
 (user=suseendranb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2395:b0:857:7317:cff5 with SMTP id d2e1a72fcca58-8a2c5f488famr51343b3a.22.1792694005807;
 Thu, 22 Oct 2026 11:33:25 -0700 (PDT)
Date: Thu, 22 Oct 2026 18:33:18 +0000
In-Reply-To: <CAO9r8zP+GUE-hcGWSGzhLNLcchFoZ38EMVCAtX5yZ78tZ0bbgA@mail.gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-3-suseendranb@google.com> <CAO9r8zNtuN=_BTV53oHqaTqE0Bo2qiDSrgTBzEZo5oyOnWyeYA@mail.gmail.com>
 <20261022155144.4177200-1-suseendranb@google.com> <CAO9r8zP+GUE-hcGWSGzhLNLcchFoZ38EMVCAtX5yZ78tZ0bbgA@mail.gmail.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022183319.163484-1-suseendranb@google.com>
Subject: Re: [PATCH 2/2] mm/zswap: classify compression dst overflow as poor compression
From: Suseendran Bhaskaran <suseendranb@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Suseendran Bhaskaran <suseendranb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 22, 2026 at 09:01:02AM -0700, Yosry Ahmed wrote:
> On Thu, Oct 22, 2026 at 8:51 AM Suseendran Bhaskaran
> <suseendranb@google.com> wrote:
[...]
> > With that unchanged, existing zswap_compress() already accounts -ENOSPC
> > vs other error codes when writeback is disabled, except for the
> > !comp_ret && dlen >= PAGE_SIZE case mentioned above:
>
> Is this actually possible? When we changed the buffer size to
> PAGE_SIZE, I thought we made sure all compressors wouldn't write
> beyond the buffer size. dlen > PAGE_SIZE means buffer overflow, which
> is a bigger problem than debugfs stats. Or maybe compressors can set
> dlen > PAGE_SIZE but won't actually write to the buffer? I didn't
> check.

dlen > PAGE_SIZE isn't possible, since all compressors bound their
output by the input req->dlen (PAGE_SIZE) as you mentioned, and only
set req->dlen <= PAGE_SIZE. The 'dlen >= PAGE_SIZE' check in commit
dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
as-is") was written when the buffer was still 2 * PAGE_SIZE prior to
commit 0b1bf60c324a ("mm/zswap: reduce the size of the compression
buffer to a single page").

> As for the (!comp_ret && dlen == PAGE_SIZE) case specifically, yeah we
> should probably use -ENOSPC to count it as poor compression.

Ack.

> The compt_ret and dlen checks are not super intuitive tbh, I wonder
> how they should relate. What is the expected value of dlen if comp_ret
> is an error? Is it always 0, or can the compressor set it as a
> non-zero value if compression fails?

On error (comp_ret != 0), dlen is not guaranteed to be 0. The value
left in dlen depends on the compressor used. For example:
- zstd, 842, and qat set dlen = 0 on error.
- lz4, lz4hc, lzo, lzo-rle (via scomp_acomp_comp_decomp()), deflate,
  and iaa return the error code without modifying dlen, so dlen
  remains at its input value (PAGE_SIZE).
- hisi_zip sets dlen to the hardware-reported produced bytes even
  on error.

So dlen is only meaningful when !comp_ret. The !dlen check was
added in commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE
compression failed page as-is") as a defensive check for the case when
comp_ret is 0 with 0 dlen which shouldn't happen unless the compressor
is faulty.

> >
> > -                       comp_ret = comp_ret ? comp_ret : -EINVAL;
> > +                       comp_ret = comp_ret ? comp_ret :
> > +                                  (dlen >= PAGE_SIZE ? -ENOSPC : -EINVAL);
> >
> > Would you prefer that I narrow Patch 2 to just that change in v2, or drop
> > Patch 2 and only send Patch 1?
>
> Let's figure out what needs to be done for patch 2 first, if anything.

Since dlen is only valid when !comp_ret, we could normalize comp_ret
first when !comp_ret and then just check 'if (comp_ret)':

diff --git a/mm/zswap.c b/mm/zswap.c
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -874,19 +874,24 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 */
 	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
 	dlen = acomp_ctx->req->dlen;
+	if (!comp_ret) {
+		if (dlen == PAGE_SIZE)
+			comp_ret = -ENOSPC;
+		else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))
+			comp_ret = -EINVAL;
+	}
 
 	/*
 	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
 	 * save the content as is without a compression, to keep the LRU order
 	 * of writebacks.  If writeback is disabled, reject the page since it
 	 * only adds metadata overhead.  swap_writeout() will put the page back
 	 * to the active LRU list in the case.
 	 */
-	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
+	if (comp_ret) {
 		rcu_read_lock();
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
 			rcu_read_unlock();
-			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}

Does this look good to you?
