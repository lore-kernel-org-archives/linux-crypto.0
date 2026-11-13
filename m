Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590316;
	b=mgONsqohVOVPyQfYW1dmMjub/zY6fsfcRq3m5aafPDf+1+ERSQgQhueZiizvTuxuFkOl
	 CFVgUIGCwate01VasjfdKTV6NaZWefwn2HP5Uaz9o5+2RUvtWYdQ9ooywN9TK2maxr3F5
	 lfrvb7rNZ5bHx4F082HCusy2QT6//NKYQhqY0xKgqebAOcniJvhCWq84/yyOqZIzXFl4r
	 bywmzPAkiFWz828+YQl9xJ6ATmfCXqG9vwT4/vAn2/sfhZSuWDBXAJO3eSdEaCZ/MF6kR
	 eURECWv+hynK6w5Pmu0jSfmI7zMmBAkwvn+8NIlIpJ8gMmLEXVA8Vhb+8afjAumixMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590316;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=3C8tSwHqjzI+bnh3DElyKp/N4OUqkqrYjzdrA+UxunU=;
	b=xfVGhHHv8roke3XMXuaCo5cmgFHdqS5rtc4zoj7zJEdMoxO/dqU8/rjF9sxxBi0duTlX
	 Y2nHHQRTptsdjpOwodN7BMCQDmc+Ja8lZiqIMVM6z5X+yhoEAfh9me5JlzruX0CaQrisv
	 3dBEuMbMtzpngbpS7f/Y1QhiR0ee1R2GV4UFNSJItsQMmRhoNLyQ7GJuxAwaiNQseqvBJ
	 v4LHDRXxmBJIgSvJNLfuSF5bg9rs8orLWNcU1KdAGw9eGqBDPhTct1r2zSgAqAr34K+II
	 mfWHfrNeXgodFPcVGPkLInF+Gc8V93NXk903m5TkbB5z9wvQ0IYYh2sMKVZKyEKvP6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Js5JUeMr;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A32060A6F59
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 17:18:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A32060A6F59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Js5JUeMr
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e942864693so15660525ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 09:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794590316; x=1795195116; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3C8tSwHqjzI+bnh3DElyKp/N4OUqkqrYjzdrA+UxunU=;
        b=Js5JUeMr/jjG8IP4L7djYwEXs7HWQC/vfmV4sl1JPlvn9LC9U2xww308mqJNDLaSHu
         p9pOkNTcXGvg3W5OPDDMmxc6H37fUHw2PpHb9j37/qvZuY2OH80rQS/SGOZY9ja0sxay
         v8rKpl0Le67un0PBdA3AUEMpFtuEhUUfTvt2g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794590316; x=1795195116;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3C8tSwHqjzI+bnh3DElyKp/N4OUqkqrYjzdrA+UxunU=;
        b=1X/9DcNCwtMlpKzGLG4MT3OkrSmf82uTuWu2vX7lwSGPvhSmhrlIY6UTkrDLi2eZOS
         XHAvebwcDCbZUXtTZdDuw5PDKd5x/01zoj4Zl6SQsm04EtQ29IVojexxQ5UryT5YImte
         nUGblwwTB/nVQdyLjvWJ68ncUhpNpl2AkoDb1PgBJSM1GGm2CFNKygWcZ/GjWYLpNioU
         9nhdlvcWpvlQQsDvwGhpA/9xeA3sPzN3WdgmrfR6H656zPFHU2gu4972fUhvdggmTyWC
         yVn80F9e65FgjcRR3A6maRrS8+yP9GwmlhtLT7TklyoliGWMi0LKJnjEtVQX/AzyGebD
         N5eQ==
X-Forwarded-Encrypted: i=1; AL+hErETiUMwobVhWFR7QXTDor4rkWyFkpMN+2cvLeUiSLeH+0DQKtWoACb6J9zHDdSLolikT3U7BzdK6caZ+9Q=@vger.kernel.org
X-Gm-Message-State: APuU4Z90RCytAdjrZnKHy0zNzIKdx6ZEItbwoFUCq0je7Tz0G1WIHo1+
	8dF8gNhOvMuKMxbTh0W0TXuch0BVBsZ7qWLONqU2XQtLt3roskw63seBDn7AYplCFj4=
X-Gm-Gg: AYBFou1vqvBIE6psG1R3vmlnJGuAs8SvRwBu9VNjCvlCFoTB6lhn3hj4tiG9qymNg4Q
	dz2gZc4WuOD1sfcEl6+w1Jn5i2puKdranYFky2GqwFoP4XTGQAOSZTf3yukCvFesEDrmsa8Y9QC
	tGwq15CbGoCkFf4lyJGzY/jmf7JKIDrErHyqAh4/wYwurQRldcxvrwjvbl2rkgy3W1PRIoHb3TM
	y2Vqkaw82fE6x4ErPb1YLsFavuAvagCUSNmmllo4vmtaRKBL4IiwKjzY3z0GTmxKpJpEhnY4wLe
	1wIYwExJ7aU5Xzcek3vaOEhQBGY2+baLO99uEcJSRmhx4OQg+O1KTOgmUxM66sYyDOReQteae/t
	E3uraaUTBER7n1bllFZwGPLrvXwGVByxpQql9/oKuBx//PWukxWMbmE2Jgu+qs7Ez8fOOmZG7zx
	hCUjRqGHZkszDAaxGZHazq1QijsPWedOmva1Ri45mjwGoQMWpsoOj0pZDpJlgTCKyFzlLbKrFg3
	jYG0V0qAHucXDzlPbT4uFGUnkEwqFZuNI1m9HBQPV5fF8nKwALQyOWO0ElfGEGtxL1JnxLuqLRb
	0TKZ8H+kn54MCfJJy2ZC4hUJRH19eLNutFoOu1BWKM7C1PLFf4aDaBOY8AQ3z2jfZvweI0Pqf/t
	gjQ6Wz1sNDx46EPUU5VbKMBIpWfZoAoqgmp5nUgECGKiOzgE2Eozoki30Z45pTSA8+6Vdnz1V5J
	skQpAG6Fme9mgQuTczJcTV31vswgrn6Mw16JtdvjGoj3PsBWpO61eEfMUETVA=
X-Received: by 2002:a17:902:e74c:b0:2e2:d77b:e586 with SMTP id d9443c01a7336-2ee0df12481mr33259215ad.60.1794590315817;
        Fri, 13 Nov 2026 09:18:35 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee10bdd1a4sm12923515ad.11.2026.11.13.09.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 09:18:35 -0800 (PST)
Date: Fri, 13 Nov 2026 09:18:33 -0800
From: Chris Down <chris@chrisdown.name>
To: Usama Arif <usama.arif@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net, terrelln@fb.com, dsterba@suse.com, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH 2/2] crypto: deflate - use vmalloc() for stream workspaces
In-Reply-To: <20261111153532.1036709-3-usama.arif@linux.dev>
References: <20261111153532.1036709-1-usama.arif@linux.dev> <20261111153532.1036709-3-usama.arif@linux.dev>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261113091833.6dccf0e5ea9aef18@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Usama,

Thanks! I've tested this with zswap using deflate, and it works well.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Chris
