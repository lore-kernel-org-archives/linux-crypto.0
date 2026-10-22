Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792667411;
	b=n8a9AfiLEpDcS+MQri5oPiiELXYJDo11SPxNeHyk3n+ijtP1QQLy24mEDJCmEVOZrnNt
	 TrbwCTlFMh+RG3OCDP5ZCvxvzywPFeSdlNaYjglweeRUohr0u2rJJjc9tIT3I0ZIOfgpi
	 knhPYjbXOB3iuNhEuCveV3pQeYwTfEXhs0L2JY7WOwuqy/Qx0Ot6uQwkLoLzwd5sG42Ya
	 7GJbh5MFg2oreslOsnuNZYRlvkMW843UErSYZuojqcaEZXtHWe7aEdle9jUdsmbOD7tUK
	 PZX2zkuh2MYYEdYpqqDN/7hlDY+rjq70C65fbkz6luIG2URRiPh1z/pHnkdGJW29vOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792667411;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HttdTsqkUrjCzFyk9ftzHRVp1fUqafY4l0pZnWl50DI=;
	b=myvAYp+EKWJbXXLEwwZmra2t2U9xBsXlnoXrApbwSF3dwqUosZq9O40Rmr2ffRQDrJsi
	 aWBamVbkmaXsR71bydXG8t7AGD5yqwoyYZPhMMs/APDuf93u35lquhjGqazktCFU3+zQm
	 fvMIeDTOKt0FjtiXqRX/kwslzsXpqup26RLZkbl+D6QZ8REU9ebGJqCneevrd2c83wo1L
	 IWsm+bccZjvDOu2y3qkPJL+vX2OM3KPu6tGMEIcouPMBdvMVnG02tAMuC23pmaNIEgR8o
	 DYyBu03KSHR/pFXKpSSY63TohXVVGZbCJXg0zyr8OVH9iZ2KxbykRzdk5uv9xnzEVWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=deLDtou7;
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBBA606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 11:10:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CBBA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=deLDtou7
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ea4f255ba1so5158735ad.2
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 04:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792667410; x=1793272210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HttdTsqkUrjCzFyk9ftzHRVp1fUqafY4l0pZnWl50DI=;
        b=deLDtou7pY1wV3tcwrlAPJ6TbOdXdabgH+WwNfMwMIFV1RKlHobLdD/vu3xE1XzvNC
         yEJ4/1O64Eyg0Xp8WXxfTTCpmiMUC3PwLmyK2klWzHcb+kWfGNLeyt6UO2FLN/WA6RKc
         RsIXpdLndMyHHfaU5dtj+1tbed6nj4p8e9d4vtqJB5YFsHx2mYh/eoKBAmF2P3dc4u/O
         WJMxUr98ScSpVvL8jeSLEg0ae7CITRVEOlUFjG9j58X+nSVm4nZ6oubR4fl+cs+EqsdC
         tkaooQ7loDDjP1j5lKly7lac1UZhda5UNQwdDHyLD282+J8FiLpzhPTnYqBt9vzbmoHW
         9JfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792667410; x=1793272210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HttdTsqkUrjCzFyk9ftzHRVp1fUqafY4l0pZnWl50DI=;
        b=Q5E5O6doB7oZCyoi0UOQwh4AiFBglCzluMQ/xZdp8HVrhwuPQY+wqfVYIfpeKdaU7s
         BzGe/Yj0rqrwlqmJIZ1qfhz4wUa1glE1yqchmBIeBA1dY6fXVAs0dBkbcmQvmxOMspW9
         /hD1h9WKbBoAv3HqzuNbBbej0fJDCZ9LsXBato/1Ef52H/vPwsHOS6qiV+71815IJ6zs
         dS3AGUyKOMGhgq+z8tZvGJAx61YzwzMs0aMvuTwDU3KedVRoYaFhz8//NTRa56mCyz85
         DXBqsuxHzKu0OpsmgA9SHc/ahr5mKEfcVTSkP/xKA0UChrpf33gSD835zWhsbHJp7Lrz
         DhVw==
X-Forwarded-Encrypted: i=1; AKwUvBxd1usSuRNEvdWwVquqPrMleKn6ESBvSKJVVIguBZO3dhqO25M9wR/wPchTqzzbm57F+Svy6V5rkZcMPPU=@vger.kernel.org
X-Gm-Message-State: AFq9FYKjv1fbKqKSG4Y3XDmHiz9KWUFb8IWiaLTsyArd33xi3TEoCsfc
	eFhWooRU/VCnszfUhn1Hyv8tQKnOTWhgz1JV7Qvq+1zJgweUkyY4XgHB
X-Gm-Gg: AYBFou2AuZwoC9bGl7dLVC4iefoXRDhyB9+dSHdAGgF1k+mNsMndN3clftLzKmHRWIj
	M+cfaIbHWMnymBx+PQ5DyHGwMxSgf906b+FDz/HrvHAQyUyJhBi25VAGlazcVkRW3/+TaHWDiA8
	tfX3mWicGG5TRRnSMHCktJpswgrp+Mco4XvD7vEfWx9v5N5RhapCVRUYrSBpWk7vN9bCixpJ6oc
	0Iy5FRtTBP32MhY8Lbb/U+1aBlUMlpRzYXblxZByPHkSFG6acuW09dvy0Z2QEye/7GTjnsM24p/
	r2yVIgCzRlnVwLXuec9dEKJwDWR6eQxvsvK75eicbXoDVWuYkx1WOwFyOzYByoDWSp8cSkZfmrd
	QLxMg21na1Q698aPO26GKdB+VJyiWJf9SYdF1mDExMe9HDjIOmSRcaG3552m7+4Cmc04qvGMZJo
	iBdWR1I4FzYEncKJnFWQhQId5wm0KGczGej+aVEdrXUZ54eNhKTIltVFuKcrkxu8hxzUAicaJ/C
	gR1rGasH8yHKLE6XVJIiUEnXAU9s3+FR/g8Gp88CvgTNDfmWF0gMdj8pReuFFoSMj0Pcf/PjtR4
	OQOasg==
X-Received: by 2002:a17:903:18e:b0:2e9:66c4:1711 with SMTP id d9443c01a7336-2ea43fabc13mr39536125ad.52.1792667410495;
        Thu, 22 Oct 2026 04:10:10 -0700 (PDT)
Received: from arm-a100.. ([140.112.28.118])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea3b4addfbsm21720685ad.74.2026.10.22.04.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 04:10:09 -0700 (PDT)
From: Tzu-Ching Yang <shingekinocore@gmail.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Alexander Lobakin <aleksander.lobakin@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jose E. Marchesi" <jose.marchesi@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simon Horman <horms@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unroll: Make unrolled, unrolled_full and unrolled_none function-like
Date: Thu, 22 Oct 2026 19:09:59 +0800
Message-Id: <20261022110959.1173447-1-shingekinocore@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261022100140.101ddf52@pumpkin>
References: <20261016025613.2690485-1-shingekinocore@gmail.com> <0a38e0b0-2508-41c1-bd99-d15c27579307@intel.com> <20261022100140.101ddf52@pumpkin>
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

On Thu, Oct 22, 2026 at 10:01:40AM +0100, David Laight wrote:
> Is it possible to make the syntax:
> 	unrolled_for(....)
>
> Or is that made 'all hard and difficult' because he setting is sticky?

The pragma binds only to the loop that follows it, so it can go inside
the macro:

#define unrolled_full_for(...) \
	__pick_unrolled(clang loop unroll(full), GCC unroll 65534) \
	for (__VA_ARGS__)

	unrolled_full_for (int i = 0, j = 7; i < 8; i++, j--)
		s += a[i] * b[j];

GCC 8 to 16 and Clang 17 to 23 unroll this fully, and the same works
with break and continue in the body, nested loops and a loop inside
another macro. The count form has the same shape:

	unrolled_count_for (4, int i = 0; i < n; i++)
		s += a[i];

As a fourth option, the _for forms would replace the four unrolled*
macros: no clash with identifiers, and the loop reads like
for_each_*(); the cost is a new loop spelling at every user. Olek,
Eric, would you prefer this over options 1 to 3 from my earlier reply?

Thanks,
Tzu-Ching
