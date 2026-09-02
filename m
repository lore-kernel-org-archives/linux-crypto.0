Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7C8494837
	for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2026 12:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788353486; cv=pass; b=uCiQPBg7jn4W3TAR2ryMzJ/Y1SQV3frp2eer3bMC/OktGw6nDNt7OqE6LCqunxiLm4DvtKISL4r2W1T19twyq8Yd9rupIcuGE0aS5K4+sOmqf/ZMRtuKOZFAcx7RPjZg5B41qJP7TDMxY1XDTngqr+5iYIbgP0PpQ/zXpHSMhcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788353486; c=relaxed/simple;
	bh=K+swk/Ji08AFq0DopEKTbabw+5YxSqNaLFc8HIYssWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a8Qhyh1OG0W/F/uhCG4IbiEj6Z38o7St9Ju+3k3KXAc361Vjs35+SwNm8FZBNe0GrqmEhMseqlz4OHRTitmSidAJxl0Vb8NkwQXbAbntki74AFN4/PJEYx1XBR1kZYQsYg+3CW7I89TCpiQkjUJiecafnOS3zXtHPvY0rpHBogc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk; spf=none smtp.mailfrom=fireburn.co.uk; dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b=LIbh+SCH; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b="LIbh+SCH"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-66ce4a63e17so1060907d50.3
        for <linux-crypto@vger.kernel.org>; Wed, 02 Sep 2026 05:51:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788353483; cv=none;
        d=google.com; s=arc-20260327;
        b=pzPohbOZRpUS5pOW/bfNBxPri1uxPt0wzQ9CCBRh3K56q//zd+sOfMeAhx4eU/Fw6j
         OVcekl11EBDx1lCbjvWmFdVwXCw1qCm3o//F6apEwbrqrljX6zv2TgUs+/LCoyMY6jLE
         phHJQyPVeWqM7+EDkS/Al+scJb8U6XUnuyEAXFj17otMP3sNnEQSrXJOrOkWGJOwT+OD
         5Qgv1nIXwwLO8vXo4R2O6xohP6GOBlmWTxLKh+Xfbj+qBZ+mAsYUuXbS2EYPxawO1PHN
         U3fwUHJFVQkLTezkXQwIzNrXgqMuKpPIK3MmmPj45TMI7B6YZgcNE33QwApPxwOPfIAB
         PWmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=aoJYi83K5jDu2HW69kc7UQzbMHQ0VncPovaw06vhQ9Q=;
        fh=5PJzQpBPrVXdAlRBn0IVhhVt1Ki3WXE2Tz6KsznhIrQ=;
        b=CCBAGEjdM5OjY6yMDWlkNNlKuLJuk9PUH9ckshq4XK/snJpBckwvQCu4eMfFWAW3bt
         XN1kEDZLyJkjlrcdg7sGblQtZ07HhZGXUSKBaUdqvhbWuG4zF6JeRM8+YSbkQjssp7BS
         yKRTd9wWJ9USQKpNVLTu/Se+NtO5PHEno1QBNN6Fxv/bMXMsNIUBuF3Dpo7Y3JcR6SmW
         S3VtYgBQ2szhh8GLOXqwXMplJwa6HqzWIgaH18niFqxoLc/6eKJtmdG4uXlNx3KPiKAb
         Yl1X9YQxX0BGluISX0B5rHmhQzSY6hQO7N4CBAFawb3d5wqGUmWMaJLEibOzSKZAq0t6
         rHwg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fireburn-co-uk.20251104.gappssmtp.com; s=20251104; t=1788353483; x=1788958283; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aoJYi83K5jDu2HW69kc7UQzbMHQ0VncPovaw06vhQ9Q=;
        b=LIbh+SCHe7Kztt3Gfwy6XNZRmIF5lVKD4PG+iataVenLJfPDr5z03HhSI04Wr/bCJc
         0t3oxvLMaIZz7StbZVoROXT8P5QTA3rwm2GBXopaD1kSBeMGO8U17Aoy9uyPoTwKkCAf
         B4TBje2UUyztxGNpX6C/Zqp0tNxZ75sQdk/uoC3w6GEf/5ASeSuhypVYMKlAvx1nOwsc
         lE3EQ5kYgnBYsxv6TQpTaH9T5LqSE9Ul+iF2ULn83JDY4S9hdJZ9lRaYRX8me7Q4cvp+
         1j7uTyDSFs6tJs9F+gFRm8p6WGpiuUZm8VNbeiGPHnvA9xfDKnvJ1CvKtUzhTES6r3OP
         /Htg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788353483; x=1788958283;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aoJYi83K5jDu2HW69kc7UQzbMHQ0VncPovaw06vhQ9Q=;
        b=bIwEe+zgfFpJgNXViiLye6p11fHbW46OVq7hOphJGI34gkofWPLB0J0vtiWrd5htI1
         1Zv+kvM6XOU3DXDTAWboSzGo621RohX1sWLcD5LDTtOW2YORI9b9If54z5nZiQiR0y8m
         ZVggdPDR7JpdjAbSGCZ6ttLbBTuWEyHlnttKUIp6N0UcZ6eTuIMwIFO+d7yfrFG9I0am
         Uj4AzUN+/2rR8kDTOt9r0hl7K1chnzHEXYlxw+HAIVicsOLSCXsmrj/cftz6dIjm9o4U
         hjc4fA9YyaJzpnm4Xt4cUYS3n/afc4U8M7X3OJ1r1l189wnCdhFWDwnOB9HbDDYGsvbA
         t9/Q==
X-Forwarded-Encrypted: i=1; AKwUvBxx0acwl0p1+gCgeu92yGoNjuw5TtHufBKCQ6bls0Np7QkIC9gIyKl6QCsJRnI+PozXCfY3gRkFd+3kVJ8=@vger.kernel.org
X-Gm-Message-State: AFuF++miMgu0bngyD9xZiIBAjOB2uI/edqRyEVDjo44EIxpWD39ZPL5c
	xVkalCFdcTkr7DOS6NofgQOwMtxrWQI5vf7o/ZG9LaNRBg1jbVEM9SGjwzeCdaTMCzySBakRBPE
	lmEdswUJ2ZyNw1d69ktuSjulLkLj+p25VUCMN/h8D
X-Gm-Gg: AYBFou2lxrRrTLK2sjsN73x93nOFYoFvGnBMkBpf2kKypxJpCBN35vGm4KaK6hDBjnj
	WZrXmlMfrHlSpf7BIiy7bI1GXGOhocT/Z4pGg09i/J2zYuNcFfAkBPNNj++nq/Oi07VFAd2Gxnx
	hzMmfty4xEo8M+l3kOlTkN0wPC9ekhM2RDxfXhFbyCaMkhKOILrs2XdUwOmSnRKsyP/U9kz/Pz4
	uSrlfgnmADNa1dDkQwYPfH4Bpwu1KWrG4FoV2pUjnT/f5VgTif2xDOMB9KN/c7m2lfoiD7ybdaE
	Rr19wH2ufmXo+OdHAcrRa3narGLn1URxeOANwjeKmo8IKVtor1tFT/KaMivHdBXAMj+zNcs4BoF
	kQFgUDkAN97de3N8LbcRke6RiACrdkoHWess=
X-Received: by 2002:a53:ad4e:0:b0:66c:c638:8e88 with SMTP id
 956f58d0204a3-66f9b8b0f42mr1278753d50.2.1788353482983; Wed, 02 Sep 2026
 05:51:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826163004.3365-1-mike@fireburn.co.uk> <20260826163004.3365-2-mike@fireburn.co.uk>
 <20260826220918.GB3382628@google.com> <CAHbf0-H-nZzg=kGkN-yrUdfUUrruyN0x2inQjhXxOy4RAauDOg@mail.gmail.com>
 <20260831170546.GA239479@google.com>
In-Reply-To: <20260831170546.GA239479@google.com>
From: Mike Lothian <mike@fireburn.co.uk>
Date: Wed, 2 Sep 2026 13:51:11 +0100
X-Gm-Features: AcwNN1UyIQqRoEjaX8v-C9V9M526WfqSWSvyF5UWK9e5ESZpZjZxqm_sdht5to4
Message-ID: <CAHbf0-H5pVMz=Vk55K2mNHiA+cYL5Sg3i8aqmqtPR5tYOMjsCA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] rust: crypto: add AES-128, AES-CMAC, SHA-256, and
 HMAC bindings
To: ebiggers@kernel.org, linux-crypto@vger.kernel.org
Cc: ojeda@kernel.org, boqun@kernel.org, gary@garyguo.net, 
	bjorn3_gh@protonmail.com, lossin@kernel.org, a.hindborg@kernel.org, 
	aliceryhl@google.com, tmgross@umich.edu, dakr@kernel.org, 
	daniel.almeida@collabora.com, tamird@kernel.org, acourbot@nvidia.com, 
	work@onurozkan.dev, lyude@redhat.com, gregkh@linuxfoundation.org, 
	lina+kernel@asahilina.net, mmaurer@google.com, ljs@kernel.org, 
	joelagnelf@nvidia.com, bqe@google.com, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 31 Aug 2026, Eric Biggers wrote:
> I'm not currently planning to make the crypto library expose AES
> functions that take raw keys, since computing the AES round keys is
> fairly slow and most users use their AES keys multiple times.  So in
> this case I guess keep planning to use the sequence that is already
> supported: aes_prepareenckey() + aes_encrypt() + memzero_explicit().
> For CTR mode, use aes_prepareenckey() + aes_ctr() + memzero_explicit().

I'll drop the rest of the AES from this patch and leave the one
remaining caller, the HDCP 2.2 dKey derivation, a single ECB block on
aes_prepareenckey() + aes_encrypt() + memzero_explicit()

> But if you're using either key multiple times you should call
> aes_prepareenckey() just once and cache the result, as that is what it
> is for.


Thanks for the review.


Mike
