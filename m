Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA522192F5;
	Wed, 10 Sep 2025 19:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757533763; cv=none; b=HbhkVOqUybgqetn+wPTzQ5e7t9V4hdwWpD0yZG7U7kV6d9D8weEGjvTDUTQ5T+VSw/qwRfpX2xCrJ/VOJYn8iaFuDspOSauAZ16leNcpkwacdLk9RlbBL6bqdMog3IZbWhvrMi+HJlnlWMFCDehOo7+b+ifpQSJgzJle5AHmJVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757533763; c=relaxed/simple;
	bh=VlR4T7W5WUcCl5jM8ND6VF21jkI4rqDyaEM8DrBDXtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DghsgMdM736q6HfBRcGh/qAnUWd+mP6LYgiqkhCtAGZSIAXdvd7WEeWYL6yz338YGVhIeSIS9Bs09Q5DZzGvSztW1J40w6BkMGxXTJM8MxxZ7916Er6tL1TAeYvPjZVEBO4o0yRHYel1L25h/Wz+j+8ObVdpo32s6agaS3bLu/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B2QUeXsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B2QUeXsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09E9C4CEEB;
	Wed, 10 Sep 2025 19:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757533763;
	bh=VlR4T7W5WUcCl5jM8ND6VF21jkI4rqDyaEM8DrBDXtg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B2QUeXsFP/8t9H+uXfCOPC9W7hJbSvaQzKCacm52pDLARWQhOaI6TMggUjJ3hlcOs
	 +2ffNodYhLpM+Ry8vHv7i/kEUS92UQDOCNEw3cR7q6iPZ9fi7rINNkgfeKAA+9qLL1
	 +YGHNXz9Jbu6yORdBXPyU+aiKz1zwAUJ9tdV7rlgVlPgvBAB3QdMiyr/dgnlVMi7ub
	 jfhiSXOt77FKB+biQ8XCc9FFQAET7KoMtskxVOuwO376KJ1ca3Ido85CFZFbkgulub
	 40SSo2ut9ZJD0mrol+e3Wx21uHB1djpQHebJ2CToEgpTLhWjMRUQbNfvqT+bp9tUOg
	 iV4HGYvVU1D1g==
Date: Wed, 10 Sep 2025 19:49:21 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
	kasan-dev@googlegroups.com
Cc: Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] kmsan: Fix out-of-bounds access to shadow memory
Message-ID: <20250910194921.GA3153735@google.com>
References: <20250829164500.324329-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829164500.324329-1-ebiggers@kernel.org>

On Fri, Aug 29, 2025 at 09:45:00AM -0700, Eric Biggers wrote:
> Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
> kmsan_internal_set_shadow_origin():
> 
>     BUG: unable to handle page fault for address: ffffbc3840291000
>     #PF: supervisor read access in kernel mode
>     #PF: error_code(0x0000) - not-present page
>     PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
>     Oops: 0000 [#1] SMP NOPTI
>     CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G                 N  6.17.0-rc3 #10 PREEMPT(voluntary)
>     Tainted: [N]=TEST
>     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
>     RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
>     [...]
>     Call Trace:
>     <TASK>
>     __msan_memset+0xee/0x1a0
>     sha224_final+0x9e/0x350
>     test_hash_buffer_overruns+0x46f/0x5f0
>     ? kmsan_get_shadow_origin_ptr+0x46/0xa0
>     ? __pfx_test_hash_buffer_overruns+0x10/0x10
>     kunit_try_run_case+0x198/0xa00

Any thoughts on this patch from the KMSAN folks?  I'd love to add
CONFIG_KMSAN=y to my crypto subsystem testing, but unfortunately the
kernel crashes due to this bug :-(

- Eric
