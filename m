Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAC023C512;
	Tue, 24 Jun 2025 06:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750745111; cv=none; b=KDUaf7aQYSeMuvgj5ipa0UfHyh/SeNxDRM3rCOGuHq1EcMDOziR8JoD6emU5OQBfoTAQDZXg+5pZSvXw4F7cXudv4GrEmsRX2Lxaw5fEaCPQqjn5Q5+DIHQIabbVTFxor96qnar9DB4CApsN2V64PouJAd+pU43Q5ckGYu0Tm3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750745111; c=relaxed/simple;
	bh=QP4WQC8CMOGvDZ4qnjrX6paCES9KqmFkDIGfKhCkWWU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nGZnQXz9MhvkZYkVWRkYo+3sSQBcfZ9J35zl4reeFMVb07VhC/JzoZnFdC3+FiWJBMWNVK6Og7qtOvsCFzGZ2TRpzqQdNDvhGFJ+VB3fyptyhFM7l5kv8h+hiHBYtyZcQKr89gKVhKWjmd9sUOr2pmLk5EvDONJx/vh1Xp2c1BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TwzxxBim; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TwzxxBim"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-607b59b447bso7477414a12.1;
        Mon, 23 Jun 2025 23:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750745107; x=1751349907; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EBZgb29EYXnPQsHI45i7tM3hvc4Tx8NJtUvkYK3tyOg=;
        b=TwzxxBimvw8ZCwKKCtRYy0yk+iZh6pq94kWBEfGMl4PINFnfCyQpSsPZ25uWC+JmjY
         b1FNTd44e7Mr7JESfQhG9GEj3+Vea3AImHCpMOYmt80lNxoKwgpMKVppmycF1GIasG4N
         rsCf59WsSXXTM6var+10XmbHLU/+I9P/tcWFSiruCGPEdlgJZKplO5ULnbGmTzIpZt9T
         CNYqt3ReR59OgJ3M2j6bdLb7XKeB0HY1JBxNW20Wu8x04RpFGCmEgJCg11Ynr8iFRzal
         hzpEqbPEEYN0hHhJTqnux33a0qjjJplbny9EyKlm4xBJnQGjDeCwQdAGNoYXKnzxyQyk
         pmdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750745107; x=1751349907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EBZgb29EYXnPQsHI45i7tM3hvc4Tx8NJtUvkYK3tyOg=;
        b=s+lNl1d0ukpYTy9R5ws+5/QZzJ+0Ne1AsIEG/z53sQbD4MovOo8YCzUlbEd/4cXm/o
         sY9kB0HdYbgjCSt4reejkccnKSBPlAeLzSVoJ0bQkTBVCuG7Bka/bYe4oFeP9t1+IBqw
         svRbO7iG3OPGZAOgQfBSoDbvil5P58h39t5L+QXi4y63mLQ8u/lkR4rViFLuTWNph74N
         NUeoM3NAFk1FIPK/dwGv1aAgPbtsJAe16WzfE6Qc1/ryzs8iTEIbvVbojUtAQgyX33sG
         O6MZBJb+HcOt15AM+WlHz8zAzYxfQzQnfta2YmE2lsNRlrmRuIKfwom7GX4KmlGpokNM
         4A3A==
X-Forwarded-Encrypted: i=1; AJvYcCXAyKRw/zwx0u6cQO5tKmnGzUsbnpzfzs0YB6mx5lys4n34KT0A0v/q5OBfZRmCeFFbKR1xHKktm6CHV1Q=@vger.kernel.org, AJvYcCXMx2et8VVWRt9UmTurVM3F+pOok/AtLWeJT2uAHRqUiG3zBZ3QXsHmTv70mmthdCmVqmrp8Hy5C+jT50R7@vger.kernel.org
X-Gm-Message-State: AOJu0YwXIE7fPGmJdBlgz9oOrcBDkWq4h6LUvN6CPYyW9ZwaJe/ww80E
	y+yvLCTAbH6lmooAUH+rl+Aujvr59tzJ2jMewGwfMyQBLQ1AwJxbaMJXgIjHrncZvSOXaridOoz
	yqfu9EUFtffRtZxo4+o7nYa8sUvI2kTM=
X-Gm-Gg: ASbGnctUSRudWRD/SfsiN3O4j09X6yG23V6hkyjz435cSfdT6XfkKv29rEOLtZO+yPQ
	R3GDKBYyDabr0GNiSg/72RVwcaOlVe5R2VKfLaCqci8qdFbS36pWNZhLMNmKjj9xB8Swzxw3Kox
	Yvm8EIGBrWuxc22RBwdOZvWibw093/ezWkgHJJTT4FdN2BaTaqrYYzDA==
X-Google-Smtp-Source: AGHT+IE2tPbOe9hUTuHw6vgf6sU0gBe59KboyUclJqSCQN32+DNgQ+Ht2rZzqTOvZPWsgdaPsFGpWGZaZZmZYCHuchk=
X-Received: by 2002:a05:6402:2550:b0:607:3344:6ef1 with SMTP id
 4fb4d7f45d1cf-60a1cf2e082mr11666176a12.29.1750745106454; Mon, 23 Jun 2025
 23:05:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250623062547.1256-1-xisme1998@gmail.com> <d08e8494-851e-74b0-fdd8-ce2517dafc7a@amd.com>
In-Reply-To: <d08e8494-851e-74b0-fdd8-ce2517dafc7a@amd.com>
From: 1998 Xisme <xisme1998@gmail.com>
Date: Tue, 24 Jun 2025 14:04:54 +0800
X-Gm-Features: AX0GCFvy9g2iJYdu9gMMwAVxwnOAK4hAcmNPrIrWwfyp9QPkiC_39TVr8UY_VXs
Message-ID: <CADs4wpXGJpm7L2nOpvdKv2U0TZNizEqku_HBzAJ-gn86XAPRMQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccp - Fix crash when rebind ccp device for ccp.ko
To: Tom Lendacky <thomas.lendacky@amd.com>, herbert@gondor.apana.org.au, 
	davem@davemloft.net
Cc: john.allen@amd.com, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

You're right. But I checked with checkpatch.pl and it reported:

WARNING: debugfs_remove_recursive(NULL) is safe and this check is
probably not required
#70: FILE: drivers/crypto/ccp/ccp-debugfs.c:324:
+       if (ccp_debugfs_dir) {
+               debugfs_remove_recursive(ccp_debugfs_dir);

Perhaps we could simplify it to:

        mutex_lock(&ccp_debugfs_lock);
        debugfs_remove_recursive(ccp_debugfs_dir);
        ccp_debugfs_dir =3D NULL;
        mutex_unlock(&ccp_debugfs_lock);

I'll send a v2 patch soon.

Tom Lendacky <thomas.lendacky@amd.com> =E4=BA=8E2025=E5=B9=B46=E6=9C=8824=
=E6=97=A5=E5=91=A8=E4=BA=8C 01:17=E5=86=99=E9=81=93=EF=BC=9A
>
> On 6/23/25 01:25, Mengbiao Xiong wrote:
> > When CONFIG_CRYPTO_DEV_CCP_DEBUGFS is enabled, rebinding
> > the ccp device causes the following crash:
> >
> > $ echo '0000:0a:00.2' > /sys/bus/pci/drivers/ccp/unbind
> > $ echo '0000:0a:00.2' > /sys/bus/pci/drivers/ccp/bind
> >
> > [  204.976930] BUG: kernel NULL pointer dereference, address: 000000000=
0000098
> > [  204.978026] #PF: supervisor write access in kernel mode
> > [  204.979126] #PF: error_code(0x0002) - not-present page
> > [  204.980226] PGD 0 P4D 0
> > [  204.981317] Oops: Oops: 0002 [#1] SMP NOPTI
> > ...
> > [  204.997852] Call Trace:
> > [  204.999074]  <TASK>
> > [  205.000297]  start_creating+0x9f/0x1c0
> > [  205.001533]  debugfs_create_dir+0x1f/0x170
> > [  205.002769]  ? srso_return_thunk+0x5/0x5f
> > [  205.004000]  ccp5_debugfs_setup+0x87/0x170 [ccp]
> > [  205.005241]  ccp5_init+0x8b2/0x960 [ccp]
> > [  205.006469]  ccp_dev_init+0xd4/0x150 [ccp]
> > [  205.007709]  sp_init+0x5f/0x80 [ccp]
> > [  205.008942]  sp_pci_probe+0x283/0x2e0 [ccp]
> > [  205.010165]  ? srso_return_thunk+0x5/0x5f
> > [  205.011376]  local_pci_probe+0x4f/0xb0
> > [  205.012584]  pci_device_probe+0xdb/0x230
> > [  205.013810]  really_probe+0xed/0x380
> > [  205.015024]  __driver_probe_device+0x7e/0x160
> > [  205.016240]  device_driver_attach+0x2f/0x60
> > [  205.017457]  bind_store+0x7c/0xb0
> > [  205.018663]  drv_attr_store+0x28/0x40
> > [  205.019868]  sysfs_kf_write+0x5f/0x70
> > [  205.021065]  kernfs_fop_write_iter+0x145/0x1d0
> > [  205.022267]  vfs_write+0x308/0x440
> > [  205.023453]  ksys_write+0x6d/0xe0
> > [  205.024616]  __x64_sys_write+0x1e/0x30
> > [  205.025778]  x64_sys_call+0x16ba/0x2150
> > [  205.026942]  do_syscall_64+0x56/0x1e0
> > [  205.028108]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > [  205.029276] RIP: 0033:0x7fbc36f10104
> > [  205.030420] Code: 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00=
 00 00 00 66 90 48 8d 05 e1 08 2e 00 8b 00 85 c0 75 13 b8 01 00 00 00 0f 05=
 <48> 3d 00 f0 ff ff 77 54 f3 c3 66 90 41 54 55 49 89 d4 53 48 89 f5
> >
> > This patch sets ccp_debugfs_dir to NULL after destroying it in
> > ccp5_debugfs_destroy, allowing the directory dentry to be
> > recreated when rebinding the ccp device.
> >
> > Tested on AMD Ryzen 7 1700X.
> >
> > Fixes: 3cdbe346ed3f ("crypto: ccp - Add debugfs entries for CCP informa=
tion")
> > Signed-off-by: Mengbiao Xiong <xisme1998@gmail.com>
> > ---
> >  drivers/crypto/ccp/ccp-debugfs.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/crypto/ccp/ccp-debugfs.c b/drivers/crypto/ccp/ccp-=
debugfs.c
> > index a1055554b..0d432f3c4 100644
> > --- a/drivers/crypto/ccp/ccp-debugfs.c
> > +++ b/drivers/crypto/ccp/ccp-debugfs.c
> > @@ -320,4 +320,5 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
> >  void ccp5_debugfs_destroy(void)
> >  {
> >       debugfs_remove_recursive(ccp_debugfs_dir);
> > +     ccp_debugfs_dir =3D NULL;
>
> Hmmm... it seems like this should be protected by the mutex similar to ho=
w
> ccp5_debugfs_setup() is, right?
>
> Maybe something like:
>
>         mutex_lock(&ccp_debugfs_lock);
>         if (ccp_debugfs_dir) {
>                 debugfs_remove_recursive(ccp_debugfs_dir);
>                 ccp_debugfs_dir =3D NULL;
>         }
>         mutex_unlock(&ccp_debugfs_lock);
>
> That should also fix the issue, thoughts?
>
> Thanks,
> Tom
>
> >  }
