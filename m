Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1995248867
	for <linux-crypto@vger.kernel.org>; Sat, 25 Jul 2026 19:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785006257; cv=pass; b=BonkaFBX7n2XLsQnOMBNUjp2xIUabUlmAvG4qKjJRvd87P6oOdluG6cM71sYR9GAYQdz2ec8KlVifNwdHKHYdojjgMwxDCh5aJkUAOXAB4doug2R7xJmAAFOEWx6MTTeau7QgiJU9PuPK7YJsrxlXuacJqOAqZojdxQYSYEdMEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785006257; c=relaxed/simple;
	bh=0QbV69kmg9DsMNMBVld/5Gpugq8FwkJ+JSjN3cbkwy8=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KlpwfDD/qaZt0gPlaXXX30N3nktLhvi38SZE6M3t4ZLbc0liEAMz3FZIekGzlLT/F+9AbPbeBMmcv9Yw17fm6/vCVf/rnrk7JLKJIS1GHSZ3vQpAuTAqPz3+D6xl2WilYXljaNcgx7yD86EpPAzcKeNAlrrdlXZ1UCM/XGzuyQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai; spf=pass smtp.mailfrom=0sec.ai; dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b=Q8gjHBks; arc=pass smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0sec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b="Q8gjHBks"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cad8076b01so16360895ad.2
        for <linux-crypto@vger.kernel.org>; Sat, 25 Jul 2026 12:04:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785006255; cv=none;
        d=google.com; s=arc-20260327;
        b=di0k5A3+M5gz8Zyf+7ULA4OlojPjHhFljscp1TT38gXC4YqL8rW65JwpIageUEuWBv
         2OuJNYTwXO0ETfc+KUEBht7fCOSkW1CbOdn/3VuYsw69ddiP3V5jlnlch1cxF832fKT0
         2Xf2f3Go0Bw/jwfwVHPLilyWLAtYl1o9FpZKd6snI1NE20rREhNgG76xZXIzu3h1cylN
         +uA3DlGezjPz5ESLMEA47YKrBUmQ/7lfDDOv17Z1wzJQ9edQnQYHeMq5WYwtwez9/veh
         QC9yss3Okf8h8sC/d7rN3wT6IwrEE2LuOAuV5TIOYyeG6Lt00iySvrVc/PTIG3BvjXC1
         zXoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:dkim-signature;
        bh=0QbV69kmg9DsMNMBVld/5Gpugq8FwkJ+JSjN3cbkwy8=;
        fh=9pRh8y+p/TdRXZmcBfgg44pWyza4dQm6wecPQ2yqW6s=;
        b=XXq3I81/hloqYfDufmN4fJdzKYvM61EbCghMKGafSAIX96ba/C5vmWA1RG30YgCfre
         PZaPGxmdXgWd2uqlUBV0W0tdIegVVTxilLU1qICd4XR+18GZeL+t9XhYHGkpPS7ym6rj
         RA2CqlS1Ge2C5r4TBtKPrRZ+rj4Dq2xuq51n3ZJ0qyyQd+P+3Rmg017md7WpA5yEX4Fw
         zQplPqV79jXHaClLPhcI9Li87blqASDPUEy9moeBygcy4iILvNUfRZACi3GsmGNHX5FX
         FNZKH5zceEcYzBgDi73q1tzwmFcGvFLGYTBnulQo0ObfBEvX2fzt2ph4aENL2EQmYrUJ
         hL6g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0sec.ai; s=google; t=1785006255; x=1785611055; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0QbV69kmg9DsMNMBVld/5Gpugq8FwkJ+JSjN3cbkwy8=;
        b=Q8gjHBksorpKiaN7Zd13V0//oyFYmYMiW2PmrC/pWW6GLnr0iwb8FxjkIMqyTL0r07
         pjGB0EieUSeTwVz4TD7QnR7+vk9LGlzwHDUaQ6nOwVWU1El9CO//uf61Ke4JbBLf4ikX
         CorNCtkbqKKRa7VDIpIDGdAteZ3rXfhAwGydVK9k6SoEw4JRd570LnjGZVe5H3f5N7pb
         JwNwHG3OBP2uerIE/8WgNKKDkfzdQEIAwl/lpn+Ualq1CWAIuOkBTLjNxBVDTIWwNp3x
         d1dxcLOSthmpnvNgPijmzdWKA1sD7oOVTD8tdUu2rn7qds47dcwJ8xH93315Q18WLBaX
         UxuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785006255; x=1785611055;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0QbV69kmg9DsMNMBVld/5Gpugq8FwkJ+JSjN3cbkwy8=;
        b=BV8bMebBUNGWzzIkFCNy4S2AHURJp+XpO1r7+fUatttYFKuAxWknpuB4PbPqZn/ir1
         jcSoTypOp9XQnUelcxw/2Wm1jwfVnE+FN2fm+eHn4VWBqFwV7Fzzv0+wmYF7Tm1nb+uO
         Tz78xv71bUEvEZLW/0btnBT8e5lwl9w/O86TuF2gCRG1vtnAIvlh9y9cHisdfa72K0Zb
         JtdA9X3IeGFZiiajqFWJRW8FZsqHy+GKfJxqqD6AuJgCk+hX6oogZX4N+dHIHc+1AfXT
         D69DB3tD4yHp/0xvazgDvSBHgV4tJ9L8Th99ONAcAYZ4AhzZ7HGzQK4b+S4f+AgtteBW
         ++Eg==
X-Forwarded-Encrypted: i=1; AHgh+RpLpXJ3UPnsKUuKcSQR4/5BJ7Ei6xSmuQSO39mdKwCwAwn0e3ALEYl8+tkqQWKKqitZz/P3Rclf2jdwgkI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMPTT7NR9GGJamxNQg6jgDBjZGHqyHAUHFcMq9GQnFRbi1BQRF
	KaHlod/O21KwK6j7kbq3q1O3s29WZXD0fRUc/ofW8s+XVQeA37K0jUGzsQMcmnuPTT3IbHtq9Oo
	WNS3Uv2hJt9ON5UZSiHPWZZSd76g4hLunwbellPpG9WE=
X-Gm-Gg: AR+sD11OxLdx7Xtvvb8WVbDUqXQDUtkqQBtieqm1VoybZ9Kkxn9O5auVMeHGzFyzUuG
	XAPnwBRche2g9vd7BmMQTnIc25KSeWdQ1MAZCRorrl2FKHKsRHz35Vn48QYvoa/QDTAelGVWKsx
	oIU10IHKdo+fbk9SAGuhk95VcXOL8+tETZZRHuBXAipqmpYZjlXFvWlhzfPBfJJ2J/8qEUlLxxN
	Z0CW3iBpa0g7aeGsO6FfD8F4swWkO7AauXYnFkvwn+AXvr51ZqlTB81KLTISybZFPkrTP/EysSH
	OZD1SLLBiJArQSHPIM9BSLygmLaT/CLK2Zkdzl5nZU5RdcZG84ZacEuD7w==
X-Received: by 2002:a17:902:c40a:b0:2cc:61e8:5fba with SMTP id
 d9443c01a7336-2cfde866e46mr31930735ad.32.1785006255341; Sat, 25 Jul 2026
 12:04:15 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 25 Jul 2026 14:04:14 -0500
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 25 Jul 2026 13:39:24 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260721201114.0012-stable-reply@kernel.org>
References: <20260720191525.15450-1-doruk@0sec.ai> <20260721201114.0012-stable-reply@kernel.org>
From: "Doruk (0sec)" <doruk@0sec.ai>
Date: Sat, 25 Jul 2026 14:04:14 -0500
X-Gm-Features: AUfX_mwhjhnX5X-sZz0Adtxt7J16oeGm0EsNu5BzNSH9sAPFEWmfSUa4z711gRU
Message-ID: <CAPdMp1rzVAk-bq8wU6wTozXz=2oe1yW2muvoE5EwCa50gsx+3w@mail.gmail.com>
Subject: Re: [PATCH 6.1/6.6/6.12.y] crypto: rsa-pkcs1pad: Don't WARN on an
 empty digest
To: stable@vger.kernel.org
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

Sasha reviewed this as matching mainline=E2=80=99s no-WARN/-EINVAL behavior
and asked for a crypto-maintainer Ack before queueing it. The patch
only removes WARN_ON() for the user-controlled empty digest; invalid
input remains rejected.

Would you be comfortable Acking the attached stable variants?

Thanks,
Doruk
