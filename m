Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF7F3D45EA
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 14:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783087783; cv=pass; b=j304DIG17gv13bQ8Pd7iTQ1wXB0ZoJAnZ4gVAbqwNCBQXSurjsg9Ng9QxR5ppfQi9iSJnZ4E633N5ZraERd6Gy0db5E34F7QCexmTlVUTLgwxab1X/tNEg0T9B8MWuHenXlJ6SC5o9tNH1YsU6vQU/OK/3/0TYOk7qA83jXwdXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783087783; c=relaxed/simple;
	bh=nPlr4TTuFu5sDiDKlEBaYUGajGflCNHRFrMOSsr1njI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hIK2nWhSOa5Xach/41mwdwkTh/oJZfiDwSXYT2sNqGBeJQi950ybOXfWDAvxmbAw/4doQQMIQPxxNdqSre5tAxTOn9as8aBiMjD//P/J94wwsOVUvaXTi8fYxs/vi9KXiwQZJhIdhjVVcRyfzbG6iV2pckiRkABeDHpw8SNRb4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SllowcRF; arc=pass smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SllowcRF"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-664dd23829eso554660d50.3
        for <linux-crypto@vger.kernel.org>; Fri, 03 Jul 2026 07:09:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783087781; cv=none;
        d=google.com; s=arc-20260327;
        b=cYXGXtUcngKNVGA+R9Wlv4MyKjabfaajaDSKmYF7lNpAMcyKPe6mpVNXdixL/evOGG
         L4SL22oJ6cxkc3qjXa9eNS648BDSA1+3X/e3m7miNAkIA23IryRx7I9PDwTabVYPGtv1
         qbbv3lTchbBXcKwxuZIQTceHItnKiJi3thFlIfWNZcFQsJmmMvmGqbYvvjWU77ycnbTo
         X2xJjmxcn+AkvfOF5p5E90zkm/NVf4OkhZn6gmm5Jt6RcYOtQ+OGQ7UpotukyjAgmO5f
         HhqvQn26mL+SQrrzclx5D33cMudlAe/Df7vhHtotZQAQ8NQJNRX0YEedLGDEzlCplP0Z
         rtzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6iulTPjI8CJ+y8cbiQwWahbhZvI0ZZS53MeDPgGqhAQ=;
        fh=oLVVBeryFj0vrZUTmSxdU/oif/yGggZTBCoUE6PVA3k=;
        b=pCGFSWrg1YDbMJyF3+y28n17xu+/SRRYV4WMS+zQNhVSTRMHhXzojMn5gKc/nazi5I
         ai7pXQ3ImqvHEzQsrAuSR7WWBpr20vzybw7K86hTVAQbBfazBbUS7tF7UQYdhGdZUMIo
         04dKra9ZFic1wYJab41cj1u6tcrz91zjUoMrcuwknVuz5ymzihexJENTk+vwY0K5h1eS
         KTIr3MXNRFMU/T0vtz+vO6qACx9eLcJZHC2Z0mvMsiJiLxodvr1fuqVbqmOaVpHu2T7T
         toBNE9tX/dpOgxKvmL6pc4nLvwG8n+IB6vbTIeOOFoY0BsuwphqC41sKFjaTRDm8C8m4
         jPiA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783087781; x=1783692581; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6iulTPjI8CJ+y8cbiQwWahbhZvI0ZZS53MeDPgGqhAQ=;
        b=SllowcRFlTeWfJk81No6mtxzzrwIh1rOo5g9BfZiPxEEBuc4xLbniZqJEACONtx7t9
         V9SSbCmpOCzdbjPUlGD/3cN76mDXd8I1zLRTCQ0o8b0LoGcJu4GNV16p8Iwt2qd8mkE8
         R+VpEAjD+NwVkJ+GhRL2VOd6WVe+XhnOTbDwAUVl+oJlYVsmNzIHI1jLGyHI9beQn7pt
         JVKBZiB+bSodYa1v443ClaLR1i3l8ciwdnCFHMjOI32QtWTtw08ixOW6y5g+YEG0s69y
         5f2f6L7jd9tlyzXzFUrs6dJNmp+1NnlZQ8I/d/LSqqU5nSxhNby/RPW5EGNJZZWobfq5
         ZHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783087781; x=1783692581;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6iulTPjI8CJ+y8cbiQwWahbhZvI0ZZS53MeDPgGqhAQ=;
        b=W1i+9DhAGeIsoTlND+XBAG2ekddpSYK60IcNQu0xJA+MqjUhAfnoQnB6rW5VG0cKOZ
         HXc9bCHL91IX9qI0G+ttM0uIDtW0Yzi0HDuX96tDAIXoUgHon0s6utrvDMtJnlVOd+ea
         LGk3ZOISQIA0GkO7RtlTBi8oHcYqzuyI12qXmKgX+UupYumERQYNlYDm799oSUYlY6E9
         52sMmEATOQp3Hhyspjd558AoDP/8IC1s08DiRIrl6A9bw0kJCX2YjtQoYItJF5zeShpy
         iHhJRwXKSNdCK5KblkpJayTJ5dj5Lr6eosZN/qs4Q/M7w4GkvqDzsqqe5z0T1YJxSX5w
         f8Cg==
X-Forwarded-Encrypted: i=1; AHgh+RqESFQArsZLJukIfPzUlfZGquhh1fX5pCOy79l0N5gTmkXNjrJo3ztXWyppfQetA3gQMtOb8Re1y7iTePU=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe2+2bP/t6OL7IYxrBjJ+qswCvqhOrC1RBMJvcGNIwKCef6E4m
	j2yrH2EDqB/jOaENd/AOvbUGjaNY1zJxJWb7D/Eq/+oxSVMZ3pQglG8bxGvgnB78aqkos/qoXcp
	XWY95wMTNnuuV8bM3nEC3tPIvrKHyChB/dg==
X-Gm-Gg: AfdE7cl/tnYqaOWQC2jKS+YDTdEr2imW9ljsdrGnwKyPBg7Lcf4Ceogkv5PIi9k+Bt4
	mp0PF/moZLPjHStnOlCWCe783jpN4Q8ctsuAycjcX3K0V5IyyvyzZcvZpdsH3TV/xCoHpF3zezI
	mrO29cAr4b9EIII54Kbcj4twgTMAZP9CZnpyI8Gjf07+dF6NbuVaiHGTCXhynMDCTvSgkimFGvV
	YQEoYkPzoTISwUVXXvZgR5U5+9sd8LXTeTKxBOoRTdfOKxXdGKASFkZrS4SVFRsZiSkFxCXFzJf
	9b+Np1DUDo/xupXmGA2Jl+bTU+c=
X-Received: by 2002:a05:690e:140b:b0:664:ae69:230a with SMTP id
 956f58d0204a3-6659672606amr9255979d50.71.1783087781278; Fri, 03 Jul 2026
 07:09:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260613085858.32580-1-mertsftl@gmail.com> <akd0zGzVZSG_45hK@gondor.apana.org.au>
In-Reply-To: <akd0zGzVZSG_45hK@gondor.apana.org.au>
From: Mert Seftali <mertsftl@gmail.com>
Date: Fri, 3 Jul 2026 16:09:30 +0200
X-Gm-Features: AVVi8CdFNXrXg7zUVKFrWxPF_ASSzbUEsOQRZYtFlz-QcX_rAj16GMgPD07WP-s
Message-ID: <CAA3Noor7Bg5dDwfYyoSszyvLRibAxE2iq_41=5a8sKhOhFUHUQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: T Pratham <t-pratham@ti.com>, "David S . Miller" <davem@davemloft.net>, 
	Dan Carpenter <error27@gmail.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 3 Jul 2026, Herbert Xu wrote:
> This only fixes the symptom of the problem.  But the root goes deeper.
>
> The main issue is that the device can go away in the middle of an
> operation. [...]

Yeah agreed. my patch only covers the empty-list case the test robot
flagged but it doesn't touch the lifetime problem at all.

Doing that one properly is a much bigger change than a one-liner though, and
i'd rather take the time to understand the driver's lifecycle and do it right
than send you a half-baked fix. So, is the list_first_entry_or_null() change
still worth taking as a small correctness fix on its own or would you rather
drop it and sort the lifetime issue as a whole?

Thanks,
Mert
