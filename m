Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B5B343D8A
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 10:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768906541; cv=pass; b=NCVovPPGx4KLu8Lt6uXzWP98FAD9Ew/HOYxrfe99T8xMfJBJ3nSH3cFa28GsFs2rx4P4LeQSBdr/lyMrdAPKXfL7hSWULemZqRxQoDe+6qtX+I7Q8kodq+WMpEJI9rgAmq2l4O1IkH89YJl4nJCOR6AOcgmf26KVH1q2B7gtOGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768906541; c=relaxed/simple;
	bh=fIzQM+I1dKrQeWlW8RXDEsaXmZzlz/hUkp2KF5rWyuk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pfWtRZyJ5VFV/G+7qiMC3nKdz/cY1bzFdnT+cydJ8BFXE2DiRVaTBjUTOSGBy5D1OfSkwX7vwzTnjvtlMstkmq0N3Ec7KXTRB2EcxO2emE/nsHvealTf5DFcvRHiNp3DcY2TeFFV8X/lIhixTN+0Als+mxYTOdr3AKyoMj23pIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=UarTPr01; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="UarTPr01"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50150bc7731so79768621cf.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 02:55:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768906538; cv=none;
        d=google.com; s=arc-20240605;
        b=G0ghCdGg8o8gcCOl2rKENfUWp5831FK150S2VTr0sNV0/j5lUVGY5GqAfzI06GBG3X
         zE8+EpZ5Ok1qrzyUqu6dErpYItJ10+tQLZvsJKyi/FWo3fTs/M8moPBIOLnTMcWDHRG6
         MT9RQIyvjv10wwmB1z9wIIfafv6wk9/r+uOqei9uactvhcV8rz9pjh+8025Kay1Vlji/
         1lHNeJizEydTa55YL+2RaKdunyCLZaPYnjoY8VoQj/AC9StUlenwK5eIVw3DQWw37+dj
         Bmso4PhPkc4l4GjIFkXOQgIOte9guLTKqP4g+j6/U8pD+FEPB5RD6qrj6JrKr2L7+S1k
         sE1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+858jRkeuTzyR7QbFNMkP0w0F921+ZC4VlN4hpyPROU=;
        fh=3uJA7K85JZhwJcvj8kVjqOMxXGqLofYdjSN2V83MMAY=;
        b=gbX3zsGS5KFCwFmLR78/zWW+oWrXf4Qo0ZUhaGKG4L1fq7zjLx6s6Ro/XboDCiUXW/
         Vz+sORiD42qevxZDg/DXbMa03KjOl55sMxtRahCUBT+fnr+IsXlU3iU6/qyCurs0CjOV
         Jp7oBIt1ZXWvvB0aJWbux9ZWKdX38aEfAbmw20A1Z/gIMutE2TjIImj8cgS3k/xdyrxO
         bhh+1AlTOUL/yC2JmNfz59boDEI6KBuIbIeAj0qbKhlb5QzvWQXVqd8zSnUM4kCYJfm8
         WZHwGQ8BwWcF3tAr2qb6suX7zlxtgAKX5tXwidhNJ9qNMJqtRv44QEOKcfkBJ7pIpHVn
         kX+g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1768906538; x=1769511338; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+858jRkeuTzyR7QbFNMkP0w0F921+ZC4VlN4hpyPROU=;
        b=UarTPr015F7dRJLJacZZzl2NOK/uiKmtbKv2oceQ84MND3/ducGjUdBlaRQ98tpe8l
         iuWAxTZguNmQtI2E46ndHWUOmlqapQTRDAKQpzRsRC2qJqYZqEE63hOzLNwSX1lv5UJM
         uDEWvpK4Ov/L93nsSMEPmC0p+NZNnZ2Jtl50s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768906538; x=1769511338;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+858jRkeuTzyR7QbFNMkP0w0F921+ZC4VlN4hpyPROU=;
        b=LuYnjROLLtOO6c8FMT+DCzG5eWwBkyG2fbM9JlSp9E7el2fVvnCprRHmGmE0mkLGt+
         aYMtWiX9285v6jkaIO2TpI+wDMyNV4+KjhoYOmBDEIcPellhH4zA9y9NjKkQSXJwm1Go
         9EP8vkPbVtUB9EbusbP2hYqY5PNmc8lBbRHx/P4aDdUuYjQ5mgsZYYHGoRGNYCYWw8fp
         8rQJa4kZTyhIjkAViEN3dm/41tR4qReTogdehZZc+lIspacJluUU1D2VhdxBw7NEpLqK
         Ff6YEoxGpGpxgApvKDkSqi2ISlPRdYI8nL3KDzJW/9QaAHzQvtWsFWuCC3GmYz8xDfcC
         b0Aw==
X-Forwarded-Encrypted: i=1; AJvYcCUyOvqhBm0tskPt2tIVuTL4Q9OQ8iG4faG1A6p3jCYH3vk+lOXL8I3KbMCoGgUoJQcnrY6e9gnY2w2LnVc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx7MGbmyr3uI4ojXe9B4r1y9cc9YtEHorJSSyZv6Qci8vt+kDK
	JoWW/JXKpHx8Eg+khCuOWE+WQ5fI4OVwGNiYHEic3/5b2LnAAsMOGaKw6jb6kGuotwPeWFIfyWG
	OE8L/cI7VGWgt3rwIz7SmksXITiB/Invk8skuShlcTw==
X-Gm-Gg: AY/fxX57qn4ToBnDi4ABz4o6nzFd5c8uhTi4UXy6S2q76JgfF9TpWPwOmCwgTw7quf8
	xmkfQ5u+xXNBIPu7hCiTgPHKSHYC0zPvu8p3/SkH+xrNYaX3HoFDEvkvdHBU6BxBREpvWJYhlwl
	NOQ6Ak78DAMMo9DouJTByEi5sYrFDly8TQgiVVjLjb4oQCi3NSH+lNtYfaDTuPwX8uIo4MI827u
	dDNEm41ByBQ/wJX/1Ywn4AcEPZpR6DDsAndXDe4OiNDK8scRmuDNRIelGDKKJFxQ/ET28fiVIIR
	FQKvIcLp
X-Received: by 2002:a05:622a:f:b0:4f0:23b6:c285 with SMTP id
 d75a77b69052e-502a1f231b4mr161536681cf.41.1768906538583; Tue, 20 Jan 2026
 02:55:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1768573690.git.bcodding@hammerspace.com>
In-Reply-To: <cover.1768573690.git.bcodding@hammerspace.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 20 Jan 2026 11:55:26 +0100
X-Gm-Features: AZwV_QjAOHMTbnCyc1vnuEuGvNZiJz2bkDzfLZ1b6HoSesVSYIgHm3F1kdUgfiM
Message-ID: <CAJfpegt=eV=2OxgfiVYG7drw_yN14b7edJhj+bsF_ku7cVGuig@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] kNFSD Signed Filehandles
To: Benjamin Coddington <bcodding@hammerspace.com>
Cc: Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	NeilBrown <neil@brown.name>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>, Rick Macklem <rick.macklem@gmail.com>, linux-nfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 16 Jan 2026 at 15:36, Benjamin Coddington
<bcodding@hammerspace.com> wrote:

>  Documentation/netlink/specs/nfsd.yaml | 12 ++++
>  fs/nfsd/export.c                      |  5 +-

Would this make sense as a generic utility (i.e. in fs/exportfs/)?

The ultimate use case for me would be unprivileged open_by_handle_at(2).

Thanks,
Miklos
