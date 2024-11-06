Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D43820BB46;
	Wed,  6 Nov 2024 20:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730924732; cv=none; b=u9WsSYMWH4qJz9Tj/St+JR+d2NElZhKqkrZOaCB67ZdARGEVufgIRnj8nMCwik583GtdMSuuBaZusyKO+ZsO7+sbNONJUYCkC6asYVJUCDcGpmgAdpEqJn//XiXZydttte063J2IVoNMIGEp3XUu2iOeW7qJa5801xvdfuWulw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730924732; c=relaxed/simple;
	bh=i1W8qhP05jFcN/hyZv6961XM+LfoQmisV8biz+LRcJU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Ke/WlE6HiGsbcfiD3vhsL8jptoHZ+AgwlcUwi4lUXltkH5nhV5Q12Gi3x6UmwDRY03XAKTAluZEeEH2h4YA5J9kwnb57ciAdkEkh/F/l83HCfuCUHEIl5iacIf1S8OW6pMI63orxN/Ux8GZRnhQWUSNS7/WOeEZKv05roYFRR58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cQ0oUvjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cQ0oUvjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B35C4CEC6;
	Wed,  6 Nov 2024 20:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730924731;
	bh=i1W8qhP05jFcN/hyZv6961XM+LfoQmisV8biz+LRcJU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cQ0oUvjgqGCHlY6W3ECtu7vfOldldtKWWYWKO109XLSTy5KfEvFAsV/6Ft5mtLLna
	 JrABCOoe2pYiUJnXNzjjVNJ32EHNunTrYKbHTUMI0T6yyxhIZF0sL3IARobn++0iRc
	 LtH2oEwpBBIKeotKoBj+rf35xaJt73qXqKJHuOog=
Date: Wed, 6 Nov 2024 12:25:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
 yosryahmed@google.com, nphamcs@gmail.com, chengming.zhou@linux.dev,
 usamaarif642@gmail.com, ryan.roberts@arm.com, ying.huang@intel.com,
 21cnbao@gmail.com, linux-crypto@vger.kernel.org,
 herbert@gondor.apana.org.au, davem@davemloft.net, clabbe@baylibre.com,
 ardb@kernel.org, ebiggers@google.com, surenb@google.com,
 kristen.c.accardi@intel.com, zanussi@kernel.org, wajdi.k.feghali@intel.com,
 vinodh.gopal@intel.com
Subject: Re: [PATCH v3 00/13] zswap IAA compress batching
Message-Id: <20241106122530.1dd603d8011348b6d6713090@linux-foundation.org>
In-Reply-To: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  6 Nov 2024 11:20:52 -0800 Kanchana P Sridhar <kanchana.p.sridhar@intel.com> wrote:

> IAA Compression Batching:

hm, is this a crypto patchset or a zswap patchset?

Thanks.  Unless someone stops me I think I'll add this to mm.git after
6.13-rc1 is released.  To get it additional testing exposure while
review proceeds.

