Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBD429B0;
	Sat, 23 Aug 2025 09:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755940726; cv=none; b=soJ20GPAFndDaSgX9SdqRG++Is7W6mvVv7VD/FGk6pX1BgC2mSBHGlI0OwmUcfOSQlIdyBt0WH/qyWhVVyVl1IaXdKGoTLn4BM7fBhzCe1OpXQhvMcxlS2wWwiJEeb4hLkw7TZchIAmW/Hps9myk61GktX0qa2LAmwO0zmT2744=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755940726; c=relaxed/simple;
	bh=qQKAUKGD8YCJSmr7dhdjzTfWFLwOspnZF7Vw50KWiWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJQaYG3I2Wu2eOH+FD9BKfHpzR5cDDX8Gbf4bLlPE6srCEOvjkQUtrM6qyBYChT1eDEQz96sZ+ec8+3x8giYPinN9m2k8hnIf4CTV/g6jaoyzVw7OsnbdSRa0JzSIrgT3MmAUuS3p5Ib8PWutccw6YUjHKFwLk7cAc+Vcc4jlQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MWb5QTpj; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MWb5QTpj"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b471756592cso1806106a12.3;
        Sat, 23 Aug 2025 02:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755940725; x=1756545525; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AfNfBu1qWolJ9wIMXkd3bnXOtHy3GISGcVi04weSYTY=;
        b=MWb5QTpjSzLt9jYLqLlyr3n5APZrHAgqSo3BzEnOM9bfh5ifaCdut76BpzKiBjFzYP
         OD48ZSLw7GFBgyEN1yQBjs+i8u1llqylCF86BDT27Ba+xyLf2Hc9+PzT/9YnHtWDRtGc
         PfAeLMx+8PkemfQVCol82diLSeomBz7PWpnIw1GkZoxO8zw+kE7IRumUSWr0RtAwlmxB
         N7QemwsHeXTtINxP05WU7w+vyv0a3g1CnORxBwr9iddUizhVBo86dm0Q7dO1OdQtY75g
         K3hGC6C33+tY6CpFvcyemzZ1NLX9LIRHe8kfIoqv5bW3FtMJfGRep6cSf18HUwYiJzK+
         T5AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755940725; x=1756545525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AfNfBu1qWolJ9wIMXkd3bnXOtHy3GISGcVi04weSYTY=;
        b=T+YXKfsegklEsbp3NEuU25OEWstNfppV4qyMlIj5f26rygX1cxevCdILbf+pxR2k3V
         39HN4o3tsSB1yqLAFmGmqF5upYIYU9gENq4/UHHu4kmpz9dTNMeJ9W0P4+dmhQYbGZGF
         xj0WSw+dtpB4CkTeqNAjYQ+kf/MOtTLQu/ZuOnjsLXbnZQE8hrQhIAtoNYWgcwWeKjW3
         oe0UpWVSzgdUm+bDIDMovzLQmr5Og4BPcsEqs/TrxSff7xKSWdr2Ru+vGVdY1e/hLRPQ
         Hpf0WeKxV4FW7MNVXkH+4l9PTjA2xdbY+CxtDELJxCl1uSId+8w+gMiaKE0urZR/nRbQ
         ONsA==
X-Forwarded-Encrypted: i=1; AJvYcCV6pxjyNwCrw20cUJWmfNfX9Gwb17EtUoeH5SFxhpDcTpTTsgAiQIbAPkDFHGMUX5AIVHEkBDYJi9pt@vger.kernel.org, AJvYcCX2Bw8eE4XmuwRVPuUlNxOMCQxZB2Thiuosw1JZ4yLfLEkO8dL/eG3kIMkWOGshUPD/3CO7tleXEQZ2YUc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRJ4jEBqRnBUQnHbukld3srnZvPYJDhyMZrm/WYKKeJV2AY4/u
	lAjJEuXHVgJTbS5huupv/7kO942txY1DnyZTEcuAEt4cppxhZQwraX6m
X-Gm-Gg: ASbGncut/EQ5emrwC1JQqSGHDsNstSxxEImRWcVfWBXBHENbPk03xn4wgnsiP4b4ZpY
	4+KoUSbhB7Q2B/Z7TZHySSOChdWCx0Mn7KrdioJSjTruelTlYem25+WcqMNLnzIYZeh6SAmgoXN
	4TZwYwGQeincVVw8/QlKX/+czYK8z50Ni0GrMOqXlp8619GEGHdcJ6hhNu5gQzmndjDLU9MA/vv
	R3G0AbUHewXbNqfGQ0hNx1BELh1r0zv+NT92TbemC7CW/zcgYkCThE2KwjVaAkEztM+bYEtix/t
	M+ScfpvFcCakCnrAOCNBE2g0pv/hDtCFcg/OmTEK7FP/ichLhxxQgVWqzfyUysYsZA55r/D6vC1
	zJCgzkvEGERjIPQ1tPmH03shxDHc8qaXNjci42aFT8aX7CuuNX/Zyb7Pn2A==
X-Google-Smtp-Source: AGHT+IFDYWklpG7n/RCWVYe9fEt6cFZZCJhCfu1jBDgekkP0Uetb+/s+2CwZHMHpt7emWt1eZkWvMQ==
X-Received: by 2002:a17:902:d489:b0:244:9888:3a1c with SMTP id d9443c01a7336-2462ef1f1e4mr83311725ad.29.1755940724611;
        Sat, 23 Aug 2025 02:18:44 -0700 (PDT)
Received: from lkmp.. ([27.61.56.127])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2467a6f5489sm12509535ad.144.2025.08.23.02.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Aug 2025 02:18:44 -0700 (PDT)
From: Rakuram Eswaran <rakuram.e96@gmail.com>
To: ebiggers@kernel.org
Cc: ardb@kernel.org,
	corbet@lwn.net,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel-mentees@lists.linuxfoundation.org,
	rakuram.e96@gmail.com,
	skhan@linuxfoundation.org
Subject: Re: [PATCH] Documentation/staging: Fix typo and incorrect citation in crc32.rst 
Date: Sat, 23 Aug 2025 14:48:32 +0530
Message-ID: <20250823091837.5037-1-rakuram.e96@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250821035913.GG185832@quark>
References: <20250821035913.GG185832@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Thanks for applying my patch!

I noticed your comment about the file being dated. 
I’d be interested in helping to update it to cover the more modern 
CRC implementations — things like carryless multiplication and 
hardware CRC instructions on x86, ARM, etc.

Since I’m not very familiar yet with these optimized approaches. 
Could you suggest a good starting point for exploring this in the kernel 
(or any references you recommend)? 

I was planning to look at lib/crc32.c and the arch-specific 
implementations, but would appreciate your guidance.

Best Regards,
Rakuram 
