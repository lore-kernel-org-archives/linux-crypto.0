Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B75176FAC;
	Wed, 21 Aug 2024 22:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724280097; cv=none; b=Avg5EI3WTmrvzjPLvn4dC1rqPsaBiwLCbh0iuF914ygk4Eef5NClw+1UbwHh+S47D3RvD+dh327k/fE68q7oikp/Ey1rgl+aMOtqBPRqW2C982fjC3jguCR91mtjFf94pwC8toP0mH4A8Zvl6kn0J4yt3yCB/dQdsZjJ0ivqCaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724280097; c=relaxed/simple;
	bh=MU5eX2ZknS+WS6wreHZexZd69rODrhjryDKYvVR0OQ0=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=LZ8M/0CD4iat6Yur580jdiBOFMwh6atxQhgTcomMSQb7N4KUnF4xD5Nla76we3+H2ksT/UjzyLmeW1DHFZoBTfaBogCaBiW9//asF9i84TbNMu0rWPIUBhqH4NxHFavCS0AiwPpRDEzXzfxxJYs46tFbXAj9YggLvmop/3fHT5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=URb/BoIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="URb/BoIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E2EC32781;
	Wed, 21 Aug 2024 22:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724280097;
	bh=MU5eX2ZknS+WS6wreHZexZd69rODrhjryDKYvVR0OQ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=URb/BoIaWRMpk4YpCvjH6goKjrz9oJD+taUF/8zSjzkMVEFIZ1k5RQGe1qLUb6YHN
	 aT/7rFWa2sA/xXFFV/da/lvlFiAkJpDg4AWM2qtRRn/P55/TRXKDhsLWS552xqXNni
	 Tbj5xzqnL8rBXmt2qykcvLRbL1f/upaZl8A9z5hM=
Date: Wed, 21 Aug 2024 15:41:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>, Daniel Jordan
 <daniel.m.jordan@oracle.com>, Waiman Long <longman@redhat.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] padata: Honor the caller's alignment in case of
 chunk_size 0
Message-Id: <20240821154136.a09fa0e80903aa9ae17d43bd@linux-foundation.org>
In-Reply-To: <20240822-max-v1-1-cb4bc5b1c101@ti.com>
References: <20240822-max-v1-1-cb4bc5b1c101@ti.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 22 Aug 2024 02:32:52 +0530 Kamlesh Gurudasani <kamlesh@ti.com> wrote:

> In the case where we are forcing the ps.chunk_size to be at least 1,
> we are ignoring the caller's alignment.
> 
> Move the forcing of ps.chunk_size to be at least 1 before rounding it
> up to caller's alignment, so that caller's alignment is honored.
> 
> While at it, use max() to force the ps.chunk_size to be at least 1 to
> improve readability.

Please (as always) describe the userspace-visible runtime effects of
this change.  This helps others to determine which kernel(s) should be
patched.  And it helps others decide whether this fix might address an
issue which they are encountering.


