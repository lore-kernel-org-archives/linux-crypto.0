Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A50B255F3F
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 17:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759340970; cv=none; b=A/Tgwhp/GMSBxKMCQ1DAaCp6eUevRINHFy0Wbenlcvw6BH8QqRZ3TOnz+KxQVDKMCjS1d8r0nodCmeD6540eqbUNvEfGKDXroy/ttPs4RzhUA0//QWQDNDL9prF+OIZzTDm7R6JYB56AF7oDvOmAopiDIbL15G30v3SYTstxtTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759340970; c=relaxed/simple;
	bh=+waJQB4fHI/86YXZ3IivT0VQyCfdoykuuj8W+W79+qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQW9PmYvb0GWwaGyurFlaCEtHYVBc+CqJNaNabu0Nrd/vDFkxbnU5YCRpvX9BTRK4OIP1JmdwdekEi0k7h0q9FCrG4fjWBFuThhygFfu5vxu0sYJMNOhReNdxoR8Q2p+m8I3nqLu0snIGDDT3lDv3KwGX12zJcRKfsyjZs27TbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KKALSCzK; arc=none smtp.client-ip=209.85.210.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KKALSCzK"
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-781db5068b8so200786b3a.0
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 10:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759340969; x=1759945769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mDXYs1gW6lHgm0Sdi5E337TPiuAJ1IkOjd5WpuSNp2U=;
        b=KKALSCzK2K8phkEy0Ibm9BECtutDeSLdAh5QTb4fKqSouzDqouLVMmtCrgjk3Fn1J9
         EL/GEJsapcQ9lUoqBWLZEbNoYvyAitJTa8BpNrvygX8pRVaRAkbxNLUuZoYE9EZoUkC1
         l/5QcFkkwcCZB940a5mxdzztT3JnRM0NegkCyVkr5iWZkwXJJu5LxfqGgaEr2eXAS0gW
         Bhqg681GsbeneE8p3kjuUSP9/bsEyov52VyuJv5j+LX8a29fvuJYAOpNpfqLpw9wtW7q
         oURDwxUiHpOVdieZBA/JxBdI1OPwK7cko02ikCSS7l4w+ucNGhZN1PNEXvljN4LoPO8h
         8xIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759340969; x=1759945769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mDXYs1gW6lHgm0Sdi5E337TPiuAJ1IkOjd5WpuSNp2U=;
        b=GLQ7lGDFf8/SKMhHTm3AnBsfHeUsVjl0og8/kwHr7gliz2giia4vwTGtZdny9dRRFK
         IsNEHgaKx4ULQWZNk4VnibjSf7ERC53UgucNxZ9p4mRAsw1453PMAQjho6bN+/GV2TV2
         gNMQ98iElU9Qctd954L6cx9N9o6BLZhSyZgp5eOVyCecWR+yJbKa/1xAj908dhLWr7og
         2YHV3G1cjTot8bJIqeFfMcHu0QafjJHFC7vTBipbRwGl7oD4xXFZphGj1p43BZPEBkqU
         MYqCzqRJ9uS/MMpXB+2ThL7oShzOxOQmzEmzZXh2NzinGpsab0WxYTw+Jr/2ypXViTym
         zZ6g==
X-Gm-Message-State: AOJu0Yx5rJPbYL3dyZSKUrO+EEMWO+aS7gnzHzCr7iV7pQ0j5saUdspF
	jXjSoqSsF8frOPdtzNuEXqLtjnqSOZzSlj4Y1aJJwpqWqwyduWicP5xl
X-Gm-Gg: ASbGnct2Fthn3/SRLNsQ6IpN/Jb9qGBEgnjF98YyGWKD9WB3aD+YH5b9z/BfbnuZ4i0
	mmJ5vGDalAegvHNEV8dH5INV+obXMcSAhxFKxOe9aHNDUJ03MgFrYXXYemVEnW1f9ToPLPYGrd2
	UYSpYp53ruJoLJJFftADMWEqokhG64MJGQGXqEJwCtTN+1UraH6aCfIV+X2/6APZOiiYpK2xLjU
	2qPWQtrEf817pKj93CeBfLPy7tYuFFerHucd1PjFa+9e7ElVTouNQywLIzp6a7mXtcBzoSBcrsy
	V//Sk9fgVo4D8EKGwidphK8Av82AAKfgKO6R+l4Df/zwD44sX4zv5pTtZhB5MBqABDa0i5YzT+U
	wuDjo1IlFsfeech5aKW21SqkcskbrIQ==
X-Google-Smtp-Source: AGHT+IHwkrMABNi4K2yFUS+N5upbIB/1p2WPLL98eB0Gpyk0aDMrnqKNVONAsmUquFt3MfN5gfQChA==
X-Received: by 2002:a05:6a00:4b54:b0:77f:6971:c590 with SMTP id d2e1a72fcca58-78af4223e1amr4810892b3a.22.1759340968453;
        Wed, 01 Oct 2025 10:49:28 -0700 (PDT)
Received: from archlinux ([2a09:bac6:d739:1232::1d0:83])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b020938b1sm264532b3a.83.2025.10.01.10.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 10:49:28 -0700 (PDT)
From: kfatyuip@gmail.com
To: Ashish.Kalra@amd.com
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kieran Moy <kfatyuip@gmail.com>
Subject: Re: [PATCH] crypto: ccp/sfs - Use DIV_ROUND_UP for set_memory_uc() size calculation
Date: Thu,  2 Oct 2025 01:49:21 +0800
Message-ID: <20251001174921.274261-1-kfatyuip@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001144431.247305-1-Ashish.Kalra@amd.com>
References: <20251001144431.247305-1-Ashish.Kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kieran Moy <kfatyuip@gmail.com>

Signed-off-by: Kieran Moy <kfatyuip@gmail.com>

Thank you for your review and for pointing this out. You are absolutely right - the math is indeed straightforward in this case, and the existing calculation is correct. I apologize for my unnecessary change.

Thanks again for your attention to this and for the clarification.

Best regards,  
Kieran Moy
