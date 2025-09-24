Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A68283FEB;
	Wed, 24 Sep 2025 08:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758702753; cv=none; b=nH7PZFaBdAD4Dryvv2m0pOFsPIuDijTiUhoPi5jF7FlrwEx7m7gINTIWTrz04CH4s23WgPDTiN84xdb4D2zrvjDy26yiMM5SBDGsf2tAQaVo6LSXmmDW5VAkjXrDmKkGV4kvaaYFjh2O2XD3u8kC7seGNoTKRWB+/slP9uCUX3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758702753; c=relaxed/simple;
	bh=IeX8yOCoDvdcx0fmIasWNFpPwpjlgV+9WMTNQdEmwx8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pX4xaLgL4AkfJApvm5qgL9DDzXkFhoi77quR/1xxuLz8krG9u+E50R4I6xpDQ+a3bg8ISROsVardJP/VgNUay6lwhb3LOKC8NyDLPHAt3ZA5ViyrqVnBOPUSZR/UzCmUvv/tpsFV4O1Q13WvyEv2ksH2zLV8CIypRZMjE2Opu7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKCiEqK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKCiEqK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276C7C4CEE7;
	Wed, 24 Sep 2025 08:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758702753;
	bh=IeX8yOCoDvdcx0fmIasWNFpPwpjlgV+9WMTNQdEmwx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKCiEqK8BrrchqRM3mvUVeZyIHSQcphRs0Pn/zKiofSIxKdDycgQec11VJpho3HhB
	 f3TPMh7Cd3FPuL3MZ+1WcHdYv/7/KIOFfg+pL7NGMMm797Tbf3pyf0x92qJXtpg5nG
	 vdBNszgGIRz71lHagi+gJSmcBvjON8rqgkSTV9aB904ZpKhrfbgwrAkA0zUBmiur4+
	 ilfckVKEogkxF+f2ZXXrdjpSP7oO8gpnvxJIvyCFg08POk/ZGAcVgQo5acdxhlexnl
	 CX5tW8G55aYDv9N/OUk3n6UIruY10vjTYRClD+ySOq17u2I4bIpF4vPHZdTjRWp0wp
	 gkuMHk9elmRSg==
From: SeongJae Park <sj@kernel.org>
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	ethangraham@google.com,
	glider@google.com,
	andreyknvl@gmail.com,
	andy@kernel.org,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com
Subject: Re: [PATCH v2 10/10] MAINTAINERS: add maintainer information for KFuzzTest
Date: Wed, 24 Sep 2025 01:32:28 -0700
Message-Id: <20250924083228.63898-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250919145750.3448393-11-ethan.w.s.graham@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello Ethan,

On Fri, 19 Sep 2025 14:57:50 +0000 Ethan Graham <ethan.w.s.graham@gmail.com> wrote:

> From: Ethan Graham <ethangraham@google.com>
> 
> Add myself as maintainer and Alexander Potapenko as reviewer for
> KFuzzTest.
> 
> Signed-off-by: Ethan Graham <ethangraham@google.com>
> Acked-by: Alexander Potapenko <glider@google.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dcfbd11efef..14972e3e9d6a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13641,6 +13641,14 @@ F:	include/linux/kfifo.h
>  F:	lib/kfifo.c
>  F:	samples/kfifo/
>  
> +KFUZZTEST
> +M:  Ethan Graham <ethan.w.s.graham@gmail.com>
> +R:  Alexander Potapenko <glider@google.com>
> +F:  include/linux/kfuzztest.h
> +F:  lib/kfuzztest/
> +F:  Documentation/dev-tools/kfuzztest.rst
> +F:  tools/kfuzztest-bridge/

I found you moved kfuzztest-bridge to tools/testing/ on this version, accepting
my suggestion.  Thank you for that.

Nevertheless, so I think the above line should also be updated like below.

F:  tools/testing/kfuzztest-bridge


Thanks,
SJ

> +
>  KGDB / KDB /debug_core
>  M:	Jason Wessel <jason.wessel@windriver.com>
>  M:	Daniel Thompson <danielt@kernel.org>
> -- 
> 2.51.0.470.ga7dc726c21-goog
