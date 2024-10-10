Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0248319D08F;
	Thu, 10 Oct 2024 17:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728581737; cv=none; b=rwX88dW6/DtlRjpnlBJtCoLs4m7sD3j4b42Od+ycQcoVwM3u5xeQKfi0+5qsSw7uaRBB+rcT/3QV6jKhDNxRe/7DJSZYI8X3+4kaJ9q0rXQhyQ2ulKO2QiPvHLeU36ILPwMvn2VQx7EEKAAnImfxCgBLO0JtsRfETPt77+7gDe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728581737; c=relaxed/simple;
	bh=S+rMcJ8/jS3HFXQyKZXsNh4spiuJuM4uFw4BGF5HU88=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kcDa3+JY8w3NIziKnmV0rFh0jueWqrYQnnTHw+yBiwXnAFEjC5HHG+GLC/T1Azt5amuJYwk5Ebs/UNfeUD4lGTLhhM5rqr3mYtpTVAj66H5f6Znbv+oDKRP8d1I3nmF5xSTotYyjDn9VHbYyQsJtSBj6tUPeET1zEuFroP/Oga8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AgCUVHda; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AgCUVHda"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-42cb57f8b41so13190205e9.0;
        Thu, 10 Oct 2024 10:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728581734; x=1729186534; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VNsUYQQaFG56Dmegv4Djw6iUIXglHdRgGxtxIZcSNOk=;
        b=AgCUVHdad6Mk57svc1EqzjHua8nsCUlSwGN7bl2Mdu7TNTs4cXNvx3rgH7LOvfUcJ9
         U6mPifmtvPljRvdMqBfINOBbW/pXnk9d2SQT5TOcmhf26eL3nDojWiNUr/HtIFyRq7xG
         SIQXp7ewKU5uhCBnTF0IAvGE98R5sXRXAnINLsDvtR/osVervlFv4TMAA2eUFKLUuB2B
         bmwGDKPerPnaM4II02/oO4snWZUsGoZ6RNKR5Ye4FURlR8pAkvs0YUzXYQ20VE6oxqIr
         M58QdtJk76qI6hKdmQbO7DJ9r3PbLYJ6XfCgqb4MaF/cOO108iN/ot257U8plu/E1JwU
         yn1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728581734; x=1729186534;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VNsUYQQaFG56Dmegv4Djw6iUIXglHdRgGxtxIZcSNOk=;
        b=VLPJtAhA6614+PuFqp76DtyTAa/h9ycGeXM9JHvUQsFv5InUWZ0Rn5tFDeOPVmHMxb
         WxvtfnyJZmDL6A+Soj2BSlSefBLDWFjVyFhpFQhOK7KRCyGrGAeNZ74GZN8DdTwbj+LA
         2zrmknupYB6mIef96uqUri8yNPryEgbfpD8ggsousrN3Zq/1sisKUSD8uHhBrYsVr9pK
         OvLE5KSzl2AIeGEKSCrRkZSiHvuAjP2a0Ysb7EApU/fC2N8siJJvme5WtVsD9JbEgAV/
         duYheYUsjvlupneTT+dCdznAj2iDOLxNAL6g3qDwXP7w0VQYgjkfcoMzn/DKSvUxcvnX
         Di9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWRVi7cteAuumIcBC5xUo2AfDpKoTN3sIHIk5WiDJ5pYNmZGrg+U62q42SSsg0wZKifoAsT0tJhS0i9+aM=@vger.kernel.org, AJvYcCXxb1+ipbzm2k5jgVhsexlwB0xGvlWto8GsvXyV7w6riFxiDC60bDzFEEI56HxWp75IVfaEWc0hHG8zdCxd@vger.kernel.org
X-Gm-Message-State: AOJu0YzVbD8SNyRxuPCtmKkPuGmmTtCpCl5IShfr3iJKoTKpQyNIMvwR
	oAr9g6yUCa3yRDfsEJB4f1lUWrvzEoyQ34wiIQo5wpewE/c+x2vE
X-Google-Smtp-Source: AGHT+IEbovSVPx7/3so4TpJhAALxqsgBJoh2Pa5F7DoDnnY+ormteMpIWujQQ0ypOiNF6zRd95uEqA==
X-Received: by 2002:a05:600c:4f14:b0:430:9fde:3b92 with SMTP id 5b1f17b1804b1-430ccf312c9mr84472395e9.14.1728581734201;
        Thu, 10 Oct 2024 10:35:34 -0700 (PDT)
Received: from ?IPv6:2a02:168:6806:0:e7da:5d3c:892a:5009? ([2a02:168:6806:0:e7da:5d3c:892a:5009])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431183065e2sm22042075e9.28.2024.10.10.10.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 10:35:33 -0700 (PDT)
Message-ID: <15fadc356b73a1e8e24183f284b5c0a44a53e679.camel@gmail.com>
Subject: Re: [REGRESSION] alg: ahash: Several tests fail during boot on
 Turris Omnia
From: Klaus Kudielka <klaus.kudielka@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: regressions@lists.linux.dev, linux-kernel@vger.kernel.org, Linux Crypto
 Mailing List <linux-crypto@vger.kernel.org>, Boris Brezillon
 <bbrezillon@kernel.org>, Arnaud Ebalard	 <arno@natisbad.org>, Romain Perier
 <romain.perier@free-electrons.com>
Date: Thu, 10 Oct 2024 19:35:33 +0200
In-Reply-To: <ZwePSPG8aWm6mwKK@gondor.apana.org.au>
References: <ZwJUO5Nz3S7EeqO6@gondor.apana.org.au>
	 <1fc4db6269245de4c626f029a46efef246ee7232.camel@gmail.com>
	 <ZwObXYVHJlBaKuj2@gondor.apana.org.au>
	 <38a275a4e0224266ceb9ce822e3860fe9209d50c.camel@gmail.com>
	 <ZwZAExmK52txvHE8@gondor.apana.org.au>
	 <7e38e34adddb14d0a23a13cf738b6b7cccbfce6f.camel@gmail.com>
	 <ZwduxHxQtHdzz-kl@gondor.apana.org.au>
	 <ZwePSPG8aWm6mwKK@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.0-1+b1 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-10-10 at 16:24 +0800, Herbert Xu wrote:
> On Thu, Oct 10, 2024 at 02:05:56PM +0800, Herbert Xu wrote:
> >=20
> > Is it really OK to add new entries to the chain after it has been
> > given over to the hardware?
>=20
> Please give this patch a try to see if it improves the hashing.
>=20
>=20

Hmmm, not really (patch applied on top of 6.12-rc2). 5 algorithms failed se=
lf-test.

[    0.385833] alg: ahash: mv-md5 test failed (wrong result) on test vector=
 3, cfg=3D"init+update+update+final two even splits"
[    0.390576] alg: ahash: mv-hmac-sha256 test failed (wrong result) on tes=
t vector 1, cfg=3D"init+update+final misaligned buffer"
[    0.396982] alg: self-tests for md5 using mv-md5 failed (rc=3D-22)
[    0.408306] alg: self-tests for hmac(sha256) using mv-hmac-sha256 failed=
 (rc=3D-22)
[    0.408311] ------------[ cut here ]------------
[    0.408316] ------------[ cut here ]------------
[    0.408313] WARNING: CPU: 0 PID: 72 at crypto/testmgr.c:5929 alg_test+0x=
618/0x640
[    0.408319] WARNING: CPU: 1 PID: 83 at crypto/testmgr.c:5929 alg_test+0x=
618/0x640
[    0.408330] alg: self-tests for md5 using mv-md5 failed (rc=3D-22)
[    0.408330] alg: self-tests for hmac(sha256) using mv-hmac-sha256 failed=
 (rc=3D-22)
[    0.408334] Modules linked in:
[    0.408336] Modules linked in:
[    0.408341] CPU: 1 UID: 0 PID: 83 Comm: cryptomgr_test Not tainted 6.12.=
0-rc2+ #1
[    0.408349] Hardware name: Marvell Armada 380/385 (Device Tree)
[    0.408353] Call trace:=20
[    0.408359]  unwind_backtrace from show_stack+0x10/0x14
[    0.408377]  show_stack from dump_stack_lvl+0x50/0x64
[    0.408388]  dump_stack_lvl from __warn+0x7c/0xd4
[    0.408400]  __warn from warn_slowpath_fmt+0x110/0x16c
[    0.408413]  warn_slowpath_fmt from alg_test+0x618/0x640
[    0.408426]  alg_test from cryptomgr_test+0x18/0x38
[    0.408436]  cryptomgr_test from kthread+0xdc/0xf8
[    0.408449]  kthread from ret_from_fork+0x14/0x28
[    0.408458] Exception stack(0xf0fe9fb0 to 0xf0fe9ff8)
[    0.408464] 9fa0:                                     00000000 00000000 =
00000000 00000000
[    0.408470] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[    0.408475] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    0.408479] ---[ end trace 0000000000000000 ]---
[    0.408480] CPU: 0 UID: 0 PID: 72 Comm: cryptomgr_test Not tainted 6.12.=
0-rc2+ #1
[    0.408489] Tainted: [W]=3DWARN
[    0.408492] Hardware name: Marvell Armada 380/385 (Device Tree)
[    0.408495] Call trace:=20
[    0.408498]  unwind_backtrace from show_stack+0x10/0x14
[    0.408513]  show_stack from dump_stack_lvl+0x50/0x64
[    0.408524]  dump_stack_lvl from __warn+0x7c/0xd4
[    0.408534]  __warn from warn_slowpath_fmt+0x110/0x16c
[    0.408547]  warn_slowpath_fmt from alg_test+0x618/0x640
[    0.408559]  alg_test from cryptomgr_test+0x18/0x38
[    0.408569]  cryptomgr_test from kthread+0xdc/0xf8
[    0.408581]  kthread from ret_from_fork+0x14/0x28
[    0.408590] Exception stack(0xf0fc5fb0 to 0xf0fc5ff8)
[    0.408595] 5fa0:                                     00000000 00000000 =
00000000 00000000
[    0.408602] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[    0.408607] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    0.408615] ---[ end trace 0000000000000000 ]---
[    0.408749] alg: ahash: mv-hmac-md5 setkey failed on test vector 0; expe=
cted_error=3D0, actual_error=3D-80, flags=3D0x1
[    0.419090] alg: self-tests for hmac(md5) using mv-hmac-md5 failed (rc=
=3D-80)
[    0.419099] ------------[ cut here ]------------
[    0.419104] WARNING: CPU: 1 PID: 75 at crypto/testmgr.c:5929 alg_test+0x=
618/0x640
[    0.419119] alg: self-tests for hmac(md5) using mv-hmac-md5 failed (rc=
=3D-80)
[    0.419123] Modules linked in:
[    0.419131] CPU: 1 UID: 0 PID: 75 Comm: cryptomgr_test Tainted: G       =
 W          6.12.0-rc2+ #1
[    0.419140] Tainted: [W]=3DWARN
[    0.419143] Hardware name: Marvell Armada 380/385 (Device Tree)
[    0.419146] Call trace:=20
[    0.419151]  unwind_backtrace from show_stack+0x10/0x14
[    0.419168]  show_stack from dump_stack_lvl+0x50/0x64
[    0.419179]  dump_stack_lvl from __warn+0x7c/0xd4
[    0.419191]  __warn from warn_slowpath_fmt+0x110/0x16c
[    0.419204]  warn_slowpath_fmt from alg_test+0x618/0x640
[    0.419217]  alg_test from cryptomgr_test+0x18/0x38
[    0.419227]  cryptomgr_test from kthread+0xdc/0xf8
[    0.419240]  kthread from ret_from_fork+0x14/0x28
[    0.419249] Exception stack(0xf0fcdfb0 to 0xf0fcdff8)
[    0.419255] dfa0:                                     00000000 00000000 =
00000000 00000000
[    0.419261] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[    0.419266] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    0.419270] ---[ end trace 0000000000000000 ]---
[    0.419541] alg: ahash: mv-sha1 test failed (wrong result) on test vecto=
r 1, cfg=3D"init+update+final aligned buffer"
[    0.430056] alg: self-tests for sha1 using mv-sha1 failed (rc=3D-22)
[    0.430063] ------------[ cut here ]------------
[    0.430068] WARNING: CPU: 0 PID: 82 at crypto/testmgr.c:5929 alg_test+0x=
618/0x640
[    0.430082] alg: self-tests for sha1 using mv-sha1 failed (rc=3D-22)
[    0.430086] Modules linked in:
[    0.430094] CPU: 0 UID: 0 PID: 82 Comm: cryptomgr_test Tainted: G       =
 W          6.12.0-rc2+ #1
[    0.430103] Tainted: [W]=3DWARN
[    0.430106] Hardware name: Marvell Armada 380/385 (Device Tree)
[    0.430110] Call trace:=20
[    0.430114]  unwind_backtrace from show_stack+0x10/0x14
[    0.430132]  show_stack from dump_stack_lvl+0x50/0x64
[    0.430144]  dump_stack_lvl from __warn+0x7c/0xd4
[    0.430155]  __warn from warn_slowpath_fmt+0x110/0x16c
[    0.430169]  warn_slowpath_fmt from alg_test+0x618/0x640
[    0.430182]  alg_test from cryptomgr_test+0x18/0x38
[    0.430192]  cryptomgr_test from kthread+0xdc/0xf8
[    0.430205]  kthread from ret_from_fork+0x14/0x28
[    0.430214] Exception stack(0xf0fe5fb0 to 0xf0fe5ff8)
[    0.430220] 5fa0:                                     00000000 00000000 =
00000000 00000000
[    0.430226] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[    0.430231] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    0.430235] ---[ end trace 0000000000000000 ]---
[    0.430326] alg: ahash: mv-hmac-sha1 setkey failed on test vector 0; exp=
ected_error=3D0, actual_error=3D-80, flags=3D0x1
[    0.440728] alg: self-tests for hmac(sha1) using mv-hmac-sha1 failed (rc=
=3D-80)
[    0.440733] ------------[ cut here ]------------
[    0.440736] WARNING: CPU: 0 PID: 73 at crypto/testmgr.c:5929 alg_test+0x=
618/0x640
[    0.440747] alg: self-tests for hmac(sha1) using mv-hmac-sha1 failed (rc=
=3D-80)
[    0.440750] Modules linked in:
[    0.440757] CPU: 0 UID: 0 PID: 73 Comm: cryptomgr_test Tainted: G       =
 W          6.12.0-rc2+ #1
[    0.440764] Tainted: [W]=3DWARN
[    0.440767] Hardware name: Marvell Armada 380/385 (Device Tree)
[    0.440771] Call trace:=20
[    0.440773]  unwind_backtrace from show_stack+0x10/0x14
[    0.440788]  show_stack from dump_stack_lvl+0x50/0x64
[    0.440798]  dump_stack_lvl from __warn+0x7c/0xd4
[    0.440808]  __warn from warn_slowpath_fmt+0x110/0x16c
[    0.440821]  warn_slowpath_fmt from alg_test+0x618/0x640
[    0.440834]  alg_test from cryptomgr_test+0x18/0x38
[    0.440844]  cryptomgr_test from kthread+0xdc/0xf8
[    0.440855]  kthread from ret_from_fork+0x14/0x28
[    0.440864] Exception stack(0xf0fc9fb0 to 0xf0fc9ff8)
[    0.440869] 9fa0:                                     00000000 00000000 =
00000000 00000000
[    0.440875] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[    0.440880] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    0.440884] ---[ end trace 0000000000000000 ]---

