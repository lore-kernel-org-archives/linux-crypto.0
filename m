Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE753B42CC;
	Mon, 21 Sep 2026 07:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.29.242.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789977417; cv=none; b=E1NNKk3CZY9fHI6+KRBV3SuWftPV0jBY/XBhXbZi6EsdD3NTa8rWPcVaPd+eRWp9gP6AYaOgRTdvewrmfg1esRjtoHhP7PYnTBj96iEsA/hYQVfbM46U0AKy7Ou5oFXMgaYI4gGOAQ4xdHBZf5qW8/f+Ykb7ISU7YQ9d6R7txUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789977417; c=relaxed/simple;
	bh=igIVzTr1x3ub8IbEXOwWcGrbS8zbtyw8OmiSKZIxvvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kfRsKKu0n1J8zrdd+vNuHMlDs5Qa1kZKy4cUXBsUaZLw+oADJoPUizK82igpNR4T4qyvYW1ryVCL94Rj0ZMPlReEKKfj/qykmwPIOG3NgNigaxxC4mwHlR717NFw2Q7VhGvTTeUuxeuQ/r6pxFkS4YZPELUdzU1c/t6p08BnxA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net; spf=pass smtp.mailfrom=davidgow.net; arc=none smtp.client-ip=203.29.242.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id 9134C1EABD9; Mon, 21 Sep 2026 15:56:46 +0800 (AWST)
X-Spam-Level: 
Received: from [IPV6:2001:8003:8802:7000::41b] (unknown [IPv6:2001:8003:8802:7000::41b])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id 7A2521EABB1;
	Mon, 21 Sep 2026 15:56:43 +0800 (AWST)
Message-ID: <c48b2403-92e1-4b7b-8bbe-aacf5c005cd1@davidgow.net>
Date: Mon, 21 Sep 2026 15:56:41 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/842: depend on the decompressor for KUnit tests
To: Karl Mehltretter <kmehltretter@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Haren Myneni <haren@us.ibm.com>, Dan Streetman <ddstreet@ieee.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 Brendan Higgins <brendan.higgins@linux.dev>, Rae Moar <raemoar63@gmail.com>,
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com,
 linux-kernel@vger.kernel.org
References: <20260917055645.26780-1-kmehltretter@gmail.com>
Content-Language: en-US
From: David Gow <david@davidgow.net>
In-Reply-To: <20260917055645.26780-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 17/09/2026 à 13:56, Karl Mehltretter a écrit :
> 842_DECOMPRESS_KUNIT_TEST selects the decompressor even when no other
> option needs it, including through KUNIT_ALL_TESTS.
> 
> Depend on 842_DECOMPRESS as required by
> Documentation/dev-tools/kunit/style.rst. This also prevents the test from
> promoting a modular decompressor to built-in.
> 
> Fixes: cca072cb1423 ("lib/842: add KUnit tests for the decompressor")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Closes: https://lore.kernel.org/r/CAMuHMdVcZ5cV4-HrjLYfFKh6UshiVxq5eXCNyp0Z1k_SMAvF5g@mail.gmail.com/
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
> Follow-up to the accepted commit, based on cryptodev-2.6/master.
> 
> Testing: Checked Kconfig dependency resolution for eight x86_64
> configurations before and after the change, including KUNIT_ALL_TESTS
> and modular/built-in combinations.
>

Thanks!

Acked-by: David Gow <david@davidgow.net>

-- David
