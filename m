Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C573215058;
	Mon,  3 Mar 2025 18:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741026110; cv=none; b=IdzCKorUkBGTUTBHwqlWzjYqSf+udnSsGy4grW5xYyPPfQ3aIOVXrP+rHHcUPs7wBGGORfMj8Rl9heayoJG5AQLTJPnF8Mj6/WfDLVDe89XSm5KNeuSfSU/MgMxZ94WQLVcil/mzVMbGudWKiUfYQc+00HI/NEv6PyAKKohZbz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741026110; c=relaxed/simple;
	bh=qQ9RbbHxETfyug0GfVaqoYXTPk0pB6Cyk1KbM4vwpnA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VS1PcqRxgSaNTvmQ5j1lNoAMWVyytD3ivqKQVuH/GJbeUcl5DaWYsP1rVVdLFXIAPyIMGTfPBAf9Kx2BH6JG5EdRcXaDBHDdrKfWaqc00ap1mrn8xF+RxgTNE6AiOAUqEBjO799LWXATunG52jtgdD4blGqRapDloEOGtRLEsCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F6TBBp0E; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F6TBBp0E"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7c3c4ff7d31so120893185a.1;
        Mon, 03 Mar 2025 10:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741026107; x=1741630907; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HFzZWjcFqsfDxYl0mzTkCHRR3hGJXZp8cboZARo9iCA=;
        b=F6TBBp0EccEdr0HJbG6qWO8ZcMcesMxI/JC0mFnwDbo5ft+4+uWvtcZCvaIab0OoPO
         hyq7RCvyHJDUYkfiLsqZCuKM7wCZgx4Cj0VuL90LMkSm/lpcgZ3qQNBJpDjHt12W5NQI
         8bV2aPf1LdFyZHgKMDULXZ69Ng4lsRzsOuHXULFMMYO/3rboTi2+XvtyBJJHn0R3xVsD
         0fFmp8xMmiWE4H/96SfTZJfZMz32Kx5jzlm1F2HDM+MPFbi5zQNkxvqW/ji4npgYcJTq
         X/K/Ps2/0JP2SYxlEr6fpJuqQUsiSDs2J3ImuK0VKGYuo/5W+FTcNo3pyaHyizlIxkC0
         74cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741026107; x=1741630907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HFzZWjcFqsfDxYl0mzTkCHRR3hGJXZp8cboZARo9iCA=;
        b=v7SSLrUeFeyEAgcgm2nNQzpaoHmm0L4Skhu2xMQ2ZUdUsqUu/AeVpLenH8u9mAqAAV
         r43dcmKXq4F3KAMbVg/vr8wArQYHD+RQjFZVQDYEwFG2igzVajaECtUvEgAGXxVT+Ubv
         g02pPZxJDIzVkvMtIptrDZQS+MpMSLfQ4ZuHOE9muu17GAbWuoQ23PjFqKwPR3kMLrST
         QNbND9ftqvpl454GcYN/CwRvYoCv9hpgom3ukhMoSRSSPysmqzC38KfBavtz7lq3EM1Y
         rVXeVYuMPNpq2DFTCCglGaTHpUqdErKHib8sml7ne0Skn3pRAXGr/4oaaWPaBBoj6B9J
         Jv2g==
X-Forwarded-Encrypted: i=1; AJvYcCUjcd0oEyHdWUWJ4kbdWVKkTGJrffApKo91KcvcC7FeJhxekcx41u8lfhu8XHc3oRToyju/aoW2gvOIh43N@vger.kernel.org, AJvYcCVzJgPg0tKfaQ+paLBvQzqL/r5M5aU7GrvxkWEsw0Tb4QxogkG/0hxwrYPO5Pp9pWqTitVEDdl5hzlL1+8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGRgvsa/gAp7URTR9ZfNRoLtWWUuizeWDasIqD10aH2Rhv1FNP
	YWV0BWpDKboyrZGbQDKt8SKWedHxbBczC/keSDi82+ADXn7Ny9mavkvb/aBdLcqBY6qTBgUzGir
	U39NZFCm5d51DDuZUZbzg3zXa+8c=
X-Gm-Gg: ASbGncug+cALk8PBOciqs7oUBMfKRGTkoLurMcbcpDbjiEaJIHZg4Kwvq9UDUihDu43
	mSaWN3EP1G7ARkcCrpzk/bUnJ+RwDZGzL1dTnf/o4uc0zPio6/aqEyjkT/9Fl16wBdYoPusc3zz
	FJBleL36ClQhqaJkDquhizNIl9LgzwXu5oUj2kCaOTRCaJVO8PZlXzQ+fU2Q==
X-Google-Smtp-Source: AGHT+IFzLl7EDIrfRlNRztKKZxawCHfzjGSBK4vOyQk5OfXMs1Mp/lLcfpbA5RL1hdMg34E0AWitNb0abmx0uhun5qI=
X-Received: by 2002:a05:6214:2462:b0:6e2:43d1:5fec with SMTP id
 6a1803df08f44-6e8a0d6d85dmr208171246d6.33.1741026107393; Mon, 03 Mar 2025
 10:21:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303084724.6490-15-kanchana.p.sridhar@intel.com> <202503031847.j1iReOtf-lkp@intel.com>
In-Reply-To: <202503031847.j1iReOtf-lkp@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 3 Mar 2025 10:21:35 -0800
X-Gm-Features: AQ5f1Joteeu0OkDzJuqjMB5KRiGMoPyQGJnXPi01TtEkBA2B70o-aPls5I0oWA4
Message-ID: <CAKEwX=MgV22UBNi-2dNBDgNM2DRfrngk_4gO7z9t-O0KrpdPUw@mail.gmail.com>
Subject: Re: [PATCH v8 14/14] mm: zswap: Compress batching with request
 chaining in zswap_store() of large folios.
To: kernel test robot <lkp@intel.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, yosry.ahmed@linux.dev, 
	chengming.zhou@linux.dev, usamaarif642@gmail.com, ryan.roberts@arm.com, 
	21cnbao@gmail.com, ying.huang@linux.alibaba.com, akpm@linux-foundation.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 3:07=E2=80=AFAM kernel test robot <lkp@intel.com> wr=
ote:
>
> Hi Kanchana,
>
> kernel test robot noticed the following build errors:
>
> > 1166                          prefetchw(entries[j]);
> --

Why are we doing this anyway? Does it have a notable performance
difference? At the very least, leave a comment explaining why we're
prefetching this (although the build error suggests that we have to
remove it anyway).
