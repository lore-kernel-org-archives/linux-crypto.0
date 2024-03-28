Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41D24D5AC
	for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 23:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711667124; cv=none; b=OTVFF0+MKUB68GZ1WgKJP/c9wCNfP8cEd8xW7KHMQgbt3Fug8Us76KI99J1ObhdRo8wR2+7bsOc9Iv4naF0FuFvd0B7UD2FeGL/e2NtCG9N1I4K1xWllyFLW0DDURrkavbtYJdO/vbJu80lxzQoHJr/1OTbAx/VM3w6/PlmTrnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711667124; c=relaxed/simple;
	bh=z3tf46ej8qpBQPDevbtFzGy9O5nWOl/MaSu7nJvWxGA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MKhAsgEWaHPwVJulE/0h0okuMKFN3TYVBKPprtZyvke45Spt1JH8+f2qszQG9AJxYBnqck+J7EsP0ZmJeEJAWlorKts7ebooBYRej64Wu9qGK0DjaaDF10uCG2OJUW3Oi7dqKid/HsR8uno/fkI0TX1E/Un7cA7TehiBsY8OFm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=whoze/eT; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="whoze/eT"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-29df844539bso403142a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 16:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711667122; x=1712271922; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/3aFzydSyExlB9BmbA34QemVRJ/ZXxJRv4umeOt6fqw=;
        b=whoze/eTuQ7WCfQ2KvL3NhiXL9NdmAEclm+rcZS0cncIpOf/Vikox6zms2HxC9Ae2N
         4cWzjapfm+Ag5yRjl++DCupMT9G0IjnCYZ3nNC+kJfMkiLbw5EVML96+SqYgGbQPf/VS
         bAegt8fbYFAnyvUsUkMvGFyBvyRQ5XH1TQCwZ8wp/hMoUEc+ou+Jdrl/U/B/9hbIN9Pz
         ca5G59PaLbaPt/Ea3p2x0ca8jA0mNfAZEvQ0udRXouYnoxRhALy1hoiVPXZMyYFszsBy
         Y+cdwWib2eaKcRcCvB5aEASf2HOtQ3qrKmO1UrZPwMKUknip7iwA4w74FrCGZOhdUpof
         hOeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711667122; x=1712271922;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/3aFzydSyExlB9BmbA34QemVRJ/ZXxJRv4umeOt6fqw=;
        b=jbwY0OwZk6K7QNTZCyn/zdjIl9qLDJsWUvpc71pwSWiPZ9yBCakFJWKhlKPykEkTAk
         PTu1dnQw075vF0KUEly108qTu8AVr3LDUxmI0Jfnq6t5GUMn28yIleI54QLPSRKaqVKW
         SDGJaM5aZHPE562P4JDSq8s8i3WbCG/hsbxZpiK44AF09mHsdOB0e0juLpCiY3w/2iMe
         En3MCEATJWT/W3RRuOSiIdlJkLCZoR9o5wsRFxbBPWJohm8Jk+gI5emXQvjqHo3MDLQ1
         5Ycz4Tuiy6MA6sniF45Ps0LD2IXiBU+TvVCbW9GeolB0lcd3WB2ZsGTiLzJfAykZ9wVe
         FJNg==
X-Forwarded-Encrypted: i=1; AJvYcCWafsFijQOQoQ3S+thq64nO2B4/+dv/02CKKTxs5QdlocNmZEXsvQg0OU1MQjSUcl2CmgeR2BvqEntKRrpYAr55cxJZ293xuXkkG1LS
X-Gm-Message-State: AOJu0Yw604Q/u6s5DQQOHbB38Rni19M/OBG08K2vsZL8UOX7A4ipHdlt
	y5mf/C8/zyzZIVcAKp4AjIXV8m9Gz/r3uM1kDd3eubIVD9xw2uePdjZDLCxbBqs=
X-Google-Smtp-Source: AGHT+IGt0gkc119snKbJARF7UnrFMVXsS7gpTXjZzbZBfCEKd0wr8mr1SMS6Ds7kY42qafqSBM/uug==
X-Received: by 2002:a17:90b:3504:b0:29b:780c:c671 with SMTP id ls4-20020a17090b350400b0029b780cc671mr907698pjb.0.1711667121826;
        Thu, 28 Mar 2024 16:05:21 -0700 (PDT)
Received: from [127.0.0.1] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id cx18-20020a17090afd9200b0029d7e7b7b41sm4013902pjb.33.2024.03.28.16.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:05:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <naoya.horiguchi@nec.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, David Howells <dhowells@redhat.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, Kees Cook <keescook@chromium.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Pavel Begunkov <asml.silence@gmail.com>, 
 Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Joel Granados <j.granados@samsung.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
 io-uring@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org
In-Reply-To: <20240328-jag-sysctl_remset_misc-v1-0-47c1463b3af2@samsung.com>
References: <20240328-jag-sysctl_remset_misc-v1-0-47c1463b3af2@samsung.com>
Subject: Re: (subset) [PATCH 0/7] sysctl: Remove sentinel elements from
 misc directories
Message-Id: <171166712004.796545.8747989552701562593.b4-ty@kernel.dk>
Date: Thu, 28 Mar 2024 17:05:20 -0600
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 28 Mar 2024 16:57:47 +0100, Joel Granados wrote:
> What?
> These commits remove the sentinel element (last empty element) from the
> sysctl arrays of all the files under the "mm/", "security/", "ipc/",
> "init/", "io_uring/", "drivers/perf/" and "crypto/" directories that
> register a sysctl array. The inclusion of [4] to mainline allows the
> removal of sentinel elements without behavioral change. This is safe
> because the sysctl registration code (register_sysctl() and friends) use
> the array size in addition to checking for a sentinel [1].
> 
> [...]

Applied, thanks!

[6/7] io_uring: Remove the now superfluous sentinel elements from ctl_table array
      (no commit info)

Best regards,
-- 
Jens Axboe



