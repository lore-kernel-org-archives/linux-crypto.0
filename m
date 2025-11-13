Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71533AC3B
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 10:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763028147; cv=none; b=RnN0qNvCAB//vMdeL5VL3FGi+F9lR0HSxRPMC5nmVKLsNGiJWI0PfNPZQVuwHnh5IIYC/0xMH68cY4+mQSj60IUIXIb2exTfFP3V6QPwYb47JG61318oel8Hq2QD2Q1TOveDcYYK+jnKO1o73L2Nk1pgpjLwkvK3WRLvMHC6Xz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763028147; c=relaxed/simple;
	bh=347InnF7w0TQGwF3LKDpkxoBP63o1pAQwc45OEGOOng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RL1X+oTS+d7FlPjD0aBj/AKiD7z/nRZcx6rSxuOsnlxKIjhSoZPDJtjnM31mJaaqSAnpPS3ovXDhimQpph259MOJQVE4S/FU/mpBe0CF6w+W8eXgPiwGmNHvXdJVSslCc6j6MROzBojWdmP7YqrbxP05U6XNUz7kt2UNMnNK3t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=FFz+VPhT; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="FFz+VPhT"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-37a3a4d3d53so5528691fa.3
        for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 02:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1763028144; x=1763632944; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=347InnF7w0TQGwF3LKDpkxoBP63o1pAQwc45OEGOOng=;
        b=FFz+VPhTnQolSJSmG4FCu3Xt4fES5kBKLCd+GhIneSTYDKRGfPN8zyn3eUMQLuodD/
         H2z3dbJ9PxXXRjIXTypnTv7fD5q3Rd/ke6LsB+xiLQUaKflb+Wnx1eYs1wITzu/OVP9b
         aiQMqhgD8S012hXS5cNwQrhvYHpCByonyFcXG3j7AOXGG6rN+GampPrA0sRvyyGO/3vz
         zjd8sdAl75JUdv+8J4VnsuXD3OZ/I0yGFVt/xMOhgUO+SwPyJp5Y8RUtnSDToJOGyxYb
         XKLGpelNvpUjvGQhJA54sg7e1sOfozlMiFDTN9BV6FpwmJcpSPfww6fSimPKkmYoJLsd
         p9uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763028144; x=1763632944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=347InnF7w0TQGwF3LKDpkxoBP63o1pAQwc45OEGOOng=;
        b=UVvKPaobpxLoTMf8mPL449eP/6Sha+LX4P/hPhz/w1S2WqPvKYxyDHESqW+/JpdUI/
         z1qmghYpNchAIuel4HFVVpQsaYZCw3bZJyIE/z/k068gqwaKbZC6ycsosu7N6pj4Fx2X
         5iyEEhlZOPxliVGaFKmnd5QFugnAc5FZz++BXeJicPodQAOGk5enJReOSV8c5p0KDR19
         +GZPb+QcNyArz+RxRuwOFfVz8/0rQckwx87jPzpgLpEdqrH32SK7bF3sxM3T77tPhBIy
         ZI7InMNtFy6fY1xTW0CiE7bq6SY3rSrzRvkixA2Y0hLh+LrVKow17Kk8YmdnmKbFwE3P
         YDGg==
X-Forwarded-Encrypted: i=1; AJvYcCWeBqO6rNMBg9PS+uoKKD1xkVoQbZEMuTuTqj5bi/1NU8gv1Oe8Qd3cuakgYZ2Xt57t/Xk6B7pJ8NqGFLk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyhha1I2D61Fe+ldWb2e4cALtNs9stzOfFZ92Qq/rAegiIIPPkh
	B6pFFnRpR5VJ0yG0gB17pq/jWGVXeaJd8Ci5tSseWXdzCR0Jtq9scxfXCJ5dLry3JD1ngIcp2wT
	xvNE3lK3Nw8j6KU3aU3jkHwxqy2YxWCXP3edRwwaPGg==
X-Gm-Gg: ASbGncuDPdg3BJQWg3CuPFYJScZ7k1IAbVq+ZXw2/p4EvKSm6uPqqGHTSsDUnqUmTyO
	sv1hoj62EspwqgU6GgTra3NUHPism66Om/yRm18kx7WIP+3Kdk1fYDgKlVfBGuZaxiEVvyNOdgv
	xRqNGFCcjPcr9hhlFEY3IbSurZm8CKppcumqFDxA52Kt2RM7+NngN+Nmr+JF4/OxszzXCDATEBD
	6PYKbcU3RztiLvtHUXwR6b+vaDEls9GGMKXRUaZpgh91IE+Ep1HsCBt8PfZ6iI3kK/cfCp7uSFq
	lnNc+hwhue1Rsm9wgWKVaWof2e8=
X-Google-Smtp-Source: AGHT+IF80BtPctM9eC4e7ij+kECyiSMuMR8eaI6A5q1UsvTkOe0o1G32eF/kAIX8FZ3UAPGxB2FJF3dPMAqvlpNwJF4=
X-Received: by 2002:a05:651c:4191:b0:378:e055:3150 with SMTP id
 38308e7fff4ca-37b8c2e1512mr16366071fa.5.1763028143794; Thu, 13 Nov 2025
 02:02:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251106-qcom-qce-cmd-descr-v8-0-ecddca23ca26@linaro.org>
 <20251106-qcom-qce-cmd-descr-v8-1-ecddca23ca26@linaro.org> <xozu7tlourkzuclx7brdgzzwomulrbznmejx5d4lr6dksasctd@zngg5ptmedej>
In-Reply-To: <xozu7tlourkzuclx7brdgzzwomulrbznmejx5d4lr6dksasctd@zngg5ptmedej>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 13 Nov 2025 11:02:11 +0100
X-Gm-Features: AWmQ_bk-LstuhQR3H10ukwySBYZfpE2zb40DoLXgGCclIQAg4lhk-Zsk676Qpb0
Message-ID: <CAMRc=MdC7haZ9fkCNGKoGb-8R5iB0P2UA5+Fap8Svjq-WdE-=w@mail.gmail.com>
Subject: Re: [PATCH v8 01/11] dmaengine: Add DMA_PREP_LOCK/DMA_PREP_UNLOCK flags
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Udit Tiwari <quic_utiwari@quicinc.com>, 
	Daniel Perez-Zoghbi <dperezzo@quicinc.com>, Md Sadre Alam <mdalam@qti.qualcomm.com>, 
	dmaengine@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 1:30=E2=80=AFPM Dmitry Baryshkov
<dmitry.baryshkov@oss.qualcomm.com> wrote:
>
> On Thu, Nov 06, 2025 at 12:33:57PM +0100, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> >
> > Some DMA engines may be accessed from linux and the TrustZone
> > simultaneously. In order to allow synchronization, add lock and unlock
> > flags for the command descriptor that allow the caller to request the
> > controller to be locked for the duration of the transaction in an
> > implementation-dependent way.
>
> What is the expected behaviour if Linux "locks" the engine and then TZ
> tries to use it before Linux has a chance to unlock it.
>

Are you asking about the actual behavior on Qualcomm platforms or are
you hinting that we should describe the behavior of the TZ in the docs
here? Ideally TZ would use the same synchronization mechanism and not
get in linux' way. On Qualcomm the BAM, once "locked" will not fetch
the next descriptors on pipes other than the current one until
unlocked so effectively DMA will just not complete on other pipes.
These flags here however are more general so I'm not sure if we should
describe any implementation-specific details.

We can say: "The DMA controller will be locked for the duration of the
current transaction and other users of the controller/TrustZone will
not see their transactions complete before it is unlocked"?

Bartosz
