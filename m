Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49CE1547D4
	for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2024 04:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732251076; cv=none; b=qsAvpsn+kFqU57zEUyg756oa+VdiiCfOD1v5pher3tY7ktOjf/rljbI3mFsbc18gh+Z9JC+t8pBwtOrTERtsYamNhnpLlR/Dnh8AqKUk4pL2i0br9gVsSA0k5fAiFb9OqXu/47l6fzGIMytmmjcS7opDhwsE+ege/qsgujrLrAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732251076; c=relaxed/simple;
	bh=jDw8VJdK7HsUxsxLYkcsqkJWumi7DFGQUIlQD9fGSiw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ONEC8aBqLWZuSXx4vO+B+356B0tKn9+Higc01VVDjAG1j64ZbrFsHI09EPyC8CLh4sNCrvALv9uRBIUxKEKYSSlPfpU4B6X9l8ijZZIZj9JrCHEb1JSr/Y4My/bFi13A10Kfjc6U2ZOHGIpcpjzgOg1FMMNDsLfg/x5NHU0Jy8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fkju08tl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fkju08tl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732251073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=elmcLeOJm+mDVlXoOKcPt5H9RufxPwtwG8/LNNuQMh4=;
	b=fkju08tlLs4UxpGA2Xbbp07Ioa0M+vN5am52bnxGSTb6fhfZ71xP5teYttNcjM8HDGCLL0
	4Euc6Hts5VS50SaACIyNbeiJw0xsSstf8N2mqX69K1mtExJN/RUxrfR7a/MApQRQAcKs1b
	GOZKiyGCkx1+PLuz19iLZJbeE7AnYyo=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-m-conHXYPruZQWgdFovPag-1; Thu, 21 Nov 2024 23:51:12 -0500
X-MC-Unique: m-conHXYPruZQWgdFovPag-1
X-Mimecast-MFC-AGG-ID: m-conHXYPruZQWgdFovPag
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-20d417fc584so18060515ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 21 Nov 2024 20:51:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732251070; x=1732855870;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=elmcLeOJm+mDVlXoOKcPt5H9RufxPwtwG8/LNNuQMh4=;
        b=HJHQXw/AwzDSjHjp7/RXtgv85odbfgxkY+GTaYphsinSZzz/i9BAW9fe1ATk5soXiU
         2mURvpS9ph8FJghu+lpD0ywx9TFrRYrFlR49BbZ+akOaIng1XkAC69mZfL+f+bDABQUG
         FlXTwscGluKZ8K//9vUfDquNtnEWaa0hq0Nz0i5n8FT6dk1dflqr4rW4fdy6vjxUwwNL
         71TCi0A/syGAJeAuOSzC3B6zjIHfgiUUN1l1WVh8i0CWd/mQX3TkaJtdDLI1z8XQCxYG
         xlOBHO2ZeTzoQ/+DIVL8ZfX03B5sRVDu90KXTL1T/xV4sDtZOL8wjBg3kLyNeOJPmjoG
         grNg==
X-Gm-Message-State: AOJu0YxbREo4sCPEW2vjKluNVevNCfGtla3WIM5FoN3B3+kEOhoOe3Ah
	cEvtE8QmmBOpQXfL7/0Kp9M5MALV5vy7U2/TfmLh0Nhg8gIVIvBesm9j6O0Cq5TMXUET8YFRNHX
	vVle9yrbLYyZsWvFd2Oc39hr+aEBGwXtJu2GIBVmtR6AQPl2XMu9irUSj3j86h6tFS8qLaXc0tL
	I6XnG0WBZS7MfrCXdu/6d2GaDr6SV2L/sL6PW1ASS2MfrB
X-Gm-Gg: ASbGncsPkm+l5eDCGTZZEz4l6ZIYxjlJwp/h1ZvEz+47C1f9aadUJ4yPxWtPdMg82nd
	4zNZYAwQqSG3kr3GjmSGS5DSGjiOq1k7Lrph4AUg7Gjx9JLUgRatN268KQyiMu7GidhPi/lowjO
	e8umbEbF9DohGb4iXF1xm2AMQXZfkbtDkG2IzxMT+d3diZML05LtVMKGBnEScxl9nBCXpSfMHFs
	ahfrnb3gylXbIYcGtlYz7JguIHUZc5DctzlR7RoRWfaHmZhCyW8zXKHpqkWjMfkv2ruWdaRWqU2
	nC3zF/Mv1MDKnYw=
X-Received: by 2002:a17:902:c941:b0:20b:5231:cd61 with SMTP id d9443c01a7336-2129f69b854mr22674885ad.24.1732251070545;
        Thu, 21 Nov 2024 20:51:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHBJ1BtUcuXXUDQhFQr7YmLqB9vBuzW4fZgWvFNsJCyj+YfStMRgSAXhC2TW5WeP5odlF6x7Q==
X-Received: by 2002:a17:902:c941:b0:20b:5231:cd61 with SMTP id d9443c01a7336-2129f69b854mr22674655ad.24.1732251070090;
        Thu, 21 Nov 2024 20:51:10 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129dbfa834sm6870955ad.117.2024.11.21.20.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 20:51:09 -0800 (PST)
Date: Fri, 22 Nov 2024 12:51:06 +0800
From: Zorro Lang <zlang@redhat.com>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [Bug report] kernel BUG at include/linux/scatterlist.h
Message-ID: <20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I hit a kernel panic on aarch64 several times recently, when I tried to do a
fstests test. It's not related with fstests, due to I hit it when I boot the
latest mainline linux kernel (HEAD=fc39fb56917bb3cb53e99560ca3612a84456ada2).

The console log looks like related with crypto things, I'm not familar with
it, so just send this email to linux-crypto@ and cc linux-kernel@.

I hit this panic several times, I did nothing except building and installing
the latest kernel and then boot it, then it crash directly on booting time.
Looks like crash from:

       183 static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
       184                               unsigned int buflen)
       185 {
       186 #ifdef CONFIG_DEBUG_SG
==>    187         BUG_ON(!virt_addr_valid(buf));
       188 #endif
       189         sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
       190 }

If someone need, I can provide the big linux/.config file.

Thanks,
Zorro


[1]
...
[    7.313015] registered taskstats version 1 
[    7.320132] Loading compiled-in X.509 certificates 
[    7.347635] Loaded X.509 cert 'Build time autogenerated kernel key: ed2b2ec16b583dda991830c146172ef4fd4cd1cf' 
[    7.522429] Demotion targets for Node 0: null 
[    7.523941] debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture page table helpers 
[    7.530102] page_owner is disabled 
[    7.532083] Key type .fscrypt registered 
[    7.533070] Key type fscrypt-provisioning registered 
[    7.535734] Key type big_key registered 
[    7.539305] Key type encrypted registered 
[    7.541143] ima: secureboot mode disabled 
[    7.542177] ima: No TPM chip found, activating TPM-bypass! 
[    7.543508] Loading compiled-in module X.509 certificates 
[    7.546783] Loaded X.509 cert 'Build time autogenerated kernel key: ed2b2ec16b583dda991830c146172ef4fd4cd1cf' 
[    7.549427] ima: Allocated hash algorithm: sha256 
[    7.550827] ima: No architecture policies found 
[    7.552706] evm: Initialising EVM extended attributes: 
[    7.554011] evm: security.selinux 
[    7.554842] evm: security.SMACK64 (disabled) 
[    7.555877] evm: security.SMACK64EXEC (disabled) 
[    7.557025] evm: security.SMACK64TRANSMUTE (disabled) 
[    7.558367] evm: security.SMACK64MMAP (disabled) 
[    7.559696] evm: security.apparmor (disabled) 
[    7.560726] evm: security.ima 
[    7.561451] evm: security.capability 
[    7.562297] evm: HMAC attrs: 0x1 
[    7.631769] Running certificate verification RSA selftest 
[    7.652546] ------------[ cut here ]------------ 
[    7.653656] kernel BUG at include/linux/scatterlist.h:187! 
[    7.654975] Internal error: Oops - BUG: 00000000f2000800 [#1] SMP 
[    7.656386] Modules linked in: 
[    7.657104] CPU: 3 UID: 0 PID: 176 Comm: cryptomgr_test Not tainted 6.12.0+ #1 
[    7.658822] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015 
[    7.660575] pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--) 
[    7.662385] pc : sg_init_one+0x124/0x150 
[    7.663401] lr : sg_init_one+0x34/0x150 
[    7.664380] sp : ffff800083e87950 
[    7.665240] x29: ffff800083e87950 x28: 0000000000000048 x27: ffff3fc6f3aabc00 
[    7.667078] x26: ffff3fc6f3aabc48 x25: ffff800083e87a60 x24: 1fffe7f8de689885 
[    7.668895] x23: ffffb3207fb10fe0 x22: 0000000000000100 x21: ffffb3207fb7d880 
[    7.670774] x20: ffff800083e87a20 x19: 0000b3207fb7d880 x18: 0000000000000000 
[    7.672568] x17: ffffb3207de83630 x16: ffffb3207de8306c x15: ffffb3207de78cb0 
[    7.674370] x14: ffffb3207d916474 x13: ffffb3207cf38c70 x12: ffff7000107d0f48 
[    7.676156] x11: 1ffff000107d0f47 x10: ffff7000107d0f47 x9 : dfff800000000000 
[    7.677939] x8 : ffff800083e87a40 x7 : 0000000000000000 x6 : 0000000000000004 
[    7.679738] x5 : ffff800083e87a20 x4 : 0000000000000000 x3 : 1ffff000107d0f44 
[    7.681515] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000600000000000 
[    7.683305] Call trace: 
[    7.683926]  sg_init_one+0x124/0x150 (P) 
[    7.684919]  sg_init_one+0x34/0x150 (L) 
[    7.685890]  rsassa_pkcs1_verify+0x288/0x980 
[    7.686976]  test_sig_one+0x344/0x848 
[    7.687916]  alg_test_sig+0xc0/0x168 
[    7.688859]  alg_test+0x2e0/0xd58 
[    7.689715]  cryptomgr_test+0x58/0x88 
[    7.690702]  kthread+0x270/0x2f8 
[    7.691542]  ret_from_fork+0x10/0x20 
[    7.692470] Code: a8c47bfd d50323bf d65f03c0 d4210000 (d4210000)  
[    7.694042] ---[ end trace 0000000000000000 ]--- 
[    7.695246] Kernel panic - not syncing: Oops - BUG: Fatal exception 
[    7.696819] SMP: stopping secondary CPUs 
[    7.697868] Kernel Offset: 0x331ffcf20000 from 0xffff800080000000 
[    7.699457] PHYS_OFFSET: 0xffffc03ac0000000 
[    7.700505] CPU features: 0x00,40000045,00801240,82004203 
[    7.701867] Memory Limit: none 
[    7.702637] ---[ end Kernel panic - not syncing: Oops - BUG: Fatal exception ]--- 

