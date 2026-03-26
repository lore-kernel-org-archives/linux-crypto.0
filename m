Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F95387377
	for <linux-crypto@vger.kernel.org>; Thu, 26 Mar 2026 01:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774489141; cv=none; b=uB9n4ihlZ6Dsch94t4pI8wmhRPZs/uTO1iILH5rrIzUKLbN4D+YBpOe4Gq4yqqpZkOXtVtRUsx4GSRtsRLwQbZsnd3H5BpKlliPGhRr0jf8fqLzzP5CQzdACdQ6/rQyjw9/2xiFVVLWm0bF6vTP7WO2YLccvcVmcDxL2G3BYupk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774489141; c=relaxed/simple;
	bh=foagc7Wp0Yy0iTrB+4NGBiIt4PUxdnmRNSZZbM9ZZLU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oQhddyNXutGYleQnHjzbssJ+1p7LFEquqnI+cASvnQODBuVoAiaTMufeACigmPgi3SRnSNKSzbazdvCqZ1hnvbYCZ2TwuvlcU8lKAWLCMppExI6+wv2cHQhpmbxXKgbq2nLEnvLW0d14PvkOP+DEq0hXVGBxRtaYXXHajgKa1HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=O4tQcBW8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="O4tQcBW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A76C4CEF7
	for <linux-crypto@vger.kernel.org>; Thu, 26 Mar 2026 01:39:00 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="O4tQcBW8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1774489139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=foagc7Wp0Yy0iTrB+4NGBiIt4PUxdnmRNSZZbM9ZZLU=;
	b=O4tQcBW8MkIJrQGJtaLmt6YCloYcRsi7uqvATCa/AZ6jfASGD9BMqiBG8eySY3fg2dq1lQ
	bhncTr4y3zWagieS+GPXZmMNDdkZGU8iJBggB3bkfS+xMA8dCiuOEMgOdLUyHZmX+oHcV7
	T4zoPPZZdCbCed/zhNeo2mAo8sxXFK8=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f3ab7043 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <linux-crypto@vger.kernel.org>;
	Thu, 26 Mar 2026 01:38:59 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d7f09aa39fso536246a34.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2026 18:38:59 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz1QCIkfJLtuT8FV+OZJNlqd60j2wv7LCdTpjB4sR3bLVdvYj3x
	em9A0nZQOzYHbohL+N41DHvLTxVzBEomJE8vlYsZWNRogCbwHZ+f/7cVY3EbyW8kp4O9pNzt5kH
	CAsdILy3kEWaOvNi7T/M9BGdsMwK1v+0=
X-Received: by 2002:a05:6808:4f52:b0:467:272e:87d with SMTP id
 5614622812f47-46a5c5e6d2bmr2736940b6e.14.1774489138180; Wed, 25 Mar 2026
 18:38:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260326001507.66500-1-ebiggers@kernel.org> <20260326001507.66500-2-ebiggers@kernel.org>
In-Reply-To: <20260326001507.66500-2-ebiggers@kernel.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 26 Mar 2026 02:38:47 +0100
X-Gmail-Original-Message-ID: <CAHmME9qWks00NyM8-kLKCcZNM6LAme5VZJkgrpg3ZVjbZFtH4Q@mail.gmail.com>
X-Gm-Features: AQROBzCJ25AVxxCw82kvwIDOzCNsvGSg3pNYVw7NlpeaEvIucbiRLHY3ALrs6hM
Message-ID: <CAHmME9qWks00NyM8-kLKCcZNM6LAme5VZJkgrpg3ZVjbZFtH4Q@mail.gmail.com>
Subject: Re: [PATCH 01/11] crypto: rng - Add crypto_stdrng_get_bytes()
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

I'm a little worried about this because I don't want to see a
proliferation of crypto_stdrng_get_bytes() users. How can we be sure
that this is mostly never used?


Jason
