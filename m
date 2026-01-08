Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E359466FF2;
	Thu,  8 Jan 2026 11:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767871462; cv=none; b=DJyvS7IpT7IRVv5ZxFfHmAm77yBsog34UwvYsHepuGPF45AchpJbrPChbeS4N/laVTrbf/ZRBTDXYPexPZ6+PM4mv9KjaCWiZo+4O1kUic8+TRh311deZ0g3eUZtVbx5sMQKMH9j7u5IEFwOHSGmENkPMqy32m3u3c8jgQEDk3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767871462; c=relaxed/simple;
	bh=3aPn4Nyb5dJ3/lKeV8jT93iQ3qzkUHNcE3PnCr/yoRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DM9EPzsKiP1sx8Hw+e88Q93ix9hMnRIMAoC55dVvip6fe13uFw+ISmdGxnpUUA00TaxqRsjABFRE9hgzZG4KW49aYLI8eig7+txQ4mMq9yC91UazVEYq/K/mFdT+ri9Lf6VbSenmgrADYA4jNT5OwyFEUY7KkRrdcgIUDw4Pq4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qsL0LlKP; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qsL0LlKP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=raykClked1/JLJCbQnf4hmphE07lLLn7ScKUbMKwTGo=; b=qsL0LlKPeCPKDLe8Zmz0BbHHT9
	UUd44siueHFgPdRTDy1FUnJp0QKfamSiAxrBgrCFknIBEALVSkRpZVLrrjaDqqgFpf3sCkFjTKXjm
	9eBhSS7Bs/XX4T3QWY9YY1A9UM+5tCHhSLx4YGnj6Q2etJ+O6UF46rkClwnmleNBXY3ZBn5nOLXYu
	Sb4mSTXYriev5CZ9uQom3K42OujBuIIlkN2tyNPDBvBrIJISddqK3ycDfQ6mz8Z5M48a6otV5Ie/G
	7GKEcfnSoGYHrDVDSgGCRJzXaTr4E+HLiR6iBF5gN+hpcC7hlYkOO/l2ubXEhv0+axOAmW4X5EJyu
	ukFIjcYg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdo7h-0000000D2FP-0ABB;
	Thu, 08 Jan 2026 11:24:13 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id DCCE6300E8E; Thu, 08 Jan 2026 12:24:11 +0100 (CET)
Date: Thu, 8 Jan 2026 12:24:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: =?utf-8?B?546L5b+X?= <wangzhi_xd@stu.xidian.edu.cn>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	syzkaller-bugs@googlegroups.com, security@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [syzbot] BUG: KASAN: slab-use-after-free in
 mutex_optimistic_spin via adf_ctl_ioctl
Message-ID: <20260108112411.GI272712@noisy.programming.kicks-ass.net>
References: <7b50a9a8.abb1.19b9b902fae.Coremail.wangzhi_xd@stu.xidian.edu.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b50a9a8.abb1.19b9b902fae.Coremail.wangzhi_xd@stu.xidian.edu.cn>

On Thu, Jan 08, 2026 at 11:04:36AM +0800, 王志 wrote:
> syzbot has found the following issue on:
> 
> HEAD commit:    6.18.0 (custom build)
> git tree:       linux-stable
> console output: (see below)
> kernel config:  (attached)
> 
> ---
> 
> QAT: failed to copy from user cfg_data.
> c6xxvf 0000:00:05.0: Starting acceleration device qat_dev0.
> ==================================================================
> BUG: KASAN: slab-use-after-free in owner_on_cpu home/wmy/Fuzzer/third_tool/linux-6.18/include/linux/sched.h:2282 [inline]
> BUG: KASAN: slab-use-after-free in mutex_can_spin_on_owner home/wmy/Fuzzer/third_tool/linux-6.18/kernel/locking/mutex.c:397 [inline]
> BUG: KASAN: slab-use-after-free in mutex_optimistic_spin home/wmy/Fuzzer/third_tool/linux-6.18/kernel/locking/mutex.c:440 [inline]
> BUG: KASAN: slab-use-after-free in __mutex_lock_common home/wmy/Fuzzer/third_tool/linux-6.18/kernel/locking/mutex.c:602 [inline]
> BUG: KASAN: slab-use-after-free in __mutex_lock+0xd0a/0x1160 home/wmy/Fuzzer/third_tool/linux-6.18/kernel/locking/mutex.c:760

> Allocated by task 150:

>  getname_flags.part.0+0x50/0x560 home/wmy/Fuzzer/third_tool/linux-6.18/fs/namei.c:146
>  getname_flags+0x9a/0xe0 home/wmy/Fuzzer/third_tool/linux-6.18/include/linux/audit.h:345
>  getname home/wmy/Fuzzer/third_tool/linux-6.18/include/linux/fs.h:2924 [inline]

> 
> Freed by task 150:

>  putname.part.0+0x120/0x160 home/wmy/Fuzzer/third_tool/linux-6.18/fs/namei.c:297
>  putname+0x41/0x50 home/wmy/Fuzzer/third_tool/linux-6.18/include/linux/err.h:84

> The buggy address belongs to the object at ffff888104e04400
>  which belongs to the cache names_cache of size 4096

So how again is mutex->owner a names_cache object? This seems to suggest
something has gone terribly wrong somewhere.
