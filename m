Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B269433372A
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 00:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791850914; cv=none; b=BaouKjS8DZbNDFzcnx9BGUEjyMIIElOKBcOFyzoLi9zcjpPtaI6zmWfcXkkqpyO4W4V/R+z3oTX2neRxoyBKDSOzAwNRBvqntFik+qqUfzJHIir7N4LvjFN0DmZZECaE9zEGT/vnUfqP7BVd1PLGspkYBk48gFR/GoJ1D/vCnhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791850914; c=relaxed/simple;
	bh=26R6QjZja8iwEgaIS7NPevZdCEiibaTu0MopPJ7UPos=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yr3qKS49e4bqwzjHk8RK91fI3yJlXqA+kBPtj4BwPoAKvpQdFIZwbCS0/aiVTc0TzUsXEerW8cYRwb7EDAwSjlkka4jzIMsLlWYWPn1coXI9ONFQVKLf6UTCFAcFBLTdVibRI9tRcj5ug3h7OJ8C5AHzJe087c5Iu29furjyS4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RSjR3MZY; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RSjR3MZY"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-33e6279a1d7so1400014eec.1
        for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 17:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791850913; x=1792455713; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=26R6QjZja8iwEgaIS7NPevZdCEiibaTu0MopPJ7UPos=;
        b=RSjR3MZY/vVTaZx1qZ0noJdcqE8d5NiFifbzdj/ueXIM3MEEWsjFSY4rb0pNPjOmjq
         sxE2pEUTqY0JsY6iHdrCmh4Ve+r4exBhaQnbEIS+Yoqy3JJBnrFKCVOckufg5SSm7yJf
         OQg6lGX5jKk7W2ON34kaVl63gqm7zdfyF1xgW/nwMvGrWMmpsT2AZXGfwggKhXSXBljP
         6AKrJzXKV+j0Na+EFCMz+A0i96VVUnO2+R5JzZxZACs5/fkYBNoX8/fjc278yfehCEni
         j+NTnA9YlFua2kZk+guYLK8GCOqAjwe28lWlHuJlZGk1c5o+vK+foimcATKiP2im4eQd
         BIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791850913; x=1792455713;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=26R6QjZja8iwEgaIS7NPevZdCEiibaTu0MopPJ7UPos=;
        b=JnmnuKcoy3/+pugVc2E8jh6low/zCO9Y7J8DP09AepeJWAODYLn48gH8G/e93eUOl+
         O8JBiX3AvcS1VjqdsBoBVNFRyuag+dhb5GV5IfNoxpDW/iJn5OIx7UxekLJk+bjyx5OE
         oP1fCbNjSUs7n7IaeCHHErcWyh45LFTkariG1NlVH0+YaPMzX1/0uGQ8CmnLAbY7LvEc
         eRFmypVAQA2nrsEdm4GBXNMFh6qdLucgkxzEjKQltQ10zmAMamcaoSt0rDqpeFQ+56QY
         rBKL81HpPxdI6L9lpaN1jKzqRdTkPlLv1e2Nfk8fe42WyxHEwA3e3l4ASFfQsOWWMrdk
         RvGA==
X-Forwarded-Encrypted: i=1; AKwUvBzHUMMy8knJx52jXQiy9ErSdygfUysuScvzY2ybUMMsXGK+kQcOouun+2ZGLz6MWDKBq+VeJbNYZVeYCu0=@vger.kernel.org
X-Gm-Message-State: AFq9FYI40Ze1g8THY+EzvRcvKpi+8NymLz2wKAbCqFkjIpFQveOLWLF0
	Z7IPCeAa/n0NHk696UPMzbtRnE6xKGfWZzqmZUIwAYgxxt0iEUQYMIYR
X-Gm-Gg: AYBFou3pJ/6a9IVaiBMdr9YGFJYNecMx3MhhimVmcSmuwGPRV+SEq+bnq/cklGDgwuR
	srzTl3x0/n+tWmUsOj8/2dWniZgTKI9X572sMguj6BXdQOirZroBIKSvvN/a0QEpemvv0suIkRk
	7aV2BwWZGB8xFJuJLXRdIn6xs2Pth8d/ZXf5bOibZk7m2HNrWue2GmEzInc9wj9w1McV3paDc7J
	rAZSi01Ey46SbAjLFMqb1cgf8iM+c5wOPTnDhSbtGWrgrYRbZG4cdf3kTsvK7h6EL1Dqk9TWB6I
	OiLsind49roSFiEile4HC6NoL7GCp241gmhBhsTvnBQZ/qZZZ68BdxUAXqPzfQT9o8mr3qoMfp+
	XYi0NNEL3l/nKI1bz04Obqkg2PucEAAx33FxSn9k3Hqm/rZ1Z/Y98d2IcT3hE8FVhY/GKncJsfN
	gvU666PFiNiRWqJ/19g/3I93NFgdNMrcnpxNs0i5BFEzMJO7E+ccZBglvIcRfC3AxtZcnNpMhgL
	/fPu6jXA9rNpzL+xJyLIg==
X-Received: by 2002:a05:7301:7d16:b0:350:2a5c:56c with SMTP id 5a478bee46e88-3537e08eee0mr15924457eec.20.1791850912519;
        Mon, 12 Oct 2026 17:21:52 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3595e0858c6sm23646723eec.22.2026.10.12.17.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 17:21:51 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: usama.arif@linux.dev,
	akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	terrelln@fb.com,
	yosry@kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	senozhatsky@chromium.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	kanchanapsridhar2026@gmail.com,
	linux-crypto@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm: zswap: use separate compression and decompression requests
Date: Mon, 12 Oct 2026 17:21:40 -0700
Message-Id: <20261013002140.28880-1-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261009163146.83112-2-usama.arif@linux.dev>
References: <20261009163146.83112-2-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, Oct 9, 2026 at 6:31 PM Usama Arif <usama.arif@linux.dev> wrote:
>
> Stores and loads serialize on the same per-CPU acomp request and mutex.
> A low-priority store can be preempted as soon as the compressor drops
> its stream lock, while it still holds the mutex. A higher-priority load
> on that CPU then waits until the store runs again, which can take a
> long time when other tasks are runnable.
>
> Give compression and decompression their own request, completion wait
> and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> compression, so group it with the compression request. Independent
> requests can share the per-CPU transform; the codecs and drivers
> synchronize their shared state internally. Loads can still wait for
> each other on the decompression mutex, and stores still serialize on
> the compression mutex.
>
> acomp_request_free() ignores NULL requests, so drop the check in
> acomp_ctx_free().
>
> This follows the proposal from Sergey Senozhatsky for the same split
> for zram [1].
>
> [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/
>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

I have a question with regards to this patch. Is the intent to allow a
decompress thread to run concurrently with a store thread for a given process?
If so, I wonder if incurring context switch/PTE/TLB shootdowns performance
penalty is worth it?

With the proposed change, will zswap_store() continue to run on the "old" CPU
(i.e. the one to which the process got migrated), or is it a requirement that
the "old" process is in sleep state? If so, should we codify/document this
requirement?

On the new CPU, is the same process "runnable", and if so, how do we ensure that
the "higher priority" decompress is handled while the zswap_store() prior to
preemption is still not done?

Thanks,
Kanchana
