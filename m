Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC8569DE6
	for <linux-crypto@vger.kernel.org>; Sat, 17 Feb 2024 15:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708182067; cv=none; b=V0qGQiu2+KRwtfScK0AvJ/cwFG1o3soDANkr/QzKVDj/1wxWck7gIhHdhRaxKT4n6FCTeW6/dmiVfo+1oxkmZ7AFUhNunKZWvr3eFGgcW7nPIyBf5BHoGwxD8Qs6keh5enQPrb56g96NYBZH9QDWYX+cZAED4+yfC4ujLZiuhA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708182067; c=relaxed/simple;
	bh=v3qPHREL8y4lhPH+JqjQ41slZwMMdqVh6lqLROLzu/Y=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=s3UKfG2BPVukAgqaBOiv8TwijN1waT24SsHFwfi48G3IhqVC5YvrVxbhnrTsurfFTIM4v+UIvHGl2C2sJUKq+ib2yS/2VrqvL+S1rJiCm725nstmr112uhggkzfsASKvxH/A5im1k6yTj9zGo39RePGh1p4Mg1V1zvTG9dnlxq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3651d2b88aeso2423755ab.1
        for <linux-crypto@vger.kernel.org>; Sat, 17 Feb 2024 07:01:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708182065; x=1708786865;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MwNQueuYmB/11gbOG3QeCQx8po7ZygrhAL8Ov/WqAlE=;
        b=H2MUH9RB5cQzNIl/SjH3VYItscXGANOo7crV/mfkQl0PClEp0fGAV+Qb9JiAjD1JH8
         /3FXIce67KDJsW8kjRwzkCsI6sVj9pvDMNQG/tBDST4ZGmn5zNVHM7imvIkL9+DR47up
         0fBa6O0uvcw9vRjrZn24sjlWboJdciMMB+UwXO7hCfo1FiRhwjlSLNRlD+7n38Mg4Sky
         nVxTBC/0e7Pk+h8q1pbFSo2LW6T76JMh6KDIwUHBe0bltLZfTtGksQO2pZtjYbSW7mz1
         j7YCt3gwoZoVaHJjQnLpnLh/HNE3dXrno5l1dyg1X6/nvBY1LObjqKBEVB3FIkPWxKpS
         BO+w==
X-Forwarded-Encrypted: i=1; AJvYcCW08dKitnv8J4lKJo5hDu90pvSQIjHViaHT4/AVN+uQr4VYDeIMx9VLOJqy53XEtslfoRI3raiJ/1y05+EADqMfJd17npA/rP/VRpBn
X-Gm-Message-State: AOJu0YzwJA1YcJ+4nQodaABUZ4jd5bNI8asoKyOkd1fCOg3RYqLvn4eZ
	fL9rPjvQlPlp6rB8i9qehmlIA2Fw1Vhza2Am4bbSxXVqkGeWEgYp6hnfA87J/iHvQolZl9UKv+A
	/YLyv+abUFdbQWDHE01/iILddZ2/OeJhLTQqzop8fIdo5onAXCMVCEKg=
X-Google-Smtp-Source: AGHT+IEBdhWTaosc/BZRU1Ig+P68HanPIcYAdDVfh8P0PrL8wce8QOLRvgTXLmzncxBxXxBJXjNeF/KiKPKPxtq3e5BT7OxP6ZGq
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:154f:b0:363:9252:ed47 with SMTP id
 j15-20020a056e02154f00b003639252ed47mr647629ilu.1.1708182064966; Sat, 17 Feb
 2024 07:01:04 -0800 (PST)
Date: Sat, 17 Feb 2024 07:01:04 -0800
In-Reply-To: <CAMj1kXHQYuv2H5XA+abgj+Mw8xyxsoHARx2w-tT7jRrDLQ=EVg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000031b790061195214f@google.com>
Subject: Re: [syzbot] [arm?] [crypto?] KASAN: invalid-access Read in neon_aes_ctr_encrypt
From: syzbot <syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com>
To: ardb@kernel.org, catalin.marinas@arm.com, davem@davemloft.net, 
	herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com

Tested on:

commit:         67e0a702 crypto: arm64/neonbs - fix out-of-bounds acce..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git neon-aes-ctr-fix
console output: https://syzkaller.appspot.com/x/log.txt?x=122f4464180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b4dde08ba7d52a4b
dashboard link: https://syzkaller.appspot.com/bug?extid=f1ceaa1a09ab891e1934
compiler:       aarch64-linux-gnu-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
