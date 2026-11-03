Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793695664;
	b=DYD+ATvcfiooR9gp1h16w7MaBFDR7svL0Czl7HyPB+GChFlFaSCHd/70g5GX8KTeZwI6
	 BbpWKGoNCabFCetk8psGjPHxvZ1eh/D52s7Dtp3fXnY+LOlZ87hrxflFR0Q5mfyVUQOgh
	 IjDInu6drf70+TGVJ71QvasdTOZsMf1snLOqdkI0ML2NeykYnxdPowBs1gDEKgKmpLdn0
	 2qeRek7GWbHQ3yIcZBqycPJKWo3Dz8FcWGED3jpnMAKLqf2L1vPv4SuCjSdyZYieU0+7Y
	 E65h8LWp/tee5m0EE76SaoU7wBBb/aCPf6B3+TRD6iIwiJ+0syYAplrjg0qkhg2BrFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793695664;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B+BHED5eRoDIkE3I9oNS1EqLCs1mF8mondSiDowJlEA=;
	b=gwjneaYPB+s8w8a2F/Wk+s4kJ0staVI41INrnlYjT6ZH+zTTkPz+bMWtkAGrA1LPb4PC
	 7tbZrpL0OkgPXMG5dhvNk+LIBrRp3xo+OlVP3syemBggGMbcMbc+t/5I2i5d/0DTrDNF/
	 SX/VNn8cijWetkwN7u9V8L8CNg9hadFud4XMr3fNCr1FZcpdaBmE+ZDzCoheIKk1+OMGZ
	 olT8A8iBfcohY/4SMVslskDBcOjoaks+XUYQOmdWUBTXbFR0ej9qklEazfeFs4f0eHnFq
	 zHUMt00bUKrnuRLN0icDX7DkvW2qbQBzJlTrmZey8hPMd9Op+mMSOuvyGayqiyQGAOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EJ6rLKic;
	arc=none smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA88D606A336
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 08:47:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA88D606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EJ6rLKic
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8a4c72951b8so2598591b3a.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Nov 2026 00:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793695663; x=1794300463; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B+BHED5eRoDIkE3I9oNS1EqLCs1mF8mondSiDowJlEA=;
        b=EJ6rLKicFs/V8t7AShlkaCPJb3//mmq5INznbJek8qBXVZ9a1t/jAnD7/+Xb9DZmQF
         Sx74RVj3/48r4oYff39D4C18huhRZ2s8bZS3a7QMBpuivzxHlEO+pI1J4s4gA5lOeI3i
         uLMGZHXmFEAB2Twxo2vKzzglbOi0kb9Gb80Sk5tuz2dMR1EVDTgTSBBkqBGlJo53jf3E
         4j8igUqCS2eiO+JfrTkJmVgqjH9KL1o5QX1NwEMklesE3wTjLKvFiCskEDmwVkUd16oE
         d6NGJxxNOAdipqW56OkPx9zqiw+IAqgxO0esQKI0C0ZBbZZAzDZoBXK9VinfKJs0gtWA
         S6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793695663; x=1794300463;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=B+BHED5eRoDIkE3I9oNS1EqLCs1mF8mondSiDowJlEA=;
        b=Pwz2jWZsVgIF/e5Dk/SpUUvDdV070Y5u2umJHSf36SA83gEB+P3f39nq8l3gDIUbbI
         ZNHL7xHsmqyQlsPUJG1bZemwUJRoFntoN053cNjHIs9mU/MhYJGl3ydOr3JBWIpLWlYu
         mo9wi87aWjqA0t3xdHGI/HLpipeggRkeGm4Wbz9v+wI8R8a/i04oxYyJ7UKdkThTIb4W
         tJTnoJ8lUjWY/qU/cU0Mazr3q6OA87B047g2ILI5nJITeZQO7nyFIKCFd9cW1ry9ud6o
         vSCnZabB88WfMNFRCJcz/dk48FxqIO0XUw0QPe4YR0LaUZDD9iUBuB5T3K4N0aKSIvOl
         Z2iQ==
X-Forwarded-Encrypted: i=1; AKwUvByymKhjGX1UlZglld7rd5j96qDmfrA0KCMDSegPIPTipEQNSKgAY6/acI++XpOqhflLUgRKletsTW2S+tA=@vger.kernel.org
X-Gm-Message-State: APuU4Z8BVjY3mRylvi5bJIdaOwpliuChxL8eHHyk18Is8GFGSXOsa21j
	4fkYHGQ2SrLKsTvTX/5tDBZNImbRKquDUamLXT60+6PD55VLrI7/H34p
X-Gm-Gg: AYBFou345IHO3BqHMS9BFpQ0pjOwEb8CdI5ASScMm+TvLQdQM4YbvVgr9WhIuOsqLvH
	YrYhMiZ+cC4lea5kK5oTdgBw6q1RhwMrxKkUEtLRyxeCbPyEyRgVmMC0ekz5mvdr14BDcgrDThz
	7Zqb6zzMxeeWFyVb2yX8uc5rxJeElQcJ4mq7DNKhSUqNPoEJlAw7jjVNN2YDIP7sNsIS68miZpk
	ajIt381Us7by38yylF7BB2c4UAZPrsYnSP6lrFQQtoJzI8+CcJpCtBMGwQqOnE/V7Hw4QGkVIcy
	dQCrrcBZLUgDkPLkqSb2IULOhK06j1feP7QUupXbmZqq5SutC2SIjYKk3gk9TPzc4/RrEZQ+x3T
	gaRi4B9HkIL3SkP5cXdGeZZeDlOfojGwxN6W4aIeh+My6mP1d+qJlY+pip8fg69ycchdhh/kG8A
	NIpV5IpKad12aoVWWVyyaqzbDfl+Oy4pLlgXDh61XrBF8dQAqWtEjzq+dmBW49quKmOT7BwWo5e
	Vnf3NAM+ssYPghRr9Wi+I6Kz2w4Z9rFcy3SbAmE5+Mx+urzzKZHQSCjc+nZ2h11gtNlam6Afofb
	XqBSir0LqrTUnxcxOFqcsxpUPfqSCC9Ze99K8x36ZlELc6Bi
X-Received: by 2002:a05:6a00:4b4f:b0:89e:fe2d:abe2 with SMTP id d2e1a72fcca58-8a9bf90cae1mr10126228b3a.44.1793695663009;
        Tue, 03 Nov 2026 00:47:43 -0800 (PST)
Received: from spiderman.taila3fd8c.ts.net ([202.112.47.77])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8aada9aab57sm2844023b3a.46.2026.11.03.00.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:47:42 -0800 (PST)
From: Li Ximo <lixicaicai@gmail.com>
To: T Pratham <t-pratham@ti.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wang Haoran <haoranwangsec@gmail.com>,
	Li Ximo <lixicaicai@gmail.com>
Subject: Re: [PATCH] crypto: ti - dthev2: fix empty-list wild pointer in dthe_get_dev()
Date: Tue,  3 Nov 2026 16:47:34 +0800
Message-Id: <20261103084734.1996045-1-lixicaicai@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <e9e36645-51c3-4099-9c5f-063224b479d0@ti.com>
References: <e9e36645-51c3-4099-9c5f-063224b479d0@ti.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Pratham,

On 10/28/26 12:26, T Pratham wrote:
> Thanks for the patch. However, this fix is already in works in this series:
>
> [PATCH v10 00/15] Fix several issues in DTHEv2 driver
> https://lore.kernel.org/all/20261016124456.1802080-1-t-pratham@ti.com/
>
> Specifically this is the patch:
> https://lore.kernel.org/all/20261016124456.1802080-2-t-pratham@ti.com/

Thanks for the pointer - we were not aware of your series. Our patch
duplicates the dthe_get_dev() part of it, and yours goes further by
also fixing the callers, so please consider our patch dropped in favor
of your series. We will review your patches instead.

Sorry for the noise, and thanks for the heads-up.

Best regards,
Li Ximo
