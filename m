Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6B11CAA92
	for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 17:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763831950; cv=none; b=XlkgafibFtywkelezrcgu2G5aujAGKuK3NODu54u6X4UGcOdLrwAo2CUjCt1HCJceQZMVYwCUHOu3JVliJDyvWYEbgrj6zIz8t/jZoHBQDGAfDgE8DtJBuOseTbrMH634F2pdUHg/+WY8wmRdRO1ftzYcfZ/XbsgkMbZDV6xexI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763831950; c=relaxed/simple;
	bh=YdVcIwGwKDh/6sNNooTobnWdLRFBymQDy/hqcAiUbLg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q4ErmC1QI9A+/ozLfPuCPK+YyVy5RStzyXQGebsjJCxIoxBtSw+Ef4GPnJuKNHmm00iK33wkirqZIBYNI42LlvXHOKAWYNqCskRIeAWuIuhjn2pNmZOqvOBWVGnVhcCyvQDok90s3IMV6pNpq4beDNo7UrydCLh4iwKq3L+nl+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TlWVCnM4; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TlWVCnM4"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-29516a36affso42765395ad.3
        for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 09:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763831946; x=1764436746; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YdVcIwGwKDh/6sNNooTobnWdLRFBymQDy/hqcAiUbLg=;
        b=TlWVCnM4nTfqURfZsmDv7A+sN4t+k5G0hkw315A6YvKGECZcoJIvTGAZIUt6Xx73Br
         91ZBfUFBJlO2ItrUb7yTjcPLErT6a+yUEQ5CPge9iU+5Se7KMyg+pPzwrhaGuyht0R3T
         2WBYZhw+ZktmDRM9aDX+WR7hozY9inlax+gpwojdL79D9IVBiQMgsXDdO8HynVpFwRZA
         g6zCPAFgkBCozbU/3vOaaWDFtU/MBFY2DcAXHvISPe8FxyPQTs2Mui6FOf2eCC/IYZKh
         iQ5QjrpYuMRaHiIyoD5jvHRg3AEXYh3sRQzSYwko5JfTVKG9P8QEwD5Pk7A+7g8IHuN3
         VD0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763831946; x=1764436746;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YdVcIwGwKDh/6sNNooTobnWdLRFBymQDy/hqcAiUbLg=;
        b=GnMSviWiQCSFuMgoZh/KRV/E6oE9unr1or2RfDPq/fHUGnqJV0XI0DL1uF5vC5g/Af
         KsJ2bGqYeSeP7VQVw3f+OvW4orsqzCLCq4/m1xLbD23rQCiTmq5EW0q4UPq+DlY4Xxsf
         dyMRxT3LeoFspmyxV3zT6XPsRhik0Iw3X5lP0mlxIF3HD5Mib9JQ1DVWG/l+VYUvu86e
         mW27zDpoFloifr4KaJKJl5nGzKcCJ/BDRxK1LBLewKXh9n1OuEQhAmV25QWSWCUvV48q
         JYodY4Ow67ZoKG1N3l/8K94rVoZevRqnEOOZNDSTwW2AoSfrLR32IQXAXx1blk875l/F
         ZKIg==
X-Forwarded-Encrypted: i=1; AJvYcCVnNugDivluLsI7VPL36zzTBVOOW+VsBuTKSTbhksz44hPzv26aTpbhj3ti7l+ouaEKmhUZCMwenQYcRAc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxP2nMtDUM3ixDhTDPjUBUJ9kgVGJQk94zX8Mvc6eV5Kf3oFGZJ
	Ra1CnTPNxElMEQXeuwuX0Csq/Agk8U4O3/av5mTOe1liyqr0Q9PoUoGx
X-Gm-Gg: ASbGnct/q3q0UMAOrjZu/+PlMzqSsXbhZZfwFRvTV5O5u5BEQW5n0pg3CM3Ri6A0gZ/
	YDfjxBN/Ww1ybHkKHdIldQFMVwmJcOiLBctoA/uvEsj9PgplKNKJZFUDNwgJQ+84FrdvLftlsVh
	TOXa9Y7Y3/YTbwMT75pdOb6rxqmovIM3kG+wyLyZ0bzr4SX3lXdEC6MB5pW70J/bZ2yOcuK8Lev
	/dmN25bXYW7A9aj1A0xiLgumCytGkzKqFfLgrBB5WmDLlTIQXDpAWqyyBfa9hDEdpJo13+CrK5P
	ATl1rnrFufRJ+CkyamP3kHjCpgmGpteLYV+qqIGM8JZMl30llvUO6uB2k5YT8atZvKgWHdjKL9n
	8kFsdqkSQ4OhFSRSA8U8OOZmnlvM7/WgFqOMpvgmbNj09HYIxTvKdfosWITb0A7VUKgJw7Q2nHm
	TEfNDY7KSAfaVAB+QGxXE5eFF9QtO1kXp/S40nnALnfBl16m5x41h/24nfSw==
X-Google-Smtp-Source: AGHT+IHsrLiktElDl4VpBRWD7TSKCwrK/iXEsY4HhXbo8d2kQN4F0sY+95g5j41nDQTVNYF7qGlfkg==
X-Received: by 2002:a17:903:2c06:b0:290:94ed:184c with SMTP id d9443c01a7336-29b6c3e86acmr69614135ad.15.1763831946402;
        Sat, 22 Nov 2025 09:19:06 -0800 (PST)
Received: from ?IPv6:2401:4900:8fcd:4575:1ad3:3d1a:3314:cdd0? ([2401:4900:8fcd:4575:1ad3:3d1a:3314:cdd0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f024b7c5sm9536723b3a.43.2025.11.22.09.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 09:19:05 -0800 (PST)
Message-ID: <b296730415a6b4e261d431bc6adf864ed3b2a630.camel@gmail.com>
Subject: Re: [PATCH v2] crypto: asymmetric_keys: fix uninitialized pointers
 with free attribute
From: ally heev <allyheev@gmail.com>
To: Krzysztof Kozlowski <krzk@kernel.org>, David Howells
 <dhowells@redhat.com>,  Lukas Wunner <lukas@wunner.de>, Ignat Korchagin
 <ignat@cloudflare.com>, Herbert Xu	 <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@linaro.org>
Date: Sat, 22 Nov 2025 22:49:00 +0530
In-Reply-To: <531dba90-247e-481a-a26b-2dc9e7927d6d@kernel.org>
References: 
	<20251111-aheev-uninitialized-free-attr-crypto-v2-1-33699a37a3ed@gmail.com>
	 <531dba90-247e-481a-a26b-2dc9e7927d6d@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2025-11-22 at 15:25 +0100, Krzysztof Kozlowski wrote:
> On 11/11/2025 14:36, Ally Heev wrote:
> > Uninitialized pointers with `__free` attribute can cause undefined
> > behavior as the memory assigned randomly to the pointer is freed
> > automatically when the pointer goes out of scope.
> >=20
> > crypto/asymmetric_keys doesn't have any bugs related to this as of now,
> > but, it is better to initialize and assign pointers with `__free`
> > attribute in one statement to ensure proper scope-based cleanup
> >=20
> > Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > Closes: https://lore.kernel.org/all/aPiG_F5EBQUjZqsl@stanley.mountain/
> > Signed-off-by: Ally Heev <allyheev@gmail.com>
> > ---
> > Changes in v2:
> > - moved declarations to the top and initialized them with NULL
>=20
> Why? This is not the syntax we want for cleanup.h. Either initialize it
> with proper constructor or don't use cleanup.h.
>=20
>=20
> Best regards,
> Krzysztof

This is the only one I missed reverting :(
(after the disc=C2=A0https://lore.kernel.org/lkml/58fd478f408a34b578ee8d949=
c5c4b4da4d4f41d.camel@HansenPartnership.com/)

Regards,
Ally
