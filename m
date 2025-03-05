Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FD424E4B4;
	Wed,  5 Mar 2025 15:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741188501; cv=none; b=ag8LI4CosYWiinngQ4LrM9helUVH7e1ISQn+EVkt6plCscrOojyPg1SBWpsD1UaKYqvLS9zrFIKSJn2YcsQsUaIIgq5xuSozYws9RfDnm5O5GIkJfP0kvB2RjQ19ecJDiLXULh4bQfQdPbBM2hglehlEtMPxJF3crkUgaykDWyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741188501; c=relaxed/simple;
	bh=FkSGlxwa6Za9SEd5lVxByYyNMnDEy1BzzOaMm23fdT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u7ItmLFEsWD1w18WJ+L8EiJtRLZjjZGHlw20juxKHZhONrYKCzKL/O7AtSwJFQjgIakRS0hxqDmkO5E4nOZKghm+pbGo9cnvzySX8S+zitmysoM6a6SMpUWPzFpX8QHG+pos1F7MJAX9uepyOpH2Tw5jyZc4CjdKFhdurFjwbLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=q8IjToJP; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="q8IjToJP"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4Z7GfB1L6nzlgrvF;
	Wed,  5 Mar 2025 15:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741188491; x=1743780492; bh=hY6jxVsAnHOCHywkDBxV1aWm
	itqfJ1ddK8tCRoZT1RY=; b=q8IjToJPxYBXMsEJewI4PeBnW9SC+ybVJpbMF3on
	noQNqBpt987nLyB/jSAGEeYz4n2SqdhJpkeRbwFr/rp0QSYVq1jO9fSdc5jz/OCj
	/1KX/jHLglF53q52/3XvV40TqeX+IB3C08iQJeovSpfKs1M9vtEkrTf+9wDWP/sv
	CIY+7Ue1s7YQFkSKE7T2/W/ghONy/xGbJWC4d8tWOtAi1+oxIl0ahIfRJ2LBQMGQ
	9wdmyzMmeZ+YpQKs6i2dInySRAO4G/Z5or48ijPSr12ooKs8N15OUlAfoXkPrycj
	gYDDRCJ39963QT/H1hKm31lq2oWG6Q4RAKD1pj8Tg64gKw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Gnv6XcKP6Kp8; Wed,  5 Mar 2025 15:28:11 +0000 (UTC)
Received: from [172.20.1.83] (unknown [192.80.0.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Z7GdN2P4fzlgrv7;
	Wed,  5 Mar 2025 15:27:34 +0000 (UTC)
Message-ID: <76f8c8e1-5f32-4f31-a960-9285a15340e3@acm.org>
Date: Wed, 5 Mar 2025 07:27:32 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/34] Compiler-Based Capability- and Locking-Analysis
To: Peter Zijlstra <peterz@infradead.org>, Marco Elver <elver@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>,
 Frederic Weisbecker <frederic@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@kernel.org>,
 Jann Horn <jannh@google.com>, Jiri Slaby <jirislaby@kernel.org>,
 Joel Fernandes <joel@joelfernandes.org>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Uladzislau Rezki <urezki@gmail.com>,
 Waiman Long <longman@redhat.com>, Will Deacon <will@kernel.org>,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-serial@vger.kernel.org
References: <20250304092417.2873893-1-elver@google.com>
 <20250305112041.GA16878@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250305112041.GA16878@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/25 3:20 AM, Peter Zijlstra wrote:
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 248416ecd01c..d27607d9c2dc 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -945,6 +945,7 @@ static inline unsigned int blk_boundary_sectors_left(sector_t offset,
>    */
>   static inline struct queue_limits
>   queue_limits_start_update(struct request_queue *q)
> +	__acquires(q->limits_lock)
>   {
>   	mutex_lock(&q->limits_lock);
>   	return q->limits;
> @@ -965,6 +966,7 @@ int blk_validate_limits(struct queue_limits *lim);
>    * starting update.
>    */
>   static inline void queue_limits_cancel_update(struct request_queue *q)
> +	__releases(q->limits_lock)
>   {
>   	mutex_unlock(&q->limits_lock);
>   }

The above is incomplete. Here is what I came up with myself:

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 248416ecd01c..0d011270e642 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -945,15 +945,19 @@ static inline unsigned int 
blk_boundary_sectors_left(sector_t offset,
   */
  static inline struct queue_limits
  queue_limits_start_update(struct request_queue *q)
+       ACQUIRE(q->limits_lock)
  {
         mutex_lock(&q->limits_lock);
         return q->limits;
  }
  int queue_limits_commit_update_frozen(struct request_queue *q,
-               struct queue_limits *lim);
+               struct queue_limits *lim)
+       RELEASE(q->limits_lock);
  int queue_limits_commit_update(struct request_queue *q,
-               struct queue_limits *lim);
-int queue_limits_set(struct request_queue *q, struct queue_limits *lim);
+               struct queue_limits *lim)
+       RELEASE(q->limits_lock);
+int queue_limits_set(struct request_queue *q, struct queue_limits *lim)
+       EXCLUDES(q->limits_lock);
  int blk_validate_limits(struct queue_limits *lim);

  /**
@@ -965,6 +969,7 @@ int blk_validate_limits(struct queue_limits *lim);
   * starting update.
   */
  static inline void queue_limits_cancel_update(struct request_queue *q)
+       RELEASE(q->limits_lock)
  {
         mutex_unlock(&q->limits_lock);
  }

> diff --git a/include/linux/device.h b/include/linux/device.h
> index 80a5b3268986..283fb85d96c8 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -1026,21 +1026,25 @@ static inline bool dev_pm_test_driver_flags(struct device *dev, u32 flags)
>   }
>   
>   static inline void device_lock(struct device *dev)
> +	__acquires(dev->mutex)
>   {
>   	mutex_lock(&dev->mutex);
>   }
>   
>   static inline int device_lock_interruptible(struct device *dev)
> +	__cond_acquires(0, dev->mutex)
>   {
>   	return mutex_lock_interruptible(&dev->mutex);
>   }
>   
>   static inline int device_trylock(struct device *dev)
> +	__cond_acquires(true, dev->mutex)
>   {
>   	return mutex_trylock(&dev->mutex);
>   }
>   
>   static inline void device_unlock(struct device *dev)
> +	__releases(dev->mutex)
>   {
>   	mutex_unlock(&dev->mutex);
>   }

I propose to annotate these functions with __no_capability_analysis as a
first step. Review of all callers of these functions in the entire
kernel tree learned me that annotating these functions results in a
significant number of false positives and not to the discovery of any
bugs. The false positives are triggered by conditional locking. An
example of code that triggers false positive thread-safety warnings:

static void ath9k_hif_usb_firmware_fail(struct hif_device_usb *hif_dev)
{
	struct device *dev = &hif_dev->udev->dev;
	struct device *parent = dev->parent;

	complete_all(&hif_dev->fw_done);

	if (parent)
		device_lock(parent);

	device_release_driver(dev);

	if (parent)
		device_unlock(parent);
}

Thanks,

Bart.
