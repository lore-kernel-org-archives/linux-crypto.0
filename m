Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A6946C4B0
	for <linux-crypto@vger.kernel.org>; Fri, 28 Aug 2026 13:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787925205; cv=none; b=MZfgmvIg44uLWhIYznMHy/z1M2A+XVdEMiIaRxoD0QoJ3gqOhdIghuMVAh+vCEcH2JwlU2piaqsc12BwcApAR1+A7ajqrRKhyMJLdZRgrk+BB2mXrW2t1cGVJp5cSrgQAUReWnXn0zkgPKQvTHlRCGz9/6VLNkzNanzE2q9jLIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787925205; c=relaxed/simple;
	bh=yJpirEdYLDv3Lpmiy9lhgbwmZPn/muRM8SXvz22kC3Q=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BXXLS6mxDExPsj0pQedwN6ryiwXK++5t0a+N1iYoYlf6nf4kgp7zGusT3BW7IBd7K3U1IYbq6Chr4ZM4TOo0ngrgoiekzGOv9L8JeqeOvgW0XJBg8XHVXAwmI6fKWQWLu1Q7pOloFKA9o9/KuIE/qLKA9jT5aC1mYQJ5lONBHag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bobPOTiD; arc=none smtp.client-ip=74.125.227.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bobPOTiD"
Received: by mail-pj2-f1.google.com with SMTP id d9443c01a7336-2cb3f5bb19aso3552575ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Aug 2026 06:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787925204; x=1788530004; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6mle5YRJMS9wzlR77hySHcKB/BuhCX1MGF7sU1sRYoQ=;
        b=bobPOTiDlVYjOyhLlF/mTZ60lJ7rQabBnE+86Th+CaFgEUJg8MjWHTaZhr2ffATYOW
         zj5h5LSEhdYhaozW/jY+3XXXVpKorVXgKO56eepD1ph86ujFsw2hKwz+y4Ny36URVwpn
         3+Fe36zo6iA2aP0za2M8miac0akP0WXjJanPGuebHSw4TAyRVC10t51JILSi24ndB1Yr
         kUGosC6BZZkcLBifKfINajq5WKxvNRMqsf/+tHmCpRew+EG+9SMk0M7Im5yLqp7AReOk
         p+r+3Gpqi66V9sIAFRLVrqu5o9Dv/dOtO+LuMPef81Q5PY0edraZ1iqeSpj7x6uf0KYV
         f7lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787925204; x=1788530004;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6mle5YRJMS9wzlR77hySHcKB/BuhCX1MGF7sU1sRYoQ=;
        b=YH1FNLuetTxnD1/Yke97xtysanoHItCiD/WRuEnSzmm1LUi2o3tKjmpQJoZlfUSXFi
         o0mMQHDIjxXzZ7pXmbN3X2n3uxhLAejazIDIJj17l+ZyT4iQydAXFCECl+vMK9Uyz5Um
         BtLTw3I+pB5gB6z9H+ADELUQ8GGgCKOV5algrAdh7ORY+H36pqBEPydvErnY0bscSd9e
         nfJ2qlN+W1fGcswC2pgzmSJyDI0BrZi+Bbn9GFSqW/cIOjMpDD2OQ3VkmKhVgfIfi/0F
         b9QGje/GnAGTQw7AWBXlj12+d/IS/KAF5XqXTHQGGewCnEuNuAyE0vnVyy88Qpql1FzA
         WIOw==
X-Forwarded-Encrypted: i=1; AHgh+RpHvI3Hbclxe68Vt+Z9ezBUN3Y0rOW1Vxj8Wb7rDL+fpT5coeSIkhngpDFk0XFGBSfqQARKslGoD3EZuyo=@vger.kernel.org
X-Gm-Message-State: AFuF++mAk603v/oqrBN+4YrVKAw8teonPIw7VretP6NqsQXtYmf5RzlH
	Odspf2fbtcZTzyAqb4mQoEhSbYiSaQARsauj0eboiSyX4ZkQ6Djgh8X8
X-Gm-Gg: AR+sD117cST0s8vIsklei3j2IZVuLQKltLMCQzjY8ao/sgI5Be1tEEtVZWY5SYzQWLu
	zvEQpGOoKZV8lBF/DLq5nNKawYvweYRJ4gcrUTmP0YbWerkeuKsNgyB8nnkq1CcCEMi2rSK4rEd
	Rxj5Iufd8mWOIgSeungw0RKbxsYzapgU60BoW1xnPC+y5Pf9cintdDlZlABLomvmsvZrTOuaB0d
	77i68V5xB5wK8VYR/9uQYEPLTkLEWBQS6iwvZ52hqqLfSVWaPPwXo/W498IfT7Ato/dHDZvrm/s
	VloqkAgV8BqloqhI96d5LG9N+wXkocnlen24gM0/QUpusUkPPcldp51N++Ay/oGurjsaY/yaStM
	6i3nPH+BAfeAyfExPh47VzidUm94dKdIDasCzeRldCbnwOxpZHvqumMPy3vXGuCU3gpmQv0RQjq
	rqAMqoz1em2OpFMalTOmLrgS5NuQBuOx+M0VpRyDyLYwfZvRDz6hdt1lBNGS8dWRmWzYUegNCtQ
	Vx/mQ==
X-Received: by 2002:a17:90b:388e:b0:38d:ddc2:7ccb with SMTP id 98e67ed59e1d1-396d0eaabfamr13856671a91.1.1787925202950;
        Fri, 28 Aug 2026 06:53:22 -0700 (PDT)
Received: from localhost ([117.71.111.40])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396d29af238sm1052158a91.1.2026.08.28.06.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 06:53:22 -0700 (PDT)
Date: Fri, 28 Aug 2026 13:53:18 +0000
Message-ID: <7d6ad3d784e7c4e0ba8455064ef536f4.archwse@gmail.com>
From: Evanshenf <archwse@gmail.com>
To: liulongfang <liulongfang@huawei.com>, linux-crypto@vger.kernel.org
Cc: Weili Qian <qianweili@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 David S. Miller <davem@davemloft.net>
Subject: Re: [BUG] crypto: hisilicon/hpre: RSA request never completes during signed module verification on Kunpeng arm64
In-Reply-To: <dd6abf73-91d3-8949-59e8-549a2fe6c39e@huawei.com>
References: <178779980745.730913.5616603289665364629.hisi-hpre-7980@gmail.com>
 <5ec5464b-a84d-48c4-6ef7-d60944ae94a9@huawei.com>
 <178782001632.797153.17584967022446448195@gmail.com>
 <dd6abf73-91d3-8949-59e8-549a2fe6c39e@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Longfang and all,

Thank you for analyzing the issue and providing the GIC ITS Collection
BASER change. I applied the exact change to the source baseline used by
the installed PVE kernel and completed a real-machine validation.

The result is PASS.

The original kernel allocated only 256 flat Interrupt Collection entries
on each ITS:

  allocated 256 Interrupt Collections (... flat, esz 16, psz 4K ...)

This system has 320 possible CPUs, and the completion IRQ of the failing
HPRE PF was effectively targeted at CPU 265. With the proposed change,
`order_base_2(num_possible_cpus())` caused all four ITS instances to
allocate 512 flat Collection entries:

  allocated 512 Interrupt Collections (... flat, esz 16, psz 4K ...)

The table remained flat on this hardware; the effective fix was increasing
its capacity from 256 to 512 entries.

For deterministic testing, I used a one-time kexec image with the same
`7.0.14-6-pve` release. The ITS change was the only functional source
patch. I built HPRE/QM in and added only the original kernel's public
module-signing certificate to the test keyring, so package-signed `xfs.ko`
verification selected:

  pkcs1(hpre-rsa,sha512), priority 1000

No private key was used. The production kernel and initramfs were not
replaced.

I then explicitly set the completion IRQ for `0000:7a:00.0` to CPU 265 to
reproduce the original out-of-range Collection ID and ran signed-module
load/unload tests pinned to each NUMA node.

Results:

  PF                CPU   cycles   send   recv   completion IRQ delta
  0000:3e:00.0        0      250    250    250       250
  0000:3a:00.0       80      250    250    250       250
  0000:7e:00.0      160      250    250    250       250
  0000:7a:00.0      240     1250   1250   1250      1250

For the original failing PF, the completion vector remained on effective
CPU 265 throughout the test. Its IRQ count changed from 2 to 1252,
exactly matching the 1250 HPRE completions.

Across all 2000 hardware RSA verifications:

  send_busy_cnt   = 0
  send_fail_cnt   = 0
  invalid_req_cnt = 0
  watchdog events = 0
  residual D tasks = 0

There were no HPRE/QM error or timeout messages and no
`rsassa_pkcs1_verify` blocked-task warning.

After validation, I performed a normal firmware reboot. The host returned
to the untouched signed production kernel, the HPRE blacklist remained
active, PVE services and hosted workloads recovered, and software-RSA
module verification passed.

This confirms that the undersized ITS Collection table caused the
reproduced completion loss and that your change resolves it on this
320-CPU Kunpeng system.

Please feel free to add:

Tested-by: Evanshenf <archwse@gmail.com>

If you submit this change upstream, I would appreciate a link to the patch
thread so I can follow any review or run additional tests if requested.

Regards,
Evanshenf
GitHub: https://github.com/Evanshenf
