Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488763CBE70
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 18:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776881256; cv=none; b=jndoylsclu6AoUSYsWtjfq1t6zNqxX9Toi2sW7E9i3LbubrAs9feF6MOkmWdPGUz8MC005uIFiLDBoyePvpUfuQ3X0nTg9OlKcRGa6PXZLlvizWCVO4M/OfSn77Dfo8oJFxTY2BhWwL+/14kRuA9it+PPbXpN5VrPU/hjFkkeRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776881256; c=relaxed/simple;
	bh=68e2vkBr3OUqhrf81M0NoGbo9Z0zZ3BkkBAVPKwS+nU=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=AgkzbosYzYxwmRGHOhr0A33NCs9jbtNqISH1+a07pSsb8Z70CjhhOguF7ZfgPN4inp0jLlYrj8h7eHpjwRn4z8isLYP58J6HEDoHwzOucDGMAqkQ9+NHVQGLnf4qEJ5Dcxs3/Cwy0B1ppME2wNAAnwBbyX8umz571nhFuRi2Hmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cyczf0e3; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cyczf0e3"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488e1a8ac40so71782515e9.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 11:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776881252; x=1777486052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3v4gati8jz+0eLCt+fkaA6QE0HrpYumOYS61o02yFpA=;
        b=cyczf0e3ByeaAAZFS5OtD02KqMwtPiJ5sdAH0doKrgxnWr8k3GqsYCYFsk0aA+bKjr
         2iJIGWEX2HbeBKfCL840kscvJzAkq12kymk5enin/NgxMOHE/REUOw+QwFdymzXlFpbx
         9+wqGE3i4jhLv+MH8PzewpiOgg0krrrj6icX+wfIIwxEI9bXs7FKQ9SUSuLRHFQ6qh3s
         Q8QgSPZisTwyp0WBgsU+76Ewn89RwyeVcZA5gU5R9kVXh1mmV6CBn6/bNvvBSKfkXmkV
         H5wOOrOPQaFXES9gFDsMiGkMKwTzcSOzq/tNBcLH6sp02P39Gw8535w4H8BwxqD4L5gl
         n82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776881252; x=1777486052;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3v4gati8jz+0eLCt+fkaA6QE0HrpYumOYS61o02yFpA=;
        b=fo5b0AY/h3LGds6oZlG4JjFwVp9/mAMFvC/SL97oGRcBVmwqJCy+8L9n+2bmq8QfSI
         KghmrwrH6qlwDOM1v9yaenZu/0CS7jSRZBZdXkIf9plb6K4/FNsMG8yCon9xrI25G4qa
         GxysbT/M0sOmeGcgYk3IVkxTSkQMWaYmadbLm6JM3nxtTIPm61I4V3MxVuDczkv/VGFf
         /pIamEQaI9cZd0n4YVIjTm0i7gr1h1fNRmo5FuElVxe0li433WBlXJE9ehlBKAaELdg9
         hGT2zK49BijAu7I6icf3yJarzIt3DHUe0g5ZVp5HioZwQHwvkPA0kOiRBY71iKndW5rI
         OiDg==
X-Forwarded-Encrypted: i=1; AFNElJ93LjQcf/peX1nKJdh5wuWRo+DrAS7fTYmcJgZ/4u+S49ojFVqrKF93wLl7RhzC/4kD+UmcB4keuALHcXo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu8HcLDaafE+HVixiocvmvPYzAxfoAhRuETW+cT7zYQKByJkYP
	6fF+k3ZxkgxZtzPBZ2qzz9718hVVrpHlQ0HwuVD5KMPaYVteXSvlhGGb
X-Gm-Gg: AeBDieuN+Wp0Ch4lS1jtVSHJLwcjW6ZXOFDal8y5N1uJ+mAvlGNJaYpUtDKCfyql0sF
	0CYjCqD1Acxn6uaZ9qUhcw6MMVu4u4xuvJprMUh66jJMIuS8ZxxwRGOjl1BohRgAIZ1iEPyq5nA
	nzhVi2eiJxx011m3rlaLj2lmJ1DjnwPRf8aLILeD8ocMr8eAMNW7OS8oHdDAHDUo+1imEPelahk
	sMAUOdbAg6TV4ImYwIIaDj8103DY9KUncu9YRL1Kp1asX+njPF60tfEtfttnUvhYrkS4QxUH1Pc
	m8zC/sBysl1vz9AylPlHSkpNlY8jR9bekJLZLz4d3FJpUJVysbzIB9Bq92p+g1UAm718Z8DahMM
	/oFeK9h3/Po84HJ0JXICxqBPMZpkIx6DUgWcY69kn+QMi3VThvbq/5ohHSux094Kanfkd2gVRhV
	IeJIYXaUC2+vWLo+WehYDui4Oqo+PmdoD7hv02
X-Received: by 2002:a05:600c:859a:b0:48a:53ea:13df with SMTP id 5b1f17b1804b1-48a53ea1500mr120994365e9.2.1776881252234;
        Wed, 22 Apr 2026 11:07:32 -0700 (PDT)
Received: from ehlo.thunderbird.net ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc1393f5sm432764375e9.9.2026.04.22.11.07.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 11:07:31 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:07:32 +0100
From: Josh Law <joshlaw48@gmail.com>
To: ardb+git@google.com
CC: ardb@kernel.org, arnd@arndb.de, ebiggers@kernel.org, hch@lst.de,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-raid@vger.kernel.org, linux@armlinux.org.uk
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_2/8=5D_xor/arm=3A_Replace_vectoriz?=
 =?US-ASCII?Q?ed_implementation_with_arm64=27s_intrinsics?=
In-Reply-To: <20260422171655.3437334-12-ardb+git@google.com>
Message-ID: <3341B2B2-9B57-4273-AD5B-EDDE00CC4119@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

Hi ard.

I like this patch.

So, I'd be crazy not to say what I love here.

+		/* p1 ^= p2 */
+		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
+		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
+		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
+		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
+
+		/* p1 ^= p3 */
+		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
+		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
+		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
+		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
+
+		/* store */
+		vst1q_u64(dp1 +  0, v0);
+		vst1q_u64(dp1 +  2, v1);
+		vst1q_u64(dp1 +  4, v2);
+		vst1q_u64(dp1 +  6, v3);
+
+		dp1 += 8;
+		dp2 += 8;
+		dp3 += 8;
+	} while (--lines > 0);
+}

I really like how clean this is, I'm personally nodding my head here

Taking the "bad" guesswork of the compiler here is also amazing, it also
guarantees we won't get stupid regressions in the future.

Also, that performance boost is even better ;) 

I'm not the biggest expert of this subdirectory, but I understand it well.

So well,

Reviewed-by: Josh Law <joshlaw48@gmail.com>


Thanks! (I will review your lib patches) :)
