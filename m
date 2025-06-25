Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861392D8DD6
	for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 15:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750864998; cv=none; b=OvLujL8i+c1ymqmxeflbKPBjgM8VVFKP0WODFx/5A+ebwBjptZJVH/ZQUw1FjRFQ+DzmRvAuqXjMJOrTIzoTDN2qhGyYypW92+1xnEW+XH0imnItyWkxhNlncfpdjmNh3lRMOBDBEJSZQcNjOeibxS1d5QeszvN+T2BhJiQ4g+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750864998; c=relaxed/simple;
	bh=7Sjl3arAU6l+ct4OIc3hiLJH1j7yUSh9QgIYsdqT8xU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CNzFsoRb1BYAEFDqk0hnYnn7MkitQlRtomTAlQ3TuVVb3YBl2hw2teKpXllNk7e1RTrikGs2HxEaOerFh6Qg7czfUcGGS2r+HE4qcznYMIUAh90osUfUuSgs7PcISsnxuLl7UUuXZ/ILczKYxvmUwfjbaLQgdsG8Ch2h8QHuaLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sWliHQBu; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sWliHQBu"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-2efa219b5bbso14119fac.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 08:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750864995; x=1751469795; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nBTrV/qHiTTEHkO79YRzlOS2Pz4aSN6jHKI3tcdStg4=;
        b=sWliHQBuClCdusCHGnUxgxH+qDzUycPYh/r6OlFFj/BBqVg1edY5wdUHWtW4IcIVSe
         ljXxqq3vadBd8GU1M+LVbUF8RrMAd7bD/LlPME34cfn0C5RKWtaCU4TMQLVZ2OQcLOAF
         pl7Ey7hzqbzqG9LjSXsiLALvbryDwdqmTMNrQd7lDczuSpfdoRwiqC+L+km6J0x0Fe6/
         FV3XVOPR7OqF26PAv23SG3cICKzxtdcxTiDyjjvJ4reVfFKImb1m0HnRyEtyMnBIqEZK
         izIhFFiAlN32Xtu1hq7zJfsArEiRXS1Vb2KbBUY2N0a1EqGb1xUv6dl/hyb2Lzi/onaF
         5HEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750864995; x=1751469795;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nBTrV/qHiTTEHkO79YRzlOS2Pz4aSN6jHKI3tcdStg4=;
        b=Lx38an4ZIfUGDZ2oVC9/2amm5GBIQR3E5UhJ62dL37u76caML7CIzIvqdR729DFImo
         +XT8BPqMfSZSWlnAEwjY0x5YWYRozgcOxuTJMh/On1QdtTnDG2HukgCpi6bX9jnPVpyq
         U7ZsV+W7bVXZFX3rIiaRyHYvMU3bwzdp3YBSxnRyuckDxIhcFwS0sLOh3rVuE0YeFlC0
         /QsYESzjXR3mCbfjFWaZJY60j1Q1OHChRjJIpSyOu0PgmpuaPs0Mx4y5RIxRa+LxF2SK
         thXBpdib1wzWp0iiCXXVTn5y9cH4KfDkQN/itYQqvAiPiIOtqZPtLlIovG4E4Kg5HdlB
         zBUA==
X-Gm-Message-State: AOJu0Yz47INFfcIMx4POUzlSqRGFYYd6QprDKPixcOGssEFtx7Tk2mMm
	B7lO4jzNRG3pZoTTr8VHm5MLL1nw+Jo9ecnLMV/4qTqFigXNZkw7aN6+6c9u/+/LaRY2y3hn4MU
	UxS8m
X-Gm-Gg: ASbGncsplTZ1xh4XngQxXUKOWAp3/KKr82MHyOCFlku/RDiifadthyhI3QKAm3fjurx
	1nDTxBZImUMqR+27CbjJ43tDM+xkPPZPZD7Kjp1CwWTO27Y4qptxkMA5AwYii39bF7dYOe59j8n
	Z48eOYWzzWqSlcdXhL0ver+rjSDRP5zhLGg6mNibD2+0+pMwnI4/D+6XNQUNzv4kWUw/pNNb9q1
	lp7ejAQF4QCqU1PZN5rXT1YS267vW3ae6H9VIrB/t6rn8RsBWSGRzHkKSFdxKBnduT3ufDhtpOR
	UG/Udw59r8cnJtICg6/0hXF50d0aOCGH6OqtS8QmaxpiPE2ZtLZ7OWy+V2jN77VPycn36A==
X-Google-Smtp-Source: AGHT+IHguMsxXTrJbsiT1mDaoVBogHuqrzn+L+bYL9CaleASD263clez8DE7J3zfh+CjCPzLTLd8EA==
X-Received: by 2002:a05:6870:3d8a:b0:2e9:1c4a:9fdc with SMTP id 586e51a60fabf-2efb27430d7mr2440883fac.17.1750864995496;
        Wed, 25 Jun 2025 08:23:15 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:1fca:a60b:12ab:43a3])
        by smtp.gmail.com with UTF8SMTPSA id 586e51a60fabf-2efaf488114sm481919fac.14.2025.06.25.08.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 08:23:15 -0700 (PDT)
Date: Wed, 25 Jun 2025 10:23:13 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org
Subject: [bug report] crypto: zstd - convert to acomp
Message-ID: <92929e50-5650-40be-8c0a-de81e77f0acf@sabinyo.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Suman Kumar Chakraborty,

Commit f5ad93ffb541 ("crypto: zstd - convert to acomp") from Jun 16,
2025 (linux-next), leads to the following Smatch static checker
warning:

	crypto/zstd.c:273 zstd_decompress()
	warn: duplicate check 'scur' (previous on line 235)

crypto/zstd.c
    208 static int zstd_decompress(struct acomp_req *req)
    209 {
    210         struct crypto_acomp_stream *s;
    211         unsigned int total_out = 0;
    212         unsigned int scur, dcur;
    213         zstd_out_buffer outbuf;
    214         struct acomp_walk walk;
    215         zstd_in_buffer inbuf;
    216         struct zstd_ctx *ctx;
    217         size_t pending_bytes;
    218         int ret;
    219 
    220         s = crypto_acomp_lock_stream_bh(&zstd_streams);
    221         ctx = s->ctx;
    222 
    223         ret = acomp_walk_virt(&walk, req, true);
    224         if (ret)
    225                 goto out;
    226 
    227         ctx->dctx = zstd_init_dstream(ZSTD_MAX_SIZE, ctx->wksp, ctx->wksp_size);
    228         if (!ctx->dctx) {
    229                 ret = -EINVAL;
    230                 goto out;
    231         }
    232 
    233         do {
    234                 scur = acomp_walk_next_src(&walk);
    235                 if (scur) {
    236                         inbuf.pos = 0;
    237                         inbuf.size = scur;
    238                         inbuf.src = walk.src.virt.addr;
    239                 } else {
    240                         break;

If scur is NULL then we break.

    241                 }
    242 
    243                 do {
    244                         dcur = acomp_walk_next_dst(&walk);
    245                         if (dcur == req->dlen && scur == req->slen) {
    246                                 ret = zstd_decompress_one(req, ctx, walk.src.virt.addr,
    247                                                           walk.dst.virt.addr, &total_out);
    248                                 acomp_walk_done_dst(&walk, dcur);
    249                                 acomp_walk_done_src(&walk, scur);
    250                                 goto out;
    251                         }
    252 
    253                         if (!dcur) {
    254                                 ret = -ENOSPC;
    255                                 goto out;
    256                         }
    257 
    258                         outbuf.pos = 0;
    259                         outbuf.dst = (u8 *)walk.dst.virt.addr;
    260                         outbuf.size = dcur;
    261 
    262                         pending_bytes = zstd_decompress_stream(ctx->dctx, &outbuf, &inbuf);
    263                         if (ZSTD_isError(pending_bytes)) {
    264                                 ret = -EIO;
    265                                 goto out;
    266                         }
    267 
    268                         total_out += outbuf.pos;
    269 
    270                         acomp_walk_done_dst(&walk, outbuf.pos);
    271                 } while (scur != inbuf.pos);
    272 
--> 273                 if (scur)

No need to check.  It's weird that the line before is
} while (scur != inbuf.pos); instead of } while (inbuf.pos != scur);
Normally, the variable goes first.

    274                         acomp_walk_done_src(&walk, scur);
    275         } while (ret == 0);
    276 
    277 out:
    278         if (ret)
    279                 req->dlen = 0;
    280         else
    281                 req->dlen = total_out;
    282 
    283         crypto_acomp_unlock_stream_bh(s);
    284 
    285         return ret;
    286 }

regards,
dan carpenter
