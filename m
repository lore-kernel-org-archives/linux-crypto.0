Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287283BBEC
	for <linux-crypto@vger.kernel.org>; Tue, 19 Mar 2024 20:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710881490; cv=none; b=OyY0VzCWXe32x7ZEQbAexmdta01PuHGNcERvYb9t0YZgdGGK6BvMMthtoVdUdfzruhc/5UOHbgeWm3t3VVfljCJtcU2bsscjG2Rt6ns0FbN0q1KCYGJbwQEGK7k5eNx2qyJgMQIyycatKAEs4pS5jAIV2Pg/+IXkDL6sFpitP8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710881490; c=relaxed/simple;
	bh=85uSy1BgmsS3GTVRdkd39siEYZ35oAsQyqVHs6iy5V8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BiZ0pqnnUKZwA9qpFeh+XWV0slu5cg8VsXNcq/GjUKbu1urIuZ9mmvvNlARYIg7Yz3uaO7IITzIrhFBUsX6MDuHrHKxFwknpB2eb/8Vn1eefue8DdCGQ9LDJq+QkgRvY02C2tfvxCqxRJ2cyAQRfB/B4PRLx7PeAiwyjV1goW5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bhza59/q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bhza59/q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710881487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=50Cf814cIlyFlBh4H0FAQBMccTz8+X4z7pGx1Pllfxs=;
	b=Bhza59/qeZMm4Os8Obz+5U7LC8oSd2ow83eRwCpsXp9JlBFi7R4oqpoul/10MkLJ9Vg7Mx
	zw6RcRzEXg3ATVH/VbAYyOyz9ZsfpczQtZ6ly7r6pM4ByGpF/ZKMohTjoypRkquCOa0Eam
	c/5vg/wTki7wiwOdk8i7Hhqxs8VwEm4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-1RpkC2pjN6eBK9Zl_HGfug-1; Tue, 19 Mar 2024 16:51:26 -0400
X-MC-Unique: 1RpkC2pjN6eBK9Zl_HGfug-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-68fa064556eso50880756d6.3
        for <linux-crypto@vger.kernel.org>; Tue, 19 Mar 2024 13:51:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710881486; x=1711486286;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=50Cf814cIlyFlBh4H0FAQBMccTz8+X4z7pGx1Pllfxs=;
        b=YxVczpLfyf2xGwQWinferZxV9CurtkY+xCiBuK9SWpFPowqstTImKnUB9z52eQdCLJ
         5tGRTDETcUt0uYdjptkZyUw14eV6xMAULVmR86XAZVnIBaxuU0HkpLNldIxRjDHVOb5p
         PdCBClaP8W8WVtGrteGkepKps+2yd0OaGaioA6wvvmkBPvhi2CniG5TL+rXKsAXhABM7
         Zt7uwN3AFDjbHO+vt0G6NF9DrkNeZQLVk6Hm5bfmGatsC6HE8JvnH0U/1YjK9o02YAak
         9/LIkUffVEj1aCilQZeOjDBxhFqPi7PWOt2Is+pr/l99a1CqR8HM+s0gY0iTCjfk4lVF
         WbgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOyxdsBVaDFbMmH5iBasdzuQAYNxS8i5FRkG53BAFvirTipVGOdWFaIKShcZEljSGM7CYhMdRyymXShuXi7anldYIlazHunXXZ2LLV
X-Gm-Message-State: AOJu0YxSUBcr7ePB5lrKHCWn+LmdMqUFPMr6KOvj4qp1RoPW2pCl6yNU
	svyVv87ktnNCXOKUJXydUDXzQ4w/9qyggNgVivTcyioVTrLSIaAKGBQAJ3wA9wqM+cqB1MLCqct
	A9qSzMHuoY/0G+UBPe0uzENWU6Bsx6CQc9BWthFv5b8m+2n+1MIzVfxgIgz5xmt2alaRaDA==
X-Received: by 2002:a0c:ab43:0:b0:690:a66b:268e with SMTP id i3-20020a0cab43000000b00690a66b268emr131874qvb.57.1710881485854;
        Tue, 19 Mar 2024 13:51:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFADjwuGFP0J7186i9biolmiuHU2FZru+zhspBIk0FHQ4sPu2zvGDxDJsgxwWjbRMZ384R/Bg==
X-Received: by 2002:a0c:ab43:0:b0:690:a66b:268e with SMTP id i3-20020a0cab43000000b00690a66b268emr131864qvb.57.1710881485555;
        Tue, 19 Mar 2024 13:51:25 -0700 (PDT)
Received: from localhost (ip70-163-216-141.ph.ph.cox.net. [70.163.216.141])
        by smtp.gmail.com with ESMTPSA id iu10-20020ad45cca000000b006914cd7a8b1sm6886432qvb.48.2024.03.19.13.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 13:51:25 -0700 (PDT)
Date: Tue, 19 Mar 2024 13:51:23 -0700
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Tom Zanussi <tom.zanussi@linux.intel.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org
Subject: Divide by zero in iaa_crypto during boot of a kdump kernel
Message-ID: <hyf3fggjvnjjdbkk4hvocmlfhbz2wapxjhmppurthqavgvk23m@j47q5vlzb2om>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Tom,

While looking at a different issue on a GNR system I noticed that
during the boot of the kdump kernel it crashes when probing iaa_crypto
due to a divide by zero in rebalance_wq_table. The problem is that the
kdump kernel comes up with a single cpu, and if there are multiple iaa
devices cpus_per_iaa is going to be calculated to be 0, and then the
'if ((cpu % cpus_per_iaa) == 0)' in rebalance_wq_table results in a
divide by zero. I reproduced it with the 6.8 eln kernel, and so far
have reproduced it on GNR, EMR, and SRF systems. I'm assuming the same
will be the case on and SPR system with IAA devices enabled if I can
find one.

Should save_iaa_wq return an error if the number of iaa devices is greater
than the number of cpus?


    [   17.242696] idxd: crypto: iaa_crypto now ENABLED
    [   17.248641] divide error: 0000 [#1] PREEMPT SMP NOPTI
    [   17.254358] CPU: 0 PID: 396 Comm: systemd-udevd Not tainted 6.8.0-63.eln136.1.x86_64 #1
    [   17.263399] Hardware name: Intel Corporation AvenueCity/AvenueCity, BIOS BHSDCRB1.IPC.2780.D02.2311070514 11/07/2023
    [   17.275266] RIP: 0010:rebalance_wq_table.part.0+0x163/0x220 [iaa_crypto]
    [   17.282851] Code: 85 c0 74 c1 8b 35 6d ed f3 c2 31 db 48 39 f3 73 4d 48 89 da 4c 89 f7 e8 9b 5a 26 c1 3b 05 55 ed f3 c2 89 c6 73 38 31 d2 89 d8 <f7> 35 9f 76 00 00 83 fa 01 41 83 d5 00 44 89 ef e8 68 f9 ff ff 85
    [   17.303974] RSP: 0018:ffa0000001147bb0 EFLAGS: 00010246
    [   17.309895] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000ffffffff
    [   17.317956] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
    [   17.326016] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
    [   17.334076] R10: ff1100005bff93c0 R11: 0000000000000003 R12: ffffffff826cbba8
    [   17.342137] R13: 00000000ffffffff R14: ff1100005bff93c0 R15: ff110000563968e0
    [   17.350197] FS:  00007f0697de8540(0000) GS:ff1100005ba00000(0000) knlGS:0000000000000000
    [   17.359333] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [   17.365834] CR2: 000055bf003ad358 CR3: 0000000046632003 CR4: 0000000000f71eb0
    [   17.373900] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    [   17.381960] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
    [   17.390020] PKRU: 55555554
    [   17.393113] Call Trace:
    [   17.395905]  <TASK>
    [   17.398310]  ? die+0x36/0x90
    [   17.401600]  ? do_trap+0xda/0x100
    [   17.405373]  ? rebalance_wq_table.part.0+0x163/0x220 [iaa_crypto]
    [   17.412265]  ? do_error_trap+0x65/0x80
    [   17.416519]  ? rebalance_wq_table.part.0+0x163/0x220 [iaa_crypto]
    [   17.423412]  ? exc_divide_error+0x38/0x50
    [   17.427970]  ? rebalance_wq_table.part.0+0x163/0x220 [iaa_crypto]
    [   17.434861]  ? asm_exc_divide_error+0x1a/0x20
    [   17.439805]  ? rebalance_wq_table.part.0+0x163/0x220 [iaa_crypto]
    [   17.446696]  iaa_crypto_probe+0x117/0x2e0 [iaa_crypto]
    [   17.452514]  really_probe+0x19b/0x3e0
    [   17.456674]  ? __pfx___driver_attach+0x10/0x10
    [   17.461715]  __driver_probe_device+0x78/0x160
    [   17.466659]  driver_probe_device+0x1f/0xa0
    [   17.471313]  __driver_attach+0xba/0x1c0
    [   17.475665]  bus_for_each_dev+0x8c/0xe0
    [   17.480028]  bus_add_driver+0x116/0x220
    [   17.484380]  driver_register+0x5c/0x100
    [   17.488731]  iaa_crypto_init_module+0xe5/0xff0 [iaa_crypto]
    [   17.495043]  ? __pfx_iaa_crypto_init_module+0x10/0x10 [iaa_crypto]
    [   17.502032]  do_one_initcall+0x58/0x310
    [   17.506385]  do_init_module+0x60/0x240
    [   17.510640]  __do_sys_init_module+0x17a/0x1b0
    [   17.515587]  do_syscall_64+0x81/0x160
    [   17.519746]  ? handle_mm_fault+0xdd/0x360
    [   17.524302]  ? do_user_addr_fault+0x2fe/0x670
    [   17.529248]  ? exc_page_fault+0x6b/0x150
    [   17.533697]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
    [   17.539413] RIP: 0033:0x7f0698a2ef1e
    [   17.543479] Code: 48 8b 0d 05 af 0e 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 af 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d2 ae 0e 00 f7 d8 64 89 01 48
    [   17.564605] RSP: 002b:00007ffe27da0918 EFLAGS: 00000246 ORIG_RAX: 00000000000000af
    [   17.573156] RAX: ffffffffffffffda RBX: 000055beffb45cb0 RCX: 00007f0698a2ef1e
    [   17.581216] RDX: 000055beffb78ba0 RSI: 0000000000026400 RDI: 000055bf00386cf0
    [   17.589276] RBP: 000055bf00386cf0 R08: 000055beffb70340 R09: 0000000000026010
    [   17.597337] R10: 0000000000000005 R11: 0000000000000246 R12: 000055beffb78ba0
    [   17.605397] R13: 000055beffb71110 R14: 0000000000000000 R15: 000055beffb45fe0
    [   17.613459]  </TASK>


Regards,
Jerry

