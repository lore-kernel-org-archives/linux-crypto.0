Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A396E35F8D0
	for <linux-crypto@vger.kernel.org>; Wed, 14 Jan 2026 07:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768375659; cv=none; b=BPZUVBj2PNOjw/2Jz9nrHhp3mrnv2sidlTEN/mfBDe/GUm6jLq5Wlb0MYIOllRhmZ4++EBHslHlNZEAymLiBoM0MYNV0QRBbO+fOtaQU/FWN0v+Rs5DAmFbyNwoLBzlmpld1I+IO0XycmBfNxpRtEBObYrZQ2RYSovQ4FAyV1og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768375659; c=relaxed/simple;
	bh=DQUeirNpPP89aLFHeqsLAGeTASvH8cy8TfogQVOev1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSzu/EPy6rFeARAZA1qzniJo9FDWXak+6dJRaJBreR6dx8LxYzKQRl/Zu54OiiKodEsTMgu9r0Q62yXoId4n5QBJwdXXD0Uw8i5l7Tyw3yxOnA7rBnwhh6+hc2lEh29vrNLq61R0jx+9epQRvUNOlny44sK9+PqkPXfrq7myvlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jsy3RiMK; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jsy3RiMK"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-430f9ffd4e8so222455f8f.0
        for <linux-crypto@vger.kernel.org>; Tue, 13 Jan 2026 23:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768375643; x=1768980443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iatfbkb039XtZtG7yO5eMvoMHygvxkVJOdhG6yXVCuE=;
        b=Jsy3RiMKatD5gGcBzlt8vZgyZbSjtRMF8NHUerUpH4iSTn7cmUTXXg40ZxLiDVI4S+
         lMU6+0a3Vml9Oh4ebjleWnz1bjJDztZ9k3iAHceao/RIIQyE4Ou6Ago20/rDN2s6xZIV
         2Y0ZC61ca89sSy/eNeTN6tZqpAw4QSkuZX2X3u0JXIndZIppyAP0uZfg4T86VCjy1Mdz
         1GdJif+MPFpHCjjdnTsWlw9oWTmDkgiDNW25tQ5iwWjdEcBTtD9BuycYum9dGuJ1QRVX
         spcA1/CUW1fgVL2W14ffZsgyTWT07+WrJ+qsiNDoScL7QtD8/yR1kDToKCNvB1KFN9wh
         6/QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768375643; x=1768980443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Iatfbkb039XtZtG7yO5eMvoMHygvxkVJOdhG6yXVCuE=;
        b=U4l5Pu7FdteqSZX5v516AxKseqkwRPp734/3EyTA0hROQZEuR3Nj71BzCkKdPeyOv7
         5/jBJCW8dGcKFwiixEbNqDAIU+LeoXq18AoA4t5lX0dYNbJ9GgZ72AaV2J0qaWE/aKrK
         ZFJ4sTTChRN4JZNRYPW7R9L6yH9WYExFyeg5GPHzEoq2caQr2/A2OR/zkls+9YMTSrnr
         8o5MpfwbhF6HpPz2mvRL4nfHK3UEqp+xZp4SIP7SkdoxINeqPII7eK9CQhNveMnxjgQo
         UfmJJjs1OwOfnK7yiPPSmz2w7lDZsLP9CYmrePXnU9jAU0Ud0U9LWttTApIqPeZ/Zc07
         0kOA==
X-Forwarded-Encrypted: i=1; AJvYcCXrJ45i/DtUrXDEOhqJi3dsCG+ERKgPlntHOuC39rshdF2yzbfREshemm0glkgdeGQbn5ZEWxI18xnJ4Rk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbOvymqkZkS2fRtZGbbKY9wlsmwkS8f0sENnWqfsGnsN7xVL3D
	8kegm+7lJpAU/Aqo1GF/3tzB32Y2zrX3PfcucCSCsnQgUtb12Lv2VgAL
X-Gm-Gg: AY/fxX6FmQvIKi44LVQY8OxgepJUWLcm2XqOjLoAmZxOnFt2aObaNnBYZoNXX23MwDa
	ptK+RrhOayJt/TwOGhaV77GE84evTAwmabIcAYCTO5D2swKiaJJEw1GjYxhUNhDblTy08udaiH4
	AkEfZXIi6uVelJJP0Mdxd/bXGAc8Y7vyd/Kgwk1QjAVlZRcqW//QcMG8+UfeMzy3vlGmg4qC4cZ
	iMQ4kfRXfmI1AfxVe/kzo5kFZIX/BSVqamK50VsoE4y0MBC0aCzufZ8wI51EEm3rjAholOrg5Hb
	mrl4GRGCDKK1KHgmAjsGKYSY9A6OZGIGbKPRd84apfZYf2J8kZkLU7caxZ+FCGeJU/vW9L541PT
	7bRoJ2IhTLhl8vsrEsl1iwYDDhEl+fRvRKLBc0m3ua6xeCiqcp/idxSIN8fu7PJhsOHDpBjog0U
	TNAYbR0mQ=
X-Received: by 2002:a05:6000:402c:b0:431:66a:cbda with SMTP id ffacd0b85a97d-43423d4709emr6998700f8f.0.1768375642965;
        Tue, 13 Jan 2026 23:27:22 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-432bd0dacd1sm47532193f8f.4.2026.01.13.23.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 23:27:22 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com,
	agk@redhat.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	milan@mazyland.cz,
	msnitzer@redhat.com,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Wed, 14 Jan 2026 10:27:05 +0300
Message-ID: <20260114072705.2798057-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
References: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mikulas Patocka <mpatocka@redhat.com>:
> Askar Safin requires swap and hibernation on the dm-integrity device mapper
> target because he needs to protect his data.

Now I see that your approach is valid. (But some small changes are needed.)

[[ TL;DR: you approach is good. I kindly ask you to continue with this patch.
Needed changes are in section "Needed changes". ]]

Let me explain why I initially rejected your patch and why now I think it is good.


= Why I rejected =

In your patch "notify_swap_device" call located before "pm_restrict_gfp_mask".

But "pm_restrict_gfp_mask" is call, which forbids further swapping. I. e.
we still can swap till "pm_restrict_gfp_mask" call!

Thus "notify_swap_device" should be moved after "pm_restrict_gfp_mask" call.

But then I thought about more complex storage hierarchies. For example,
swap on top of some dm device on top of loop device on top of some filesystem
on top of some another dm device, etc.

If we have such hierarchy, then hibernating dm devices should be intertwined
with freezing of filesystems, which happens in "filesystems_freeze" call.

But "filesystems_freeze" call located before "pm_restrict_gfp_mask" call, so
here we got contradiction.

In other words, we should satisfy this 3 things at the same time:

- Hibernating of dm devices should happen inside "filesystems_freeze" call
intermixed with freezing of filesystems
- Hibernating of dm devices should happen after "pm_restrict_gfp_mask" call
- "pm_restrict_gfp_mask" is located after "filesystems_freeze" call in current
kernel

These 3 points obviously contradict to each other.

So in this point I gave up.

The only remaining solution (as I thought at that time) was to move
"filesystems_freeze" after "pm_restrict_gfp_mask" call (or to move
"pm_restrict_gfp_mask" before "filesystems_freeze").

But:
- Freezing of filesystem might require memory. It is bad idea to call
"filesystems_freeze" after we forbid to swap
- This would be pretty big change to the kernel. I'm not sure that my
small use case justifies such change

So in this point I totally gave up.


= Why now I think your patch is good =

But then I found this your email:
https://lore.kernel.org/all/3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com/ .

And now I see that complex hierarchies, such as described above, are not
supported anyway!

This fully ruins my argument above.

And this means that your patch in fact works!


= Needed changes =

Please, move "notify_swap_device" after "pm_restrict_gfp_mask".

Also: you introduced new operation to target_type: hibernate.
I'm not sure we need this operation, we already have presuspend
and postsuspend. In my personal hacky patch I simply added
"dm_bufio_client_reset" to the end of "dm_integrity_postsuspend",
and it worked. But I'm not sure about this point, i. e. if
you think that we need "hibernate", then go with it.


-- 
Askar Safin
