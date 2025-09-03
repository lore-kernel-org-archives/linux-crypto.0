Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FCD2FAC12
	for <linux-crypto@vger.kernel.org>; Wed,  3 Sep 2025 11:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756899382; cv=none; b=GdGJ6YjfzhAvRI092dqMWcqPnyGNSvp1vheXtFZ9plhbwYUBEIqEZZusMkwKelnC1HzUmBAL7pv6d3gFdxVnh3sJBQcnVMQwwTuYHRU5cpptrnPvIdi4u9vm/NQ5mY55A29yGIPPSkcIcodYB3W7v7AFljsEM/mAmusFQXVmkAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756899382; c=relaxed/simple;
	bh=1S0oCNu8oF/vMuMeRiEdBUA7z3A55yPQtE9fmoNeTcM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XjgA0l1SFziRQG+NpKsovl0gElh+jZl0e6jmxsAxXgc8TKmITJcBJKd9qYCwQ9JkY5A+q9JODH/bKZeHiKFJDvtxeTG9rhhwoYTOoSZVfQ/rKCUqSMUwr3/haim/AwbQrycadok6EcM4I6yqjk9niBX37zB6ck0GmZ6oGxkzAas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gyhv/EF+; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gyhv/EF+"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-722e079fa1aso8080106d6.3
        for <linux-crypto@vger.kernel.org>; Wed, 03 Sep 2025 04:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756899380; x=1757504180; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a3IW4gClMpsxg8pegPHxJ+hydJ79H7ht+ce7OmUzWyQ=;
        b=Gyhv/EF+fGymevRyCu0EVkNBMQvLeQdRcexx1ZShr+sy0ozKNfLVd4thU1m/VRsY7d
         fqczt8DKt1DxNSeb3b4QesHHzmBDZ3dUA1mYWprJvOGM4PrXoeJj88b/Ym76oEF27bT4
         KIEUAPdr8UyuqEI5tO3ur3RSoipl9SMeEhbZnVGqxCkrKo0LIgV1BzCO+8eUij/ZKWrT
         Y2MkmxH9XwG6LzhFCNpmhIZ52lqdx2V6EEBrm4lYK+aw87/An+rAbP7qDm9HtzybwA+7
         DDLV7Z5AbnimY9uUOE7ZVcsWU964mrlWd3lPM+sKZBbN40Kxj8c+SHNXWdQzhJ9UIujr
         5Lpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756899380; x=1757504180;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a3IW4gClMpsxg8pegPHxJ+hydJ79H7ht+ce7OmUzWyQ=;
        b=Oi+RlLFeTIJvvC9CApaP4bvos/FBM+q89gx87q1YIms1r421xGsZe0EMGYBJ6BtbbL
         KaNW09rCiHDy1VnbV1rXWg32e/WNJ90LABbQ+G1YMwxoTzsN25hd8DiQDXbse56BdPkv
         yvFvmzhQrX7tUXjxhUlscXSnjmFmlfKblMpGD+SwtJm8gi0z3r8A52PoOnXIkeRyEl8S
         +j3bLT2YLbKMlxKszUDaZMO6fVch1i7OaV6KNDLEDR9H6D/wQMLaBmhXdIK/o3cVm1EZ
         lMnFb5+kaYv4d7dqsxYEsVOnVuqKckADcge5ZnVBpsMmnKXKAlGerLNU1Y3PV0t0kgGT
         9IKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXaIflt7wwNUCcmjU6q6V0taDraXF+nOjAFrnVO7Ran2+w3woen1LXEn7aNvvWd/j8ZEid4JXTP+HMRxs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc8AKYHLbmchIZKtyMjh0sBcxpd2Z9dElTQefxxlmTtmKaUVlx
	uZkryzFaWTyWh7D++d+CZJV8LepTYQziZBBqhvUvw6lbMJThL4AOOccmHrVWReAzlJIjwc9h2Zq
	K4bgYfz0lC2BGHGSprb8X2ofgYm6pf4avtfnHIQnf
X-Gm-Gg: ASbGncu+xG4lFAFYs8OkKbeyBVGr1hFodVSC4dgw9VdInrC1Ohs4eyJUlFSgWiVg8dV
	q0h3G6GNpF0qk00BNNKwXRw8D63LGpAFehbYdInRy9gZVA9v/TC2USuH/aPpw3oh2a9QsqXJ5M3
	QUngVm5HJ/lRCHnUVYBFGAnSAKPKh5XD6P/zDwqqU5OqLzQ2sc1lCQ8H/M+Yzb/xqTPFZUU2L2R
	47gh1PfKpfXP8r/SiEBNHjcAT00xpKgYH+8m0btVsI=
X-Google-Smtp-Source: AGHT+IHt5Uf7f9hHKKGO4y+S7XWf9ByCdyBez8I/gMbmDbS05z3pOWgerpBal3i6mcnzy0T4lRXiKY79hwA2pscstuA=
X-Received: by 2002:ad4:5aaf:0:b0:725:1fb:a6b6 with SMTP id
 6a1803df08f44-72501fbac03mr16948666d6.31.1756899379536; Wed, 03 Sep 2025
 04:36:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-3-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-3-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 3 Sep 2025 13:35:41 +0200
X-Gm-Features: Ac12FXyA87fTSQv-blZ3tbQBrKQAAZ9Bwbod18tXQa26iNm899ybg0GqU8LYCbA
Message-ID: <CAG_fn=U+xi3zjr+g+PaT_41JHSca1W6J72xd5=c0dVrSy75XpA@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 2/7] kfuzztest: add user-facing API and data structures
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> +       static ssize_t kfuzztest_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len, \
> +                                                     loff_t *off)                                           \
> +       {                                                                                                    \
> +               test_arg_type *arg;                                                                          \
> +               void *buffer;                                                                                \
> +               int ret;                                                                                     \
> +                                                                                                             \
> +               buffer = kmalloc(len, GFP_KERNEL);                                                           \
> +               if (!buffer)                                                                                 \
> +                       return -ENOMEM;                                                                      \
> +               ret = simple_write_to_buffer(buffer, len, off, buf, len);                                    \
> +               if (ret < 0)                                                                                 \
> +                       goto out;                                                                            \
> +               ret = kfuzztest_parse_and_relocate(buffer, len, (void **)&arg);                              \
> +               if (ret < 0)                                                                                 \
> +                       goto out;                                                                            \
> +               kfuzztest_logic_##test_name(arg);                                                            \
> +               ret = len;                                                                                   \
> +out:                                                                                                         \
> +               kfree(buffer);                                                                               \
> +               return ret;                                                                                  \
> +       }                                                                                                    \
> +       static void kfuzztest_logic_##test_name(test_arg_type *arg)

simple_write_to_buffer() may write less than len bytes if it hits a
protected page.
You should check that `ret == len` and return -EFAULT if they differ.
