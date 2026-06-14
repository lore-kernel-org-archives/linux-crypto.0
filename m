Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7731037BE9F
	for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2026 16:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781453691; cv=pass; b=kpuX0b0wTWH7fBj3nF9eZQbwWi/Z8Lb/RCKml/+nqnWxLDyHgGsdLWKJW8L9NZUwQnzaPcteiS6irHiA7DE86JW4YkPakBMIoW91iNp6huGjld/CAgdf0rnptRz01Qfi6Mukhe9+Q5U0iji6OTU/Ey0Q9CFS+7yHa20Q4cg0kiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781453691; c=relaxed/simple;
	bh=GafyeebZAzgXIwpDZ/XxAtB3YDhyuA1vtDBy2V1SRQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ll0TjJgstsibjm9+V+ZxGIFri9lPGy9sexiArtE+UvKCX5a2oa11F1ButBALJfGJie8SQENVTrIUdtwfXJGhrniMittWqelDX2T9pAb1nuORUFPgxX8f3Xeri5QMejaDK0TgyKjQRQYu4DPIT6H0KS3IzHtymaNQGXB4CPXibbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XUTmy7PG; arc=pass smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XUTmy7PG"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7e266714bd3so27462927b3.2
        for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2026 09:14:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781453689; cv=none;
        d=google.com; s=arc-20240605;
        b=agA2rXh3SmDRmxUGYcyEzsbpOJZjLF+XZu6C9PtdA0vimWhbc0UEVmtUr0kNJGEH+W
         Zvj/M9j3Ng6XsDTM71X0Nfmp2T+ZYeKCKTmbQonGVj7mJT0taKViBe2eVq9+a1rJCWzj
         CYFnLecuoGZl25q+2KK52eXzP+892btgyym0Jq/Q/Isj5Ayg1WWRrFVR1nlWJQ2TEjWr
         THjFuwYQgjyMGO2N2khqezFKKBiPftW7nihkqPQ7Uv98KhK2U7KyJHoZnZRnQg+kFRf3
         i74nKdpxPiwgHunXSxJuQ4uVZR6V9uK0Yl4rHE2lQedme5AKQsKe9P+9UOTF+FthQ1Ui
         TMrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ty5lBs7BYCuv0nBuQV2yqa7LPhpPLdyc9ZwRXmG1e1M=;
        fh=3pb4NkQnkRzHlnlE7ZYYEzllV3I2oHG4W6IFaxBWG7c=;
        b=YdZMNnZVCqeqmH4ZIC2dJRrzlSiUVtku0WlphaeKt9lu7YLVssXj66FrcQV67oQvAt
         vCMqspC2NOr1DXAgy1yAZaYYVvkUwydqKHro2i+xwjQBi0TsKzweMshYuRBV9oUzRJcV
         uqHkW/0S7xdMCVvFo+J+k+u7ZudXqa6rSXk51bvxAiNpVFIfSwEITdR26+Ar/Bc4KV1Q
         YE6urFlKZupoEx3D3LMXKWYINIv6iQO8HyS9VU67O5uB/aloRqCLEY033jbzp+CP27by
         +YTI1dU9AIpIQkHRMAgmhc06Z7LPX38RtpWCtf9M38+E8E5SkYLXNPdxMsDNtKMlfRpV
         p3Cg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781453689; x=1782058489; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ty5lBs7BYCuv0nBuQV2yqa7LPhpPLdyc9ZwRXmG1e1M=;
        b=XUTmy7PGnqvfuM473dNwh1C7K6lBu6VukOxzAsS9E8FuE9xx4HKQ4WsVmaFdW1QYHx
         Ar1eNKkajF8AD/3hCW1FeX0A0vulHxloQXKrA+eM/YfYQ1OmCrsm5EXCFfZeMOp1+RrK
         TeQ43glLoFd+ghdQa4Cm0BWGnZqTOob76mIpKsxwkVfjsQIdpXXNPnwhf4SDKYAmA4Ls
         yNFea5pNvbw9uXukO/Yl78LYl3mOcpGeHESYduGpJ/n/ExD/PktUCGonPDldk8OH13hs
         CY5iDi01CwbnjCGWPNhDZKG/pzkvCc+5STdTZySpL+g8hyrk0ELdkkBisEx+vwViIIu2
         idIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781453689; x=1782058489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ty5lBs7BYCuv0nBuQV2yqa7LPhpPLdyc9ZwRXmG1e1M=;
        b=f8BfrC+MD1rRVx3XhI5F5+VKjGp4PxepZOVYpuJnw+6vHbsYKD5RijAQiTAQ3Sc2V6
         cP8b6zSaxTu+udWwqRBYJdsq3n1emzB61LMm83GW6EjiHZ/+dv9ncxopUREMzXsAywAW
         /HIajHeXT8/dRNxOcXbLjU9UnVkgl8pdOPVpP3qdqleIdg/1O6yTX43RsaQx8ZuU5XB2
         b6QvyVrd4+Tgqu1vfMLjo6A376jgM+cj7rROHKHhKCTgT7IVQ5vqAu/vdEEhLfOtBI9f
         U0QbXD8YT/KQhskpJ7gcLaxKdJRDw/SzN9kLj7TB7p8HdCprpoJsdI30xiEDbE2Ko+fZ
         UZMA==
X-Forwarded-Encrypted: i=1; AFNElJ/ZfUsPneeQEG/BfY8Nuaz8KzSt+jfTSEKrFgE5GuohPLy0fVXU3TJQ7lsaWONsQ1Ke/qvYC2am3u1mvrE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBfRtvjuCOT+QsCXnyM+V/76WqYgaJaiSpF1a8+i9oDPSD6NkC
	7TCfq++tfhxeXJgsaTstJvDx1nIqh076tEDvncnP+/urzhseNWHlOep/sQ6o1UQ/HFN0p2g+D1N
	nrV5VpxhvdmSLUcwckJ7AfEsrMIGedHo=
X-Gm-Gg: Acq92OG1Go8rNP1vD74flLg6j3Z9RIChVaS+mf2J7jldgstfDeE9SDhjX8bTeUagLd1
	wDufyEHtx9m38HOdfO1i4Y05/yqnkifW9Qu+RWBgoXV9NW1HUiWWj4+KhFknnT5B/yCW7dJfGMt
	Uh80mg5HeR2TN/PB6GnIVNKTQMQ8AWKCQLatFeEP0kncznjSgS2XjV9R3gw5f3TxFGVG9K1u+E6
	9gTx44rpAjAUiSXPkTennL1PkdJVsSYyrJKbcRBCMPkbzNKVv13bSsTs+HKQaaoGzHftiOVsHNK
	8Xfv42/QneE2Xxgz5sVwLBAOhJBV5/o4HRJN
X-Received: by 2002:a05:690c:4a08:b0:7dc:61c7:5929 with SMTP id
 00721157ae682-7f8c1e186fcmr72702827b3.14.1781453689525; Sun, 14 Jun 2026
 09:14:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260531142251.2792061-1-michael.bommarito@gmail.com>
 <aio83ZWadVTiuNpR@gondor.apana.org.au> <20260611025916-mutt-send-email-mst@kernel.org>
 <aipn8sIAQ6Ai2sax@gondor.apana.org.au> <20260611035035-mutt-send-email-mst@kernel.org>
 <aipvZhfvdtRxOQm0@gondor.apana.org.au> <20260611050731-mutt-send-email-mst@kernel.org>
 <aip9nja-Oz2RxkWi@gondor.apana.org.au> <20260611064040-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260611064040-mutt-send-email-mst@kernel.org>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Sun, 14 Jun 2026 12:14:38 -0400
X-Gm-Features: AVVi8CcUV6kBzoaAvDDRMWKFTCSd_vc02sh0mmpZIxeJVk8RGpH0yKfWyYpQUKU
Message-ID: <CAJJ9bXyihwkBc71jWbvmPHU-s5=i5G19g5jP-d+5-3_G6MW=cg@mail.gmail.com>
Subject: Re: [PATCH v3] hwrng: virtio: clamp device-reported used.len at copy_data()
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Olivia Mackall <olivia@selenic.com>, 
	linux-crypto@vger.kernel.org, Jason Wang <jasowang@redhat.com>, 
	Kees Cook <kees@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Dan Williams <djbw@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	torvalds@linux-foundation.org, alan@linux.intel.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 11, 2026 at 6:43=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
> AKA defence is depth programming)
> Alright we can drop this. No biggie.

Sorry for the delay.  I'll ship a v4 without the nospec

Thanks,
Mike
