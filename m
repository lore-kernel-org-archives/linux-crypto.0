Received: from r3-20.sinamail.sina.com.cn (r3-20.sinamail.sina.com.cn [202.108.3.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC222D249A
	for <linux-crypto@vger.kernel.org>; Thu,  8 Jan 2026 05:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.108.3.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767849272; cv=none; b=qekUFZf4Y+vS1JByLnVN/PCU2XVjh56K4y0RmCLZdyqpnXtJhS3z7IosKLOB4CVPMznsmF0531WTmt1aiAfS8UjCd4Vtpyz/kZjYPyQyOPpS3CQqmCE522jJI8u9yxEh98J/yJC8oEC3e+COBMeN9LI5D1AfSw+byMExnnmgz9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767849272; c=relaxed/simple;
	bh=cXfeOsB/w9RNQpyoy/BPpRpp3EG96E/v51h4cT9VF84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeqQOyLzNhTL7i7jq9hsV0f1N2oJgWsfwsJJA77HGkqOSBl04NwOc5Ac34utD17v3PjSE/o4pkh71E7TYdYZLDjvicEVHW/MdWpbYM+dQxfKMhC/nR9OMyA0LRy/hagqGQbBuVTGlnsnKZZ1b2rGMZ1xYacd92j0F7fZc+MTUk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=BxFvz/BB; arc=none smtp.client-ip=202.108.3.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="BxFvz/BB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1767849262;
	bh=fnRvKLnm75yZhQVLT5TD7xrf42u+Cwrn45aKVr9rdQI=;
	h=From:Subject:Date:Message-ID;
	b=BxFvz/BBIiHvmOnMUQOnvJl5fJabpzc23rsZNC5j9+p8wpc4JDLJKNX/caU5gyE/Q
	 72S9pEAO9qSCWvZV8b9N9auZOevY0F7m/lRKJYeUdASyYSoCM3sH/BjpI9Z+/2CWsH
	 PDHY/XgN4ARPeO1/K0mLNX7gzZRFaBMO2KTBesuc=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.57.85])
	by sina.com (10.54.253.32) with ESMTP
	id 695F3D2400000AA9; Thu, 8 Jan 2026 13:14:13 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 5057564456834
X-SMAIL-UIID: 68FFC90FEDB4408A8A6D571F1F791FE8-20260108-131413-1
From: Hillf Danton <hdanton@sina.com>
To: =?UTF-8?B?546L5b+X?= <wangzhi_xd@stu.xidian.edu.cn>
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org
Subject: Re: [syzbot] BUG: KASAN: slab-use-after-free in mutex_optimistic_spin via adf_ctl_ioctl
Date: Thu,  8 Jan 2026 13:14:05 +0800
Message-ID: <20260108051409.2045-1-hdanton@sina.com>
In-Reply-To: <b781d87.ab9f.19b9b885c66.Coremail.wangzhi_xd@stu.xidian.edu.cn>
References: 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Date: Thu, 8 Jan 2026 10:56:03 +0800 (GMT+08:00)
> 
> syzbot has found the following issue on:
> 
> HEAD commit:    6.18.0 (custom build)
> git tree:       linux-stable
> console output: (see below)
> kernel config:  (attached)
>
1) is the uaf in mainline?
2) stop delivering reports with [syzbot] in the subject line because it is
a used tag.
3) feel free to ignore -- more hands instead of fuzzer are needed to fix
issues reported given regular syzbot reports.
