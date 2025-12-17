Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BABE330305
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 23:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766013528; cv=none; b=twvDWYA5vDqeun/OaXkY828o0vYVt3qpP7m5CffyPnuwBcmU0itEbnvLDU6ShPfW7fAuuPdbFCXtWh1Xm7nweM75XnEtXZEfS0TPHq4lI4e0S1NsL4fkovd34Px3T0NDDwIecYSCT6OZsbPQsX2Q846abHZU/H97iH250/1K0bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766013528; c=relaxed/simple;
	bh=C1X5R0T9A6CrUnxpIm/QVXVuRULmzTp597QRk97zyjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OX2bq2e0Cn+5T4JfYY83/QUXoQU0tS86k8eY7YP5kd93XhDiLcqmAzEEYvvkn/oi5VbD0o1WxEj4zgqW3zxCzaNvklOdgH8hdlqbPOUHLNiPgnPpJQDvt62Y+UzznHFEmEfREZVPMvKBBco6pFZQh9aUpJ3cFDJXBTtG2sURikA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VBaT4sxa; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VBaT4sxa"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-597de27b241so17498e87.2
        for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 15:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766013524; x=1766618324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZvc3rVI0di0d/Re6Le5Bvc+vMvJtdhpmIxMnxjb6tA=;
        b=VBaT4sxaHFvfVHw/0PNR0mma9L9CQCE0t1LZsPF9klP2ecyZEgzKiX754iClqRnz0f
         GmmYZH9YBVrmYyy8S74MtCYaKuLLOE2twPEfhgrGbfkH8UXctcxVy2vj9OV5ntO4+YDt
         N24t/STd7wbl7G92s0Ny+GD1Htd8YjaiuuS7DGr+Iv8Q9IUwNUEXilozkJvTMnE86WQu
         MnZ+OnIJvOTufXzIWehEwX5Rn+kCV2O/NoVJ2bWPv2EgbMUdijMRcUlXoqnDdN/RqdV2
         qtSKWp2M81Sd6yvPFFJro9CHX/HMKbmz3BzLch4xdn6FHJrroyI4t4EVNBxfQxTI6t+V
         6rDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766013524; x=1766618324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AZvc3rVI0di0d/Re6Le5Bvc+vMvJtdhpmIxMnxjb6tA=;
        b=RnkpfL/dYfMdHkG5Drhpl0ujhQF4ZiYM63+amvySm1BxMzAeg+3Sc2acW6AHMs8rJ/
         KDGTwUvuicYc45Xs+QS2+q9aDs3SwycvQhAWBBoi+7x6GBNOzbCvVykUpKhieTHHPryW
         i8+zUf8/iCvNAYkz+DIs/ecqhUkjyI1u+weLF7WO7lVbpC2OW9VK/1QGm9WsMMOHT0/o
         Y0mn0WgOx0iejD2vTqJ38gRPRKucXAwJe5xnul8/9nxXCXfWrGQjDBH9W1flPEQNRG5w
         XEu4BtDyzl0mV7uKWGaF4ZJWunDQm/sCk5p44HqzCCVku2ywnqAB51mrGW7GqUTRM2pb
         kDTg==
X-Forwarded-Encrypted: i=1; AJvYcCUjXl7R3kCYEDDi7kj04JFjjn/DtiGcsq+mKdZkEdVAcCSEnOJMBYneMMLaDsTu/D6ENg5/7nHILJ/csPU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIPHx5DVcowK5MJJVfXait3gjMhDJUW9y6lXo8mB2za3Vo8fy3
	rB+L3/NLAW3kFBkszgPK8+XZjXFAVwGprYOBx//i79QsqC+PBVRHE7aS
X-Gm-Gg: AY/fxX66BicTtpZrWm77Fblb+XYw9hWBImSvJY3UmM2N/GW7eGUaOUwzpkLdxShWZpx
	Mu3W3JIJa1KPF2BmFvYr/d14kLenRBzt69T1oLMaY1mMaVHGvc3UX2G1Lqj3ZIAalt6L/QbvlYO
	tyasJbIZDOIAD93PnvorBRKYdv5Do43P3N7d30rYnekIAejxVPixrBqMntcQrt5poDV3VLYlEXp
	SWOmYWwXgUegFsWXb44n208uv9yeFF2R/SinhqScmA4UHUUCVGet3he3py3kLCeAN3IUS+xDVzR
	9W2qWDt6S7O7VNdelvPshcbujzg7pLKrrMzIWy4LjrMI5oA1yIgM5F4yHjb8E4ar3OZ7qp2HcfN
	MqkhRZW+paGtLyMj2s5qCT12Bqh9w85Xq90DtBLq+CV1xTDyZRrmTp/pQEULd0LCc2mie1dJgLw
	xPwK+yaL1b
X-Google-Smtp-Source: AGHT+IFoFgIAi9PMNEfIKCxeozWxswujwd1S6MJvMAmdk00BzJYAqN7Mqo6fE4Jz6OZ88KHyEwKy2w==
X-Received: by 2002:a05:6512:3ba2:b0:598:edd4:d68 with SMTP id 2adb3069b0e04-598faa5a3bamr5789014e87.28.1766013524025;
        Wed, 17 Dec 2025 15:18:44 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-381134b5011sm2807821fa.3.2025.12.17.15.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 15:18:42 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	pavel@ucw.cz,
	rafael@kernel.org,
	gmazyland@gmail.com
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Thu, 18 Dec 2025 02:18:37 +0300
Message-ID: <20251217231837.157443-1-safinaskar@gmail.com>
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

Hi, Mikulas, Milan and others.

I'm running swap on dm-integrity for 40 days.

It runs mostly without problems.

But yesterday my screen freezed for 4 minutes. And then continued to work
normally.

So, may I ask again a question: is swap on dm-integrity supposed to work
at all? (I. e. swap partition on top of dm-integrity partition on top of
actual disk partition.) (I'm talking about swap here, not about hibernation.)

Mikulas Patocka said here https://lore.kernel.org/all/3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com/ :

> Encrypted swap file is not supposed to work. It uses the loop device that 
> routes the requests to a filesystem and the filesystem needs to allocate 
> memory to process requests.

> So, this is what happened to you - the machine runs out of memory, it 
> needs to swap out some pages, dm-crypt encrypts the pages and generates 
> write bios, the write bios are directed to the loop device, the loop 
> device directs them to the filesystem, the filesystem attempts to allocate 
> more memory => deadlock.

Does the same apply to dm-integrity?

I. e. is it possible that write to dm-integrity will lead to allocation?

-- 
Askar Safin
