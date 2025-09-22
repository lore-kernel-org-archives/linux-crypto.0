Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5051928C037
	for <linux-crypto@vger.kernel.org>; Mon, 22 Sep 2025 09:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758533616; cv=none; b=H9YKB79J+SE79LwkMPO94CKPfFszSRDfEMHIU/Ry3GVOExcmzmAwIztZ4AYM4lCmP5p4Pa574S1iDHv5GQ7zBmnGgMqrR6ArPL+8B9ONUflP0HN+G4V1Wgk1DQpfIAKFgcY+0LPfKdAYOWG/P7dmbSpBrYRh1itCJmFJw3TUeKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758533616; c=relaxed/simple;
	bh=uR7IyOLN2X3biDgABs/idhTRrUaMmnWVYyN/UzgtCKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwhH4m6wZIgrP44WhhdRJ9bVjnipkeU4QmKfFerwwLI2xWHcdmV1iLu4GKsw9QxL8mgceHV4tpOuoZpR9O8qxvCpg79BvvxdjSJ5c7y61c8FSFw9gg41dBjuGX4lcBrSlmPUifclmaB3AwoqnuztxP0smPMknBz6qEuQjixULnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rtqRVKgw; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rtqRVKgw"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45f2c9799a3so30937405e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 22 Sep 2025 02:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758533613; x=1759138413; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=89qPC2dMk40SQhoKG37yGCiQt/NY420sGfty0Meng0w=;
        b=rtqRVKgwXVLDUPMcssfmWmAiw96i6zfxA/t2vqhdNA5YUqKeezt2pPCKNqVyuYTQE4
         gVXMk/0hOTwX4zwKdwi3p146YZma2gcgaSCBW29dZqy7v7TEgm2EGs84QxoYNsAn1znb
         slwzGELxqwII971SnlHT1bDj6nwjAKtx20WV+dXWzoBKLw4zi9u0z8u4f7HVH9w+TcqV
         fk7//ZiYPMZISgktY4gCh/huytX2ZwLjvMMgStS6ETfULKiiydWXMY4YMns37F16PFVb
         6hWHTbG4lZj71aB+/CtXTslBsPyT7fXYYYekfTbAhGw5cudJI4ZwVFn3PDSnYXowHJ5p
         kIXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758533613; x=1759138413;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=89qPC2dMk40SQhoKG37yGCiQt/NY420sGfty0Meng0w=;
        b=Iw7H5qC7VkMnpWUBE2zS698uEKDxGhY12FsZcA8KzcPvMxBEIvEa7C1cHYo6k0SVIb
         cNevIemEWCREHLJr5J38h8Tl/7dOFvfqUDcThogWy4H0Lzh6Bws33rzlQWm0ofIitet3
         r2u4S+bkskFp/8GH+VNymTrdP2HA7XiP04zERXHF23kDNcZN2CzGdtPz+E4i0KZOS+ec
         grOwzgT9afeou0mrGD0jXzg2S5mCx0sHtWF/exFC6ACpzRb60YMwGMzUDB2gkht14ztv
         NOgJj4GkEe3KLmLB5nkWYx9kvFYgiKUZFfK7VZWPvdSMagUN4blFcpCtP+EejcDBlwMT
         XsVg==
X-Forwarded-Encrypted: i=1; AJvYcCXGdPjFTTn2pNOF+IBr1cJAXUGLVCi92YaAvzcYN42tmiIYAkGNXLNbgP4sa1MP9n2vLnkfCqSZzVyKdpI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbWSJy4BM6Sc85q4cRq+o6Yq4wrguNSR1pnOT48dx6dQpDGx0J
	fyKJ1GKv5w30PWSp6u/crYlKMSle3+tIKjjC5uUH3f+Y3FOD4otM3NmhvvK2JdGDig==
X-Gm-Gg: ASbGncuZSDicrIO2bQzgQioh6zhVPWZWbju4A+yuOxByu0VWEl4+Tw7f925jL1XxOPY
	UI4ls/jMkDnMvzj573FR6kTyaeODTJ2TE7wfNOu5/QxIbr2DtszhB7p3X6FnxJs1jlJPy+MMwco
	sgvv3Ph41ZWxdzolJUmJ+ggIsyG5sJE1RG+/rfG24SK/gL76IiXQnx46+m/6akzqTNvciAVC2tp
	WM9OSaC3oee7pcJmmJNrWjEOmf/K/uLMBNTVREMjj+qubOMVSTbT4FTXOAjW0Ix6fBpifEl1a+3
	5ZqQBS1P0TkZVCv4UuXSIAnf/Ol05jPpPEIz2yRqvoj1uuP79OJb2W2lhIgYeuiUszUhFWyYwWy
	cr7DfxJ5Gy5uNRuK0jc5S3fGjODfcn9T4sgVuReGacN/0ZRC+20SO7FOSwqY=
X-Google-Smtp-Source: AGHT+IEkoU9ognY1IS2/WNXTQHBehT3iG6jr+rUMfSA5BLARxzu2twytBIMtwJpeHRGrTnG81Cn1IQ==
X-Received: by 2002:a05:600c:46c6:b0:45b:804a:a65e with SMTP id 5b1f17b1804b1-467ebbbff33mr123610355e9.28.1758533612329;
        Mon, 22 Sep 2025 02:33:32 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:2834:9:8fed:21ad:ce77:2e15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46d1f3e1b03sm39713145e9.23.2025.09.22.02.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 02:33:31 -0700 (PDT)
Date: Mon, 22 Sep 2025 11:33:23 +0200
From: Marco Elver <elver@google.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Bill Wendling <morbo@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, llvm@lists.linux.dev,
	rcu@vger.kernel.org
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
Message-ID: <aNEX46WJh2IWhVUc@elver.google.com>
References: <20250918140451.1289454-1-elver@google.com>
 <20250918141511.GA30263@lst.de>
 <20250918174555.GA3366400@ax162>
 <20250919140803.GA23745@lst.de>
 <20250919140954.GA24160@lst.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919140954.GA24160@lst.de>
User-Agent: Mutt/2.2.13 (2024-03-09)

On Fri, Sep 19, 2025 at 04:09PM +0200, Christoph Hellwig wrote:
> On Fri, Sep 19, 2025 at 04:08:03PM +0200, Christoph Hellwig wrote:
> > I started to play around with that.  For the nvme code adding the
> > annotations was very simply, and I also started adding trivial
> > __guarded_by which instantly found issues.
> > 
> > For XFS it was a lot more work and I still see tons of compiler
> > warnings, which I'm not entirely sure how to address.  Right now I
> > see three major classes:
> 
> And in case anyone cares, here are my patches for that:
> 
> https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/cap-analysis
> 
> git://git.infradead.org/users/hch/misc.git cap-analysis

I gave this a try, and with the below patch and the Clang fix [1],
fs/xfs compiles cleanly. I think the fundamental limitation are the
conditional locking wrappers. I suspect it's possible to do better than
disabling the analysis here, by overapproximating the lock set taken
(like you did elsewhere), so that at least the callers are checked, but
when I tried it showed lots of callers need annotating as well, so I
gave up at that point. Still, it might be better than no checking at
all.

[1] https://github.com/llvm/llvm-project/pull/159921

Thanks,
 -- Marco


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9c39251961a3..f371a08e5d44 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -140,6 +140,7 @@ void
 xfs_ilock(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
+	__capability_unsafe(/* conditional locking */)
 {
 	trace_xfs_ilock(ip, lock_flags, _RET_IP_);
 
@@ -183,6 +184,7 @@ int
 xfs_ilock_nowait(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
+	__capability_unsafe(/* conditional locking */)
 {
 	trace_xfs_ilock_nowait(ip, lock_flags, _RET_IP_);
 
@@ -243,6 +245,7 @@ void
 xfs_iunlock(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
+	__capability_unsafe(/* conditional locking */)
 {
 	xfs_lock_flags_assert(lock_flags);
 
@@ -272,6 +275,7 @@ void
 xfs_ilock_demote(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
+	__capability_unsafe(/* conditional locking */)
 {
 	ASSERT(lock_flags & (XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL|XFS_ILOCK_EXCL));
 	ASSERT((lock_flags &
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d9ac9521c203..9c4ec3aa8bf9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -472,6 +472,7 @@ xfs_log_reserve(
 static void
 xlog_state_shutdown_callbacks(
 	struct xlog		*log)
+	__must_hold(&log->l_icloglock)
 {
 	struct xlog_in_core	*iclog;
 	LIST_HEAD(cb_list);
