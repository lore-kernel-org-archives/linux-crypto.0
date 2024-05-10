Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D8438396
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 09:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715332934; cv=none; b=OaKom+vR15VcDceaHcIHhEZ0Ycl1XNKYczsogKUP0GXNazO+v7lsSJEPcCU6j7ZqwP2DFNAid1Twt226ayCClkFhc4zZyHPDhcajuM3EUOFbt8r9csNHHgBfOcoFFsKskHiT+1FC7XqdWdkNvPUWKnnr8OeewP+8u/0Q7xcQS7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715332934; c=relaxed/simple;
	bh=fcTSEUDWOhgk7gRhwUfZbupZ9Z7U6Z95LVhWarKdWVU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=mhr3tSzaRKGNnqTwDiGHcxKJLImCGH9nu0PAko3T5o51QmG/A2t8PcgK9xvepavFffdt4E6oEESi25yqcOTYpzj5D6dF3R9ptdIa6hzYmncbdjVUeCi4n2FOfaAn3lyVXPNkJbd+nrvIVbc38DDtsGTPexEbYT/T04Ot0o8GbiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eBeDjqd5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eBeDjqd5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715332931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=EQzyDRlKNx0K9GC+x0R0vqlQJ9qg0rKXpnc4mE5bFhE=;
	b=eBeDjqd5DtljN63uJb8AHeiloqGfSfw8IivRZg9qxGGRLLEsfv19BVZiOZKnt0aqYTgTZD
	AqT5JwGnhaPGEA2d0UWaHzhu6vVdtYyAys6JP/JhA9D9ujhKS+VehZaZsFKrmUDpHj2WfK
	p7H3fA/pVYEKZpULQqasfgRp/SGkdU4=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-1Z2P5_lsPzit5KbgJ0EIhA-1; Fri, 10 May 2024 05:22:09 -0400
X-MC-Unique: 1Z2P5_lsPzit5KbgJ0EIhA-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2b5bc0952a3so1702822a91.3
        for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 02:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715332928; x=1715937728;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EQzyDRlKNx0K9GC+x0R0vqlQJ9qg0rKXpnc4mE5bFhE=;
        b=bV62eSG0ezTPgY84wlsGaoz8TqLo6VjZM1brG6EPuCkVPzxHh9GOZ69EJwLmYR3nI2
         J2LIC+N4uecF0jfFLuHfRc6rlbKyaFFV8GE4qATLxY2D6I6IgYqnhHbxXQdfpBGpo0xD
         W1YvXdeJHokIcAhwgUbz4fSeN0NqJzBjgx8qvagYs9Gv+7ZbKrFPG9uAOa2y82ErkSTs
         sdLcKhriLQvxdJQO9DAurJ6IhYB0ws7CG80mgsPajIt/6sxWZL2UhtmhtlrrKWDn0/sJ
         a2vBBgMxWk+5uiKojtaSyNcAJezvbsXBRWq4VyFzmhnk47RDQX37mwoFbA7VpnnpfTsq
         ZK8w==
X-Gm-Message-State: AOJu0Yy+Sq3BUOqKv6Qgfmm1qAbnqVYRcMc1Dq3bzYvyvMEctnyrMoa0
	oWQZ8h+ETcrAyevImuMgHVpoM9EBueOeTBlsx9sCudbX8g/azq7mtlKu8xnn1cXgvN1YyhyqNxI
	iGVvrGdurF1SDXd+LKIHnHQGluGtWCfyD3CuohTC0dYbSZmlMnpS09U/7Y9kG3QmO9PMtmV1O8/
	ePJcvjecdUG7uS4LwaCCboYJBrmYYvR2ERT0LbLCSNBYpQP5VOgw==
X-Received: by 2002:a17:90a:b101:b0:2a2:7edd:19b7 with SMTP id 98e67ed59e1d1-2b6cc7805e1mr1781395a91.27.1715332927572;
        Fri, 10 May 2024 02:22:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJEfIBhwmazSuERrVglFcfJqeRX1pgb4K2MVI/Xx841nAiJfmq8oDeBV5MXracXegoz+EbC+KN0Sr51uwBhng=
X-Received: by 2002:a17:90a:b101:b0:2a2:7edd:19b7 with SMTP id
 98e67ed59e1d1-2b6cc7805e1mr1781380a91.27.1715332927110; Fri, 10 May 2024
 02:22:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Changhui Zhong <czhong@redhat.com>
Date: Fri, 10 May 2024 17:21:56 +0800
Message-ID: <CAGVVp+X7_k_a561s6dZX0tHoM2j8cg2D_AnE6UJ9HMyAbAiXjQ@mail.gmail.com>
Subject: [bug report] Kernel panic - not syncing: alg: self-tests for xxhash64
 (xxhash64) failed in fips mode!
To: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I hit the kernel panic on recent upstream, please help check it and
let me know if you need any info/testing for it, thanks.

repo:https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
branch:for-next
commit HEAD: d7c9295b12e267bd9b6623bd6e23637f4bb5ceb2

reproducer:
# fips-mode-setup --enable

[   15.665335] alg: hash: failed to allocate transform for xxhash64: -2
[   15.671682] Kernel panic - not syncing: alg: self-tests for
xxhash64 (xxhash64) failed in fips mode!
[   15.680800] CPU: 33 PID: 1416 Comm: modprobe Not tainted 6.9.0-rc4+ #1
[   15.687315] Hardware name: GIGABYTE R152-P31-00/MP32-AR1-00, BIOS
F31n (SCP: 2.10.20220810) 09/30/2022
[   15.696607] Call trace:
[   15.699040]  dump_backtrace+0x9c/0x130
[   15.702780]  show_stack+0x1c/0x30
[   15.706082]  dump_stack_lvl+0x34/0xe0
[   15.709733]  dump_stack+0x14/0x20
[   15.713035]  panic+0x390/0x3d8
[   15.716079]  alg_test+0x574/0x580
[   15.719382]  do_test+0x4ad0/0x7468 [tcrypt]
[   15.723556]  do_test+0x744c/0x7468 [tcrypt]
[   15.727729]  tcrypt_mod_init+0x64/0xfff8 [tcrypt]
[   15.732423]  do_one_initcall+0x50/0x2e8
[   15.736246]  do_init_module+0x5c/0x280
[   15.739984]  load_module+0x1f48/0x2008
[   15.743721]  init_module_from_file+0x90/0xd0
[   15.747979]  __arm64_sys_finit_module+0x168/0x3a8
[   15.752670]  invoke_syscall.constprop.4+0x50/0xe0
[   15.757363]  do_el0_svc+0x78/0xc0
[   15.760666]  el0_svc+0x40/0x1b8
[   15.763795]  el0t_64_sync_handler+0x98/0xc0
[   15.767966]  el0t_64_sync+0x160/0x168
[   15.771616] SMP: stopping secondary CPUs
[   15.775842] Kernel Offset: 0x276185f00000 from 0xffff800080000000
[   15.781922] PHYS_OFFSET: 0x80000000
[   15.785397] CPU features: 0x0,0000000b,80140528,4241720b
[   15.790696] Memory Limit: none
[   15.793737] ---[ end Kernel panic - not syncing: alg: self-tests
for xxhash64 (xxhash64) failed in fips mode! ]---

--
Best Regards,
     Changhui

