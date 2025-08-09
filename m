Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7FC22087
	for <linux-crypto@vger.kernel.org>; Sat,  9 Aug 2025 04:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754713981; cv=none; b=tjFCMgMhhNG1dQecy4att+2ztrC8snu0Zxnny5Ftnt2hvo+FPwv3Q+UoORdZ6A9pgo3RYgvXsfPUEtPHkjpMK54Ipoek44yKX7/ITjsMV1hmx6N0lLRud/gzanYPG/p0ghkUGtgi9GjA2KhX+AeejkGjf9nX2+VJvlQWuWKKESg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754713981; c=relaxed/simple;
	bh=3j2f3Q3qaDiwQ77M/AgMn60ASwYucXL52DAzl2u5P+M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bFQ1ncX5Wy4Do1O/Uz88RaNq0DXZ38dXFIFt4rhevm4/2vXr+s0E5crR1MXNCwVkVxflec3P2ZpIIasVHUs5OkbKkzvMrv/OpTyrVCM31xgXJ4qiQWBDU1eELKkqqI+SWUNMeXkeEtI8xJfuZU8qbGzod6qoKkmyowccyPJ6xHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EDPaMow3; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EDPaMow3"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-af95ecfbd5bso482750366b.1
        for <linux-crypto@vger.kernel.org>; Fri, 08 Aug 2025 21:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1754713978; x=1755318778; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pkD+P2y+y39hXD0Pcj8Lfy9t0SWSXpSEsHCRhG/IbnI=;
        b=EDPaMow3X+v9RQcxn/+Tj7QkOEeJWcLfMEtg81qEJu/vXwhwqqQAYURrZfMlaUY9fR
         39UMQ2qs0zSMxLIDiywMgoOLXI7oMQfty8NZ5JpG/uyEoBfDw6Ye5zUrLzQWXwfyp807
         V0ApGMQWokysshd0i/7XhM+mUbcxySslS2Ms4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754713978; x=1755318778;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pkD+P2y+y39hXD0Pcj8Lfy9t0SWSXpSEsHCRhG/IbnI=;
        b=FvOLD5fsVmaaSHr2uKV+kpASggpj8J1bbA/cumVyfHOR+svBntsnpkkS9cfBwu1BJY
         FGOEUwpxEbiEsbp0P0ehNYlUKDILAcpdl8vJr4WIEgVc6A+d/xzrU7nyMteeQyGy8H4U
         +/UVSAapL+VZAkvMqyFYumMdLUGnl/gEoBiZtAnes1wUuc9dlGZhIP56FXq+APZm2HwC
         6cP9Cv6AbCVaVbH/BJ15lFRWqGAAQeUHSO7RQ56mCAxza7RxBWID9YwBwHHRgrM+z3G0
         +TYczS8/TY6hp6swej3AkyCTuMJEHlvNZisYm9zSdcDjt0rI8ZluAUq1tN5KmIY/WHZo
         +Qag==
X-Forwarded-Encrypted: i=1; AJvYcCUzR7n5ZNNbG6mAmRCYJBNMJHsjxWGdhrn2kJULJD6WdFL2Slh84tMHQd6G1hSx0pDbQ0MqYN8lrYOY0m8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yybm5CbQyJU6GkltaApZ3dj0/SnzUndMZmwz+/nWsyk64Eq0lzu
	bDDrxrstMIZhVTJaizGK4PfJNIML42KgETT8BBG3yemKme6J8uP27wjPqe2UQlVNYIERkUAjWDM
	nrUNA32JeQw==
X-Gm-Gg: ASbGncvz67ayb9CXa1wBnmALWSawiH8rwTVRKfDta1ISEnDgEMAnl4VVQjHCvkFx2ky
	ToBDwQQ4mcBnAaoPYuc2kGiMLLZaDfhL1WqeE4QPJ1+Nz/CRU0yBFzLPQFdORjULovVpBcAYw2A
	Q96x4VD/iXu9OBhwbVR12UA/PLA229xCyLBOk1dYkogD27kRLV6DoimYDnlXa7bMuBbB9ZzLvxt
	LHnzzpjnYKg5FmpPG6noOdNPR9cTtP2F+qDVdHx6fFoEXDMlokI+JTzcB6uM1fCXd0/OhxQ6AXf
	Dl+bVKCwhMrbveRIW3Q+YunbBETg/bvI+wQFMVRpanYp61P7XR3FQRsX1uPWMS8hwlDWdnsQ0Ct
	kp48Cc5gs8XuqRBXxCUEM5k5gEsrCrywfWPG1LkViqPyxWWc7knpS9LhPZkRt+2vz7JRPEVbh
X-Google-Smtp-Source: AGHT+IFdZ5W0sM/esT6S+qxKV0A1PpwZrfJ6SjuGSJ/Gx6tk74oKvfC8NgrPKySfDtixxzqobE/ttg==
X-Received: by 2002:a17:907:2689:b0:af9:14cf:d827 with SMTP id a640c23a62f3a-af9c645f8dcmr449630466b.18.1754713977809;
        Fri, 08 Aug 2025 21:32:57 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0a3e80sm1615483566b.47.2025.08.08.21.32.56
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 21:32:56 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-af97c0290dcso510468266b.0
        for <linux-crypto@vger.kernel.org>; Fri, 08 Aug 2025 21:32:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVd04TRohZ3khBK3ITlDFVY1ol1+0zpCsk5+qbNs6lC3DYfbYMvWDPM1AaAxVLoZilmN+gaiZqGvXd5MPg=@vger.kernel.org
X-Received: by 2002:a17:907:948a:b0:af9:69d1:9c6d with SMTP id
 a640c23a62f3a-af9c65b02d8mr501213966b.40.1754713976386; Fri, 08 Aug 2025
 21:32:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aJWOH9GgXhoJsHp6@gondor.apana.org.au>
In-Reply-To: <aJWOH9GgXhoJsHp6@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 9 Aug 2025 07:32:39 +0300
X-Gmail-Original-Message-ID: <CAHk-=wgE=tX+Bv5y0nWwLKLjrmUTx4NrMs4Qx84Y78YpNqFGBA@mail.gmail.com>
X-Gm-Features: Ac12FXzvZx-Q2z8j9r1ZnqxMDu_VuBdhbV9giLfb4eCGbjAuOV9Pm09Va7WqOBU
Message-ID: <CAHk-=wgE=tX+Bv5y0nWwLKLjrmUTx4NrMs4Qx84Y78YpNqFGBA@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Fixes for 6.17
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 8 Aug 2025 at 08:42, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This push fixes a regression that breaks hmac(sha3-224-s390).

_Please_ describe the completely random strange constants, and why they changed.

What is "361", and why did 360 use to work but no longer does?

I've pulled this, because I'm sure it fixes a bug, but neither the
pull message nor the commit have acceptable explanations.

And honestly, the code should be fixed too. Having a random constant
like that with no explanation for the completely random value is not
ok.

             Linus
