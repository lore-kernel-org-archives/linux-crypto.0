Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518443603EC
	for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 20:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774039463; cv=pass; b=cCvQ+OGFoOA0SgM5SlPaNM+8iFzqgtpj/rDVIAMzKtNBfdclMSCkQgX373p3CEC9l1DV5xO9fNBora+IY5gg5kUDnGSIBBuiPzNrblK4aGk8koOEPzCT2M5mnfxZWZH4g/UgS4TBvILOSk0S9Rtr9YnS3US+q/0aZon6XA5j8qI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774039463; c=relaxed/simple;
	bh=LsdHqDd8K5ajWXhVBebP/jK8yRaCeFNPT0U03h3TL9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GTAHmWCw8RIQ+CVojkDxXztrxA0xSJhECwm+q/LPUbf0F1CQWx4NQwqCUcctJBAdEooIbZcTZXJ1xk6x3vA445CD7H/TqQY+76U2zruHLou0StU3yp0F+JwZOwl47mkxaqcozyI8ZgwYwYjTlQB1EoqRJudL70L5qRrlGDpiu9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WkcYNH0K; arc=pass smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WkcYNH0K"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-127380532eeso908582c88.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 13:44:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774039461; cv=none;
        d=google.com; s=arc-20240605;
        b=TnXglYQP7PxqVNnD0tck3WHn6Z8TEXY0LOwwXjxxvGiDirYPPhBQF2RaLaqMBF78ZY
         nc1nLgCh48RE5Iwz87/juVqd6KL1JnUrQ6Q/lh67rzET+Ch465lpBPDqcKI2hwv67jvl
         VR2TtvhR4cuKMLu4BGJ7W7Bw50RuZscFuVc9ZOUt17Bun+8ZOdW2N8ppbNGnNL5v8FCZ
         q8uokPIQHf9MZlodtk5OtvJw+f4HCoy1oYo7WpNX30LCL4u4EpbckbJVWg9csClvXvye
         eGSAgcVwZ+AKuRSCQWcHjGxHsK2aGWAlGYNmcX9SJ9mscxUQ0WejZ0weOvqR3i7qUzdo
         JjaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LsdHqDd8K5ajWXhVBebP/jK8yRaCeFNPT0U03h3TL9M=;
        fh=m9zZvJ6pGwVoPqyMdBrmQ0AA+R7T3tEFR2jl5YEpGPo=;
        b=VjCGV/Jf63gv7GBlCtpLiJ7zLy3RuZKva55sB+o4NhDsJG+yi3q/n/SXYyFZBwrrBR
         a35SzU+7YPdkT0WmX1i4kBugmqrPfq/4gQQycqzNc+YI5A2vU5A1Dbmq11sPdp87o5Db
         WaCa3vOzKVQJ0tQcBBgl3cwmWb8z6RH5BGQi0O4INnUADmk6Y1qb/kgd3e7PKGpTGmLR
         Gw/Cw3ZHJpS3lWuOWFYXfganYPFU5Qjx1EkcaqOti15tdIDLNmORT1EDqQ8xMzOvU4TX
         o3nnMjRnTQud1cVYKAf18IsqEYRUhf1bKhEMVYUSEfFLk9vgPwrmxSyFJ1onWUEpIZCR
         9ylA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774039461; x=1774644261; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LsdHqDd8K5ajWXhVBebP/jK8yRaCeFNPT0U03h3TL9M=;
        b=WkcYNH0KZXKBCqADR2jhSuZCF0tf0j/WdVGa0fFSShfkF6O0PJwTlw9UHJ9+LbeNcu
         PeUGA+LAtn3UJt5s1TgIm5zFjE9d/lIBcum3+ix+Rm41PE1xegoxnw/qJ7npxqL9wWrT
         OfGX3rkbMb5pZ/lZjvE3D1Dztn4zWDZ00wuq6/qN0ClGKbhFahHuZPBLhg7Y6shjdGtw
         /YfBcpRcA9I/Z4PcaRjuoYaQ+UzCFpjisNnbBlz1ksVhGB/2p7W4vH84ghJnZ5MzXqnt
         OgbIOKe79MoABI1joJXxcFfUKuPK7GOQKsiBchidGoROPenmFPzZITfOdAIW5oP6t9hA
         /oWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774039461; x=1774644261;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LsdHqDd8K5ajWXhVBebP/jK8yRaCeFNPT0U03h3TL9M=;
        b=mZLV4i2Y+QxzIKl727O44LdKT9NudxlpPkp9Hct1E8qnpqGOT6kkSIDvQJK/yOHKnc
         zZezEn6/gnj9x4CcVb9NPbny6SHWbnLTmw7OigI1khF/ajTl7u8Qo8QrJCqZJtACB9wB
         DnDrnuPqg4NtcTSbOHeocCk8Mrv6BdMLB5US4LTh8ScG7LfiKrHZVzUo8G69IgY1EB2I
         5dwlj+4A3D8sCRtdynOfkZyAq4/rrNBG/EwSRMTnNAGp4emHtpOn3lWy7/9ZrP1pspsz
         ynaFgiaO0PgDvgu+M7HtBDxybbloIt/+AAEbvGE/GuUWkWF3FKup2bp8J8oYdrosAl/l
         W7mA==
X-Forwarded-Encrypted: i=1; AJvYcCXtHy2SzJe5IFi/QoHYA5ViqF+B0Y61VsAU48KWsgjtH4o6+KV3oAZ7L/I1CivS7SQl+BxZvYRgdDZuS40=@vger.kernel.org
X-Gm-Message-State: AOJu0YywD+G5WWdQ/ZUb+BhONLPqlQ+PrA3cHWlqTGNHByHcw3U9arhN
	2c1XZoQYRhpW1GYnt+myUpmYkPBfesTCn2+KW0Te2i4pLv9229Z/aYngHTSVMh6E1KOZMd/cl1C
	amijXrgJ0RwsKh+nDHQDtLVK4aVnwuv0=
X-Gm-Gg: ATEYQzxKNgxiqHlV3Cn56EkHTqHUp8dedU4r0G5af35o+D5L9hE2w/CLCRdHeJY7rOr
	IdxQALPsFi+ZGlIKdrEsvG0u7WYfkUtXkVTugUAaygfeQa1AiWjK2fXy/8csbCH035WT1sC4zwp
	cpeYUk+BYipqjXRImt6EeX0PslyII23DsaQia5rgrO1OuLcxBBmSVcBhwhaO9CraIUW9x1ybdgc
	b6T3pS/HKHPLEz3kYdZUmbb0WsqTO5rDLzI3M6S7yMxrTr5nzq392CgcV0E3vRsrp3AF6ohXN5X
	0O2CRtDfQ91gk01mnnBgYBfVU0iU5dPSssc1HQ2i
X-Received: by 2002:a05:7023:b13:b0:119:e56b:c74b with SMTP id
 a92af1059eb24-12a72668755mr2413078c88.16.1774039461342; Fri, 20 Mar 2026
 13:44:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260309082051.2087363-1-atwellwea@gmail.com> <abx7522F7DLyBauU@gcabiddu-mobl.ger.corp.intel.com>
In-Reply-To: <abx7522F7DLyBauU@gcabiddu-mobl.ger.corp.intel.com>
From: Wesley Atwell <atwellwea@gmail.com>
Date: Fri, 20 Mar 2026 14:44:09 -0600
X-Gm-Features: AaiRm53NNFVH_4OCdDRgOaCKbjQ2HfHwRDbaKMkhJhbf3dYTpTBTs1ZETUZf0bc
Message-ID: <CAN=sVvx3k30A02=hH8bkzsdG2_FBY-kVr2V-HDROiL2kpbWq1A@mail.gmail.com>
Subject: Re: [PATCH] crypto: zstd - fix segmented acomp streaming paths
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, terrelln@fb.com, 
	dsterba@suse.com, suman.kumar.chakraborty@intel.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Giovanni,

Will fix and post a V2.

Thanks,
Wesley A
