Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0712D4B1E45
	for <linux-crypto@vger.kernel.org>; Sun, 18 May 2025 21:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747602120; cv=none; b=CR4v6gNpyjyTJE5pvkXhHlIKgZtdcqjMPHfE36YQCwpimeZxBaYaupoGbZBtSvSDXvuj0pYsE1/4tRaStJsh66tLvEBNHUgjeI45ydqHjm18NZPHuPTzMvtnq4mMKaWJ81IBo/Mrgc6BPjYP5OqIsMvEOs/37nIISbpb8XHjLtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747602120; c=relaxed/simple;
	bh=ba9xU7Jbn2FVi7LZvXa2UDGEzZHap/n1XsQdYEMk1WI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rXA9mSyHGis+fQJMLbsA5hXAvOvGbg7ZsCGT9j+V5Zqz5wh6B9ycY/0eOz1mpwK5+kbIOBWdiEFPW8+weg8zHBCmfNpYiZ9A0EiZcYVmSLdn+NpOwjFnaJEe0xDnNacykSRLYQ01IYjMMgZt4USN1j6fe22/+36Hsvzu0VimTY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i51zLqY0; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i51zLqY0"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cf848528aso32548515e9.2
        for <linux-crypto@vger.kernel.org>; Sun, 18 May 2025 14:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747602117; x=1748206917; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DqIvtSaTElVAbU5WQSUQYnUEAxZ5Pww0sV4dezTl6k0=;
        b=i51zLqY0a0iPdoYT5Y57r+8LIraXohe/0eJHP6lbVGtGK9V+PEccwBqmlRhKHX50Kz
         Y1xe+nG6ugOuJ+f4NgO1w2DKcmo2Y4qPjdRCerfpLoK7tTMZIm+3xHddW9FZYXmBuIEc
         hAel+yQWaoRqd+vf0f7pOl9793/ChUz6cH4ShFMkifGUgho7AKDsndFhcNMP5muIfxtr
         mL/387zTwHlD58YO2eRdhMJHi/LeIQAYQQph28UxGUPwKX7XnkGv/0ldSzTLxjU0sGmX
         mY6F0Tu91yCLRo5vjfUDkYxXVOgV3dPrLYI+L9XcmQT5wk9WFNS2yc6v01SxGDalGrnU
         Gq5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747602117; x=1748206917;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DqIvtSaTElVAbU5WQSUQYnUEAxZ5Pww0sV4dezTl6k0=;
        b=TgGGN+9LNiec6r0Igdxjfr6Jtwss4g5EXJdwLuSkuZ+1bTIRDZ+g4yl00u0u5jKnMg
         //SrHwS8u1kng1Pql69fILn3GTp3+sL4Kc+rKpklV+fi2G6BzX1iCVJxE2tzQVoLy4iW
         sRnQRpzVshufNvZ3I2EUpxBRLoQ5xjfpe3oHABZqdJSIIam1rjqgtfOSCVeI4W+7OtkN
         MB5UAHpaTGEX4SCnlo8eZEh7wZx6N2qu3J4G7+aEWl5vE6pKXrhIAH3KehV9MTkBlVnq
         XoqQXRdvhE3ldo4qCHW/CHmxHpJ1nxljVoAeM6hUyPu5AXQL3fMKDwNx58lFwovfNonG
         MLQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVj+M7+ro8etnhbc4tgSP5Hf5V2gk+doWyaWChn6V7hECMyC1N7dxhiEREyJxc2aN0VTrM7JhMVd0SsTXQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzx/MUL2yC2FIscic875DwklCWokpfXBOCAEylF2Db/uRcPor1d
	FajetWZHHE7giBjmQGDo5P3kV2QEG4baxCUn33dZuL6jEVqE/gOUh9JK
X-Gm-Gg: ASbGncudW51Wh1Ddz4svqvQLb3dohsI8Tc7JhL0O3aepx5mCBWJKS4wICCMBbqpkYbw
	vY0aRpmZvcwIc1vAwERRBoEy41a/N2EQf5UGRXYSFX8gh3zC7Xw1Tb2ukmRCCsu/JXgAe1tr110
	Ubv9IJOcbnjoj6bfGBNpvSFDuly7bR4RvvyazFFlLtAEPOcGd8NnsVPQW7YGDFCAoaZU/9DhMsU
	46nsFUIBBYp01+hcUelSylR8JizW9NeLprJAPfer1gaLnzY7sJd43X61WZGGZiTGryYtZ43KzDn
	WVHw+yUODNr6l+2ZSe7oc1if0ZKvgZGP3HM7t4HTp41XbYIv2tbFVNSy8ax+nM3jQhnwrUyjNg5
	UOdTnTWbb3FeR+rf+
X-Google-Smtp-Source: AGHT+IGrYzuwvnM5GBwNUtbVh52o0BdeQe0+kqk0GZ44Im7Utz0dK2lG7e2QEx/woomVTDH999/IPg==
X-Received: by 2002:a05:6000:3107:b0:39c:cc7:3c97 with SMTP id ffacd0b85a97d-3a35c84ac99mr9538403f8f.50.1747602117076;
        Sun, 18 May 2025 14:01:57 -0700 (PDT)
Received: from Red (lfbn-nic-1-341-50.w90-116.abo.wanadoo.fr. [90.116.174.50])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-442f3369293sm190744445e9.6.2025.05.18.14.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 May 2025 14:01:56 -0700 (PDT)
Date: Sun, 18 May 2025 23:01:54 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, terrelln@fb.com, dsterba@suse.com
Subject: Re: [PATCH] crypto: zstd - convert to acomp
Message-ID: <aCpKwjzLoqUi5ZwK@Red>
References: <20250516154331.1651694-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250516154331.1651694-1-suman.kumar.chakraborty@intel.com>

Le Fri, May 16, 2025 at 04:43:31PM +0100, Suman Kumar Chakraborty a écrit :
> Convert the implementation to a native acomp interface using zstd
> streaming APIs, eliminating the need for buffer linearization.
> 
> This includes:
>    - Removal of the scomp interface in favor of acomp
>    - Refactoring of stream allocation, initialization, and handling for
>      both compression and decompression using Zstandard streaming APIs
>    - Replacement of crypto_register_scomp() with crypto_register_acomp()
>      for module registration
> 
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---

This patch lead to a selftest failure on qemu ARM:
[    8.966883] alg: self-tests for zstd using zstd-generic failed (rc=-22)
[    8.967242] ------------[ cut here ]------------
[    8.968659] WARNING: CPU: 0 PID: 64 at crypto/testmgr.c:5808 alg_test+0x42c/0x654
[    8.971391] alg: self-tests for zstd using zstd-generic failed (rc=-22)
[    8.971716] Modules linked in:
[    8.973531] CPU: 0 UID: 0 PID: 64 Comm: cryptomgr_test Not tainted 6.15.0-rc5-g0f25e6007813-dirty #113 NONE 
[    8.974311] Hardware name: Generic DT based system
[    8.975088] Call trace: 
[    8.976322]  unwind_backtrace from show_stack+0x10/0x14
[    8.977257]  show_stack from dump_stack_lvl+0x54/0x68
[    8.977910]  dump_stack_lvl from __warn+0x80/0x124
[    8.978418]  __warn from warn_slowpath_fmt+0x124/0x18c
[    8.979081]  warn_slowpath_fmt from alg_test+0x42c/0x654
[    8.979645]  alg_test from cryptomgr_test+0x18/0x38
[    8.980054]  cryptomgr_test from kthread+0x108/0x234
[    8.980603]  kthread from ret_from_fork+0x14/0x28
[    8.981254] Exception stack(0xdfb7dfb0 to 0xdfb7dff8)
[    8.982194] dfa0:                                     00000000 00000000 00000000 00000000
[    8.982734] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    8.983394] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    8.984699] ---[ end trace 0000000000000000 ]---

Regards
